<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="Main.ChangePassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CTU - E Wallet | Change Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet" />
    <link href="Content/styles/ChangePassword.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="layout-wrapper">
            <div class="form-card">

                <div class="form-header">
                    <h2>Change Password</h2>
                    <p>Update your E-Wallet account security.</p>
                </div>

                <%-- Message container: shown only when lblMessage has text --%>
                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <div class="message-container">
                        <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Text=""></asp:Label>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtCurrentPassword">Current Password</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvCurrent" runat="server"
                        ControlToValidate="txtCurrentPassword"
                        ErrorMessage="Current password is required."
                        CssClass="error-text"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtNewPassword">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNew" runat="server"
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="New password is required."
                        CssClass="error-text"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your new password."
                        CssClass="error-text"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPasswords" runat="server"
                        ControlToCompare="txtNewPassword"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="New passwords do not match!"
                        CssClass="error-text"
                        Display="Dynamic">
                    </asp:CompareValidator>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn-primary" OnClick="btnChangePassword_Click" />
                    <%-- CausesValidation="false" + UseSubmitBehavior="false" prevents validators from firing on Cancel --%>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" UseSubmitBehavior="false" />
                </div>

            </div>
        </div>
    </form>
</body>
</html>
