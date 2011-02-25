<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminIndex.aspx.cs" Inherits="WebSite1_Admin_AdminIndex" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>后台功能</title>
</head>  
<frameset id="frame" framespacing="0" border="false" rows="105,*" frameborder="0" scolling="no" >
	<frame name="top"   marginwidth="0"  src="Top.aspx" scrolling="no">
	<frameset framespacing="0" border="false" cols="200,*" frameborder="0" scrolling="yes" class="gb"  >
		<frame name="left" scrolling="yes" src="Left.aspx">
		<frame name="right" scrolling="yes" src="InquiryDvs.aspx" >
	</frameset>
</frameset>
         
</html>
