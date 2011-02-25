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

public partial class WebSite1_Admin_Left : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            SelectAreas sa = new SelectAreas();
            IList<Areas> areas = sa.GetAreas(Session["userid"].ToString());
            
            foreach (Areas area in areas)
            {
                TreeNode tn = new TreeNode();
                tn.Text = area.Area_Name;
                tn.Value = area.ID.ToString();

                //suburb

                IList<Areas> suburbs = sa.Getsuburb(area.ID.ToString(), Session["userid"].ToString());
                foreach (Areas suburb in suburbs)
                {
                    TreeNode tv = new TreeNode();
                    tv.Text = suburb.Area_Name;
                    tv.Value = suburb.ID.ToString();
                    TreeNode node = new TreeNode();
                    node.Text = "";
                    tv.ChildNodes.Add(node);
                    tv.Expanded = false;
                    tv.CollapseAll();
                    tn.ChildNodes.Add(tv);

          
                }

                TreeView1.Nodes.Add(tn);
            }
        }
        //SelectAreas sa = new SelectAreas();
        //IList<Areas> areas = sa.GetAreas(Session["userid"].ToString());
        //StringBuilder sb = new StringBuilder();
        //foreach (Areas area in areas)
        //{
        //    sb.Append("<li><span>" + area.Area_Name + "</span>");
        //    sb.Append("<ul>");
        //    //suburb

        //    IList<Areas> suburbs = sa.Getsuburb(area.ID.ToString(), Session["userid"].ToString());
        //    foreach (Areas suburb in suburbs)
        //    {
        //        sb.Append("<li id=\"" + suburb.ID.ToString() + "\" class=\"hasChildren\"><span>" + suburb.Area_Name + "</span>");
        //        sb.Append("<ul>");
        //        sb.Append("<li><span class=\"placeholder\">&nbsp;</span></li>");
        //        sb.Append("</ul>");
        //        sb.Append("</li>");
        //    }

        //    sb.Append("</ul>");
        //    sb.Append("</li>");
        //}
        //ltlArea.Text = sb.ToString();
    }
    protected void TreeView1_TreeNodeExpanded(object sender, TreeNodeEventArgs e)
    {
        if (e.Node.Depth > 0)
        {
            if (e.Node.Depth == 1)
            {
                e.Node.ChildNodes.Clear();
                SelectDvs sd = new SelectDvs();
                DataSet ds = sd.Query(e.Node.Value);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dataRow in ds.Tables[0].Rows)
                    {
                        TreeNode tv = new TreeNode();
                        tv.Value = Convert.ToString(dataRow["id"]);
                        tv.Text = Convert.ToString(dataRow["Customername"]) + "<a target='right' href='ResEncoder.aspx?id=" + Convert.ToString(dataRow["id"]) + "'>编辑</a>";
                        TreeNode node = new TreeNode();
                        node.Text = "";
                        tv.ChildNodes.Add(node);
                        tv.Expanded = false;
                        e.Node.ChildNodes.Add(tv);

                    }
                }
            }
            else if (e.Node.Depth == 2)
            {
                e.Node.ChildNodes.Clear();
                SelectCameras sc = new SelectCameras();
                DataSet ds1 = sc.Query(e.Node.Value);
 
                foreach (DataRow dataRow in ds1.Tables[0].Rows)
                {
                    TreeNode tv = new TreeNode();
                    tv.Text = Convert.ToString(dataRow["dvsno"]) + "(" + Convert.ToString(dataRow["dvsport"]) + ")" + "<a target='right' href='ResCamera.aspx?id=" + Convert.ToString(dataRow["id"]) + "'>编辑</a>";
                    e.Node.ChildNodes.Add(tv);
                }
            }
        }
    }
}
