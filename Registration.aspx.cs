using Main.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Main
{
    public partial class Registration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Email_ServerValidate(object source, ServerValidateEventArgs args)
        {
            string typedEmail = emailTxt.Text.Trim();

            UserManager userManager = new UserManager();
            args.IsValid = userManager.IsEmailUnique(typedEmail);
        }

        protected void registerBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string firstName = firstNameTxt.Text.Trim();
                string lastName = lastNameTxt.Text.Trim();
                string email = emailTxt.Text.Trim();
                string password = passwordTxt.Text.Trim();
                string gender = rbMale.Checked ? "Male" : "Female";

                // 1. Create the instance of your class
                UserManager userManager = new UserManager();

                // 2. Call the method and capture the new auto-generated Account Number
                string newAccountNumber = userManager.RegisterUser(firstName, lastName, email, password);

                // 3. Check if registration was successful (it didn't return null)
                if (newAccountNumber != null)
                {
                    // Pass the generated Account Number to the label in the success panel
                    lblPinDisplay.Text = newAccountNumber;

                    // Hide the registration form and show the success panel
                    pnlRegistration.Visible = false;
                    pnlSuccess.Visible = true;
                }
                else
                {
                    // Optional: If it fails (like if they use an email that already exists),
                    // the panels won't switch. You could add an error label here later!
                }
            }
        }
    }
}