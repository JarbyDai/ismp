<%@ page import="gateway.GwOrder" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-交易详情</title>
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
                    <b>交易详细信息</b>
                </th>
            </tr>
            <tr><td class="txtRight" scope="col" width="100">交易号：</td><td class="txtLeft" scope="col">${trade?.tradeNo}</td></tr>
            <tr><td class="txtRight" scope="col">交易类型：</td><td class="txtLeft" scope="col">${trade?.tradeTypeMap[trade?.tradeType]}</td></tr>
            <tr><td class="txtRight" scope="col">时间：</td><td class="txtLeft" scope="col">${trade.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td></tr>
            <g:if test="${trade.tradeType != 'withdrawn'}">
            <tr><td class="txtRight" scope="col">付款方：</td><td class="txtLeft" scope="col">${trade?.payerName}</td></tr>
            <tr><td class="txtRight" scope="col">收款方：</td><td class="txtLeft" scope="col">${trade?.payeeName}</td></tr>
            </g:if>
            <tr><td class="txtRight" scope="col">交易金额：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${trade?.amount/100}" type="currency"/></td></tr>
            <tr><td class="txtRight" scope="col">交易状态：</td><td class="txtLeft" scope="col">${ismp.TradeBase.statusMap[trade.status]}</td></tr>
            <g:if test="${trade.tradeType=='refund'}">
                <tr><td class="txtRight" scope="col">退款申请备注：</td><td class="txtLeft" scope="col">${trade?.refundApply}</td></tr>
                <tr><td class="txtRight" scope="col">退款备注：</td><td class="txtLeft" scope="col">${trade?.note == 'null' ? '' : trade.note}</td></tr>
            </g:if>
            <g:else>
                <tr><td class="txtRight" scope="col">提现失败原因：</td>
                <!-- 判断提现失败的原因，如果是失败或者关闭显示提现失败的原因 -->
                    <g:if test="${trade.status=='closed'}">
                        <td class="txtLeft" scope="col"> ${trade?.note == 'null' ? '' : trade.note}</td>
                    </g:if>
                    <g:if test="${trade.status=='starting' ||  'completed' || 'processing'}">
                        <td class="txtLeft" scope="col"></td>
                    </g:if>


                </tr>
            </g:else>
            <g:if test="${trade.tradeType=='payment'}">
                <tr><td class="txtRight" scope="col">商品名称：</td><td class="txtLeft" scope="col">${trade?.subject}</td></tr>
                <tr><td class="txtRight" scope="col">买家真实姓名：</td><td class="txtLeft" scope="col">${GwOrder.findById(trade.tradeNo)?.buyerRealname}</td></tr>
                <tr><td class="txtRight" scope="col">商品描述：</td><td class="txtLeft" scope="col">${GwOrder.get(trade.tradeNo)?.body}</td></tr>
            </g:if>
            <g:if test="${trade.tradeType=='transfer'}">
                <tr><td class="txtRight" scope="col">付款理由：</td><td class="txtLeft" scope="col">${trade?.subject}</td></tr>
                <tr><td class="txtRight" scope="col">提交方式：</td><td class="txtLeft" scope="col">${trade.submitTypeMap[trade.submitType]}</td></tr>
                <tr><td class="txtRight" scope="col">操作员：</td><td class="txtLeft" scope="col">${trade.submitter}</td></tr>
            </g:if>
            <g:if test="${trade.tradeType=='withdrawn'}">
                <tr><td class="txtRight" scope="col">提现银行：</td><td class="txtLeft" scope="col">${boss.BoBankDic.findByCode(trade?.customerBankCode)?.name}</td></tr>
                %{--<tr><td class="txtRight" scope="col">银行帐户名：</td><td class="txtLeft" scope="col">${trade?.customerBankAccountName}</td></tr>--}%
                <tr><td class="txtRight" scope="col">银行账号：</td><td class="txtLeft" scope="col">${trade?.customerBankAccountNo}</td></tr>
                %{--<tr><td class="txtRight" scope="col">转账手续费：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${trade?.transferFee/100}" type="currency"/></td></tr>--}%
                %{--<tr><td class="txtRight" scope="col">实转金额：</td><td class="txtLeft" scope="col"><g:formatNumber currencyCode="CNY" number="${trade?.realTransferAmount/100}" type="currency"/></td></tr>--}%
                %{--<tr><td class="txtRight" scope="col">处理状态：</td><td class="txtLeft" scope="col">${trade?.handleStatusMap[trade.handleStatus]}</td></tr>--}%
            </g:if>
        <tr>
            <td colspan="2" align="center">
                <input type="button" id="back" name="back" class="btn mglf10" value="返回" onClick="javascript:history.go(-1);"/>
            </td>
        </tr>
        </table>
    </div>
</body>
</html>
