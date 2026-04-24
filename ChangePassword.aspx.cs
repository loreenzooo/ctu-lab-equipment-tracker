using System;
using Main.Classes;

namespace Main
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if no active session
            if (Session["AccountNumber"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            int currentAccountNo = Convert.ToInt32(Session["AccountNumber"]);
            string currentPassword = txtCurrentPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();

            UserManager userManager = new UserManager();

            // Step 0: Minimum password length check
            if (newPassword.Length < 8)
            {
                ShowMessage("New password must be at least 8 characters long.", false);
                return;
            }

            // Step 1: Verify the current password is correct
            if (!userManager.UserLogin(currentAccountNo, currentPassword))
            {
                ShowMessage("Incorrect current password. Please try again.", false);
                return;
            }

            // Step 2: New password must differ from current
            if (currentPassword == newPassword)
            {
                ShowMessage("New password must be different from your current password.", false);
                return;
            }

            // Step 3: Attempt the update in the database
            string result = userManager.ChangePassword(currentAccountNo, newPassword);
            if (result == "Success")
            {
                ShowMessage("Password updated successfully! Redirecting you back...", true);

                // Clear fields on success
                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";

                // Redirect to Index after 2 seconds
                string script = "setTimeout(function(){ window.location = 'Index.aspx'; }, 2000);";
                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
            else
            {
                ShowMessage("An error occurred: " + result, false);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Index.aspx");
        }

        // Shows the message panel with correct styling.
        // isSuccess = true  → green success message
        // isSuccess = false → red error message
        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message-label success" : "message-label error";
        }
    }
}
