using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MapDAL;
using System.Collections;
using MapModle;
using System.Collections.Generic;

public class DicType
{
    public const int Alarm_Level_List = 3;
    public const int Alarm_Flow_Tache_List = 4;
    public const int Alarm_SendType = 11;
    public const int Alarm_Type = 12;
    public const int DvsKind = 20;
    public const int DvsType = 21;
    public const int ServiceType = 22;
    public const int CaremaType = 23;
    public const int CaremaKind = 24;
    public const int DeviceManu = 25;
    public const int DevicePropertyRight = 26;
    public const int DeviceState = 28;
    public const int CustomerType = 29;
    public const int InstallMode = 30;
    public const int ControlProtocol = 31;
    public const int BaudRate = 32;
    public const int CodeAddr = 33;
    public const int CodeStream = 34;
    public const int StorageType = 35;
    public const int PowerType = 36;
    public const int PowerVoltage = 37;
    public const int PaymentType = 38;
    public const int CustomerKind = 39;
    public const int Alarm_RepItem_List = 14;
    public const int AlarmKind = 2;
    public const int Alarm_Cause_List = 7;
    public const int Alarm_Resolvent_List = 6;
    public const int SWITCHINMODE = 40;
    public const int SWITCHINPLACE = 41;
    public const int Device_Full_Percent = 15;
    public const int AlarmOccurCent = 16;
    public const int AlarmSpendingStat = 17;
    public const int RING_TYPE = 42;
    public const int AlarmBillType = 5;
    public const int COMPANY_REP = 19;
    public const int BRANCH_REP = 18;
    public const int AlarmOPRecType = 101;
    public const int DeviceLevel = 43;
    public DicType()
    {
    }

}
/// <summary>
/// DataGlobal 的摘要说明
/// </summary>
public class DataGlobal
{
    public DataGlobal()
    {
        
    }

    /// <summary>
    /// 加载字典类型
    /// </summary>
    /// <param name="fddl">列表框</param>
    public static void LoadDictType(DropDownList fddl, int dicType)
    {
        fddl.Items.Clear();
        DicCode dc = new DicCode();
        IList<AlarmDicCodeInfo> dicList = dc.GetDicCode(dicType);
        foreach (AlarmDicCodeInfo dic in dicList)
        {
            ListItem ddlone = new ListItem(dic.DicName, dic.DicCode.ToString());
            fddl.Items.Add(ddlone);
        }

        ListItem ddltwo = new ListItem("请选择", "0");
        ddltwo.Selected = true;
        fddl.Items.Add(ddltwo);
    }

    public static void LoadDeviceLevel(DropDownList fddl)
    {
        fddl.Items.Clear();
        DeviceLevel dc = new DeviceLevel();
        IList<DeviceLevelInfo> dicList = dc.GetDeviceLevel();
        foreach (DeviceLevelInfo dic in dicList)
        {
            ListItem ddlone = new ListItem(dic.NAME, dic.ID.ToString());
            fddl.Items.Add(ddlone);
        }

        ListItem ddltwo = new ListItem("请选择", "0");
        ddltwo.Selected = true;
        fddl.Items.Add(ddltwo);
    }

    public static void LoadTown(DropDownList fddl, string userid)
    {
        SelectAreas sa = new SelectAreas();
        IList<Areas> areas = sa.GetAreas(userid);
        foreach (Areas area in areas)
        {
            ListItem ddlone = new ListItem(area.Area_Name, area.ID.ToString());
            fddl.Items.Add(ddlone);
        }
        ListItem ddltwo = new ListItem("请选择郊县", "0");
        ddltwo.Selected = true;
        fddl.Items.Add(ddltwo);
    }

    public static void SetGridStyle(GridView fGridView, string fGridStyle)
    {
        fGridView.CssClass = fGridStyle;
        fGridView.CellPadding = 0;
        fGridView.CellSpacing = 0;
        fGridView.HeaderStyle.CssClass = "ti";
        fGridView.RowStyle.CssClass = "color2";

        fGridView.AlternatingRowStyle.CssClass = "color1";
        fGridView.RowCreated += GridView_RowCreated;
        //设置空数据集template
        string htmlTemplate = "";
        htmlTemplate += "<tr class='ti'>";
        foreach (DataControlField dcf in fGridView.Columns)
        {
            htmlTemplate += "<th class='" + dcf.HeaderStyle.CssClass + "' scope='col'>" +
                dcf.HeaderText + "</th>";
        }
        htmlTemplate += "</tr>";

        fGridView.EmptyDataText = htmlTemplate;
        //分页功能
        fGridView.AllowPaging = true;
        fGridView.PageSize = 20;
    }

    protected static void GridView_RowCreated(object sender, GridViewRowEventArgs e)
    {
        // header 不加效果
        if (e.Row.RowIndex != -1)
        {
            // 奇数行
            if (e.Row.RowIndex % 2 == 1)
            {
                e.Row.Attributes.Add("onmouseout", "this.className='color1'");
            }
            // 偶数行
            else
            {
                e.Row.Attributes.Add("onmouseout", "this.className='color2'");
            }
            e.Row.Attributes.Add("onmouseover", "this.className='gridMouseOver'");
        }
    }

    public static int ConvertToInt(string fVal)
    {
        return Convert.ToInt32(fVal.Trim().Equals("") ? "0" : fVal.Trim());
    }

    public static double ConvertToDouble(string fVal)
    {
        return Convert.ToDouble(fVal.Trim().Equals("") ? "0" : fVal.Trim());
    }
}
