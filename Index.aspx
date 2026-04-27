<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Main.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CTU - E Wallet</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet" />
    <link href="Content/styles/LandingPage.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="layout-wrapper">

            <%-- ==================== SIDEBAR ==================== --%>
            <div class="sidebar">
                <div class="sidebar-menu" style="margin-top: 20px;">
                    <asp:LinkButton ID="btnSidebarDashboard" runat="server" CssClass="menu-item active" OnClick="Sidebar_Click" CommandArgument="0">Dashboard</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarManage" runat="server" CssClass="menu-item" OnClick="Sidebar_Click" CommandArgument="1">Manage Funds</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarNotifications" runat="server" CssClass="menu-item" OnClick="Sidebar_Click" CommandArgument="2">Notifications</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarChangePassword" runat="server" CssClass="menu-item" OnClick="btnSidebarChangePassword_Click" CausesValidation="false">Change Password</asp:LinkButton>
                    <asp:LinkButton ID="btnSidebarLogout" runat="server" CssClass="menu-item logout-btn" OnClick="btnSidebarLogout_Click" CausesValidation="false">Log-out</asp:LinkButton>
                </div>
            </div>

            <%-- ==================== MAIN CONTENT ==================== --%>
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

                        <%-- ==================== VIEW 0: DASHBOARD ==================== --%>
                        <asp:View ID="vwDashboardStats" runat="server">

                            <h2 class="dashboard-title">My Dashboard</h2>

                            <%-- Profile Card: Name, Account No, Date Registered --%>
                            <div class="dashboard-profile-card">
                                <div class="profile-avatar">
                                    <asp:Label ID="lblDashInitial" runat="server" Text="U"></asp:Label>
                                </div>
                                <div class="profile-details">
                                    <div class="profile-name">
                                        <asp:Label ID="lblDashName" runat="server"></asp:Label>
                                    </div>
                                    <div class="profile-meta">
                                        <div class="profile-meta-item">
                                            <span class="meta-label">Account No.</span>
                                            <asp:Label ID="lblDashAccountNo" runat="server" CssClass="meta-value gold"></asp:Label>
                                        </div>
                                        <div class="profile-meta-divider"></div>
                                        <div class="profile-meta-item">
                                            <span class="meta-label">Date Registered</span>
                                            <asp:Label ID="lblDashDateReg" runat="server" CssClass="meta-value"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- Stats Row: Balance and Total Sent side by side --%>
                            <div class="dashboard-stats-row">
                                <div class="stat-card balance-card">
                                    <div class="stat-info">
                                        <span class="stat-label">Total Current Balance</span>
                                        <span class="stat-value green">&#8369;<asp:Label ID="lblDashBalance" runat="server"></asp:Label></span>
                                    </div>
                                </div>
                                <div class="stat-card sent-card">
                                    <div class="stat-info">
                                        <span class="stat-label">Total Sent Amount</span>
                                        <span class="stat-value">&#8369;<asp:Label ID="lblDashTotalSent" runat="server"></asp:Label></span>
                                    </div>
                                </div>
                            </div>

                        </asp:View>

                        <%-- ==================== VIEW 1: MANAGE FUNDS ==================== --%>
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
                                            <p style="font-size:12px; color:#A0AABF;">Min: &#8369;100 | Max: &#8369;2,000 | Must be divisible by 100</p>
                                            <asp:TextBox ID="txtDepositAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                            <asp:Button ID="btnSubmitDeposit" runat="server" Text="Confirm Deposit" CssClass="btn-submit" OnClick="btnSubmitDeposit_Click" />
                                        </div>
                                    </asp:View>

                                    <asp:View ID="vwWithdraw" runat="server">
                                        <div class="action-panel">
                                            <h3>Withdraw Funds</h3>
                                            <p style="color:#2DD253; font-weight:bold;">Current Balance: &#8369;<asp:Label ID="lblWithdrawBalance" runat="server"></asp:Label></p>
                                            <p style="font-size:12px; color:#A0AABF;">Min: &#8369;100 | Max: &#8369;2,000 | Must be divisible by 100</p>
                                            <asp:TextBox ID="txtWithdrawAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                            <asp:Button ID="btnSubmitWithdraw" runat="server" Text="Confirm Withdraw" CssClass="btn-submit" OnClick="btnSubmitWithdraw_Click" />
                                        </div>
                                    </asp:View>

                                    <asp:View ID="vwSend" runat="server">
                                        <div class="action-panel">
                                            <h3>Send CloudMoney</h3>

                                            <asp:Panel ID="pnlVerifyReceiver" runat="server">
                                                <asp:TextBox ID="txtSendAccount" runat="server" CssClass="form-input" placeholder="Recipient Account No."></asp:TextBox>
                                                <asp:Button ID="btnVerifyReceiver" runat="server" Text="Verify Receiver" CssClass="btn-submit" OnClick="btnVerifyReceiver_Click" />
                                            </asp:Panel>

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

                                            <asp:Panel ID="pnlSendMoneyForm" runat="server" Visible="false" style="width:100%; display:flex; flex-direction:column; align-items:center; gap:10px;">
                                                <p style="font-size:12px; color:#A0AABF;">Min: &#8369;100 | Max: &#8369;2,000 | Must be divisible by 100</p>
                                                <asp:TextBox ID="txtSendAmount" runat="server" CssClass="form-input" placeholder="Amount"></asp:TextBox>
                                                <asp:TextBox ID="txtSendPassword" runat="server" CssClass="form-input" placeholder="Enter Your Password" TextMode="Password"></asp:TextBox>
                                                <asp:Button ID="btnSubmitSend" runat="server" Text="Send Money" CssClass="btn-submit" OnClick="btnSubmitSend_Click" />
                                                <asp:Button ID="btnCancelSend" runat="server" Text="Cancel" CssClass="btn-filter" OnClick="btnCancelSend_Click" CausesValidation="false" />
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
                                    <h3 class="filter-title">
                                        <asp:Label ID="lblFilterTitle" runat="server" Text="My Statement of Account"></asp:Label>
                                    </h3>
                                    <div class="filter-row">
                                        <label>From</label>
                                        <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="filter-input-centered"></asp:TextBox>
                                    </div>
                                    <div class="filter-row">
                                        <label>To</label>
                                        <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="filter-input-centered"></asp:TextBox>
                                    </div>
                                    <div class="filter-row">
                                        <label>Type</label>
                                        <asp:DropDownList ID="ddlType" runat="server" CssClass="filter-input-centered">
                                            <asp:ListItem Text="All" Value="All"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <asp:Label ID="lblDateError" runat="server" CssClass="date-error" Visible="false"></asp:Label>
                                    <div class="filter-actions">
                                        <asp:Button ID="btnList" runat="server" Text="List" CssClass="btn-list" OnClick="btnList_Click" />
                                    </div>
                                </div>

                                <asp:MultiView ID="mvTables" runat="server" ActiveViewIndex="0">

                                    <asp:View ID="vwTableStatement" runat="server">
                                        <asp:GridView ID="gvStatement" runat="server" AutoGenerateColumns="False" CssClass="grid-view" GridLines="None" AllowPaging="True" PageSize="10" OnPageIndexChanging="gvStatement_PageIndexChanging">
                                            <HeaderStyle CssClass="grid-header" />
                                            <RowStyle CssClass="grid-row" />
                                            <AlternatingRowStyle CssClass="grid-alt-row" />
                                            <Columns>
                                                <asp:BoundField DataField="SeqNum" HeaderText="Seq. #" />
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
                                            <HeaderStyle CssClass="grid-header" />
                                            <RowStyle CssClass="grid-row" />
                                            <AlternatingRowStyle CssClass="grid-alt-row" />
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
                                            <HeaderStyle CssClass="grid-header" />
                                            <RowStyle CssClass="grid-row" />
                                            <AlternatingRowStyle CssClass="grid-alt-row" />
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

                        <%-- ==================== VIEW 2: NOTIFICATIONS ==================== --%>
                        <asp:View ID="vwNotifications" runat="server">
                            <div class="card" style="max-width: 700px; margin: 0 auto;">
                                <h2 class="dashboard-title">Notifications</h2>
                                <p class="notif-subtitle">Recently received CloudMoney transfers</p>
                                <hr class="notif-divider" />

                                <%-- Shown when no transfers received --%>
                                <asp:Label ID="lblNoNotifications" runat="server"
                                    CssClass="notif-empty"
                                    Text="You have no recent CloudMoney received."
                                    Visible="false">
                                </asp:Label>

                                <%-- One card per received transfer --%>
                                <asp:Repeater ID="rptNotifications" runat="server">
                                    <ItemTemplate>
                                        <div class="notif-item">
                                            <div class="notif-left">
                                                <span class="notif-sender"><%# Eval("SenderName") %></span>
                                                <span class="notif-date"><%# Eval("Date", "{0:MM/dd/yyyy hh:mm tt}") %></span>
                                            </div>
                                            <div class="notif-right">
                                                <span class="notif-label">Received</span>
                                                <span class="notif-amount">+&#8369;<%# Eval("Amount", "{0:N2}") %></span>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>

                            </div>
                        </asp:View>

                    </asp:MultiView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
