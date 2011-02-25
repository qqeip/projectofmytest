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
using MapDAL;
using System.Collections.Generic;
using MapBLL;

public partial class Admin_ResCamera : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ValidatorFactory.CreateRequiredValidator(rfvCameraNo, txtCameraNo, "请输入摄像头编号");
            ValidatorFactory.CreateRequiredValidator(rfvCustomerAddress, txtCustomerAddress, "请输入用户地址");
            ValidatorFactory.CreateRequiredValidator(rfvCustomerName, txtCustomerName, "请输入用户名称");
            ValidatorFactory.CreateDoubleRangeValidator(RangeValidator1, txtLongitude, 180, -180);
            ValidatorFactory.CreateDoubleRangeValidator(RangeValidator2, txtLatitude, 90, -90);
            //字典
            DataGlobal.LoadDictType(ddlBaudrate, DicType.BaudRate);
            DataGlobal.LoadDictType(ddlCameraKind, DicType.CaremaKind);
            DataGlobal.LoadDictType(ddlCameraType, DicType.CaremaType);
            DataGlobal.LoadDictType(ddlCodeAddr, DicType.CodeAddr);
            DataGlobal.LoadDictType(ddlCodeStream, DicType.CodeStream);
            DataGlobal.LoadDictType(ddlControlProtocol, DicType.ControlProtocol);
            DataGlobal.LoadDictType(ddlCustomerType, DicType.CustomerType);
            DataGlobal.LoadDeviceLevel(ddlDeviceLevel);
            DataGlobal.LoadDictType(ddlDeviceManu, DicType.DeviceManu);
            DataGlobal.LoadDictType(ddlDevicePropertyRight, DicType.DevicePropertyRight);
            DataGlobal.LoadDictType(ddlDeviceState, DicType.DeviceState);
            DataGlobal.LoadDictType(ddlInstallMode, DicType.InstallMode);
            DataGlobal.LoadDictType(ddlPaymentType, DicType.PaymentType);
            DataGlobal.LoadDictType(ddlPowerType, DicType.PowerType);
            DataGlobal.LoadDictType(ddlPowerVoltage, DicType.PowerVoltage);
            DataGlobal.LoadDictType(ddlStorageType, DicType.StorageType);
            DataGlobal.LoadDictType(ddlSwitchinMode, DicType.SWITCHINMODE);
            DataGlobal.LoadDictType(ddlSwitchinPlace, DicType.SWITCHINPLACE);

            hdfCameraID.Value = "0";
            btnModify.Enabled = false;
            if (Request["id"] != null && Request["id"] != "")
            {
                LoadCameraInfo(Request["id"].ToString());
                btnModify.Text = "确定修改";
            }
            else if (Request["dvsid"] != null && Request["dvsid"] != "")
            {
                LoadDvsInfo(Request["dvsid"].ToString(), "0");
                btnModify.Text = "确定新增";
            }

        }
    }

    private void LoadCameraInfo(string id)
    {
        SelectCameras sc = new SelectCameras();
        Cameras c = sc.GetCamera(id);
        if (c != null)
        {
            hdfCameraID.Value = c.Id.ToString();
            LoadDvsInfo(c.Dvsid, c.Dvsport);
            //
            txtAssertNo.Text = c.Assertno;
            txtCameraNo.Text = c.Caremano;
            txtCustomerAddress.Text = c.Customeraddress;
            txtCustomerName.Text = c.Customername;
            txtHandleNo.Text = c.Handleno;
            txtInfo.Text = c.Info;
            txtInstalldate.Text = c.Installdate.ToShortDateString();
            txtInstallPlace.Text = c.Installplace;
            txtJunctionBoxNo.Text = c.Junctionboxno;
            //txtLatitude.Text = c.Latitude.ToString();
            txtLinkman.Text = c.Linkman;
            txtLinkmanPhone.Text = c.Linkman_phone;
            //txtLongitude.Text = c.Longitude.ToString();
            txtSinglePlace.Text = c.Singleplace;
            txtStorageTime.Text = c.Storagetime;
            ddlBaudrate.SelectedValue = c.Baudrate;
            ddlCameraKind.SelectedValue = c.Caremakind;
            ddlCameraType.SelectedValue = c.Carematype;
            ddlCodeAddr.SelectedValue = c.Codeaddr;
            ddlCodeStream.SelectedValue = c.Codestream;
            ddlControlProtocol.SelectedValue = c.Controlprotocol;
            ddlCustomerType.SelectedValue = c.Customertype;
            ddlDeviceLevel.SelectedValue = c.Devicelevel;
            ddlDeviceManu.SelectedValue = c.Devicemanu;
            ddlDevicePropertyRight.SelectedValue = c.Devicepropertyright;
            ddlDeviceState.SelectedValue = c.Devicestate;
            ddlDvsPort.SelectedValue = c.Dvsport;
            ddlInstallMode.SelectedValue = c.Installmode;
            ddlPaymentType.SelectedValue = c.Paymenttype;
            ddlPowerType.SelectedValue = c.Powertype;
            ddlPowerVoltage.SelectedValue = c.Powervoltage;
            ddlStorageType.SelectedValue = c.Storagetype;
            ddlSwitchinMode.SelectedValue = c.Switchinmode;
            ddlSwitchinPlace.SelectedValue = c.Switchinplace;
            //经纬度
            SelectDeviceXy sdxy = new SelectDeviceXy();
            Device_Info_xy xy = sdxy.SelectByID(c.Id);
            if (xy != null)
            {
                txtLongitude.Text = xy.LONGITUDE.ToString();
                txtLatitude.Text = xy.LATITUDE.ToString();
            }
        }
    }

    private void LoadDvsInfo(string dvsID, string port)
    {
        hlkNew.NavigateUrl = "ResCamera.aspx?dvsid=" + dvsID;
        hlkBack.NavigateUrl = "ResEncoder.aspx?id=" + dvsID;
        SelectDvs sd = new SelectDvs();
        Dvs dvs = sd.GetDvs(dvsID);
        if (dvs != null)
        {
            txtDvsID.Text = dvs.Dvsno;
            txtBroadbandAccessNo.Text = dvs.Broadbandaccessno;
            txtCustomerManager.Text = dvs.Customermanager;
            txtCustomerManagerPhone.Text = dvs.Customermanager_phone;
            txtLanNo.Text = dvs.Lanno;
            txtIP.Text = dvs.Ip;
            txtGateway.Text = dvs.Gateway;
            txtSubnetMask.Text = dvs.Subnetmask;
            txtDialupAccount.Text = dvs.Dialupaccount;
            txtDialupPassword.Text = dvs.Dialuppassword;
            hdfSuburbID.Value = dvs.Suburb;

            SelectAreas sa = new SelectAreas();
            Areas area =sa.GetArea(dvs.Suburb); //分局
            if (area == null)
            {
                return;
            }
            txtSuburb.Text = area.Area_Name;

            area = sa.GetParentAreas(area.ID.ToString()); //郊县
            if (area == null)
            {
                return;
            }
            txtTown.Text = area.Area_Name;
            //剩余的端口
            SelectCameras sc = new SelectCameras();
            IList<Cameras> list = sc.GetCameras(Session["userid"].ToString(), Session["cityid"].ToString(), dvsID);
            int portNum = DataGlobal.ConvertToInt(dvs.Portnum);
            for (int i = 1; i <= portNum; i++)
            {
                bool flag = false;

                for (int j = 0; j < list.Count; j++)
                {
                    if (list[j].Dvsport == i.ToString())
                    {
                        flag = true;
                    }
                }
                if (i.ToString() == port)
                {
                    flag = false;
                }
                if (!flag)
                {
                    ListItem ddlone = new ListItem(i.ToString(), i.ToString());
                    ddlDvsPort.Items.Add(ddlone);
                }
            }
            if (Request["dvsport"] != null && Request["dvsport"] != "")
            {
                ddlDvsPort.SelectedValue = Request["dvsport"].ToString();
            }
            btnModify.Enabled = true;
            hdfDvsID.Value = dvs.Id.ToString();
        }
    }

    protected void btnModify_Click(object sender, EventArgs e)
    {
        Cameras c = new Cameras();
        c.Assertno = txtAssertNo.Text;
        c.Caremano = txtCameraNo.Text;
        c.Customeraddress = txtCustomerAddress.Text;
        c.Customername = txtCustomerName.Text;
        c.Handleno = txtHandleNo.Text;
        c.Info = txtInfo.Text;
        c.Installdate = txtInstalldate.Text.Trim() == "" ? DateTime.Now : Convert.ToDateTime(txtInstalldate.Text.Trim());
        c.Installplace = txtInstallPlace.Text;
        c.Junctionboxno = txtJunctionBoxNo.Text;
        c.Latitude = txtLatitude.Text.Trim() == "" ? 0 : Convert.ToDouble(txtLatitude.Text.Trim());
        c.Linkman = txtLinkman.Text;
        c.Linkman_phone = txtLinkmanPhone.Text;
        c.Longitude = txtLongitude.Text.Trim() == "" ? 0 : Convert.ToDouble(txtLongitude.Text.Trim());
        c.Singleplace = txtSinglePlace.Text;
        c.Storagetime = txtStorageTime.Text;
        c.Baudrate = ddlBaudrate.SelectedValue;
        c.Caremakind = ddlCameraKind.SelectedValue;
        c.Carematype = ddlCameraType.SelectedValue;
        c.Codeaddr = ddlCodeAddr.SelectedValue;
        c.Codestream = ddlCodeStream.SelectedValue;
        c.Controlprotocol = ddlControlProtocol.SelectedValue;
        c.Customertype = ddlCustomerType.SelectedValue;
        c.Devicelevel = ddlDeviceLevel.SelectedValue;
        c.Devicemanu = ddlDeviceManu.SelectedValue;
        c.Devicepropertyright = ddlDevicePropertyRight.SelectedValue;
        c.Devicestate = ddlDeviceState.SelectedValue;
        c.Dvsport = ddlDvsPort.SelectedValue;
        c.Installmode = ddlInstallMode.SelectedValue;
        c.Paymenttype = ddlPaymentType.SelectedValue;
        c.Powertype = ddlPowerType.SelectedValue;
        c.Powervoltage = ddlPowerVoltage.SelectedValue;
        c.Storagetype = ddlStorageType.SelectedValue;
        c.Switchinmode = ddlSwitchinMode.SelectedValue;
        c.Switchinplace = ddlSwitchinPlace.SelectedValue;
        c.Dvsid = hdfDvsID.Value;
        c.Suburb = hdfSuburbID.Value;
        if (hdfCameraID.Value == "0" || hdfCameraID.Value == "")  //新增
        {
            CameraManager cm = new CameraManager();
            cm.NewCamera(c, Session["userid"].ToString());
            hdfCameraID.Value = c.Id.ToString();
            btnModify.Text = "确定修改";
        }
        else
        {
            c.Id = DataGlobal.ConvertToInt(hdfCameraID.Value);
            CameraManager cm = new CameraManager();
            cm.ModifyCamera(c, Session["userid"].ToString());
        }
    }
}
