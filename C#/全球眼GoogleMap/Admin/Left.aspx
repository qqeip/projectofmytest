<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Left.aspx.cs" Inherits="WebSite1_Admin_Left" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>树图导航</title>
    <link href="../CSS/jquery.treeview.css" rel="stylesheet" type="text/css" />
    
</head>
<body>
    
    <form id="form1" runat="server">
    <div>
        <h4>设备树图</h4>
        <asp:TreeView ID="TreeView1" runat="server" Width="248px" OnTreeNodeExpanded="TreeView1_TreeNodeExpanded">
        </asp:TreeView>
        </div>
    </form>
</body>
</html>
