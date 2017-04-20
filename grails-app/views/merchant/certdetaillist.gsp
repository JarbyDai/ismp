<%@ page import="ismp.Merchant" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-接口证书详细信息</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>

<div class="serchlitst">
    <table class="tlb1">
        <tr>
            <th class="txtLeft" scope="col" colspan="2">
                <b>证书信息</b>
            </th>
        </tr>
        <tr><td class="txtRight" scope="col" width="150">证书DN：</td><td class="txtLeft" scope="col" width="800">${certMessage.subject}</td></tr>
        <tr><td class="txtRight" scope="col">证书序列号：</td><td class="txtLeft" scope="col">${certMessage.serialNumber}</td></tr>
        <tr><td class="txtRight" scope="col">申请时间：</td><td class="txtLeft" scope="col"><g:formatDate date="${certMessage.createTime}" format="yyyy-MM-dd HH:mm:ss" /></td></tr>
        <tr><td class="txtRight" scope="col">证书有效期：</td><td class="txtLeft" scope="col"><g:formatDate date="${certMessage.applyTime}" format="yyyy/ MM/ dd"/> 到 <g:formatDate date="${certMessage.expiredTime}" format="yyyy/ MM/ dd"/></td></tr>
        <tr><td class="txtRight" scope="col">是否可用：</td><td class="txtLeft" scope="col">${Merchant.availableMap[certMessage.available]}</td></tr>
        <tr><td class="txtRight" scope="col">商户号：</td><td class="txtLeft" scope="col">${customerNo}</td></tr>
        <tr><td class="txtRight" scope="col">申请人：</td><td class="txtLeft" scope="col">${certMessage.operator}</td></tr>
    </table>
</div>

</body>
</html>