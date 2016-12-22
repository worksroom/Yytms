<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    HttpSession userSession = request.getSession();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <base href="<%=basePath%>">
    <title>印刷耗材管理系统</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <link href="resources/ligerUI/skins/Aqua/css/ligerui-all.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" id="mylink" />
    <link href="resources/ligerUI/skins/Gray/css/all.css" rel="stylesheet" type="text/css">
    <script src="resources/jquery/jquery-1.9.0.min.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/ligerui.all.js" type="text/javascript"></script>
    <script src="resources/ligerUI/js/plugins/ligerTab.js"></script>
    <script src="resources/ligerUI/js/plugins/ligerTree.js" type="text/javascript"></script>
    <script src="resources/js/jquery.cookie.js"></script>
    <script src="resources/js/json2.js"></script>

    <style type="text/css">
        body, html {
            height: 100%;
        }

        body {
            padding: 0px;
            margin: 0;
            overflow: hidden;
        }

        .l-link {
            display: block;
            height: 26px;
            line-height: 26px;
            padding-left: 10px;
            text-decoration: underline;
            color: #333;
        }

        .l-link2 {
            text-decoration: underline;
            color: white;
            margin-left: 2px;
            margin-right: 2px;
        }

        .l-layout-top {
            background: #102A49;
            color: White;
        }

        .l-layout-bottom {
            background: #E5EDEF;
            text-align: center;
        }

        #pageloading {
            position: absolute;
            left: 0px;
            top: 0px;
            background: white url('resources/images/loading.gif') no-repeat center;
            width: 100%;
            height: 100%;
            z-index: 99999;
        }

        .l-link {
            display: block;
            line-height: 22px;
            height: 22px;
            padding-left: 16px;
            border: 1px solid white;
            margin: 4px;
        }

        .l-link-over {
            background: #FFEEAC;
            border: 1px solid #DB9F00;
        }

        .l-winbar {
            background: #2B5A76;
            height: 30px;
            position: absolute;
            left: 0px;
            bottom: 0px;
            width: 100%;
            z-index: 99999;
        }

        .space {
            color: #E7E7E7;
        }

        /* 顶部 */
        .l-topmenu {
            margin: 0;
            padding: 0;
            height: 31px;
            line-height: 31px;
            background: url('resources/images/top.jpg') repeat-x bottom;
            position: relative;
            border-top: 1px solid #1D438B;
        }

        .l-topmenu-logo {
            color: #E7E7E7;
            padding-left: 35px;
            line-height: 26px;
            background: url('resources/images/topicon.gif') no-repeat 10px 5px;
        }

        .l-topmenu-welcome {
            position: absolute;
            height: 24px;
            line-height: 24px;
            right: 30px;
            top: 2px;
            color: #070A0C;
        }

        .l-topmenu-welcome a {
            color: #E7E7E7;
            text-decoration: underline
        }

        .body-gray2014 #framecenter {
            margin-top: 3px;
        }

        .viewsourcelink {
            background: #B3D9F7;
            display: block;
            position: absolute;
            right: 10px;
            top: 3px;
            padding: 6px 4px;
            color: #333;
            text-decoration: underline;
        }

        .viewsourcelink-over {
            background: #81C0F2;
        }

        .l-topmenu-welcome label {
            color: white;
        }

        #skinSelect {
            margin-right: 6px;
        }

        .l-dialog-content {
            overflow-y: hidden
        }
    </style>
    <style type="text/css">
        /* 菜单列表 */
        .menulist { margin-left: 2px; margin-right: 2px; margin-top: 2px; text-align: left; color: #000; padding: 0; }
        .menulist li { height: 24px; line-height: 24px; padding-left: 24px; display: block; position: relative; cursor: pointer; text-align: left; }
        .menulist li img { position: absolute; left: 4px; top: 4px; width: 16px; height: 16px; }
        .menulist li.over, .menulist li.selected { background: url('Images/index/menuitem.gif') repeat-x 0px 0px; }
        .menulist li.over .menuitem-l, .menulist li.selected .menuitem-l { background: url('Images/index/menuitem.gif') repeat-x 0px -24px; width: 2px; height: 24px; position: absolute; left: 0; top: 0; }
        .menulist li.over .menuitem-r, .menulist li.selected .menuitem-r { background: url('Images/index/menuitem.gif') repeat-x -1px -24px; width: 2px; height: 24px; position: absolute; right: 0; top: 0; }
    </style>


    <script src="resources/js/YYT.js" type="text/javascript"></script>
    <script type="text/javascript">
        var tab = null;
        var accordion = null;
        var tree = null;
        var tree2 = null;
        var tabItems = [];
        var addChangePassword = "changePassword";

        $(function () {

            navigation();

            $("#layout1").ligerLayout({
                leftWidth: 190,
                bottomHeight: 25,
                allowBottomResize: false,
                allowLeftResize: false,
                allowRightResize: false,
                height: '100%',
                onHeightChanged: f_heightChanged,
                isRightCollapse: true
            });


            var height = $(".l-layout-center").height();

            //Tab
            $("#framecenter").ligerTab({
                height: height,
                showSwitchInTab: true,
                showSwitch: true,
                onAfterAddTabItem: function (tabdata) {
                    tabItems.push(tabdata);
                    //saveTabStatus();
                },
                onAfterRemoveTabItem: function (tabid) {
                    for (var i = 0; i < tabItems.length; i++) {
                        var o = tabItems[i];
                        if (o.tabid == tabid) {
                            tabItems.splice(i, 1);
                            //saveTabStatus();
                            break;
                        }
                    }
                },
                onReload: function (tabdata) {
                    var tabid = tabdata.tabid;
                    addFrameSkinLink(tabid);
                }
            });

            /**
             * 修改密码
             */
            $("#changePassword").click(function () {
                if (tab.isTabItemExist(addChangePassword)) {
                    tab.selectTabItem(addChangePassword);
                    tab.reload(addChangePassword);
                } else {
                    f_addTab(addChangePassword, "修改密码", "${baseURL}/user/changePassword.do");
                }
            });

            //面板
            accordion = $("#accordion1").ligerAccordion({
                height: height - 25, speed: null
            });

            initLayout();
            $(window).resize(function () {
                initLayout();
            });


            $(".l-link").hover(function () {
                $(this).addClass("l-link-over");
            }, function () {
                $(this).removeClass("l-link-over");
            });

            tab = liger.get("framecenter");
//            accordion = liger.get("accordion1");
            $("#pageloading").hide();

            css_init();


        });

        function navigation() {
            $.ajax({
                cache: false,
                type: "POST",
                url:"manager/sysMenu.do?method=loadNavigation&rnd=" + Math.random(),
                async: false,
                dataType:"html",
                error: function(request) {
                    alert("error");
                },
                success: function(data) {
                    var obj = eval('(' + data + ')');
                    var items = obj.Items;

                    $("#toolbar").ligerToolBar({
                        background: false,
                        items: items
                    });
                    checkcr();

                    $("#pageloading").fadeOut(800);

                }
            });
        }


        function clickMenu(id) {
            if (!id) id = "00020002";

            var mainmenu = $("#accordion1");
            mainmenu.empty();

            $.ajax({
                cache: false,
                type: "POST",
                url:"manager/sysMenu.do?method=loadAccordion&id=" + id + "&rnd=" + Math.random(),
                async: false,
                dataType:"html",
                error: function(request) {
                    alert("error");
                },
                success: function(data) {
                    var menus = eval('(' + data + ')');
                    $(menus).each(function (i, menu) {
                        var item = $('<div title="' + menu.Menu_name + '"><ul class="menulist"></ul></div>');
                        $(menu.children).each(function (j, submenu) {
                            var subitem = $('<li><img/><span></span><div class="menuitem-l"></div><div class="menuitem-r"></div></li>');
                            subitem.attr({
                                url: submenu.Menu_url+"?menuId="+submenu.Menu_id,
                                tabid: "tabid" + submenu.Menu_id,
                                menuno: submenu.Menu_id
                            });
                            $("img", subitem).attr("src", submenu.Menu_icon);
                            $("span", subitem).html(submenu.Menu_name);

                            $("ul:first", item).append(subitem);
                        });
                        mainmenu.append(item);
                    });
                    accordion._render();
                    accordion.setHeight($(".l-layout-center").height() - 25);
                    }
            });

            //菜单初始化
            $("ul.menulist li").live('click', function () {
                var jitem = $(this);
                var tabid = jitem.attr("tabid");
                var url = jitem.attr("url");

                f_addTab(tabid, $("span:first", jitem).html(), url); if ($(this).hasClass("selected")) {
                    return;
                }
                else {
                    $(".selected").removeClass("selected");
                    $(this).addClass("selected");
                }

            }).live('mouseover', function () {
                var jitem = $(this);
                jitem.addClass("over");
            }).live('mouseout', function () {
                var jitem = $(this);
                jitem.removeClass("over");
            });

        }

        function css_init() {
            var css = $("#mylink").get(0), skin = getQueryString("skin");
            $("#skinSelect").val(skin);
            $("#skinSelect").change(function () {
                if (this.value) {
                    location.href = "${baseURL}/ligerUI/index.htm?skin=" + this.value;
                } else {
                    location.href = "${baseURL}/ligerUI/index.htm";
                }
            });


            if (!css || !skin) return;
            skin = skin.toLowerCase();
            $('body').addClass("body-" + skin);
            $(css).attr("href", skin_links[skin]);
        }

        function f_heightChanged(options) {
            if (tab)
                tab.addHeight(options.diff);
            if (accordion && options.middleHeight - 25 > 0)
                accordion.setHeight(options.middleHeight - 25);
        }

        function f_addTab(tabid, text, url) {
            tab.addTabItem({
                tabid: tabid,
                text: text,
                url: url,
                callback: function () {
                    addFrameSkinLink(tabid);
                }
            });
        }

        var skin_links = {
            "aqua": "lib/ligerUI/skins/Aqua/css/ligerui-all.css",
            "gray": "lib/ligerUI/skins/Gray/css/all.css",
            "silvery": "lib/ligerUI/skins/Silvery/css/style.css",
            "gray2014": "lib/ligerUI/skins/gray2014/css/all.css"
        };

        function addFrameSkinLink(tabid) {
            var prevHref = getLinkPrevHref(tabid) || "";
            var skin = getQueryString("skin");
            if (!skin) return;
            skin = skin.toLowerCase();
            attachLinkToFrame(tabid, prevHref + skin_links[skin]);
        }

        function attachLinkToFrame(iframeId, filename) {
            if (!window.frames[iframeId]) return;
            var head = window.frames[iframeId].document.getElementsByTagName('head').item(0);
            var fileref = window.frames[iframeId].document.createElement("link");

            if (!fileref) return;
            fileref.setAttribute("rel", "stylesheet");
            fileref.setAttribute("type", "text/css");
            fileref.setAttribute("href", filename);
            head.appendChild(fileref);
        }

        function getLinkPrevHref(iframeId) {
            if (!window.frames[iframeId]) return;
            var head = window.frames[iframeId].document.getElementsByTagName('head').item(0);
            var links = $("link:first", head);
            for (var i = 0; links[i]; i++) {
                var href = $(links[i]).attr("href");
                if (href && href.toLowerCase().indexOf("ligerui") > 0) {
                    return href.substring(0, href.toLowerCase().indexOf("lib"));
                }
            }
        }
    </script>

</head>
<body style="padding: 0px; background: #EAEEF5;">
<div id="pageloading"></div>
<div id="topmenu" class="l-topmenu">
    <div class="l-topmenu-logo">印刷管理系统</div>
    <div class="l-topmenu-welcome">
        <span style="color:white">欢迎:<%=userSession.getAttribute("uname") %></span>
        <span class="space">|</span>
        <a href="loginAction.do?method=logout" class="l-link2">退出</a>
        <span class="space">|</span>
        <a style="cursor:pointer" class="l-link2" id="changePassword">修改密码</a>
    </div>



</div>

<div style="margin: 0; padding: 0; height: 28px; overflow: hidden; border-bottom: 1px solid #8db2e3; width: 100%;">
    <div id="toolbar" style="height: 27px; margin-top: 1px; padding-right: 70px;background: url(resources/ligerUI/skins/Gray2014/images/layout/layout-header.gif);"></div>
</div>

<div id="layout1" style="width: 100%; margin: 0 auto; margin-top: 2px;">
    <div position="left" title="功能菜单" id="accordion1">

    </div>

    <div position="center" id="framecenter">
        <div tabid="home" title="欢迎" style="height: 100%">
            <iframe frameborder="0" name="home" id="home" src="manager/layout/welcome.jsp"></iframe>
        </div>
    </div>
</div>

<div style="height: 32px; line-height: 32px; text-align: center;">
    Copyright © 2011-2014 王石
</div>
<div style="display: none"></div>
</body>
</html>
