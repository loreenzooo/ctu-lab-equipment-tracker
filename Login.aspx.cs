using Main.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Main
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void createAcc_Click(object sender, EventArgs e)
        {
            Response.Redirect("Registration.aspx");
        }

        protected void loginBtn_Click(object sender, EventArgs e)
        {
            string password = passwordTxt.Text.Trim();
            errorLbl.Text = "";

            if (!int.TryParse(pinTxt.Text.Trim(), out int pin))
            {
                errorLbl.Text = "Please enter a valid numeric PIN";
                return;
            }

            UserManager userManager = new UserManager();
            bool isSuccessLogin = userManager.UserLogin(pin, password);

            if (isSuccessLogin)
            {
                // FIX IS HERE: Changed "LoggedInPin" to "AccountNumber"
                Session["AccountNumber"] = pin;
                Response.Redirect("Index.aspx");
            }
            else
            {
                errorLbl.Text = "Invalid PIN or Password. Please Try again.";
            }
        }
    }
}