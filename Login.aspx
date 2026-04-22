<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Main.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - CTU Bank</title>
    <link href="../Content/styles/Login.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

        <div class="container">
            <div id="login-container">

                <div id="form">
                    <h2 style="color: #EBA800;">Login</h2>

                    <asp:TextBox ID="pinTxt" runat="server" CssClass="login-input" placeholder="PIN"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvpinTxt" runat="server"
                        ControlToValidate="pinTxt"
                        ErrorMessage="PIN is required!"
                        ForeColor="Red"
                        Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:TextBox ID="passwordTxt" runat="server" CssClass="login-input" TextMode="Password" placeholder="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPasswordTxt" runat="server"
                        ControlToValidate="passwordTxt"
                        ErrorMessage="Password is required!"
                        ForeColor="Red"
                        Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:Button ID="loginBtn" runat="server" CssClass="login-input" Text="Login" OnClick="loginBtn_Click" />
                    <asp:Button ID="createAcc" runat="server" CssClass="login-input" Text="Create Account" OnClick="createAcc_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
