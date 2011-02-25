using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// 动态创建编辑框的校验控件，并绑定
/// </summary>
public class ValidatorFactory
{
    /// <summary>
    /// 创建浮点型范围校验控件
    /// </summary>
    /// <param name="fForm">表单对象</param>
    /// <param name="fControl">绑定的控件</param>
    /// <param name="fMaxValue">最大值</param>
    /// <param name="fMinValue">最小值</param>
    public static void CreateDoubleRangeValidator(HtmlForm fForm, Control fControl, double fMaxValue, double fMinValue)
    {
        RangeValidator Validator = new RangeValidator();
        Validator.Type = ValidationDataType.Double;
        Validator.MaximumValue = fMaxValue.ToString();
        Validator.MinimumValue = fMinValue.ToString();
        Validator.ErrorMessage = "超出范围";
        //Validator.EnableViewState = false;
        Validator.ControlToValidate = fControl.ID;
        Validator.Text = "请输入正确的值";
        fForm.Controls.AddAt(fForm.Controls.IndexOf(fControl) + 1, Validator);
    }

    public static void CreateDoubleRangeValidator(RangeValidator fValidator, Control fControl, double fMaxValue, double fMinValue)
    {
        fValidator.Type = ValidationDataType.Double;
        fValidator.MaximumValue = fMaxValue.ToString();
        fValidator.MinimumValue = fMinValue.ToString();
        fValidator.ErrorMessage = "超出范围";
        //Validator.EnableViewState = false;
        fValidator.ControlToValidate = fControl.ID;
        fValidator.Text = "请输入正确的值";
    }


    /// <summary>
    /// 创建浮点型校验控件
    /// </summary>
    /// <param name="fForm">表单对象</param>
    /// <param name="fControl">绑定的控件 </param>
    public static void CreateDoubleValidator(HtmlForm fForm, Control fControl)
    {
        RegularExpressionValidator validator = new RegularExpressionValidator();
        validator.ValidationExpression = "^[0-9]+(.[0-9]{1,16})?$";
        validator.ErrorMessage = "格式必须为数值";
        validator.ControlToValidate = fControl.ID;
        //validator.EnableViewState = false;
        fForm.Controls.AddAt(fForm.Controls.IndexOf(fControl) + 1, validator);
    }

    public static void CreateDoubleValidator(RegularExpressionValidator fValidator, Control fControl)
    {
        fValidator.ValidationExpression = "^[0-9]+(.[0-9]{1,16})?$";
        fValidator.ErrorMessage = "格式必须为数值";
        fValidator.ControlToValidate = fControl.ID;
        //validator.EnableViewState = false;
    }

    /// <summary>
    /// 创建整型校验控件
    /// </summary>
    /// <param name="fForm">表单对象</param>
    /// <param name="fControl">绑定的控件</param>
    public static void CreateIntegerValidator(HtmlForm fForm, Control fControl)
    {
        RegularExpressionValidator validator = new RegularExpressionValidator();
        validator.ValidationExpression = "^[0-9]*$";
        validator.ErrorMessage = "格式必须为整数";
        validator.ControlToValidate = fControl.ID;
        //validator.EnableViewState = false;
        fForm.Controls.AddAt(fForm.Controls.IndexOf(fControl) + 1, validator);
    }

    public static void CreateIntegerValidator(RegularExpressionValidator fValidator, Control fControl)
    {
        fValidator.ValidationExpression = "^[0-9]*$";
        fValidator.ErrorMessage = "格式必须为整数";
        fValidator.ControlToValidate = fControl.ID;
        //validator.EnableViewState = false;
    }

    /// <summary>
    /// 创建必填校验控件
    /// </summary>
    /// <param name="fForm">表单对象</param>
    /// <param name="fControl">绑定的控件</param>
    /// <param name="fErrorMessage">提示信息</param>
    public static void CreateRequiredValidator(HtmlForm fForm, Control fControl, string fErrorMessage)
    {
        RequiredFieldValidator validator = new RequiredFieldValidator();
        validator.ErrorMessage = fErrorMessage;
        validator.Display = ValidatorDisplay.Dynamic;
        validator.ControlToValidate = fControl.ID;
        //validator.EnableViewState = false;
        fForm.Controls.AddAt(fForm.Controls.IndexOf(fControl) + 1, validator);
    }

    public static void CreateRequiredValidator(RequiredFieldValidator fValidator, Control fControl, string fErrorMessage)
    {
        fValidator.ErrorMessage = fErrorMessage;
        fValidator.Display = ValidatorDisplay.Dynamic;
        fValidator.ControlToValidate = fControl.ID;
    }

    /// <summary>
    /// 创建比较校验控件
    /// </summary>
    /// <param name="fForm">表单对象</param>
    /// <param name="fControl1"></param>
    /// <param name="fControl2"></param>
    /// <param name="fErrorMessage">提示信息</param>
    public static void CreateCompareValidator(HtmlForm fForm, Control fControl1, Control fControl2, string fErrorMessage)
    {
        CompareValidator validator = new CompareValidator();
        validator.ErrorMessage = fErrorMessage;
        validator.ControlToCompare = fControl1.ID;
        validator.ControlToValidate = fControl2.ID;
        //validator.EnableViewState = false;
        validator.ValueToCompare = "=";
        fForm.Controls.AddAt(fForm.Controls.IndexOf(fControl2) + 1, validator);
    }

    public static void CreateCompareValidator(CompareValidator fValidator, Control fControl1, Control fControl2, string fErrorMessage)
    {
        fValidator.ErrorMessage = fErrorMessage;
        fValidator.ControlToCompare = fControl1.ID;
        fValidator.ControlToValidate = fControl2.ID;
        //validator.EnableViewState = false;
        fValidator.ValueToCompare = "=";
    }
}
