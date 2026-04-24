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

        // FIX 1 (Bug 1): Running balance using SUM() OVER() window function.
        //   OLD: (SELECT balance FROM Users WHERE account_number = @AccountNo) AS Balance
        //        ^ This stamped the CURRENT total balance on every single row.
        //   NEW: SUM(...) OVER (ORDER BY transaction_time ASC, transaction_id ASC ROWS UNBOUNDED PRECEDING)
        //        ^ This computes a per-row cumulative running balance in chronological order.
        //        The transaction_id tiebreaker ensures correct order when two transactions share the same timestamp.
        public DataTable GetStatement(int accountNumber, string fromDate, string toDate)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"
                    SELECT
                        transaction_time AS Date,
                        transaction_type AS Description,
                        CASE WHEN sender_account   = @AccountNo THEN amount ELSE NULL END AS Debit,
                        CASE WHEN receiver_account = @AccountNo THEN amount ELSE NULL END AS Credit,
                        SUM(
                            CASE
                                WHEN receiver_account = @AccountNo THEN  amount   -- Deposit / received = +
                                WHEN sender_account   = @AccountNo THEN -amount   -- Withdraw / sent    = -
                                ELSE 0
                            END
                        ) OVER (
                            ORDER BY transaction_time ASC, transaction_id ASC
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) AS Balance
                    FROM Transactions
                    WHERE (sender_account = @AccountNo OR receiver_account = @AccountNo)";

                // FIX 2 (Bug 2): Append 23:59:59 to toDate so the entire end day is included.
                //   OLD: transaction_time <= '2026-04-24'  ->  cuts off at 2026-04-24 00:00:00
                //   NEW: transaction_time <= '2026-04-24 23:59:59'  ->  includes the full day
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";

                query += " ORDER BY transaction_time DESC, transaction_id DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate + " 23:59:59");
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }

        // FIX 2 (Bug 2): toDate + " 23:59:59" to include the full end day.
        // FIX 3 (SeqNum): ROW_NUMBER() OVER() so Seq# always starts at 1 for this
        //   table only, independent of transaction_id or any other table's numbering.
        //   OLD: transaction_id AS SeqNum  ->  used global DB identity, numbers had gaps
        //        and continued across tables (e.g. showed 1, 3, 5 instead of 1, 2, 3)
        //   NEW: ROW_NUMBER() OVER (ORDER BY transaction_time DESC) AS SeqNum
        //        ->  always 1, 2, 3... for exactly the rows returned by this query only
        public DataTable GetDepositsWithdrawals(int accountNumber, string fromDate, string toDate, string type)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"SELECT 
                                    ROW_NUMBER() OVER (ORDER BY transaction_time DESC) AS SeqNum,
                                    CASE WHEN transaction_type = 'Deposit' THEN 'D' ELSE 'W' END AS Type,
                                    transaction_time AS Date,
                                    amount AS Amount
                                 FROM Transactions
                                 WHERE (sender_account = @AccountNo OR receiver_account = @AccountNo)
                                 AND transaction_type IN ('Deposit', 'Withdraw')";

                if (type == "D") query += " AND transaction_type = 'Deposit'";
                else if (type == "W") query += " AND transaction_type = 'Withdraw'";
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate + " 23:59:59");
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }

        // FIX 2 (Bug 2): toDate + " 23:59:59" to include the full end day.
        // FIX 3 (SeqNum): Same ROW_NUMBER() fix as GetDepositsWithdrawals above.
        public DataTable GetTransfers(int accountNumber, string fromDate, string toDate, string type)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                string query = @"SELECT 
                                    ROW_NUMBER() OVER (ORDER BY transaction_time DESC) AS SeqNum,
                                    transaction_time AS DateSent,
                                    amount AS Amount,
                                    CASE WHEN sender_account   = @AccountNo THEN receiver_account ELSE NULL END AS SentTo,
                                    CASE WHEN receiver_account = @AccountNo THEN sender_account   ELSE NULL END AS ReceivedFrom
                                 FROM Transactions
                                 WHERE transaction_type = 'Transfer'
                                 AND (sender_account = @AccountNo OR receiver_account = @AccountNo)";

                if (type == "Sent") query += " AND sender_account = @AccountNo";
                else if (type == "Received") query += " AND receiver_account = @AccountNo";
                if (!string.IsNullOrEmpty(fromDate)) query += " AND transaction_time >= @FromDate";
                if (!string.IsNullOrEmpty(toDate)) query += " AND transaction_time <= @ToDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    if (!string.IsNullOrEmpty(fromDate)) cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    if (!string.IsNullOrEmpty(toDate)) cmd.Parameters.AddWithValue("@ToDate", toDate + " 23:59:59");
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd)) sda.Fill(dt);
                }
            }
            return dt;
        }
    }
}