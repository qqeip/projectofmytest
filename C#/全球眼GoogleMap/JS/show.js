var obj;
function list(meval)
{
	var left_n=eval(meval);
	
	if (left_n.style.display=="none")
	{ eval(meval+".style.display='';");
	if (obj!=null && obj!=meval){eval(obj+".style.display='none';");
	}obj=meval;
	}
	else
	{ eval(meval+".style.display='none';"); }
	//scroll
	var newobj=document.getElementById("list_bill");
	height=newobj.scrollTop;
	newobj.scrollTop=(event.y>70)?height+30:height-30;
}

//控制用户管理页面，左边菜单 li_current代表当前打开的菜单项
function control_ul_menu(index)
{
    var ul_obj = document.getElementById("ul_menu");
    if ( ul_obj != null)
    {
        var li_obj;
        for(var i = 0 ;i < ul_obj.childNodes.length ; i++) {
            li_obj = ul_obj.childNodes[i];
            li_obj.id="";
            if (i==index)
                li_obj.id = "li_current";    
        }
    }
}

var Sys = {};
var ua = navigator.userAgent.toLowerCase();
if (window.ActiveXObject)
    Sys.ie = ua.match(/msie ([\d.]+)/)[1]
else if (document.getBoxObjectFor)
    Sys.firefox = ua.match(/firefox\/([\d.]+)/)[1]
else if (window.MessageEvent && !document.getBoxObjectFor)
    Sys.chrome = ua.match(/chrome\/([\d.]+)/)[1]
else if (window.opera)
    Sys.opera = ua.match(/opera.([\d.]+)/)[1]
else if (window.openDatabase)
    Sys.safari = ua.match(/version\/([\d.]+)/)[1];

function toExit(){ 
var args=toExit.arguments; 
var visible=args[0]; 
if(Sys.firefox){ 
if(visible=='show')visible='visible'; 
if(visible=='hide')visible='hidden'; 
theObj=document.getElementById(args[1]);
if(theObj)theObj.style.visibility=visible;
} 
else if(Sys.ie){ 
if(visible=='show')visible='visible'; 
if(visible=='hide')visible='hidden'; 
theObj=eval("document.all[\'"+args[1]+"\']"); 
if(theObj)theObj.style.visibility=visible; 
} 
} 

function fixPng() {
  var arVersion = navigator.appVersion.split("MSIE")
  var version = parseFloat(arVersion[1])

  if ((version >= 5.5 && version < 7.0) && (document.body.filters)) {
    for(var i=0; i<document.images.length; i++) {
      var img = document.images[i];
      var imgName = img.src.toUpperCase();
      if (imgName.indexOf(".PNG") > 0) {
        var width = img.width;
        var height = img.height;
        var sizingMethod = (img.className.toLowerCase().indexOf("scale") >= 0)? "scale" : "image"; 
        img.runtimeStyle.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img.src.replace('%23', '%2523').replace("'", "%27") + "', sizingMethod='" + sizingMethod + "')";
        img.src = "images/pixar/blank.gif";
        img.width = width;
        img.height = height;
        }
      }
    }
  }

fixPng();