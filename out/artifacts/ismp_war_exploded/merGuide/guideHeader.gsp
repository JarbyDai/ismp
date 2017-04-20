<%--
  Created by IntelliJ IDEA.
  User: ouyuan
  Date: 17-1-4
  Time: 下午6:25
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>商户申请指引</title>
    <meta name="description" content="">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="${resource(dir:'css/guide',file:'guide.css')}" media="all" />
    <!--[if lt IE9]>
    <script>
       (function() {
         if (!
         /*@cc_on!@*/
         0) return;
         var e = "abbr, article, aside, audio, canvas, datalist, details, dialog, eventsource, figure, footer, header, hgroup, mark, menu, meter, nav, output, progress, section, time, video".split(', ');
         var i= e.length;
         while (i--){
             document.createElement(e[i])
         }
    })()
    </script>
    <![endif]-->
</head>
<body>
    <div class="guide-container">
        <!-- 类型标题 -->
        <section class="guide-tit">
            <span>商户申请指引</span>
            <span>|</span>
            <span class="tips-span">请选择商户类型</span>
        </section>
        <!-- 商户类型 -->
        <section class="guide-mode">
            <ul>
                <li class="general-business link-box">
                    <a href="${createLink(controller: 'merGuide',action: 'guide')}" class="guide-link general-link">
                        <div class="icon-box"></div>
                        <span>普通在线商户</span>
                    </a>
                </li>
                <li class="bulk-business link-box">
                    <a href="${createLink(controller: 'merGuide',action: 'bulk')}" class="guide-link bulk-link">
                        <div class="icon-box"></div>
                        <span>大宗在线商户</span>
                    </a>
                </li>
                <li class="person-business link-box">
                    <a href="javascript:;" class="guide-link person-link">
                        <div class="icon-box"></div>
                        <span>个人商户</span>
                    </a>
                </li>
            </ul>
        </section>
    </div>
</body>
</html>