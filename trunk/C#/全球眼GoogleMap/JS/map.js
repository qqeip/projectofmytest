var EYEMAP = {

};

EYEMAP.Legend =function () {
    this.tip = null;
};

EYEMAP.Legend.prototype = new GControl();

EYEMAP.Legend.prototype.initialize = function(map) {
    var container = document.createElement("div");
    this.setButtonStyle_(container);
    
    var div1 = document.createElement("div");
    container.appendChild(div1);
    
    var input1 = document.createElement("input");
    input1.type = 'checkbox';
    input1.name = 'check_dvs';
    input1.value = "1";
    input1.style.marginRight = "5px";
    div1.appendChild(input1);
    input1.checked = "checked";
    GEvent.addDomListener(input1, "click", this.ClickHandler_());

    div1.appendChild(document.createTextNode("编码器"));
    
    var input2 = document.createElement("input");
    input2.type = 'checkbox';
    input2.name = 'check_camera';
    input2.value = "2";
    input2.style.marginLeft = "8px";
    input2.style.marginRight = "5px";
    div1.appendChild(input2);
    input2.checked=true;
    GEvent.addDomListener(input2, "click", this.ClickHandler_());
    div1.appendChild(document.createTextNode("摄像头"));

    var div2 = document.createElement("div");
    container.appendChild(div2);
    div2.style.backgroundColor = "#FF0000";
    div2.style.height = "100px";
    div2.style.display = "none";
    this.tip = div2;
    
    container.onmouseover = this.mouseover();
    container.onmouseout = this.mouseout();
//    GEvent.addDomListener(container, "onmouseover", function () {
//        alert("dd");
//        div2.style.display = "block";    
//    });
    
    map.getContainer().appendChild(container);
    return container;
};

EYEMAP.Legend.prototype.ClickHandler_ = function () {
  var me = this;
  return function () {
    GEvent.trigger(me, "deviceCheck", this.value, this.checked);
  };
};

EYEMAP.Legend.prototype.mouseover = function () {
  var me = this;
  return function () {
    me.tip.style.display = "block";
  };
};

EYEMAP.Legend.prototype.mouseout = function () {
  var me = this;
  return function () {
    me.tip.style.display = "none";
  };
};

EYEMAP.Legend.prototype.setButtonStyle_ = function(div) {
  div.style.backgroundColor = "#FFFFFF";
  //div.style.font = "宋体";
  div.style.border = "2px solid #1494D7";
  div.style.padding = "0px";
  div.style.cursor = "pointer";
  div.style.textAlign = "center";
  //div.style.height = "18px";
};


EYEMAP.Legend.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_RIGHT , new GSize(250, 7));
};
//toolbar
EYEMAP.ToolSet = function () { };
EYEMAP.ToolSet.prototype = new GControl();
EYEMAP.ToolSet.prototype.initialize = function(map) {
  var container = document.createElement("div");
  this.setContainerStyle_(container);
  
  var ele;
  ele = document.createElement("img");
  ele.src = "Img/map/my.png"; ele.alt = "0"; ele.title = "漫游"; ele.style.marginRight = "5px"; ele.style.marginLeft = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  ele = document.createElement("img");
  ele.src = "Img/map/kx.png"; ele.alt = "1"; ele.title = "矩形选择"; ele.style.marginRight = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  ele = document.createElement("img");
  ele.src = "Img/map/dx.png"; ele.alt = "2"; ele.title = "多边形选择"; ele.style.marginRight = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  ele = document.createElement("img");
  ele.src = "Img/map/cj.png"; ele.alt = "3"; ele.title = "测距"; ele.style.marginRight = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  ele = document.createElement("img");
  ele.src = "Img/map/cm.png"; ele.alt = "4"; ele.title = "测面积"; ele.style.marginRight = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  ele = document.createElement("img");
  ele.src = "Img/map/pan.png"; ele.alt = "0"; ele.title = "清除"; ele.style.marginRight = "5px";
  GEvent.addDomListener(ele, "click", this.ClickHandler_());
  container.appendChild(ele);
  
  map.getContainer().appendChild(container);
  return container;
};
//labelinfo
EYEMAP.labelInfo =function () { 
    this.div = null;
};
EYEMAP.labelInfo.prototype = new GControl();
EYEMAP.labelInfo.prototype.initialize = function(map) {
    var container = document.createElement("div");
    this.div = container;
    this.setButtonStyle_(container);
    map.getContainer().appendChild(container);
    return container;
};

EYEMAP.labelInfo.prototype.setButtonStyle_ = function(div) {
  div.style.backgroundColor = "#F4F4F4";
  //div.style.font = "宋体";
  div.style.border = "1px solid #B2B2B2";
  div.style.padding = "2px";
  div.style.cursor = "pointer";
  div.style.textAlign = "center";
  div.style.height = "15px";
  div.style.width = "130px";
};

EYEMAP.labelInfo.prototype.setContent = function (text) {
    this.div.innerHTML = text;
};

EYEMAP.labelInfo.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_LEFT , new GSize(230, 7));
};

EYEMAP.ToolSet.prototype.ClickHandler_ = function () {
  var me = this;
  return function () {
    GEvent.trigger(me, "toolCheck", this.alt);
  };
};


EYEMAP.ToolSet.prototype.setContainerStyle_ = function(div) {
  div.style.backgroundColor = "#FFFFFF";
  //div.style.font = "宋体";
  div.style.border = "2px solid #1494D7";
  div.style.padding = "2px";
  div.style.cursor = "pointer";
  div.style.textAlign = "center";
  div.style.height = "16px";
};

EYEMAP.ToolSet.prototype.getDefaultPosition = function() {
  return new GControlPosition(G_ANCHOR_TOP_LEFT , new GSize(90, 7));
};



EYEMAP.EMap = function (fMapDiv, fShowScale, fShowLargeControl, fShowTypeControl, fShowOverviewMap, fZoom, fDefaultPoint) {
    var container = document.getElementById(fMapDiv);
    var map = new GMap2(container);
    if (fZoom)
    {
        map.setCenter(fDefaultPoint, parseInt(fZoom));
    }
    this.map = map;
    if (fShowLargeControl)
    {
        this.map.addControl(new GLargeMapControl());      
    }
    else
    {
        this.map.addControl(new GSmallMapControl());  
    }

    if (fShowTypeControl)
    {
        this.map.addControl(new GMapTypeControl());
    }

    if (fShowScale)
    {
        this.map.addControl(new GScaleControl());
    }

    if (fShowOverviewMap)
    {
        this.map.addControl(new GOverviewMapControl());
    }

    this.map.enableDoubleClickZoom();
    this.map.enableContinuousZoom();
    this.that = map;
};

EYEMAP.EMap.prototype = {
    setMark2: function (fLat, fLng, fIcon, fTitle)
    {   
        // 如果经纬度有一个为空就不显示
        if (fLat === 0 || fLng === 0)
        {
            return null;
        }
        var point = new GLatLng(fLat, fLng);
        
        var markerOptions = { icon: fIcon, title: fTitle};
        var marker = new GMarker(point, markerOptions);
        //this.map.addOverlay(marker);
        
        return marker;
    },
    setCenter: function (fLat, fLng, fZoom) {
        if (fLat !== 0 && fLng !== 0) {
            var point = new GLatLng(fLat, fLng);
            if ((!fZoom) || (fZoom === 0) || (fZoom < this.map.getZoom()))
            {
                fZoom = this.map.getZoom();    
            }
            this.map.setCenter(point, parseInt(fZoom));
        }
    },
    getMap: function () {
        return this.map;
    }
};


EYEMAP.Map = function () 
{
    this.gmap = null;
    this._emap = null;
    this.markerGroup = {};
    this.allMarkers = [];
    
    this.mapIcon = {};
    this.mapIcon[0] = new GIcon(G_DEFAULT_ICON);
    this.mapIcon[0].image = "Img/map/nano_blue.png";
    this.mapIcon[0].iconSize = new GSize(24, 24);
    this.mapIcon[0].shadow = "";
    
    this.mapIcon[1] = new GIcon(G_DEFAULT_ICON);
    this.mapIcon[1].image = "Img/map/camera.png";
    this.mapIcon[1].iconSize = new GSize(24, 24);
    this.mapIcon[1].shadow = "";
    
};

EYEMAP.Map.prototype = {
        //初始化地图
    initMap: function(wrapDiv)
    {
        if (GBrowserIsCompatible())
        {
            var defaultPoint;
            if (defLat === 0 || defLng === 0)
            {
                defaultPoint = new GLatLng(37.2303, 102.0278);
            }
            else
            { 
                defaultPoint = new GLatLng(defLat, defLng);
            }       

            this._emap = new EYEMAP.EMap(wrapDiv, false, true, true, false);
            this.gmap = this._emap.getMap();
            
            var legend = new EYEMAP.Legend();
            GEvent.addListener(legend, "deviceCheck", function (val, checked) 
                {  
                    if (val === "1")
                    {
                        if (checked)
                        {
                            EYEMAP.MapShow.map.markerGroup[0].show();
                            EYEMAP.MapShow.map.markerGroup[2].show();
                        }
                        else
                        {
                            EYEMAP.MapShow.map.markerGroup[0].hide();
                            EYEMAP.MapShow.map.markerGroup[2].hide();
                        }
                    }
                    else if (val === "2")
                    {
                        if (checked)
                        {
                            EYEMAP.MapShow.map.markerGroup[1].show();
                            EYEMAP.MapShow.map.markerGroup[3].show();
                        }
                        else
                        {
                            EYEMAP.MapShow.map.markerGroup[1].hide();
                            EYEMAP.MapShow.map.markerGroup[3].hide();
                        }
                    }
            });
            this.gmap.addControl(legend);
 
            this._emap.setCenter(defaultPoint.lat(), defaultPoint.lng(), zoom);
            
            this.markerGroup[0] = new MarkerManager(this.gmap);  //告警编码器
            this.markerGroup[1] = new MarkerManager(this.gmap);  //告警摄像头
            this.markerGroup[2] = new MarkerManager(this.gmap);  //正常编码器
            this.markerGroup[3] = new MarkerManager(this.gmap);  //正常摄像头
           
            
            GEvent.addListener(this.gmap, "zoomend", this.zoomend);

        }
    },
    zoomend: function(oldLevel, newLevel) {
        if (!allmarker && (newLevel >= 17))
        {
            allmarker = true;
            $.getJSON("Ajax/DeviceSearch.aspx", {"type": 3 }, 
                function(data){ 
                    progress = 0;
                    progressBar = new ProgressbarControl(EYEMAP.MapShow.map.gmap, {width:150}); 
                    progressBar.start(data.a.length);
                    deviceData = data.a;
                    setTimeout('EYEMAP.MapShow.map.loadNormalDvs()', 10);
                }
            );        
        }
    },
    mClick: function (m) {
        if (m.p)
        {
            if (!m.infoBox)
            {
                if (m.p[0] === 1)
                {
                    m.infoBox = this.renderDvsInfo(m.p);
                }
                else if (m.p[0] === 2)
                {
                    m.infoBox = this.renderCameraInfo(m.p);
                }
            }
            m.openInfoWindowHtml(m.infoBox);
        } 
    },
    createMark: function (fIcon, fLat, fLng, fTitle)
    {
        var marker = this._emap.setMark2(fLat, fLng, fIcon, fTitle); 
        var that = this;
        if (marker)
        {
            that.allMarkers.push(marker);
            GEvent.addListener(marker, "click", function() {
                that.mClick(marker);
            });
        } 
        return marker;
    },
    renderDvsInfo: function (p)
    {
        var html = ["<div>"];
        html.push("<div class='googlelist clx' style='width: 510px;'>");
        html.push("<ul class='h_right clx'>");
        html.push("<li class='hmab'>");
        html.push("<h2 class='in-h2'><img src='Img/map/nano_blue.png' width=32 height=32 ><a href='Admin/ResEncoder.aspx?id=" + p[1] + "' class='jd' target='_blank'>编码器：" + p[4] + "</a></h2>");
        html.push("</li>");
        html.push("<li>分局：" + p[5] + "</li>");
        html.push("<li>DVS型号：" + p[6] + "</li>");
        html.push("<li>设备状态：" + p[10] + "</li>");
        html.push("<li>用户类别：" + p[7] + "</li>");
        html.push("<li>用户名称：" + p[8] + "</li>");
        html.push("<li class='pr5'>用户地址：" + p[9] + "</li>");
        html.push("</ul>");
        html.push("<div class='clear'></div>");
        html.push("<div class='tr'><a target='_blank' href='Admin/ResEncoder.aspx?id=" + p[1] + "' class='mr15'>编码器详情</a></div>");
        //
        if (p[12].length > 0)
        {
            html.push("<div class='tbz1'><span class='fb1'></span><span class='fb2'>告警内容</span><span class='fb3'>告警流转</span><span class='fb4'>告警时间</span></div>");
            for(var i = 0; i < p[12].length; i++)
            {
                html.push("<ul class='tbz'><li><span class='fb1'>" + (i + 1) + "</span><span class='fb2'>" + p[12][i][0] + "</span><span class='fb3'>" + p[12][i][1] + "</span><span class='fb4'>" + p[12][i][2] + "</span></li></ul>");
            }
        }
        html.push("</div></div>");
        return html.join('');
    },
    renderCameraInfo: function (p)
    {
        var html = ["<div>"];
        html.push("<div class='googlelist clx' style='width: 510px;'>");
        html.push("<ul class='h_right clx'>");
        html.push("<li class='hmab'>");
        html.push("<h2 class='in-h2'><img src='Img/map/camera.png' width=32 height=32 ><a href='Admin/ResCamera.aspx?id=" + p[1] + "' class='jd' target='_blank'>摄像头：" + p[4] + "</a></h2>");
        html.push("</li>");
        html.push("<li>分局：" + p[5] + "</li>");
        html.push("<li>摄像头型号：" + p[6] + "</li>");
        html.push("<li>设备状态：" + p[10] + "</li>");
        html.push("<li>用户类别：" + p[7] + "</li>");
        html.push("<li>用户名称：" + p[8] + "</li>");
        html.push("<li class='pr5'>用户地址：" + p[9] + "</li>");
        html.push("</ul>");
        html.push("<div class='clear'></div>");
        html.push("<div class='tr'><a target='_blank' href='Admin/ResCamera.aspx?id=" + p[1] + "' class='mr15'>摄像头详情</a></div>");
        //
        if (p[12].length > 0)
        {
            html.push("<div class='tbz1'><span class='fb1'></span><span class='fb2'>告警内容</span><span class='fb3'>告警流转</span><span class='fb4'>告警时间</span></div>");
            for(var i = 0; i < p[12].length; i++)
            {
                html.push("<ul class='tbz'><li><span class='fb1'>" + (i + 1) + "</span><span class='fb2'>" + p[12][i][0] + "</span><span class='fb3'>" + p[12][i][1] + "</span><span class='fb4'>" + p[12][i][2] + "</span></li></ul>");
            }
        }
        html.push("</div></div>");
        return html.join('');
    }, 
    markerDvs: function (p)
    {
        var icon = this.mapIcon[0]; 
        var marker = this.createMark(icon, p[2], p[3], p[4]);
        if (marker)
        {
            marker.p = p;
        }
        return marker;
    },
    markerCamera: function (p)
    {
        var icon = this.mapIcon[1];
        var marker = this.createMark(icon, p[2], p[3], p[4]);
        if (marker)
        {
            marker.p = p;
        }
        return marker;
    },
    //加载告警编码器
    loadDvsData: function(hdata)
    {
        this.markerGroup[0].clearMarkers();
        for (var i = 0; i < hdata.length; i++)
        {
            var p = hdata[i];
            var marker = this.markerDvs(p);
            if (marker)
            {
                this.markerGroup[0].addMarker(marker, 0);
            }
        }
        //this.markerGroup[0].refresh();
    },
    //加载正常编码器
    loadNormalDvs: function()
    {
        for (var i = 0; i < 10; i++)
        {
            if ((i + progress) >= deviceData.length)
            {
                progressBar.remove();
                $.getJSON("Ajax/DeviceSearch.aspx", {"type": 4 }, 
                        function(data){ 
                            progress = 0;
                            progressBar = new ProgressbarControl(EYEMAP.MapShow.map.gmap, {width:150}); 
                            progressBar.start(data.a.length);
                            deviceData = data.a;
                            setTimeout('EYEMAP.MapShow.map.loadNormalCamera()', 10);
                        }
                    );    
                    
                return;
            }
            var p = deviceData[i + progress];
            var marker = this.markerDvs(p);
            if (marker)
            {
                this.markerGroup[2].addMarker(marker, 17);
            }
        }
        progress = progress + 10;
        progressBar.updateLoader(10);
        setTimeout('EYEMAP.MapShow.map.loadNormalDvs()', 10);
    },
    //加载告警摄像头
    loadCameraData: function(hdata)
    {
        this.markerGroup[1].clearMarkers();
        for (var i = 0; i < hdata.length; i++)
        {
            var p = hdata[i]; 
            var marker = this.markerCamera(p);
            if (marker)
            {
                this.markerGroup[1].addMarker(marker, 0);
            }
        }
    },
    loadNormalCamera: function()
    {
        for (var i = 0; i < 10; i++)
        {
            if ((i + progress) >= deviceData.length)
            {
                progressBar.remove();
                return;
            }
            var p = deviceData[i + progress];
            var marker = this.markerCamera(p);
            if (marker)
            {
                this.markerGroup[3].addMarker(marker, 17);
            }
        }
        progress = progress + 10;
        progressBar.updateLoader(10);
        setTimeout('EYEMAP.MapShow.map.loadNormalCamera()', 10);    
    }
};

EYEMAP.MapShow = {
    map: null,
    gmap: null,
    PAGECOUNT: 15,
    searchType: 1,
    searchData: {},
    mapSearchData: [], //地图搜索数据
    tool: "0",
    points: new Array(),
    poly: null,
    label: null,
    tab_counter: 3,
    init: function() 
    {
        this.map = new EYEMAP.Map();
	    this.map.initMap("mapwrapper");
	    this.gmap = this.map.gmap; 
	    GEvent.addListener(this.gmap, "click", this.leftClick);
	    GEvent.addListener(this.gmap, "singlerightclick", this.singlerightclick);
	    GEvent.addListener(this.gmap, "mousemove", this.mousemove);
	    var toolset = new EYEMAP.ToolSet();
        this.gmap.addControl(toolset);
        GEvent.addListener(toolset, "toolCheck", function (val) {
            var that = EYEMAP.MapShow;
            that.tool = val;
            that.points.length = 0;
            if (that.poly)
            { 
                that.gmap.removeOverlay(that.poly);
                that.poly = null;
            }
            if (that.label)
            { 
                that.gmap.removeControl(that.label);
                that.label = null;  
            }
        });
	    
	    this.map.loadCameraData(alarmCamera);
	    this.map.loadDvsData(alarmDvs);
	    this.renderAlarmList(alarmDvs, alarmCamera, 1);
	    $("#searchtype > input").click( function () {
	        EYEMAP.MapShow.searchType = $(this).val();   
	    });
	    
	    $("#deviceSearch").click( this.search );
	    
    },
    search: function()
    {
        var key = $.trim($("#searchKey").val());
        if (key === "")
        {
            alert("请输入查询条件！");
            return;
        }
        
        $.getJSON("Ajax/DeviceSearch.aspx", {"key": key, "type": EYEMAP.MapShow.searchType }, 
            function(data){ 
                EYEMAP.MapShow.searchData['#tabs-' + EYEMAP.MapShow.tab_counter] = data.a;
                $tabs.tabs('add', '#tabs-' + EYEMAP.MapShow.tab_counter, key);
			    
            }
        ); 
    },
    addTab: function(event, ui)
    {
        var $div = $(ui.panel);
        var tabidx = EYEMAP.MapShow.tab_counter;
        $tabs.tabs( 'select' , tabidx - 1 );
        $("<div id='tabs-dl-" + tabidx + "' class='htj15'></div>").appendTo($div);
        $("<span id='tabs-page-" + tabidx + "' class='page_r'></span>").appendTo($div);
        EYEMAP.MapShow.renderSearchList(tabidx, EYEMAP.MapShow.searchType, 1);
        EYEMAP.MapShow.tab_counter++;
            
    },
    renderSearchList: function(tabidx, type, page)
    {
        var data = EYEMAP.MapShow.searchData["#tabs-" + tabidx];
        var $div = $("#tabs-dl-" + tabidx);
        $div.empty(); 
        if (data.length === 0)
        {
            $div.html("没有任何设备");    
        }
        var n = ((page * EYEMAP.MapShow.PAGECOUNT) >= data.length) ? data.length : (page * EYEMAP.MapShow.PAGECOUNT);
        for (var i = ((page - 1) * EYEMAP.MapShow.PAGECOUNT); i < n; i++)
        {
            var p = data[i];
            if (p[0] === 1)
            {
                this.renderDvs($div, p, i + 1);
            } 
            else
            {
                this.renderCamera($div, p, i + 1);
            }    
        } 
        
        //分页
        $pg = $("#tabs-page-" + tabidx);
        $pg.empty(); 
        var pn = Math.ceil(data.length / EYEMAP.MapShow.PAGECOUNT);
        if (page === 1)
        {
            $("<a class='ls1 npage'>上一页</a>").appendTo($pg);    
        }
        else
        {
            $("<a href='javascript:void(0);' title='上一页'>上一页</a>").bind("click", {tab: tabidx, device: type, index: page - 1}, function (event) { 
                EYEMAP.MapShow.renderSearchList(event.data.tab, event.data.device, event.data.index); }).appendTo($pg);
        }
        
        for (var i = 1; i <= pn; i++)
        {
            if(i === page)
            {
                $("<a class='dq' href='javascript:void(0);'>" + i + "</a>").appendTo($pg);
            }
            else
            {
                $("<a href='javascript:void(0);'>" + i + "</a>").bind("click", {tab: tabidx, device: type, index: i}, function (event) { 
                    EYEMAP.MapShow.renderSearchList(event.data.tab, event.data.device, event.data.index); }).appendTo($pg);
            }
        }
        
        if (page === pn)
        {
            $("<a class='ls1 npage'>下一页</a>").appendTo($pg);    
        }
        else
        {
            $("<a href='javascript:void(0);' title='下一页'>下一页</a>").bind("click", {tab: tabidx, device: type, index: page + 1}, function (event) { 
                EYEMAP.MapShow.renderSearchList(event.data.tab, event.data.device, event.data.index); }).appendTo($pg);
        }
        this.deviceSelect($div);
        
    },
    renderDvs: function(c, p, I)
    {
        var html = ["<ul lat='" + p[2] + "' lng='" + p[3] + "'>"];
        html.push("<li><span class='h_sz'>" + I + "</span><a href='javascript:void(0)'>" + p[4] + "</a></li>");
        html.push("<li class='opt'>分局：" + p[5] + "</li>");
        html.push("<li class='opt'>DVS型号：" + p[6] + "</li>");
        html.push("</ul>");
        c.append(html.join(""));
    },
    renderCamera: function(c, p, I)
    {
        var html = ["<ul lat='" + p[2] + "' lng='" + p[3] + "'>"];
        html.push("<li><span class='h_sz'>" + I + "</span><a href='javascript:void(0)'>" + p[4] + "</a></li>");
        html.push("<li class='opt'>分局：" + p[5] + "</li>");
        html.push("<li class='opt'>摄像头型号：" + p[6] + "</li>");
        html.push("</ul>");
        c.append(html.join(""));
    },
    renderAlarmList: function(data_dvs, data_c, page)
    {
        $div = $("#deviceList");
        $div.empty(); 
        var start = (page - 1) * this.PAGECOUNT + 1;
        var start1 = 1;
        var start2 = 1;
        var n1 = 0;

        if (start <= data_dvs.length)
        {
            start1 = start;
            n1 = ((data_dvs.length - start + 1) >= this.PAGECOUNT) ? this.PAGECOUNT : (data_dvs.length - start + 1);
            for (var i = 0; i < n1; i++)
            {
                var p = data_dvs[start1 + i - 1];
                this.renderDvs($div, p, i + 1);
            }   
        }
        else
        {
            start2 = start - data_dvs.length;    
        } 
        
        var n2 = this.PAGECOUNT - n1;
        n2 = ((data_c.length - start2 + 1) >= n2) ? n2 : (data_c.length - start2 + 1);
        for (var i = 0; i < n2; i++)
        {
            var p = data_c[start2 + i - 1]; 
            this.renderCamera($div, p, n1 + i + 1);
        } 
        //分页
        $pg = $("#devicePage");
        $pg.empty(); 
        var pn = Math.ceil((data_dvs.length + data_c.length) / this.PAGECOUNT);
        if (page === 1)
        {
            $("<a class='ls1 npage'>上一页</a>").appendTo($pg);    
        }
        else
        {
            $("<a href='javascript:void(0);' title='上一页'>上一页</a>").bind("click", {index: page - 1}, function (event) { 
                EYEMAP.MapShow.renderAlarmList(alarmDvs, alarmCamera, event.data.index); }).appendTo($pg);
        }
        
        for (var i = 1; i <= pn; i++)
        {
            if(i === page)
            {
                $("<a class='dq' href='javascript:void(0);'>" + i + "</a>").appendTo($pg);
            }
            else
            {
                $("<a href='javascript:void(0);'>" + i + "</a>").bind("click", {index: i}, function (event) { 
                    EYEMAP.MapShow.renderAlarmList(alarmDvs, alarmCamera, event.data.index); }).appendTo($pg);
            }
        }
        
        if (page === pn)
        {
            $("<a class='ls1 npage'>下一页</a>").appendTo($pg);    
        }
        else
        {
            $("<a href='javascript:void(0);' title='下一页'>下一页</a>").bind("click", {index: page + 1}, function (event) { 
                EYEMAP.MapShow.renderAlarmList(alarmDvs, alarmCamera, event.data.index); }).appendTo($pg);
        }
        this.deviceSelect($div);
    },
    deviceSelect: function (d)
    {
        d.children().click( function () {
            $this = $(this);
            $this.parent().children().removeClass("mpb");
            $this.addClass("mpb");
            EYEMAP.MapShow.map._emap.setCenter($this.attr("lat"), $this.attr("lng"));
            
        });
    },
    leftClick: function(overlay, point) {
        var that = EYEMAP.MapShow;
        
        if (that.tool !== "0")
        {
            if (point)
            {
                that.points.push(point); 
            }
            if (that.tool === "1")
            {
                if (that.points.length > 1 )
                {
                    var points = that.getRect(that.points[0], that.points[1]);
                    that.mapSearch(points);
                    that.points.length = 0;
                }
                
            }
            else if (that.tool === "2")
            {
                that.drawPolygon(that.points);
            }
            else if (that.tool === "3")
            {
                that.drawPolyline(that.points);
                if (that.poly) {
                    that.showLabel("共 " +  (that.poly.getLength() / 1000).toFixed(2) + " 千米");
                }
            }
            else if (that.tool === "4")
            {
                that.drawPolygon(that.points);
            }
        }
  
    },
    singlerightclick: function(pt) {
        var that = EYEMAP.MapShow;
        that.points.push(that.gmap.fromContainerPixelToLatLng(pt));
        
        if (that.tool === "1")
        {
            if (that.points.length > 1 )
            {
                var points = that.getRect(that.points[0], that.points[1]);
                that.mapSearch(points);
                that.points.length = 0;
            }
            
        }
        else if (that.tool === "2")
        {
            if (that.points.length > 2)
            {
                that.points.push(that.points[0]);
                that.drawPolygon(that.points); 
                that.mapSearch(that.points);
            } 
        }
        else if (that.tool === "3")
        {
            that.drawPolyline(that.points);
            if (that.poly) {
                that.showLabel("共 " +  (that.poly.getLength() / 1000).toFixed(2) + " 千米");
            }
        }
        else if (that.tool === "4")
        {
            that.drawPolygon(that.points);
            if (that.poly) {
                that.showLabel("共 " +  (that.poly.getArea() / 1000000).toFixed(2) + " 平方公里");
            }
        }
            
        
        that.points.length = 0;  
    },
    mapSearch: function (pts) {
        this.mapSearchData.length = 0;
        for (var i = 0; i < this.map.allMarkers.length; i++)
        {
            if ((this.map.allMarkers[i].isHidden() == false) && (this.contains(this.map.allMarkers[i].getLatLng())))
            {
                this.mapSearchData.push(this.map.allMarkers[i].p);
            }
        }
        $("#tabs-dl-2").empty(); 
        $("#tabs-page-2").empty();
        this.searchData['#tabs-2'] = this.mapSearchData;
        this.renderSearchList(2, 1, 1);
        $tabs.tabs( 'select' , 1 );
    },
    contains: function(point) {
        var j=0;
        var oddNodes = false;
        var x = point.lng();
        var y = point.lat();
        for (var i=0; i < this.poly.getVertexCount(); i++) {
          j++;
          if (j == this.poly.getVertexCount()) {j = 0;}
          if (((this.poly.getVertex(i).lat() < y) && (this.poly.getVertex(j).lat() >= y))
          || ((this.poly.getVertex(j).lat() < y) && (this.poly.getVertex(i).lat() >= y))) {
            if ( this.poly.getVertex(i).lng() + (y - this.poly.getVertex(i).lat())
            /  (this.poly.getVertex(j).lat()-this.poly.getVertex(i).lat())
            *  (this.poly.getVertex(j).lng() - this.poly.getVertex(i).lng())<x ) {
              oddNodes = !oddNodes
            }
          }
        }
        return oddNodes;
    },
    mousemove: function(pt) {
        var that = EYEMAP.MapShow;
        if ((that.tool === "1") && (that.points.length > 0))
        {
            that.points[1] = pt;
            var points = that.getRect(that.points[0], pt);
            that.drawPolygon(points);
        }
    },
    getRect: function(pt1, pt2) {
        var points = [];
        points.push(new GLatLng( Math.min(pt1.lat(),pt2.lat()), Math.min(pt1.lng(),pt2.lng()) ));
        points.push(new GLatLng( Math.max(pt1.lat(),pt2.lat()), Math.min(pt1.lng(),pt2.lng()) ));
        points.push(new GLatLng( Math.max(pt1.lat(),pt2.lat()), Math.max(pt1.lng(),pt2.lng()) ));
        points.push(new GLatLng( Math.min(pt1.lat(),pt2.lat()), Math.max(pt1.lng(),pt2.lng()) ));
        points.push(new GLatLng( Math.min(pt1.lat(),pt2.lat()), Math.min(pt1.lng(),pt2.lng()) ));
        return points;
    },
    drawPolygon: function(pts) {
        if (this.poly) { this.gmap.removeOverlay(this.poly); }
        if (pts.length > 1)
        {
            
            this.poly = new GPolygon(pts, "#1494D7", 5, .9, "#ff0000", .2);
            this.gmap.addOverlay(this.poly);
        }
    
    },
    drawPolyline: function(pts) {
        if (this.poly) { this.gmap.removeOverlay(this.poly); }
        if (pts.length > 1)
        {
            
            this.poly = new GPolyline(pts, "#1494D7", 5, .9, "#ff0000", .2);
            this.gmap.addOverlay(this.poly);
        }
    },
    showLabel: function(title) {
        if (!this.label)
        {
            this.label = new EYEMAP.labelInfo(); 
            this.gmap.addControl(this.label);
        }
        this.label.setContent(title);
    }
};

EYEMAP.GetPosition = {
    _emap: null,
    gmap: null,
    marker: null,
    mapIcon: null,
    init: function() {
        if (GBrowserIsCompatible())
        {
            this._emap = new EYEMAP.EMap("map", false, true, true, false);
            this.gmap = this._emap.getMap();
            
            var defaultPoint;
            var txtLongitude = document.getElementById("txtLongitude");
            var txtLatitude = document.getElementById("txtLatitude");
            if (txtLongitude.value === "" || txtLatitude.value === "" || txtLongitude.value === "0" || txtLatitude.value === "0")
            {
                defaultPoint = new GLatLng(37.2303, 102.0278);
            } 
            else
            {
                defaultPoint = new GLatLng(txtLatitude.value, txtLongitude.value);
            }

            this._emap.setCenter(defaultPoint.lat(), defaultPoint.lng(), 12);
            
            this.mapIcon = new GIcon(G_DEFAULT_ICON);
            this.mapIcon.image = "../Img/map/flag.gif";
            this.mapIcon.iconSize = new GSize(16, 28);
            this.mapIcon.shadow = "";
            this.marker = this._emap.setMark2(defaultPoint.lat(), defaultPoint.lng(), this.mapIcon, "");
            this.gmap.addOverlay(this.marker);

            GEvent.addListener(this.gmap,"click",function(marker,point){
                var txtLongitude = document.getElementById("txtLongitude");
                var txtLatitude = document.getElementById("txtLatitude");
                txtLongitude.value = point.lng();
                txtLongitude.value = txtLongitude.value.substring(0,9);
                txtLatitude.value = point.lat();
                txtLatitude.value = txtLatitude.value.substring(0,8);
                
                if (EYEMAP.GetPosition.marker != null )
                    EYEMAP.GetPosition.gmap.removeOverlay(EYEMAP.GetPosition.marker);  
                EYEMAP.GetPosition.marker = EYEMAP.GetPosition._emap.setMark2(point.lat(), point.lng(), EYEMAP.GetPosition.mapIcon, "");
                EYEMAP.GetPosition.gmap.addOverlay(EYEMAP.GetPosition.marker);
              
            });

        }
    }
};


