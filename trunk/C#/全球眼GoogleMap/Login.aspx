<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>全球眼前端设备管理中心</title>
    <link href="CSS/admin_login.css" rel="stylesheet"
        type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div id="login_wrapper2">
            <ul class="admin_login">
                <li>
                    <asp:TextBox ID="txtUserName" runat="server" class="admin_input"></asp:TextBox>
                </li>
                <li>
                    <asp:TextBox ID="txtPassword" runat="server" class="admin_input" TextMode="Password"></asp:TextBox>
                </li>
                <li>
                    <asp:Button ID="btnlogin" runat="server" Text="登录" OnClick="btnlogin_Click" CssClass="admin_button" />
                </li>
                <li><asp:Label ID="lblErrorInfo" runat="server" Width="112px"></asp:Label></li>
            </ul>
        </div>
    </form>
</body>
</html>
