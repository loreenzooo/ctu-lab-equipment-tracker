<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Main.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CTU - E Wallet</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet" />
    <link href="../Content/styles/LandingPage.css" rel="stylesheet" type="text/css" />
  
</head>
<body>
    <form id="form1" runat="server">
        <div class="layout-wrapper">

            <div class="sidebar">
                <div class="sidebar-menu" style="margin-top: 20px;">
                    <asp:LinkButton ID="btnSidebarDashboard" runat="server" CssClass="menu-item active" OnClick="Sidebar_Click" CommandArgument="0">Dashboard</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarManage" runat="server" CssClass="menu-item" OnClick="Sidebar_Click" CommandArgument="1">Manage Funds</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarChangePassword" runat="server" CssClass="menu-item" OnClick="btnSidebarChangePassword_Click" CausesValidation="false">Change Password</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarLogout" runat="server" CssClass="menu-item logout-btn" OnClick="btnSidebarLogout_Click" CausesValidation="false">Log-out</asp:LinkButton>
                </div>
            </div>

            <div class="main-content">
                <div class="top-header">
                    <div class="header-left"><h2>CTU - E Wallet</h2></div>
                    <div class="header-right">
                        <asp:Label ID="lblUserName" runat="server" Text="User" CssClass="user-name"></asp:Label>
                        <div class="profile-circle">
                            <asp:Label ID="lblProfileInitial" runat="server" CssClass="profile-initial" Text="U"></asp:Label>
                        </div>
                    </div>
                </div>

                <div class="content-container">
                    <asp:MultiView ID="mvMainContent" runat="server" ActiveViewIndex="0">

                        <asp:View ID="vwDashboardStats" runat="server">
                            <div class="card" style="max-width: 600px; margin: 0 auto;">
                                <h2 class="table-header-title">My Dashboard</h2>
                                <div style="font-size: 16px; line-height: 2.0;">
                                    <p><strong>Account No:</strong> <asp:Label ID="lblDashAccountNo" runat="server" ForeColor="#EBA800"></asp:Label></p>
                                    <p><strong>Name:</strong> <asp:Label ID="lblDashName" runat="server"></asp:Label></p>
                                    <p><strong>Date Registered:</strong> <asp:Label ID="lblDashDateReg" runat="server"></asp:Label></p>
                                    <p><strong>Total Current Balance:</strong> ₱<asp:Label ID="lblDashBalance" runat="server" ForeColor="#2DD253"></asp:Label></p>
                                    <p><strong>Total Sent Amount:</strong> ₱<asp:Label ID="lblDashTotalSent" runat="server"></asp:Label></p>
                                </div>
                            </div>
                        </asp:View>

                        <asp:View ID="vwManageFunds" runat="server">
                            <div class="card action-container">
                                <div class="action-buttons">
                                    <asp:Button ID="btnShowDeposit" runat="server" Text="Deposit" CssClass="action-btn" OnClick="Action_Click" CommandArgument="0" />
                                    <asp:Button ID="btnShowWithdraw" runat="server" Text="Withdraw" CssClass="action-btn" OnClick="Action_Click" CommandArgument="1" />
                                    <asp:Button ID="btnShowSend" runat="server" Text="Send CloudMoney" CssClass="action-btn" OnClick="Action_Click" CommandArgument="2" />
                                </div>

                                <asp:MultiView ID="mvActions" runat="server" ActiveViewIndex="-1">
                                    <asp:View ID="vwDeposit" runat="server">
                                        <div class="action-panel">
                                            <h3>Deposit Funds</h3>
                                            <p style="font-size:12px; color:#A0AABF;">Min: ₱100 | Max: ₱2,000 | Must be divisible by 100</p>
                                            <asp:TextBox ID="txtDepositAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                            <asp:Button ID="btnSubmitDeposit" runat="server" Text="Confirm Deposit" CssClass="btn-submit" OnClick="btnSubmitDeposit_Click" />
                                        </div>
                                    </asp:View>

                                    <asp:View ID="vwWithdraw" runat="server">
                                        <div class="action-panel">
                                            <h3>Withdraw Funds</h3>
                                            <p style="color:#2DD253; font-weight:bold;">Current Balance: ₱<asp:Label ID="lblWithdrawBalance" runat="server"></asp:Label></p>
                                            <p style="font-size:12px; color:#A0AABF;">Min: ₱100 | Max: ₱2,000 | Must be divisible by 100</p>
                                            <asp:TextBox ID="txtWithdrawAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                            <asp:Button ID="btnSubmitWithdraw" runat="server" Text="Confirm Withdraw" CssClass="btn-submit" OnClick="btnSubmitWithdraw_Click" />
                                        </div>
                                    </asp:View>

                                    <asp:View ID="vwSend" runat="server">
                                        <div class="action-panel">
                                            <h3>Send CloudMoney</h3>

                                            <%-- STEP 1: Enter account number --%>
                                            <asp:Panel ID="pnlVerifyReceiver" runat="server">
                                                <asp:TextBox ID="txtSendAccount" runat="server" CssClass="form-input" placeholder="Recipient Account No."></asp:TextBox>
                                                <asp:Button ID="btnVerifyReceiver" runat="server" Text="Verify Receiver" CssClass="btn-submit" OnClick="btnVerifyReceiver_Click" />
                                            </asp:Panel>

                                            <%-- STEP 2: Show verified receiver info (Fix #8) --%>
                                            <%-- Replaced single combined label with a proper info card --%>
                                            <asp:Panel ID="pnlReceiverInfo" runat="server" Visible="false">
                                                <div class="receiver-info-panel">
                                                    <span class="info-label">Sending To</span>
                                                    <hr class="receiver-info-divider" />
                                                    <span class="info-label">Account No.</span>
                                                    <asp:Label ID="lblReceiverAccountNo" runat="server" CssClass="info-value highlight"></asp:Label>
                                                    <span class="info-label">Name</span>
                                                    <asp:Label ID="lblReceiverName" runat="server" CssClass="info-value"></asp:Label>
                                                </div>
                                            </asp:Panel>

                                            <%-- STEP 3: Amount + password form --%>
                                            <asp:Panel ID="pnlSendMoneyForm" runat="server" Visible="false" style="width: 100%; display: flex; flex-direction: column; align-items: center; gap: 10px;">
                                                <p style="font-size:12px; color:#A0AABF;">Min: ₱100 | Max: ₱2,000 | Must be divisible by 100</p>
                                                <asp:TextBox ID="txtSendAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                                <asp:TextBox ID="txtSendPassword" runat="server" CssClass="form-input" placeholder="Enter Your Password" TextMode="Password"></asp:TextBox>
                                                <asp:Button ID="btnSubmitSend" runat="server" Text="Send Money" CssClass="btn-submit" OnClick="btnSubmitSend_Click" />
                                                <asp:Button ID="btnCancelSend" runat="server" Text="Cancel" CssClass="btn-filter" OnClick="btnCancelSend_Click" />
                                            </asp:Panel>

                                        </div>
                                    </asp:View>
                                </asp:MultiView>
                            </div>

                            <div class="card data-container">
                                <div class="tab-buttons">
                                    <asp:LinkButton ID="btnTabStatement" runat="server" CssClass="tab-btn active" OnClick="TableTab_Click" CommandArgument="0">View Statement Of Account</asp:LinkButton>
                                    <asp:LinkButton ID="btnTabDeposits" runat="server" CssClass="tab-btn" OnClick="TableTab_Click" CommandArgument="1">My Deposits or Withdrawals</asp:LinkButton>
                                    <asp:LinkButton ID="btnTabTransactions" runat="server" CssClass="tab-btn" OnClick="TableTab_Click" CommandArgument="2">My Sent or Received Transactions</asp:LinkButton>
                                </div>

                                <div class="centered-filter-form">
                                    <h3 class="filter-title"><asp:Label ID="lblFilterTitle" runat="server" Text="My Statement of Account"></asp:Label></h3>
                                    <div class="filter-row"><label>From</label><asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="filter-input-centered"></asp:TextBox></div>
                                    <div class="filter-row"><label>To</label><asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="filter-input-centered"></asp:TextBox></div>
                                    <div class="filter-row">
                                        <label>Type</label>
                                        <asp:DropDownList ID="ddlType" runat="server" CssClass="filter-input-centered"><asp:ListItem Text="All" Value="All"></asp:ListItem></asp:DropDownList>
                                    </div>
                                    <%-- Date validation error label (Fix #9) --%>
                                    <asp:Label ID="lblDateError" runat="server" CssClass="date-error" Visible="false"></asp:Label>
                                    <div class="filter-actions">
                                        <asp:Button ID="btnList" runat="server" Text="List" CssClass="btn-list" OnClick="btnList_Click" />
                                    </div>
                                </div>

                                <asp:MultiView ID="mvTables" runat="server" ActiveViewIndex="0">
                                    <asp:View ID="vwTableStatement" runat="server">
                                        <asp:GridView ID="gvStatement" runat="server" AutoGenerateColumns="False" CssClass="grid-view" GridLines="None" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvStatement_PageIndexChanging">
                                            <HeaderStyle CssClass="grid-header" /> <RowStyle CssClass="grid-row" /> <AlternatingRowStyle CssClass="grid-alt-row" />
                                            <Columns>
                                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />
                                                <asp:BoundField DataField="Description" HeaderText="Description" />
                                                <asp:BoundField DataField="Debit" HeaderText="Debit" DataFormatString="{0:N2}" NullDisplayText="" />
                                                <asp:BoundField DataField="Credit" HeaderText="Credit" DataFormatString="{0:N2}" NullDisplayText="" />
                                                <asp:BoundField DataField="Balance" HeaderText="Balance" DataFormatString="{0:N2}" />
                                            </Columns>
                                        </asp:GridView>
                                    </asp:View>
                                    <asp:View ID="vwTableDeposits" runat="server">
                                        <asp:GridView ID="gvDeposits" runat="server" AutoGenerateColumns="False" CssClass="grid-view" GridLines="None" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvDeposits_PageIndexChanging">
                                            <HeaderStyle CssClass="grid-header" /> <RowStyle CssClass="grid-row" /> <AlternatingRowStyle CssClass="grid-alt-row" />
                                            <Columns>
                                                <asp:BoundField DataField="SeqNum" HeaderText="Seq. #" />
                                                <asp:BoundField DataField="Type" HeaderText="Type" />
                                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />
                                                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />
                                            </Columns>
                                        </asp:GridView>
                                    </asp:View>
                                    <asp:View ID="vwTableTransactions" runat="server">
                                        <asp:GridView ID="gvTransactions" runat="server" AutoGenerateColumns="False" CssClass="grid-view" GridLines="None" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvTransactions_PageIndexChanging">
                                            <HeaderStyle CssClass="grid-header" /> <RowStyle CssClass="grid-row" /> <AlternatingRowStyle CssClass="grid-alt-row" />
                                            <Columns>
                                                <asp:BoundField DataField="SeqNum" HeaderText="Seq. #" />
                                                <asp:BoundField DataField="DateSent" HeaderText="Date Sent" DataFormatString="{0:MM/dd/yyyy hh:mm tt}" />
                                                <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:N2}" />
                                                <asp:BoundField DataField="SentTo" HeaderText="Sent To" NullDisplayText="" />
                                                <asp:BoundField DataField="ReceivedFrom" HeaderText="Received From" NullDisplayText="" />
                                            </Columns>
                                        </asp:GridView>
                                    </asp:View>
                                </asp:MultiView>
                            </div>
                        </asp:View>
                    </asp:MultiView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
