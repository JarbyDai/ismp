<%@ page import="ismp.RefundBatch; ismp.CmCustomerOperator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-退款拒绝交易详情</title>
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
                    <b>退款拒绝交易详情</b>
                </th>
            </tr>
            <tr><td class="txtRight" scope="col" width="100">平台交易号：</td><td class="txtLeft" scope="col">${trade?.tradeNo}</td></tr>
            <tr><td class="txtRight" scope="col">商户订单号：</td><td class="txtLeft" scope="col">${trade?.outTradeNo}</td></tr>
            <tr><td class="txtRight" scope="col">创建时间：</td><td class="txtLeft" scope="col">${trade.uploadTime.format("yyyy-MM-dd HH:mm:ss")}</td></tr>
            <tr><td class="txtRight" scope="col">审核时间：</td><td class="txtLeft" scope="col">${trade.authTime.format("yyyy-MM-dd HH:mm:ss")}</td></tr>
            <tr><td class="txtRight" scope="col">商户号：</td><td class="txtLeft" scope="col">${trade.customerNo}</td></tr>
            <%
               def co = CmCustomerOperator.findById(trade.operatorId)
            %>
            <tr><td class="txtRight" scope="col">审核人：</td><td class="txtLeft" scope="col">${co.name}</td></tr>
            <tr><td class="txtRight" scope="col">退款金额：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${trade?.amount/100}" type="currency"/></td></tr>
            <tr><td class="txtRight" scope="col">交易状态：</td><td class="txtLeft" scope="col">${ismp.TradeBase.statusMap[trade.status]}</td></tr>
            <tr><td class="txtRight" scope="col">退款申请备注：</td><td class="txtLeft" scope="col">${trade?.note=='null'?'':trade.note}</td></tr>
            <tr><td class="txtRight" scope="col">拒绝原因：</td><td class="txtLeft" scope="col">${trade?.refundRefuse=='null'?'':trade.refundRefuse}</td></tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="button" id="back" name="back" class="btn mglf10" value="返回" onClick="javascript:history.go(-1);"/>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
