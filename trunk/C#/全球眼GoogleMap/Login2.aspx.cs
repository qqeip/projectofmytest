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
using System.Web.Configuration;

public partial class Login2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["UserId"] != null && Request["Password"] != null)
        {
            Users user = new Users();
            UserInfo userInfo = user.GetUserByUserNo(Request["UserId"].ToString());
            if (userInfo != null)
            {
                string pwd = FormsAuthentication.HashPasswordForStoringInConfigFile(userInfo.USERNO + Request["Password"].ToString(), FormsAuthPasswordFormat.MD5.ToString());
                if (userInfo.USERPWD == pwd.ToLower())
                {
                    Session["userid"] = userInfo.USERID.ToString();
                    Session["cityid"] = userInfo.CITYID.ToString();
                    FormsAuthentication.RedirectFromLoginPage(Request["UserId"].ToString(), false);
                    Response.Redirect("./Admin/adminindex.aspx");
                    return;
                }
            }
        }
    }
}
