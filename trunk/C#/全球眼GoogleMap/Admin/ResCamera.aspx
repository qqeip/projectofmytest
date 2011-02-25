<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResCamera.aspx.cs" Inherits="Admin_ResCamera" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>摄像头信息</title>
        <link href="../Css/mature2.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" />
    <script src="../JS/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="../JS/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
</head>
<body onunload="GUnload()">
    <form id="form1" runat="server">
        <div class="console_head">
            <h3>
                <img src="../Img/b/icon_cons_add.gif" />
                <asp:HyperLink ID="hlkNew" runat="server">新增</asp:HyperLink>
                <img src="../Img/b/icon_cons_back.gif" />
                <asp:HyperLink ID="hlkBack" runat="server">返回到编码器</asp:HyperLink>
            </h3>
            <div class="clear">
            </div>
        </div>
    <div>
        <div class="console_content">
            <h3>基本信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            摄像头编码</td>  
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtCameraNo" runat="server" CssClass="con_short"></asp:TextBox><span><em>*</em></span>
                            <asp:RequiredFieldValidator ID="rfvCameraNo" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator></td>
                        <td class="con_new_table_obj">
                            摄像头类型</td>  
                        <td class="con_new_table_obj">
                            <asp:DropDownList ID="ddlCameraType" runat="server" CssClass="con_short">
                            </asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            摄像头型号</td>  
                        <td>
                            <asp:DropDownList ID="ddlCameraKind" runat="server" CssClass="con_short">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            分线盒编码</td>  
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtJunctionBoxNo" runat="server" CssClass="con_short"></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            生产厂家</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlDeviceManu" runat="server" class="con_short">
                            </asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            产权</td>  
                        <td><asp:DropDownList ID="ddlDevicePropertyRight" runat="server" class="con_short">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            设备等级</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlDeviceLevel" runat="server" class="con_short">
                            </asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            设备状态</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlDeviceState" runat="server" class="con_short">
                            </asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            固定资产编号</td>  
                        <td><asp:TextBox ID="txtAssertNo" runat="server" MaxLength="25" class="con_short"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            受理标号</td>
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtHandleNo" runat="server" CssClass="con_short"></asp:TextBox>
                        </td>
                        <td class="con_new_table_obj">
                            单点位置</td>
                        
                        <td colspan="3">
                            <asp:TextBox ID="txtSinglePlace" runat="server" Width="450px" CssClass="con_middle"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            相关信息</td>  
                         
                        <td colspan="5">
                            <asp:TextBox ID="txtInfo" runat="server" CssClass="con_long"></asp:TextBox></td>
                    </tr>
                </table>
            <h3>端口信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            郊县</td>  
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtTown" runat="server"  Enabled="false" CssClass="con_short"></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            分局</td>  
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtSuburb" runat="server"  Enabled="false" CssClass="con_short"></asp:TextBox></td>    
                        <td>
                            </td>  
                        <td>
                            </td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            DVS编号</td>  
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtDvsID" runat="server"  Enabled="false" CssClass="con_short"></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            管道ID</td>  
                        <td class="con_new_table_obj">
                            <asp:DropDownList ID="ddlDvsPort" runat="server" CssClass="con_short">
                            </asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                </table>  
                
                <h3>安装信息</h3> 
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            用户类别</td>
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlCustomerType" runat="server" class="con_short">
                            </asp:DropDownList></td> 
                        <td class="con_new_table_obj">
                            用户名称</td>
                        <td colspan="3"><asp:TextBox ID="txtCustomerName" runat="server" MaxLength="25" Width="450px" class="con_middle"></asp:TextBox><span><em>*</em></span>
                        <asp:RequiredFieldValidator ID="rfvCustomerName" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>   
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            用户地址</td>
                        <td colspan="5">
                            <asp:TextBox ID="txtCustomerAddress" runat="server"  MaxLength="2000" Rows="3" Height="65px"
                                TextMode="MultiLine" CssClass="con_long"></asp:TextBox><span><em>*</em></span>
                            <asp:RequiredFieldValidator ID="rfvCustomerAddress" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                                </td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            安装时间</td>    
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtInstalldate" runat="server" class="con_short" MaxLength="11"></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            安装位置</td>
                        <td colspan="3"><asp:TextBox ID="txtInstallPlace" runat="server" MaxLength="25" Width="450px" class="con_middle"></asp:TextBox></td>   
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            安装方式</td>
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlInstallMode" runat="server" class="con_short">
                            </asp:DropDownList></td> 
                        <td class="con_new_table_obj">
                            经度</td>    
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtLongitude" runat="server" class="con_short" Height="20px" MaxLength="15"></asp:TextBox>
                            <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="RangeValidator"></asp:RangeValidator>
                            </td>
                        <td class="con_new_table_obj">
                            纬度</td>
                        <td><asp:TextBox ID="txtLatitude" runat="server" class="con_short" Height="20px" MaxLength="15"></asp:TextBox>
                        <asp:RangeValidator ID="RangeValidator2" runat="server" ErrorMessage="RangeValidator"></asp:RangeValidator></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            </td> 
                        <td colspan="5">
                            <div id="map" style="width: 400px; height: 300px">
                            </div>   
                        </td>
                    </tr>
                </table> 
                <h3>联系人</h3> 
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            业务联系人</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtLinkman" runat="server" class="con_short" ></asp:TextBox></td>   
                        <td class="con_new_table_obj">
                            联系方式</td>  
                        <td><asp:TextBox ID="txtLinkmanPhone" runat="server" class="con_short"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            客户经理</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtCustomerManager" runat="server"  Enabled="false" class="con_short" ></asp:TextBox></td>   
                        <td class="con_new_table_obj">
                            联系方式</td>  
                        <td><asp:TextBox ID="txtCustomerManagerPhone" runat="server"  Enabled="false" class="con_short" ></asp:TextBox></td>
                    </tr>
                </table> 
            <h3>供电信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            供电类型</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlPowerType" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            供电电压</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlPowerVoltage" runat="server" class="con_short"></asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            付费方式</td>  
                        <td><asp:DropDownList ID="ddlPaymentType" runat="server" class="con_short"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            接入位置</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlSwitchinPlace" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            接入方式</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlSwitchinMode" runat="server" class="con_short"></asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                </table>
             <h3>IP信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            LAN编号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtLanNo" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            宽带接入编号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtBroadbandAccessNo" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            IP地址</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtIP" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            网关</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtGateway" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            子网掩码</td>  
                        <td><asp:TextBox ID="txtSubnetMask" runat="server" class="con_short" Enabled="false"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            拨号帐号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtDialupAccount" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            拨号密码</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtDialupPassword" runat="server" Enabled="false" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>    
                </table>
            <h3>其他</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            控制协议</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlControlProtocol" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            波特率</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlBaudrate" runat="server" class="con_short"></asp:DropDownList></td>    
                        <td class="con_new_table_obj">
                            485地址</td>  
                        <td><asp:DropDownList ID="ddlCodeAddr" runat="server" class="con_short"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            码流</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlCodeStream" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            存储类型</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlStorageType" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            存储时间</td>  
                        <td><asp:TextBox ID="txtStorageTime" runat="server" class="con_short" ></asp:TextBox></td>    
                        
                    </tr>
                </table>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            </td> 
                        <td>
                            <asp:Button ID="btnModify" runat="server" Text="确定修改" CssClass="button_long" OnClick="btnModify_Click"  />
                        </td>
                    </tr>
                </table>      
            </div>
        <asp:HiddenField ID="hdfCameraID" runat="server" />
        <asp:HiddenField ID="hdfDvsID" runat="server" />
        <asp:HiddenField ID="hdfSuburbID" runat="server" />
    </div>
    <script src='<% =ConfigurationManager.AppSettings["googleMap"] %>' type="text/javascript"></script>
    <script src="../JS/map.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">  
            $(document).ready(function() {
                EYEMAP.GetPosition.init();
                
                $.datepicker.regional['zh-CN'] = {
		            closeText: '关闭',
		            prevText: '&#x3c;上月',
		            nextText: '下月&#x3e;',
		            currentText: '今天',
		            monthNames: ['一月','二月','三月','四月','五月','六月',
		            '七月','八月','九月','十月','十一月','十二月'],
		            monthNamesShort: ['一','二','三','四','五','六',
		            '七','八','九','十','十一','十二'],
		            dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
		            dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
		            dayNamesMin: ['日','一','二','三','四','五','六'],
		            dateFormat: 'yy-mm-dd', firstDay: 1,
		            isRTL: false,
		            showMonthAfterYear: true,
		            showButtonPanel: true,
		            duration: 'fast'};
	            $.datepicker.setDefaults($.datepicker.regional['zh-CN']);
                $("#txtInstalldate").datepicker();
                
            
            });
    </script>
    </form>
</body>
</html>
