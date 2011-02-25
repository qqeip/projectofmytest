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
using MapModle;
using MapBLL;

public partial class Admin_DelCamera : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["id"] != null && Request["id"] != "")
        {
            SelectCameras sc = new SelectCameras();
            Cameras c = sc.GetCamera(Request["id"].ToString());
            if (c != null)
            {
                hlkBack.NavigateUrl = "ResEncoder.aspx?id=" + c.Dvsid.ToString();
                hlkBack.Enabled = true;
                CameraManager cm = new CameraManager();
                cm.DeleteCamera(c.Id.ToString(), Session["userid"].ToString());
                ltlInfo.Text = "摄像头删除成功！";
            }
            else
            {
                ltlInfo.Text = "摄像头不存在！";
            }
        }
    }
}
