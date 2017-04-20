<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <g:if test="${flag==1}">
        <title>合利宝-分润详情</title>
    </g:if>
    <g:else>
        <title>合利宝-账务详情</title>
    </g:else>
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
                    <g:if test="${flag==1}">
                        <b>分润详细信息</b>
                    </g:if>
                    <g:else>
                        <b>账务详细信息</b>
                    </g:else>
                </th>
            </tr>

            <tr><td class="txtRight" scope="col" width="100">流水号：</td><td class="txtLeft" scope="col">${acSeq.transaction.tradeNo}</td></tr>
            <tr><td class="txtRight" scope="col">交易类型：</td><td class="txtLeft" scope="col">${acSeq.transaction.transTypeMap[acSeq.transaction.transferType]}</td></tr>
            <tr><td class="txtRight" scope="col">时间：</td><td class="txtLeft" scope="col">${acSeq.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td></tr>
            <tr><td class="txtRight" scope="col">收入（元）：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${acSeq.debitAmount/100}" type="currency"/></td></tr>
            <tr><td class="txtRight" scope="col">支出（元）：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${acSeq.creditAmount/100}" type="currency"/></td></tr>
            <tr><td class="txtRight" scope="col">账户余额（元）：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${acSeq.balance/100}" type="currency"/></td></tr>
            <tr><td class="txtRight" scope="col">摘要：</td><td class="txtLeft" scope="col">${acSeq.transaction.subjict == 'null' ? '' : acSeq.transaction.subjict?.encodeAsHTML()}</td></tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="button" id="back" name="back" class="btn mglf10" value="返回" onClick="javascript:history.go(-1);"/>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
