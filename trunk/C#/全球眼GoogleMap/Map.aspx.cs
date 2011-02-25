using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MapDAL;
using System.Collections.Generic;
using MapModle;
using System.Text;

public partial class Map : System.Web.UI.Page
{
    public string alarmDvsJS = "";
    public string alarmCameraJS = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadAlarmDvs();
        LoadAlarmCamera();
    }

    private void LoadAlarmCamera()
    {
        SelectCameras sd = new SelectCameras();
        DataSet ds = sd.QueryAlarm(Session["userid"].ToString(), Session["cityid"].ToString());
        
        alarmCameraJS = DeviceOutput.GetCameraJSON(ds);
    }

    private void LoadAlarmDvs()
    {
        SelectDvs sd = new SelectDvs();
        DataSet ds = sd.QueryAlarm(Session["userid"].ToString(), Session["cityid"].ToString());
        
        alarmDvsJS = DeviceOutput.GetDvsJSON(ds);
    }
}
