<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InquiryDvs.aspx.cs" Inherits="Admin_InquiryDvs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>查询编码器</title>
    <link href="../Css/mature2.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" />

    <script src="../JS/jquery-1.4.2.min.js" type="text/javascript"></script>

    <script src="../JS/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="console_tab_head">
            <h4 class="console_head_on">
                查询编码器</h4>
            <h4 class="console_head_off">
                <a href="InquiryCamera.aspx">查询摄像头</a></h4>
            <div class="clear">
            </div>
        </div>
        <div class="console_content">
            <h3>
                查询条件</h3>
            <table class="con_new_table">
                <tr>
                    <td class="con_new_table_obj">
                        快速查询</td>
                    <td class="con_new_table_obj">
                        <asp:TextBox ID="txtBasicCondition" runat="server" CssClass="con_middle"></asp:TextBox></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        &nbsp;</td>
                    <td class="con_new_table_obj">
                        <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal"
                            Width="200px">
                            <asp:ListItem Selected="True" Value="0">快速查询</asp:ListItem>
                            <asp:ListItem Value="1">高级查询</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td class="con_new_table_obj" style="width:150px">
                        <asp:Button ID="btnQuery" runat="server" Text="查询" CssClass="button_long" OnClick="btnQuery_Click" />
                        <input id="Button1" type="button" value="清空条件" class="button_long" onclick="javascript:clear();" /></td>
                    <td class="con_new_table_obj" style="width:250px">
                        <asp:HyperLink ID="hlkExportFile" runat="server" Enabled="false"></asp:HyperLink>
                        <asp:Button ID="btnExport" runat="server" CssClass="button_long" Text="导出" OnClick="btnExport_Click" />
                    </td>
                </tr>
            </table>
            <table id="adv" class="con_new_table displayNone" style="width: 950px">
                <tr>
                    <td class="con_new_table_obj">
                        DVS编号
                    </td>
                    <td colspan="7">
                        <asp:TextBox ID="txtDvsNo" runat="server" MaxLength="25" class="con_middle"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        DVS型号</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlDvsKind" runat="server" class="con_short">
                        </asp:DropDownList>
                    </td>
                    <td class="con_new_table_obj">
                        DVS类型</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlDvsType" runat="server" class="con_short">
                        </asp:DropDownList>
                    </td>
                    <td class="con_new_table_obj">
                        生产厂家</td>
                    <td class="con_new_table_obj">
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
                    <td class="con_new_table_obj">
                        区域</td>
                    <td colspan="7">
                        郊县<asp:DropDownList ID="ddlTown" runat="server" class="con_short">
                        </asp:DropDownList>
                        分局
                        <asp:Literal ID="ltlSuburb" runat="server"></asp:Literal>
                        <asp:HiddenField ID="hdfSuburb" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        设备等级</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlDeviceLevel" runat="server" class="con_short">
                        </asp:DropDownList>
                    </td>
                    <td class="con_new_table_obj">
                        设备状态</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlDeviceState" runat="server" class="con_short">
                        </asp:DropDownList>
                    </td>
                    <td class="con_new_table_obj">
                        供电类型</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlPowerType" runat="server" class="con_short">
                        </asp:DropDownList></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        用户类别</td>
                    <td class="con_new_table_obj">
                        <asp:DropDownList ID="ddlCustomerType" runat="server" class="con_short">
                        </asp:DropDownList></td>
                    <td class="con_new_table_obj">
                        用户名称</td>
                    <td colspan="5">
                        <asp:TextBox ID="txtCustomerName" runat="server" MaxLength="25" class="con_short"
                            Width="600px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        用户地址</td>
                    <td colspan="7">
                        <asp:TextBox ID="txtCustomerAddress" runat="server" MaxLength="2000" class="con_short"
                            Width="800px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        安装时间</td>
                    <td colspan="7">
                        开始时间<asp:TextBox ID="txtBegin" CssClass="con_short" runat="server"></asp:TextBox>结束日期
                        <asp:TextBox ID="txtEnd" CssClass="con_short" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td class="con_new_table_obj">
                        LAN编号</td>
                    <td class="con_new_table_obj">
                        <asp:TextBox ID="txtLanNo" runat="server" class="con_short"></asp:TextBox></td>
                    <td class="con_new_table_obj">
                        IP地址</td>
                    <td class="con_new_table_obj">
                        <asp:TextBox ID="txtIP" runat="server" class="con_short"></asp:TextBox></td>
                    <td class="con_new_table_obj">
                        固定资产编号</td>
                    <td colspan="5">
                        <asp:TextBox ID="txtAssertNo" runat="server" MaxLength="25" class="con_middle" Width="350px"></asp:TextBox>
                    </td>
                </tr>
            </table>
            <h3>
                查询结果</h3>
            <asp:GridView runat="server" ID="gvwDvs" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
                EmptyDataText="没有记录" RowHeaderColumn="ID" Width="90%" OnPageIndexChanging="gvwDvs_PageIndexChanging" OnRowDeleting="gvwDvs_RowDeleting">
                <PagerSettings FirstPageText="首页" LastPageText="末页" NextPageText="下一页" PageButtonCount="10"
                    PreviousPageText="上一页" Mode="NumericFirstLast" />
                <PagerStyle Font-Underline="true" Font-Size="X-Large" BackColor="Coral" Width="400px"
                    Font-Bold="false" />
                <Columns>
                    <asp:TemplateField HeaderText="序号">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text=""><%=count++ %></asp:Label>
                        </ItemTemplate>
                        <ItemStyle Width="50px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="删除">
                        <ItemTemplate>
                            <asp:LinkButton ID="lbtDelete" runat="server" CommandName="Delete" OnClientClick="return confirm('确定删除数据行？')">
                            <img src="../img/b/btn_del.gif" alt="删除"></asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle Width="50px" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="ID" HeaderText="编号">
                        <ItemStyle CssClass="displayNone" />
                        <HeaderStyle CssClass="displayNone" />
                    </asp:BoundField>
                    <asp:HyperLinkField DataNavigateUrlFields="id" DataNavigateUrlFormatString="ResEncoder.aspx?id={0}"
                        DataTextField="dvsno" DataTextFormatString="{0}" HeaderText="DVS编号">
                        <ItemStyle Width="150px" />
                    </asp:HyperLinkField>
                    <asp:BoundField DataField="dvskind" HeaderText="DVS型号">
                        <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="area2" HeaderText="郊县">
                        <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="suburb" HeaderText="分局">
                        <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="devicelevel" HeaderText="设备等级">
                        <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="devicestate" HeaderText="设备状态">
                        <ItemStyle Width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="portnum" HeaderText="端口数">
                        <ItemStyle Width="50px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="CUSTOMERNAME" HeaderText="用户名称">
                        <ItemStyle />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:HiddenField ID="hdfFlag" runat="server" Value="0" />

        <script language="javascript" type="text/javascript"> 
            function clear()
            {
                alert('l');
                $('input[type="text"]').val("");
                $('select').val("0");
            }
            
            function check()
            {
                if ($("#hdfFlag").val() == "0")
                {
                    $("#adv").hide();
                }
                else
                {
                    $("#adv").show();
                }   
            }  
            $(document).ready(function() {
                
                check();
                
                $('input[name="RadioButtonList1"]').click(function() {
                    $("#hdfFlag").val($(this).val());
                    check();
                });
                
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
                $("#txtBegin").datepicker();
                $("#txtEnd").datepicker();

            });
        </script>

    </form>
</body>
</html>
