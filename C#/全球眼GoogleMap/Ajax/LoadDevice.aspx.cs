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
using System.Text;
using System.Collections.Generic;
using MapModle;

public partial class Ajax_LoadDevice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string key = Request.QueryString["root"];
        StringBuilder sb = new StringBuilder();
        sb.Append("[");
        if (key != null && key != "" && key != "source")
        {
            //编码器
            SelectDvs sd = new SelectDvs();
            DataSet ds = sd.Query(Session["userid"].ToString(), Session["cityID"].ToString(), "0", "0", "0", "0", "0", key, "0", "0", "0", 
                "0", "", "", "", "", "", "", "");
            if (ds.Tables[0].Rows.Count > 0)
            {
                int i = 0;
                foreach (DataRow dataRow in ds.Tables[0].Rows)
                {
                    if (i > 0)
                    {
                        sb.Append(",");
                    }
                    sb.Append("{\"text\": \"" + Convert.ToString(dataRow["Customername"]) + "<a target='right' href='ResEncoder.aspx?id=" + Convert.ToString(dataRow["id"]) + "'>编辑</a>\",\"hasChildren\": true}");
                    i++;
                }
            }
            else
            {
                SelectCameras sc = new SelectCameras();
                DataSet ds1 = sc.Query(key);
                int i = 0;
                foreach (DataRow dataRow in ds1.Tables[0].Rows)
                {
                    if (i > 0)
                    {
                        sb.Append(",");
                    }
                    sb.Append("{\"text\": \"" + Convert.ToString(dataRow["dvsno"]) + "(" + Convert.ToString(dataRow["dvsport"]) +")" + "<a target='right' href='ResCamera.aspx?id=" + Convert.ToString(dataRow["id"]) + "'>编辑</a>\"}");
                    i++;
                }
            }
        }
        sb.Append("]");
        Response.ContentType = "application/json";
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.Write(sb.ToString());
        Response.End();
    }
    
}
