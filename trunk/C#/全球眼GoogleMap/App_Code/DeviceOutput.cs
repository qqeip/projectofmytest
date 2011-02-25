using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MapDAL;
using System.Collections;
using MapModle;
using System.Collections.Generic;

/// <summary>
/// DeviceAlarmSearch 的摘要说明
/// </summary>
public class DeviceOutput
{
    public DeviceOutput()
    {
        
    }

    public static string GetDvsJSON(DataSet ds)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("[");

        int i = 0;
        foreach (DataRow dataRow in ds.Tables[0].Rows)
        {
            if (i != 0)
            {
                sb.Append(",");
            }
            sb.Append("[1," + Convert.ToString(dataRow["id"]) + "," +
                DataGlobal.ConvertToDouble(Convert.ToString(dataRow["Latitude"])) + "," +
                DataGlobal.ConvertToDouble(Convert.ToString(dataRow["Longitude"])) + "," +
                "\"" + Convert.ToString(dataRow["Dvsno"]) + "\"," +
                "\"" + Convert.ToString(dataRow["area1"]) + " > " + Convert.ToString(dataRow["area2"]) + " > " + Convert.ToString(dataRow["Suburb"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Dvskind"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customertype"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customername"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customeraddress"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Devicestate"]) + "\",");

            int contentcode = DataGlobal.ConvertToInt(Convert.ToString(dataRow["contentcode"]));
            sb.Append(contentcode.ToString() + ",");
            //告警记录
            if (contentcode > 0)
            {
                sb.Append(GetAlarmJSON(Convert.ToString(dataRow["id"])));
            }
            else
            {
                sb.Append("[]");
            }
            sb.Append("]");
            
            i++;
        }
        sb.Append("]");
        return sb.ToString();
    }

    private static string GetAlarmJSON(string deviceID)
    {
        StringBuilder sb2 = new StringBuilder();
        sb2.Append("[");
        AlarmOnline ao = new AlarmOnline();
        IList<AlarmOnlineInfo> list = ao.QueryDeviceAlarm(deviceID);

        int j = 0;
        foreach (AlarmOnlineInfo info in list)
        {
            if (j != 0)
            {
                sb2.Append(",");
            }
            sb2.Append("[\"" + info.CONTENTCODE + "\"," +
                "\"" + info.FLOWTACHE + "\"," +
                "\"" + info.COLLECTTIME.ToString() + "\"]");
            j++;
        }

        sb2.Append("]");
        return sb2.ToString();
    }

    public static string GetCameraJSON(DataSet ds)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("[");

        int i = 0;
        foreach (DataRow dataRow in ds.Tables[0].Rows)
        {
            if (i != 0)
            {
                sb.Append(",");
            }
            sb.Append("[2," + Convert.ToString(dataRow["id"]) + "," +
                DataGlobal.ConvertToDouble(Convert.ToString(dataRow["Latitude"])) + "," +
                DataGlobal.ConvertToDouble(Convert.ToString(dataRow["Longitude"])) + "," +
                "\"" + Convert.ToString(dataRow["Caremano"]) + "\"," +
                "\"" + Convert.ToString(dataRow["area1"]) + " > " + Convert.ToString(dataRow["area2"]) + " > " + Convert.ToString(dataRow["Suburb"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Caremakind"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customertype"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customername"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Customeraddress"]) + "\"," +
                "\"" + Convert.ToString(dataRow["Devicestate"]) + "\",");
            int contentcode = DataGlobal.ConvertToInt(Convert.ToString(dataRow["contentcode"]));
            sb.Append(contentcode.ToString() + ",");
            //告警记录
            if (contentcode > 0)
            {
                sb.Append(GetAlarmJSON(Convert.ToString(dataRow["id"])));
            }
            else
            {
                sb.Append("[]");
            }
            sb.Append("]");
            i++;
        }
        sb.Append("]");
        return sb.ToString();
    }
}
