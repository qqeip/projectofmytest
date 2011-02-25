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

public partial class Ajax_DeviceSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string key = Request.QueryString["key"];
        string type = Request.QueryString["type"];
        string result = "[]";
        if (type == "1")   //查询编码器
        {
            SelectDvs sd = new SelectDvs();
            DataSet ds = sd.Query(Session["userid"].ToString(), Session["cityid"].ToString(), key);
    
            result = DeviceOutput.GetDvsJSON(ds);
        }
        else if (type == "2")  //查询摄像头
        {
            SelectCameras sc = new SelectCameras();
            DataSet ds = sc.Query(Session["userid"].ToString(), Session["cityid"].ToString(), key);

            result = DeviceOutput.GetCameraJSON(ds);
        }
        else if (type == "3")  //
        {
            SelectDvs sd = new SelectDvs();
            DataSet ds = sd.QueryNormal(Session["userid"].ToString(), Session["cityid"].ToString());
            result = DeviceOutput.GetDvsJSON(ds);
        }
        else if (type == "4")
        {
            SelectCameras sc = new SelectCameras();
            DataSet ds = sc.QueryNormal(Session["userid"].ToString(), Session["cityid"].ToString());

            result = DeviceOutput.GetCameraJSON(ds);
        }
        Response.ContentType = "application/json";
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.Write("{\"a\":" + result + "}");
        Response.End();
    }
}
