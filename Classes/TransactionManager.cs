using System;
using System.Data;
using System.Data.SqlClient;

namespace Main.Classes
{
    public class TransactionManager
    {
        // ==========================================
        // TRANSACTION PROCESSING
        // ==========================================
        public string ProcessDeposit(int accountNumber, decimal amount)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        string updateQuery = "UPDATE Users SET balance = balance + @Amount WHERE account_number = @AccountNo";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                            cmd.ExecuteNonQuery();
                        }

                        string logQuery = "INSERT INTO Transactions (receiver_account, transaction_type, amount, transaction_time) VALUES (@AccountNo, 'Deposit', @Amount, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(logQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.ExecuteNonQuery();
                        }
                        transaction.Commit();
                        return "Success";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "Error: " + ex.Message;
                    }
                }
            }
        }

        public string ProcessWithdraw(int accountNumber, decimal amount)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        string updateQuery = "UPDATE Users SET balance = balance - @Amount WHERE account_number = @AccountNo";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                            cmd.ExecuteNonQuery();
                        }

                        string logQuery = "INSERT INTO Transactions (sender_account, transaction_type, amount, transaction_time) VALUES (@AccountNo, 'Withdraw', @Amount, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(logQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.ExecuteNonQuery();
                        }
                        transaction.Commit();
                        return "Success";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "Error: " + ex.Message;
                    }
                }
            }
        }

        public string SendCloudMoney(int senderAccountNo, int receiverAccountNo, decimal amount)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        string deductQuery = "UPDATE Users SET balance = balance - @Amount WHERE account_number = @SenderNo";
                        using (SqlCommand cmd = new SqlCommand(deductQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@SenderNo", senderAccountNo);
                            cmd.ExecuteNonQuery();
                        }

                        string addQuery = "UPDATE Users SET balance = balance + @Amount WHERE account_number = @ReceiverNo";
                        using (SqlCommand cmd = new SqlCommand(addQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.Parameters.AddWithValue("@ReceiverNo", receiverAccountNo);
                            cmd.ExecuteNonQuery();
                        }

                        string transferQuery = "INSERT INTO Transactions (sender_account, receiver_account, transaction_type, amount, transaction_time) VALUES (@SenderNo, @ReceiverNo, 'Transfer', @Amount, GETDATE())";
                        using (SqlCommand cmd = new SqlCommand(transferQuery, conn, transaction))
                        {
                            cmd.Parameters.AddWithValue("@SenderNo", senderAccountNo);
                            cmd.Parameters.AddWithValue("@ReceiverNo", receiverAccountNo);
                            cmd.Parameters.AddWithValue("@Amount", amount);
                            cmd.ExecuteNonQuery();
                        }
                        transaction.Commit();
                        return "Success";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        return "Error: " + ex.Message;
                    }
                }
            }
        }

        // ==========================================
        // HELPERS FOR DASHBOARD STATS
        // ==========================================
        public decimal GetBalance(int accountNumber)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                string query = "SELECT balance FROM Users WHERE account_number = @AccountNo";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    var result = cmd.ExecuteScalar();
                    return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                }
            }
        }

        public decimal GetTotalSent(int accountNumber)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                string query = "SELECT SUM(amount) FROM Transactions WHERE sender_account = @AccountNo AND transaction_type = 'Transfer'";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    var result = cmd.ExecuteScalar();
                    return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                }
            }
        }

        // ==========================================
        // TABLE FETCHING
        // ==========================================
        public DataTable GetStatement(int accountNumber, string fromDate, string toDate)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"SELECT transaction_time AS Date, transaction_type AS Description, 
                                 CASE WHEN sender_account = @AccountNo THEN amount ELSE NULL END AS Debit, 
                                 CASE WHEN receiver_account = @AccountNo THEN amount ELSE NULL END AS Credit, 
                                 (SELECT balance FROM Users WHERE account_number = @AccountNo) AS Balance 
                                 FROM Transactions WHERE (sender_account = @AccountNo OR receiver_account = @AccountNo)";
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";
                query += " ORDER BY transaction_time DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }

        public DataTable GetDepositsWithdrawals(int accountNumber, string fromDate, string toDate, string type)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"SELECT transaction_id AS SeqNum, CASE WHEN transaction_type = 'Deposit' THEN 'D' ELSE 'W' END AS Type, 
                                 transaction_time AS Date, amount AS Amount 
                                 FROM Transactions WHERE (sender_account = @AccountNo OR receiver_account = @AccountNo) AND transaction_type IN ('Deposit', 'Withdraw')";
                if (type == "D") query += " AND transaction_type = 'Deposit'";
                else if (type == "W") query += " AND transaction_type = 'Withdraw'";
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";
                query += " ORDER BY transaction_time DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }

        public DataTable GetTransfers(int accountNumber, string fromDate, string toDate, string type)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"SELECT transaction_id AS SeqNum, transaction_time AS DateSent, amount AS Amount, 
                                 CASE WHEN sender_account = @AccountNo THEN receiver_account ELSE NULL END AS SentTo, 
                                 CASE WHEN receiver_account = @AccountNo THEN sender_account ELSE NULL END AS ReceivedFrom 
                                 FROM Transactions WHERE transaction_type = 'Transfer' AND (sender_account = @AccountNo OR receiver_account = @AccountNo)";
                if (type == "Sent") query += " AND sender_account = @AccountNo";
                else if (type == "Received") query += " AND receiver_account = @AccountNo";
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";
                query += " ORDER BY transaction_time DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }
    }
}