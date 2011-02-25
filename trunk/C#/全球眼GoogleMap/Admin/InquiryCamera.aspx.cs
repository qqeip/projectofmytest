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
using System.Text;
using System.Collections.Generic;
using MapBLL;

public partial class Admin_InquiryCamera : System.Web.UI.Page
{
    public int count = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //字典
            DataGlobal.LoadDictType(ddlCameraKind, DicType.CaremaKind);
            DataGlobal.LoadDictType(ddlCameraType, DicType.CaremaType);
            DataGlobal.LoadDictType(ddlCustomerType, DicType.CustomerType);
            DataGlobal.LoadDictType(ddlDeviceManu, DicType.DeviceManu);
            DataGlobal.LoadDictType(ddlDevicePropertyRight, DicType.DevicePropertyRight);
            DataGlobal.LoadDictType(ddlDeviceLevel, DicType.DeviceLevel);
            DataGlobal.LoadDictType(ddlDeviceState, DicType.DeviceState);
            DataGlobal.LoadDictType(ddlPowerType, DicType.PowerType);

            DataGlobal.LoadTown(ddlTown, Session["userid"].ToString());
            DataGlobal.SetGridStyle(gvwCamera, "con_list");
        }
        LoadArea();
    }
    protected void btnQuery_Click(object sender, EventArgs e)
    {
        hlkExportFile.Text = "camera" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
        Query();
    }

    private void Query()
    {
        DataSet ds = DoQuery();
        gvwCamera.AllowSorting = true;
        gvwCamera.DataSource = ds;
        gvwCamera.DataKeyNames = new string[] { "id" };
        gvwCamera.DataBind();
    }

    private DataSet DoQuery()
    {
        SelectCameras sd = new SelectCameras();
        DataSet ds;
        if (hdfFlag.Value == "0")
        {
            ds = sd.Query(Session["userid"].ToString(), Session["cityid"].ToString(), txtBasicCondition.Text);

        }
        else
        {

            ds = sd.Query(Session["userid"].ToString(), Session["cityid"].ToString(), txtCameraNo.Text.Trim(), txtDvsNo.Text.Trim(), hdfSuburb.Value, ddlCameraType.SelectedValue,
                ddlCameraKind.SelectedValue, ddlDeviceManu.SelectedValue, ddlDevicePropertyRight.SelectedValue, ddlDeviceLevel.SelectedValue,
                ddlDeviceState.SelectedValue, ddlPowerType.SelectedValue, ddlCustomerType.SelectedValue, txtCustomerName.Text.Trim(),
                txtCustomerAddress.Text.Trim(), txtBegin.Text.Trim(), txtEnd.Text.Trim(), txtLanNo.Text.Trim(), txtIP.Text.Trim(), txtAssertNo.Text.Trim());
        }
        return ds;
    }

    private void LoadArea()
    {
        if (hdfSuburb.Value != "" && hdfSuburb.Value != "0")
        {
            SelectAreas sa = new SelectAreas();
            Areas town = sa.GetParentAreas(hdfSuburb.Value);
            ddlTown.SelectedValue = town.ID.ToString();

            StringBuilder sb = new StringBuilder();
            IList<Areas> suburbList = sa.Getsuburb(town.ID.ToString(), Session["userid"].ToString());
            sb.Append("<select id=\"ddlSuburb\">");
            foreach (Areas area in suburbList)
            {
                if (area.ID.ToString() == hdfSuburb.Value)
                {
                    sb.Append("<option selected=\"selected\" value=\"" + area.ID.ToString() + "\">" + area.Area_Name + "</option>");
                }
                else
                {
                    sb.Append("<option value=\"" + area.ID.ToString() + "\">" + area.Area_Name + "</option>");
                }
            }
            sb.Append("<option value=\"0\">请选择分局</option>");
            sb.Append("</select>");
            ltlSuburb.Text = sb.ToString();
        }
        else
        {
            ltlSuburb.Text = "<select id=\"ddlSuburb\"><option value=\"0\">请选择分局</option></select>";
        }
    }
    protected void gvwCamera_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string id = gvwCamera.DataKeys[e.RowIndex].Value.ToString();
        CameraManager cm = new CameraManager();
        cm.DeleteCamera(id, Session["userid"].ToString());
        Query();
    }
    protected void gvwCamera_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvwCamera.PageIndex = e.NewPageIndex;
        Query();
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        DataSet ds = DoQuery();
        CameraManager cm = new CameraManager();
        if (cm.Export(ds.Tables[0], Server.MapPath("~/Tmp/") + hlkExportFile.Text))
        {

            Response.Clear();
            Response.Charset = "GB2312";
            Response.Buffer = true;
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("GB2312");
            Response.AppendHeader("Content-Disposition", "attachment;filename=" + hlkExportFile.Text);
            Response.ContentType = "application/ms-excel";
            Response.WriteFile(Server.MapPath("~/Tmp/") + hlkExportFile.Text);
            Response.Flush();
            Response.Close();
            Response.End();
        }
        else
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "失败", "<script>alert('查询结果导出失败，请联系管理员！')</script>");
            return;
        }
    }
}
