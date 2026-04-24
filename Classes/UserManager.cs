using System;
using System.Data.SqlClient;

namespace Main.Classes
{
    public class UserManager
    {
        public string RegisterUser(string firstName, string lastName, string email, string password)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = @"
                    INSERT INTO Users (first_name, last_name, email_address, password_hash)
                    OUTPUT INSERTED.account_number
                    VALUES (@first_name, @last_name, @email_address, @password)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@first_name", firstName);
                    cmd.Parameters.AddWithValue("@last_name", lastName);
                    cmd.Parameters.AddWithValue("@email_address", email);
                    cmd.Parameters.AddWithValue("@password", password);

                    var result = cmd.ExecuteScalar();
                    if (result != null) return result.ToString();
                }
            }
            return null;
        }

        public bool IsEmailUnique(string email)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = "SELECT COUNT(1) FROM Users WHERE email_address = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    int count = (int)cmd.ExecuteScalar();
                    return count == 0;
                }
            }
        }

        public bool UserLogin(int pin, string password)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = "SELECT COUNT(1) FROM Users WHERE account_number = @pin AND password_hash = @password";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@pin", pin);
                    cmd.Parameters.AddWithValue("@password", password);
                    int matchCtr = Convert.ToInt32(cmd.ExecuteScalar());
                    return matchCtr > 0;
                }
            }
        }

        // Change Password Function
        public string ChangePassword(int accountNumber, string newPassword)
        {
            using (SqlConnection conn = DBConnection.GetConnection())
            {
                conn.Open();
                try
                {
                    string query = "UPDATE Users SET password_hash = @NewPassword WHERE account_number = @AccountNo";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@NewPassword", newPassword);
                        cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                        cmd.ExecuteNonQuery();
                    }
                    return "Success";
                }
                catch (Exception ex)
                {
                    return "Error: " + ex.Message;
                }
            }
        }

        // Fetches Name and Date Registered for the Dashboard
        public void GetDashboardDetails(int accountNumber, out string fullName, out string dateRegistered)
        {
            fullName = "";
            dateRegistered = "";
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = "SELECT first_name, last_name, date_registered FROM Users WHERE account_number = @AccountNo";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            fullName = reader["first_name"].ToString() + " " + reader["last_name"].ToString();
                            dateRegistered = Convert.ToDateTime(reader["date_registered"]).ToString("MM/dd/yyyy");
                        }
                    }
                }
            }
        }

        // Gets Receiver's Name for Send Money Verification
        public string GetReceiverName(int accountNumber)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = "SELECT first_name, last_name FROM Users WHERE account_number = @AccountNo";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                            return reader["first_name"].ToString() + " " + reader["last_name"].ToString();
                    }
                }
            }
            return null; // Returns null if account does not exist
        }

        public string GetUserFirstName(int accountNumber)
        {
            using (SqlConnection con = DBConnection.GetConnection())
            {
                con.Open();
                string query = "SELECT first_name FROM Users WHERE account_number = @AccountNo";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AccountNo", accountNumber);
                    var result = cmd.ExecuteScalar();
                    return result != null ? result.ToString() : "User";
                }
            }
        }
    }
}