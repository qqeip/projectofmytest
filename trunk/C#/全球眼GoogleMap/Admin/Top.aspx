<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Top.aspx.cs" Inherits="Manger_Top" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Top</title>
    <link href="../CSS/mature2.css" rel="stylesheet" type="text/css" />
<%--    <script defer type="Text/Javascript" src="../JS/show.js"></script>--%>
    
</head>
<body>
    <form id="form2" runat="server">
        <div id="header">
            <div id="logo">
                <img src="../Img/b/logo.png" title="欢迎光临XXX。"></div>
            <div class="clear">
            </div>
            <div id="bar">
                <div class="top_menu" >
                    <div class="m_nav"><a href="ResEncoder.aspx" target="right">添加设备</a></div>
                    <div class="m_nav"><a href="InquiryDvs.aspx" target="right">编码器查询</a></div>
                    <div class="m_nav"><a href="InquiryCamera.aspx" target="right">摄像头查询</a></div>
                    <div class="m_nav"><a href="../Map.aspx" target="_parent">地图展现</a></div>
                </div>
                <h4>
                    <asp:LinkButton ID="ibnLogout" runat="server" OnClick="ibnLogout_Click">安全退出</asp:LinkButton></h4>
                <h4>
                    当前用户:
                    <img src="../Img/b/icon_user.jpg" />
                    <strong>
                        <asp:Label ID="lblUserRealName" runat="server" Text=""></asp:Label></strong>
                </h4>
            </div>
            <div class="clear">
            </div>
        </div>
        <!--HEADER END-->
    </form>
</body>
</html>
