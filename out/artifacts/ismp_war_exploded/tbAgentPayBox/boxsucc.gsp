<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-store"/>
    <meta http-equiv="expires" content="0"/>
    <title>合利宝-信息提示</title>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
</head>
<body>

    <div class="main_box">
        <div class="tipsico">
            <g:if test="${type=='ok'}"><img src="${resource(dir:'images/info',file:'Gnome.png')}" width="64" height="64" /></g:if>
            <g:elseif test="${type=='warn'}"><img src="${resource(dir:'images/info',file:'Emblem.png')}" width="64" height="64" /></g:elseif>
            <g:else><img src="${resource(dir:'images/info',file:'error.png')}" width="64" height="64" /></g:else>
        </div>
        <div class="tipstxt">
            <p>
                <b style="color:red; font-size:24px;"><g:if test="${type=='error'}">错误</g:if><g:else>操作成功</g:else></b>
            </p>
            <p>
                <g:if test="${msg}">${msg}</g:if>
                <g:elseif test="${succcount}">
                    <g:if test="${succcount}">批次提交成功,共<font color="green">${succcount}</font>笔</g:if>
                </g:elseif>
                <g:else>
                    您要访问的页面不存在，请检查您输入的网址。
                </g:else>
            </p>
        </div>
    </div>
</body>
</html>
