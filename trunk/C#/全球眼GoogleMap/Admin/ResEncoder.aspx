<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ResEncoder.aspx.cs" Inherits="WebSite1_Admin_ResEncoder"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>编码器信息</title>
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
                <asp:HyperLink ID="hlkNew" runat="server" NavigateUrl="resencoder.aspx">新增</asp:HyperLink>
            </h3>
            <div class="clear">
            </div>
        </div>
        <div>
            <div class="console_content">
                <h3>基本信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj" >
                            DVS编号<asp:HiddenField ID="hdfDvsID" runat="server" />
                        </td>
                        <td colspan="2">
                            <asp:TextBox ID="txtDvsNo" runat="server" MaxLength="25" class="con_middle"></asp:TextBox><span><em>*</em></span>
                            <asp:RequiredFieldValidator ID="rfvDvsNo" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>
                        <td class="con_new_table_obj" >
                            DVS型号</td>
                        <td>
                            <asp:DropDownList ID="ddlDvsKind" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>
                        
                     </tr>
                     <tr>
                        <td class="con_new_table_obj" >
                            DVS类型</td>
                        <td>
                        <asp:DropDownList ID="ddlDvsType" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>
                        <td class="con_new_table_obj" >
                            生产厂家</td>
                        <td>
                        <asp:DropDownList ID="ddlDeviceManu" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>
                        <td class="con_new_table_obj">
                            产权</td>
                        <td>
                        <asp:DropDownList ID="ddlDevicePropertyRight" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>                        
                     </tr>
                     <tr>
                        <td class="con_new_table_obj" >
                            分线盒编码</td>
                        <td colspan="2">
                            <asp:TextBox ID="txtJunctionBoxNo" runat="server" MaxLength="25" class="con_middle"></asp:TextBox><span><em>*</em></span>
                            <asp:RequiredFieldValidator ID="rfvJunctionBoxNo" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>
                        <td class="con_new_table_obj">
                            设备等级</td>
                        <td>
                        <asp:DropDownList ID="ddlDeviceLevel" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>
                       </tr>
                     <tr>
                     <td class="con_new_table_obj" >
                            固定资产编号</td>
                        <td colspan="2">
                            <asp:TextBox ID="txtAssertNo" runat="server" MaxLength="25" class="con_middle"></asp:TextBox>
                        </td>
                        <td class="con_new_table_obj">
                            设备状态</td>
                        <td>
                        <asp:DropDownList ID="ddlDeviceState" runat="server" class="con_short">
                            </asp:DropDownList>
                        </td>
                     </tr> 
                </table> 
                <h3>区域信息</h3>
                    <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            郊县</td>
                        <td colspan="3">
                        <asp:DropDownList ID="ddlTown" runat="server" class="con_short">
                            </asp:DropDownList>
                            分局
                            <asp:Literal ID="ltlSuburb" runat="server"></asp:Literal>

                            <asp:HiddenField ID="hdfSuburb" runat="server" />
                            <span><em>*</em></span>                 
                        </td>
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
                        <td><asp:TextBox ID="txtCustomerName" runat="server" MaxLength="25" class="con_middle"></asp:TextBox><span><em>*</em></span>
                        <asp:RequiredFieldValidator ID="rfvCustomerName" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>   
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            用户地址</td>
                        <td colspan="3">
                            <asp:TextBox ID="txtCustomerAddress" runat="server"  MaxLength="2000" Rows="3"
                                TextMode="MultiLine" Width="455px"></asp:TextBox><span><em>*</em></span>
                            <asp:RequiredFieldValidator ID="rfvCustomerAddress" runat="server" ErrorMessage="RequiredFieldValidator"
                                    Display="Dynamic"></asp:RequiredFieldValidator>
                                </td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            安装时间</td>    
                        <td class="con_new_table_obj">
                            <asp:TextBox ID="txtInstalldate" runat="server" class="date con_short" MaxLength="11"></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            安装位置</td>
                        <td><asp:TextBox ID="txtInstallPlace" runat="server" MaxLength="25" class="con_middle"></asp:TextBox></td>   
                    </tr>
                    <tr>
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
                        <td colspan="3">
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
                            维护人</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtSurfaceMan" runat="server" class="con_short" ></asp:TextBox></td>   
                        <td class="con_new_table_obj">
                            联系方式</td>  
                        <td><asp:TextBox ID="txtSurfaceManPhone" runat="server" class="con_short" ></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            客户经理</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtCustomerManager" runat="server" class="con_short" ></asp:TextBox></td>   
                        <td class="con_new_table_obj">
                            联系方式</td>  
                        <td><asp:TextBox ID="txtCustomerManagerPhone" runat="server" class="con_short" ></asp:TextBox></td>
                    </tr>
                </table>
                <h3>IP信息</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            LAN编号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtLanNo" runat="server" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            宽带接入编号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtBroadbandAccessNo" runat="server" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            IP地址</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtIP" runat="server" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            网关</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtGateway" runat="server" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            子网掩码</td>  
                        <td><asp:TextBox ID="txtSubnetMask" runat="server" class="con_short" ></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            拨号帐号</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtDialupAccount" runat="server" class="con_short" ></asp:TextBox></td>
                        <td class="con_new_table_obj">
                            拨号密码</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtDialupPassword" runat="server" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
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
                <h3>其他</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            业务类型</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlServiceType" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            业务描述</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtServiceDesc" runat="server" MaxLength="25" class="con_middle"></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj">
                            存储类型</td>  
                        <td class="con_new_table_obj"><asp:DropDownList ID="ddlStorageType" runat="server" class="con_short"></asp:DropDownList></td>
                        <td class="con_new_table_obj">
                            存储时间</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtStorageTime" runat="server" class="con_short" ></asp:TextBox></td>    
                        <td class="con_new_table_obj">
                            </td>  
                        <td></td>
                    </tr>
                </table>
                <h3>摄像头</h3>
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">端口数</td>  
                        <td class="con_new_table_obj"><asp:TextBox ID="txtPortNum" runat="server" class="con_short" Text="8"></asp:TextBox><span><em>*</em>1~16</span></td>
                        <td class="con_new_table_obj"><asp:RequiredFieldValidator ID="rfvPortNum" runat="server" ErrorMessage="RequiredFieldValidator"></asp:RequiredFieldValidator></td>  
                        <td class="con_new_table_obj"><asp:RangeValidator ID="rvdPortNum" runat="server" ErrorMessage="RangeValidator"></asp:RangeValidator></td>    
                        <td class="con_new_table_obj"><asp:RegularExpressionValidator ID="revPortNum" runat="server" ErrorMessage="RegularExpressionValidator"></asp:RegularExpressionValidator></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="con_new_table_obj"></td>
                        <td colspan="5"><asp:Button
                                ID="btnRefresh" runat="server" Text="刷新" OnClick="btnRefresh_Click" CssClass="button_short" CausesValidation="false" /></td>
                    </tr>
                    <tr>
                        <td colspan="6">
                            <asp:Literal ID="ltrCameras" runat="server"></asp:Literal></td>
                    </tr>
                </table>
                
                <table border="0" cellspacing="0" cellpadding="0" class="con_new_table" >
                    <tr>
                        <td class="con_new_table_obj">
                            </td> 
                        <td>
                            <asp:Button ID="btnModify" runat="server" Text="确定修改" CssClass="button_long" OnClientClick="return check();" OnClick="btnModify_Click" />
                        </td>
                    </tr>
                </table>
                    
            </div>
        </div>
        <script src='<% =ConfigurationManager.AppSettings["googleMap"] %>' type="text/javascript"></script>
        <script src="../JS/map.js" type="text/javascript"></script>
        <script language="javascript" type="text/javascript">
            function check()
            {
                var branch = $("#hdfSuburb").val();
                if ((branch == "") || (branch == "0"))
                {
                    alert("请选择分局！");
                    return false;
                } 
                return true;
            }
            
            $(document).ready(function() {
                EYEMAP.GetPosition.init();
                
                $('#ddlTown').change(function(){
                    var id = $("#ddlTown").val();
                    if ( id != "0" )
                    { 
                        $.ajax({
                            url: '../Ajax/GetArea.aspx?pid=' + id,
                            dataType: 'json',
                            
                            type: 'get',
                            success: function (data) {
                                if (data.length) {
                                    $('#ddlSuburb').empty();
                                    $.each(data, function (index, term) {
                                        $('<option value="' + term[0] + '">' + term[1] + '</option>').appendTo($('#ddlSuburb'));
                                    });
                                    $('<option value="0" selected="selected">请选择分局</option>').appendTo($('#ddlSuburb'));
                                }
                            }
                        });   
                    }
                });
                

                $('#ddlSuburb').change(function(){
                    $("#hdfSuburb").val($("#ddlSuburb").val()); 
                });
                
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
                
            });//ready end
        
        </script>
    </form>
</body>
</html>
