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

public partial class Manger_Top : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblUserRealName.Text = Convert.ToString(Session["UserNo"]);
    }

    protected void ibnLogout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Session["userid"] = null;
        Session["cityid"] = null;
        ClientScript.RegisterClientScriptBlock(this.GetType(), "", "<script>parent.location = '../login.aspx';</script>");
    }
}
