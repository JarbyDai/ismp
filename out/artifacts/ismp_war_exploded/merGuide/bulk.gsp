<%--
  Created by IntelliJ IDEA.
  User: ouyuan
  Date: 16-12-28
  Time: 上午10:50
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
            <span class="tips-span">大宗在线商户</span>
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
        <div class="patten-container">
            <!-- 大宗在线商户 -->
            <section class="bulk-container section_box" id="bulk">
                <!-- 商户资料 -->
                <section class="business-material">
                    <header class="material-tit">
                        <h2>申请<span><a href="" class="color-red">大宗在线商户开服</a></span>需要准备哪些资料？</h2>
                    </header>
                <div class="material-list">
                    <ul>
                        <li><a href="#material-1" class="anchor"><span>1</span>企业提供基本资料 <span class="color-red">建议先提供电子版</span></a></li>
                        <li><a href="#material-2" class="anchor"><span>2</span>企业填写资料 <span class="color-red">建议先提供电子版</span></a></li>
                        <li><a href="#material-3" class="anchor"><span>3</span>协议及附件 <span class="color-red">建议先提供电子版</span></a></li>
                    </ul>
                </div>
                </section>
                <!--  1企业提供基本资料 -->
                <section class="material-table-box" id="material-1">
                    <div class="material-list">
                        <ul>
                            <li><span>1</span>企业提供基本资料</li>
                        </ul>
                    </div>
                    <div class="material-table">
                        <section class="table-head">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 28%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 10%;" />
                                    <col style="width: 15%;" />
                                    <col style="width: 8%;" />
                                    <col style="width: 27%;" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>序号</th>
                                    <th>文档名称</th>
                                    <th>份数</th>
                                    <th>是否必须提供</th>
                                    <th>盖章</th>
                                    <th>样本</th>
                                    <th>说明</th>
                                </tr>
                                </thead>
                            </table>
                        </section>
                        <!-- table header end/ -->
                        <!-- table body start -->
                        <section class="table-body">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 28%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 10%;" />
                                    <col style="width: 15%;" />
                                    <col style="width: 8%;" />
                                    <col style="width: 27%;" />
                                </colgroup>
                                <tbody id="bulk-basic-info">
                                </tbody>
                            </table>
                        </section>
                        <section class="remark-box">
                            <h3>备注：</h3>
                            <ul id="bulk-remark-1">
                            </ul>
                        </section>
                    </div>
                </section>
                <!--  2企业填写资料 -->
                <section class="material-table-box" id="material-2">
                    <div class="material-list">
                        <ul>
                            <li><!-- <span>2</span>企业填写资料 --></li>
                            <li><span>2</span>企业填写资料</li>
                        </ul>
                    </div>
                    <div class="material-table">
                        <section class="table-head">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 28%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 10%;" />
                                    <col style="width: 15%;" />
                                    <col style="width: 8%;" />
                                    <col style="width: 27%;" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>文档名称</th>
                                        <th>份数</th>
                                        <th>是否必须提供</th>
                                        <th>盖章</th>
                                        <th>样本</th>
                                        <th>说明</th>
                                    </tr>
                                </thead>
                            </table>
                        </section>
                        <!-- table header end/ -->
                        <!-- table body start -->
                        <section class="table-body">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 28%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 10%;" />
                                    <col style="width: 15%;" />
                                    <col style="width: 8%;" />
                                    <col style="width: 27%;" />
                                </colgroup>
                                <tbody id="bulk-input-info">
                                </tbody>
                            </table>
                        </section>
                        <section class="remark-box">
                            <h3>备注：</h3>
                            <ul id="bulk-remark-2">
                            </ul>
                        </section>
                    </div>
                </section>
                <!--  3协议及附件 -->
                <section class="material-table-box" id="material-3">
                    <div class="material-list">
                        <ul>
                            <li></li>
                            <li></li>
                            <li><span>3</span>协议及附件明细</li>
                        </ul>
                    </div>
                    <div class="material-table">
                        <section class="table-head">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 30%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 26%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 26%;" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>文档名称</th>
                                        <th>份数</th>
                                        <th>盖章</th>
                                        <th>样本</th>
                                        <th>说明</th>
                                    </tr>
                                </thead>
                            </table>
                        </section>
                        <!-- table header end/ -->
                        <!-- table body start -->
                        <section class="table-body">
                            <table>
                                <colgroup>
                                    <col style="width: 6%;" />
                                    <col style="width: 30%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 26%;" />
                                    <col style="width: 6%;" />
                                    <col style="width: 26%;" />
                                </colgroup>
                                <tbody id="bulk-annex-info">
                                </tbody>
                            </table>
                        </section>
                        <section class="remark-box">
                            <h3>备注：</h3>
                            <ul id="bulk-remark-3">
                            </ul>
                        </section>
                    </div>
                </section>
            </section>
        </div>
    </div>
    <script src="${resource(dir:'js/jquery',file:'jquery-1.8.2.js')}"></script>
    <script>
        var contextPath = '${request.contextPath}';
    </script>
    <script src="${resource(dir:'js/guide',file:'guide.js')}"></script>
</body>
</html>