<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DelCamera.aspx.cs" Inherits="Admin_DelCamera" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>摄像头删除</title>
    <link href="../Css/mature2.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="content">
            <div class="max_box box">
                <div class="cr-tp">
                    <span></span>
                </div>
                <div class="error_bg">
                    <div class="er01">
                        <asp:Literal ID="ltlInfo" runat="server"></asp:Literal></div>
                    <div class="er02"></div>
                    <div>
                        <asp:HyperLink ID="hlkBack" runat="server" CssClass="l_999" Enabled="false">返回编码器，请点击这里返回</asp:HyperLink>
                        </div>
                </div>
                <div class="clear">
                </div>
                <div class="cr-bt">
                    <span></span>
                </div>
            </div>
            <div class="clear">
            </div>
        </div>
    </form>
</body>
</html>
