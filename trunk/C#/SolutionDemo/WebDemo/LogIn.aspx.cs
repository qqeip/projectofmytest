using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Model;
using BLL;

public partial class _Default : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click1(object sender, EventArgs e)
    {
        UserLogOn userlogon = new UserLogOn();
        int i = userlogon.UserLogIn(this.TextBox1.Text, this.TextBox2.Text);
        if (i == -1)
            ClientScript.RegisterStartupScript(this.GetType(), "js", "alert('用户不存在!')", true);
        else if (i == 1)
        {
            //写session
            //Session["user"] = user;
            //跳转
            ClientScript.RegisterStartupScript(this.GetType(), "js", "alert('登录成功!')", true);
            Response.Redirect("Main.aspx");            
        }
        else
            ClientScript.RegisterStartupScript(this.GetType(), "js", "alert('密码错误!')", true);
    }
}
