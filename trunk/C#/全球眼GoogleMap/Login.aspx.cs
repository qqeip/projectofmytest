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
using System.Drawing;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnlogin_Click(object sender, EventArgs e)
    {
        Users user = new Users();
        UserInfo userInfo = user.GetUserByUserNo(txtUserName.Text.Trim());
        if (userInfo != null)
        {
            string pwd = FormsAuthentication.HashPasswordForStoringInConfigFile(userInfo.USERNO + txtPassword.Text, FormsAuthPasswordFormat.MD5.ToString());
            if (userInfo.USERPWD == pwd.ToLower())
            {
                Session["userid"] = userInfo.USERID.ToString();
                Session["cityid"] = userInfo.CITYID.ToString();
                FormsAuthentication.RedirectFromLoginPage(txtUserName.Text.Trim(), false);
                Response.Redirect("./Admin/adminindex.aspx");
                return;
            }
        }
        lblErrorInfo.Text = "用户名或密码错误！";
        lblErrorInfo.ForeColor = Color.Red;
    }
}
