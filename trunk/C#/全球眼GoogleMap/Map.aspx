<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Map.aspx.cs" Inherits="Map" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <link href="CSS/mature.css" rel="stylesheet" type="text/css" />
    <link href="CSS/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" />
    <style type="text/css">

		#tabs { margin-top: 1em; }
		#tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
	</style>

</head>
<body onunload='GUnload()' style="height:100%">
    <form id="form1" runat="server">
       <div id="header">
            <div id="logo">
                <img src="Img/b/logo.png" title="欢迎光临XXX。"/></div>
            <div class="clear">
            </div>
            <div id="bar">
                <div class="top_menu" >
                    <div class="m_nav"><a href="Admin/AdminIndex.aspx" target="_self">管理中心</a></div>
                </div>
                <h5>
                    <asp:LinkButton ID="ibnLogout" runat="server" >安全退出</asp:LinkButton></h5>
                <h5>
                    当前用户:
                    <img src="Img/b/icon_user.jpg" />
                    <strong>
                        <asp:Label ID="lblUserRealName" runat="server" Text=""></asp:Label></strong>
                </h5>
            </div>
            <div class="clear">
            </div>
        </div>
        
        <div id="bg_container">
            <div id="wrapper">
                <div id="content">
                    <div class="inlinecontent">
                        <div id="mapwrapper" style="height: 600px"></div>
                    </div>
                </div>
            </div>
            <div id="sidebar">
                <div id="sidebar-content" class="inlinecontent">
                    <div class="heading_map">&nbsp;&nbsp;查询</div>
                    <div style="height: 70px;">
                        <div style="margin-top:10px" id="searchtype"><input type="radio" checked="checked" value="1" name="device" style="margin-right:5px;"/>编码器<input type="radio" value="2" name="device" style="margin-left:8px;margin-right:5px;"/>摄像头</div>
                        <div style="margin-top:10px">
                            <input id="searchKey" type="text" class="con_middle"/><input id="deviceSearch" type="button"
                                value="查询" class="o_bt4"/></div>
                    </div>
                    <div class="heading_map">&nbsp;&nbsp;查询结果</div>
                    <div id="tabs">
                        <ul>
		                    <li><a href="#tabs-1">告警设备</a></li>
		                    <li><a href="#tabs-2" title="通过地图选择设备">设备选择</a></li>
	                    </ul>
                        <div id="tabs-1">
                            <div id="deviceList" class="htj15"></div> 
                            <span id="devicePage" class="page_r"></span>   
	                    </div>
                        <div id="tabs-2">
                            <div id="tabs-dl-2" class="htj15"></div> 
                            <span id="tabs-page-2" class="page_r"></span>   
	                    </div>
                    </div>
                </div>
            
            </div>
        </div>
        <script src='<% =ConfigurationManager.AppSettings["googleMap"] %>' type="text/javascript"></script>
        <script src="JS/markermanager_packed.js" type="text/javascript"></script>
        <script src="JS/extlargemapcontrol_packed.js" type="text/javascript"></script>
        <script src="JS/progressbarcontrol_packed.js" type="text/javascript"></script>
        <script src="JS/jquery-1.4.2.min.js" type="text/javascript"></script>
        <script src="JS/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
        <script src="JS/map.js" type="text/javascript"></script>
        
        <script type="text/javascript">
            var zoom = 12;
            var defLng = 120.15467;
            var defLat = 30.29204;
            var alarmDvs = <%=alarmDvsJS %>;
            var alarmCamera = <%=alarmCameraJS %>;
            var allmarker = false;
            var progressBar;
            var progress = 0;
            var deviceData;
            
            var $tabs = null;
        
            $(document).ready(function(){
                $tabs = $("#tabs").tabs({
                    tabTemplate: '<li><a href="#{href}">#{label}</a> <span class="ui-icon ui-icon-close">Remove Tab</span></li>',
                    add: EYEMAP.MapShow.addTab
                });

                
                $('#tabs span.ui-icon-close').live('click', function() {
			        var index = $('li',$tabs).index($(this).parent());
			        $tabs.tabs('remove', index);
		        });


                EYEMAP.MapShow.init(); 
        });
        </script>
    </form>
</body>
</html>
