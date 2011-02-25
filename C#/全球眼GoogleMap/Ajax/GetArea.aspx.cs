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
using MapModle;
using System.Collections.Generic;
using MapDAL;
using System.Text;

public partial class Ajax_GetArea : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string pid = Request.QueryString["pid"];// 
        SelectAreas sa = new SelectAreas();
        IList<Areas> areas = sa.Getsuburb(pid, Session["userid"].ToString());

        StringBuilder data = new StringBuilder();
        data.Append("[");
        if (areas != null)
        {
            int i = 0;
            foreach (Areas area in areas)
            {
                if (i == 0)
                {
                    data.Append("[" + area.ID.ToString());
                }
                else
                {
                    data.Append(",[" + area.ID.ToString());
                }
                data.Append(",\"" + area.Area_Name + "\"]");
                i++;
            }
        }
        data.Append("]");
        Response.ContentType = "application/json";
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.Write(data.ToString());
        //Response.Write("{\"a\":"  + data.ToString() + "}");
        Response.End();
    }
}
