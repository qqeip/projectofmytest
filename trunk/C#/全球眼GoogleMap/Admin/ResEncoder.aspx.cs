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
using System.Collections.Generic;
using System.Text;
using MapBLL;

public partial class WebSite1_Admin_ResEncoder : System.Web.UI.Page
{
    private int mPortNum = 8;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //校验
            ValidatorFactory.CreateRequiredValidator(rfvDvsNo, txtDvsNo, "请输入DVS编号");
            ValidatorFactory.CreateRequiredValidator(rfvJunctionBoxNo, txtJunctionBoxNo, "请输入分线盒编号");
            ValidatorFactory.CreateRequiredValidator(rfvCustomerAddress, txtCustomerAddress, "请输入用户地址");
            ValidatorFactory.CreateRequiredValidator(rfvCustomerName, txtCustomerName, "请输入用户名称");
            ValidatorFactory.CreateRequiredValidator(rfvPortNum, txtPortNum, "请输入端口数");
            ValidatorFactory.CreateDoubleRangeValidator(RangeValidator1, txtLongitude, 180, -180);
            ValidatorFactory.CreateDoubleRangeValidator(RangeValidator2, txtLatitude, 90, -90);
            ValidatorFactory.CreateIntegerValidator(revPortNum, txtPortNum);
            ValidatorFactory.CreateDoubleRangeValidator(rvdPortNum, txtPortNum, 16, 1);
            //字典
            DataGlobal.LoadDictType(ddlCustomerType, DicType.CustomerType);
            DataGlobal.LoadDeviceLevel(ddlDeviceLevel);
            DataGlobal.LoadDictType(ddlDeviceManu, DicType.DeviceManu);
            DataGlobal.LoadDictType(ddlDevicePropertyRight, DicType.DevicePropertyRight);
            DataGlobal.LoadDictType(ddlDeviceState, DicType.DeviceState);
            DataGlobal.LoadDictType(ddlDvsKind, DicType.DvsKind);
            DataGlobal.LoadDictType(ddlDvsType, DicType.DvsType);
            DataGlobal.LoadDictType(ddlPaymentType, DicType.PaymentType);
            DataGlobal.LoadDictType(ddlPowerType, DicType.PowerType);
            DataGlobal.LoadDictType(ddlPowerVoltage, DicType.PowerVoltage);
            DataGlobal.LoadDictType(ddlServiceType, DicType.ServiceType);
            DataGlobal.LoadDictType(ddlStorageType, DicType.StorageType);
            DataGlobal.LoadDictType(ddlSwitchinMode, DicType.SWITCHINMODE);
            DataGlobal.LoadDictType(ddlSwitchinPlace, DicType.SWITCHINPLACE);
            //行政区
            DataGlobal.LoadTown(ddlTown, Session["userid"].ToString());

            hdfDvsID.Value = "0";
            if (Request["id"] != null && Request["id"] != "")
            {
                LoadDvsInfo(Request["id"].ToString());
            }
            LoadCameras();
        }
        if (hdfDvsID.Value == "0")
        {
            btnModify.Text = "确定新增";
        }
        else
        {
            btnModify.Text = "确定修改";
        }
        LoadArea();
        
        
    }

    private void LoadCameras()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" class=\"con_list\">");
        sb.Append("<tr class=\"ti\">");
        sb.Append("<td class=\"ti\">管道ID</td>");
        sb.Append("<td class=\"ti\">删除</td>");
        sb.Append("<td class=\"ti\">摄像头编号</td>");
        sb.Append("<td class=\"ti\">摄像头类型</td>");
        sb.Append("<td class=\"ti\">摄像头型号</td>");
        sb.Append("<td class=\"ti\">生产厂家</td>");
        sb.Append("<td class=\"ti\">产权</td>");
        sb.Append("<td class=\"ti\">用户类型</td>");
        sb.Append("<td class=\"ti\">用户名称</td>");
        sb.Append("</tr>");
        SelectCameras sc = new SelectCameras();
        IList<Cameras> list = sc.GetCameras(Session["userid"].ToString(), Session["cityid"].ToString(), hdfDvsID.Value);
        for (int i = 1; i <= mPortNum; i++)
        {
            bool flag = false;
            sb.Append("<tr>");
            sb.Append("<td class=\"t\">" + i.ToString() + "</td>");
            for (int j = 0; j < list.Count; j++)
            { 
                Cameras c = list[j];
                if (c.Dvsport == i.ToString())
                {
                    sb.Append("<td class=\"t\"><a href=\"DelCamera.aspx?id=" + c.Id.ToString() + "\"><img src=\"../Img/b/icon_del.gif\" /></a></td>");
                    sb.Append("<td class=\"t\"><a href=\"ResCamera.aspx?id=" + c.Id.ToString() + "\">" + c.Caremano + "</a></td>");
                    sb.Append("<td class=\"t\">" + c.Carematype + "&nbsp;</td>");
                    sb.Append("<td class=\"t\">" + c.Caremakind + "&nbsp;</td>");
                    sb.Append("<td class=\"t\">" + c.Devicemanu + "&nbsp;</td>");
                    sb.Append("<td class=\"t\">" + c.Devicepropertyright + "&nbsp;</td>");
                    sb.Append("<td class=\"t\">" + c.Customertype + "&nbsp;</td>");
                    sb.Append("<td class=\"t\">" + c.Customername + "&nbsp;</td>");
                    flag = true;
                    break;
                }
            }
            if (!flag)
            {
                if (hdfDvsID.Value == "0")
                {
                    sb.Append("<td class=\"t\">&nbsp;</td>");
                }
                else
                {
                    sb.Append("<td class=\"t\"><a href=\"ResCamera.aspx?dvsid=" + hdfDvsID.Value + "&dvsPort=" + i.ToString() + "\"><img src=\"../Img/b/icon_cons_add.gif\" /></a></td>");
                }
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
                sb.Append("<td class=\"t\">&nbsp;</td>");
            }

            sb.Append("</tr>");
        }
        sb.Append("</table>");
        ltrCameras.Text = sb.ToString();
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

    private void LoadDvsInfo(string id)
    {
        SelectDvs sd = new SelectDvs();
        Dvs dvs = sd.GetDvs(id);
        if (dvs != null)
        {
            mPortNum = DataGlobal.ConvertToInt(dvs.Portnum);
            txtAssertNo.Text = dvs.Assertno;
            txtBroadbandAccessNo.Text = dvs.Broadbandaccessno;
            txtCustomerAddress.Text = dvs.Customeraddress;
            txtCustomerManager.Text = dvs.Customermanager;
            txtCustomerManagerPhone.Text = dvs.Customermanager_phone;
            txtCustomerName.Text = dvs.Customername;
            txtDialupAccount.Text = dvs.Dialupaccount;
            txtDialupPassword.Text = dvs.Dialuppassword;
            txtDvsNo.Text = dvs.Dvsno;
            txtGateway.Text = dvs.Gateway;
            txtInstalldate.Text = dvs.Installdate.ToShortDateString();
            txtInstallPlace.Text = dvs.Installplace;
            txtIP.Text = dvs.Ip;
            txtJunctionBoxNo.Text = dvs.Junctionboxno;
            txtLanNo.Text = dvs.Lanno;
            txtLinkman.Text = dvs.Linkman;
            txtLinkmanPhone.Text = dvs.Linkman_phone;
            txtPortNum.Text = dvs.Portnum;
            txtServiceDesc.Text = dvs.Servicedesc;
            txtStorageTime.Text = dvs.Storagetime;
            txtSubnetMask.Text = dvs.Subnetmask;
            txtSurfaceMan.Text = dvs.Surfaceman;
            txtSurfaceManPhone.Text = dvs.Surfaceman_phone;
            ddlCustomerType.SelectedValue = dvs.Customertype;
            ddlDeviceLevel.SelectedValue = dvs.Devicelevel;
            ddlDeviceManu.SelectedValue = dvs.Devicemanu;
            ddlDevicePropertyRight.SelectedValue = dvs.Devicepropertyright;
            ddlDeviceState.SelectedValue = dvs.Devicestate;
            ddlDvsKind.SelectedValue = dvs.Dvskind;
            ddlDvsType.SelectedValue = dvs.Dvstype;
            ddlPaymentType.SelectedValue = dvs.Paymenttype;
            ddlPowerType.SelectedValue = dvs.Powertype;
            ddlPowerVoltage.SelectedValue = dvs.Powervoltage;
            ddlServiceType.SelectedValue = dvs.Servicetype;
            ddlStorageType.SelectedValue = dvs.Storagetype;
            ddlSwitchinMode.SelectedValue = dvs.Switchinmode;
            ddlSwitchinPlace.SelectedValue = dvs.Switchinplace;
            //经纬度
            SelectDeviceXy sdxy = new SelectDeviceXy();
            Device_Info_xy xy = sdxy.SelectByID(dvs.Id);
            if (xy != null)
            {
                txtLongitude.Text = xy.LONGITUDE.ToString();
                txtLatitude.Text = xy.LATITUDE.ToString();
            }

            hdfSuburb.Value = dvs.Suburb;
            hdfDvsID.Value = dvs.Id.ToString();
        }
    }


    protected void btnModify_Click(object sender, EventArgs e)
    {
        Dvs dvs = new Dvs();
          dvs.Assertno =  txtAssertNo.Text;
          dvs.Broadbandaccessno =  txtBroadbandAccessNo.Text;
          dvs.Customeraddress =  txtCustomerAddress.Text;
          dvs.Customermanager = txtCustomerManager.Text ;
          dvs.Customermanager_phone = txtCustomerManagerPhone.Text ;
          dvs.Customername = txtCustomerName.Text  ;
          dvs.Dialupaccount = txtDialupAccount.Text ;
          dvs.Dialuppassword = txtDialupPassword.Text ;
          dvs.Dvsno = txtDvsNo.Text ;
          dvs.Gateway = txtGateway.Text ;
          dvs.Installdate = txtInstalldate.Text.Trim() == "" ? DateTime.Now :Convert.ToDateTime(txtInstalldate.Text.Trim()) ;
          txtInstalldate.Text = DateTime.Now.ToShortDateString();
          dvs.Installplace = txtInstallPlace.Text ;
          dvs.Ip = txtIP.Text ;
          dvs.Junctionboxno = txtJunctionBoxNo.Text ;
          dvs.Lanno = txtLanNo.Text ;
          dvs.Latitude = txtLatitude.Text.Trim() == "" ? 0 :Convert.ToDouble(txtLatitude.Text.Trim()) ;
          dvs.Linkman = txtLinkman.Text ;
          dvs.Linkman_phone = txtLinkmanPhone.Text ;
          dvs.Longitude = txtLongitude.Text.Trim() == "" ? 0 :Convert.ToDouble(txtLongitude.Text.Trim()) ;
          dvs.Portnum = txtPortNum.Text ;
          dvs.Servicedesc = txtServiceDesc.Text ;
          dvs.Storagetime = txtStorageTime.Text ;
          dvs.Subnetmask = txtSubnetMask.Text ;
          dvs.Surfaceman = txtSurfaceMan.Text ;
          dvs.Surfaceman_phone = txtSurfaceManPhone.Text ;
          dvs.Customertype = ddlCustomerType.SelectedValue ;
          dvs.Devicelevel = ddlDeviceLevel.SelectedValue ;
          dvs.Devicemanu = ddlDeviceManu.SelectedValue  ;
          dvs.Devicepropertyright = ddlDevicePropertyRight.SelectedValue ;
          dvs.Devicestate = ddlDeviceState.SelectedValue ;
          dvs.Dvskind = ddlDvsKind.SelectedValue ;
          dvs.Dvstype = ddlDvsType.SelectedValue ;
          dvs.Paymenttype = ddlPaymentType.SelectedValue ;
          dvs.Powertype = ddlPowerType.SelectedValue ;
          dvs.Powervoltage = ddlPowerVoltage.SelectedValue ;
          dvs.Servicetype = ddlServiceType.SelectedValue ;
          dvs.Storagetype = ddlStorageType.SelectedValue ;
          dvs.Switchinmode = ddlSwitchinMode.SelectedValue ;
          dvs.Switchinplace = ddlSwitchinPlace.SelectedValue ;
          dvs.Suburb = hdfSuburb.Value;

          if (hdfDvsID.Value == "0" || hdfDvsID.Value == "")  //新增
          {
              DvsManager dm = new DvsManager();
              dm.NewDvs(dvs, Session["userid"].ToString());
              hdfDvsID.Value = dvs.Id.ToString();
              btnModify.Text = "确定修改";
              mPortNum = Convert.ToInt32(txtPortNum.Text);
              LoadCameras();
          }
          else
          {
              dvs.Id = Convert.ToInt32(hdfDvsID.Value);
              DvsManager dm = new DvsManager();
              dm.ModifyDvs(dvs, Session["userid"].ToString());
          }
    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        mPortNum = Convert.ToInt32(txtPortNum.Text);
        LoadCameras();
    }
}
