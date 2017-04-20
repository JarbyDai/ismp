<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-服务详情</title>
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
                    <b>服务详细信息</b>
                </th>
            </tr>
            <tr><td class="txtRight" scope="col" width="100">合同号：</td><td class="txtLeft" scope="col">${service?.contractNo}</td></tr>
            <tr><td class="txtRight" scope="col">服务类型：</td><td class="txtLeft" scope="col">${service?.serviceMap[service.serviceCode]}</td></tr>
            <tr><td class="txtRight" scope="col">生效时间：</td><td class="txtLeft" scope="col">${service.startTime?.format('yyyy-MM-dd HH:mm:ss')}</td></tr>
            <tr><td class="txtRight" scope="col">到期时间：</td><td class="txtLeft" scope="col">${service.endTime?.format('yyyy-MM-dd HH:mm:ss')}</td></tr>
            <tr><td class="txtRight" scope="col">服务状态：</td><td class="txtLeft" scope="col">${service.enable == true ? "有效" : "过期"}</td></tr>
            <g:if test="${service?.serviceCode=='agentpay'}">

                <g:if test="${service?.singleChannel=='open'}">
                    <tr><td class="txtRight" scope="col">单笔对公手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.singlePubFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                    <tr><td class="txtRight" scope="col">单笔对私手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.singlePriFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                </g:if>

                <g:if test="${service?.batchChannel=='open'}">
                    <tr><td class="txtRight" scope="col">批量对私手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.batchPriFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                    <tr><td class="txtRight" scope="col">批量对公手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.batchPubFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                </g:if>

                <g:if test="${service?.interfaceChannel=='open'}">
                    <tr><td class="txtRight" scope="col">接口对私手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.interfacePriFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                    <tr><td class="txtRight" scope="col">接口对公手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.interfacePubFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                </g:if>

                <tr><td class="txtRight" scope="col">单笔限额 对公：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.pubLimitMoney}" type="currency" currencyCode="CNY"/></td></tr>
                <tr><td class="txtRight" scope="col">单笔限额 对私：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.priLimitMoney}" type="currency" currencyCode="CNY"/></td></tr>
                <tr><td class="txtRight" scope="col">日限额（笔数）：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.dayLimitTrans}"/></td></tr>
                <tr><td class="txtRight" scope="col">日限额（金额）：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.dayLimitMoney}" type="currency" currencyCode="CNY"/></td></tr>
                <tr><td class="txtRight" scope="col">月限额（笔数）：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.monthLimitTrans}"/></td></tr>
                <tr><td class="txtRight" scope="col">月限额（金额）：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.monthLimitMoney}" type="currency" currencyCode="CNY"/></td></tr>
            </g:if>

            <g:elseif test="${service?.serviceCode=='agentcoll'}">
                <tr><td class="txtRight" scope="col">对公手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.procedureFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                <tr><td class="txtRight" scope="col">对私手续费：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.perprocedureFee}" type="currency" currencyCode="CNY"/>/笔</td></tr>
                <tr><td class="txtRight" scope="col">单笔限额：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.limitMoney}" type="currency" currencyCode="CNY"/></td></tr>
                <tr><td class="txtRight" scope="col">当日限笔：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.dayLimitTrans}"/></td></tr>
                <tr><td class="txtRight" scope="col">当日限额：</td><td class="txtLeft" scope="col"><g:formatNumber number="${service?.dayLimitMoney}" type="currency" currencyCode="CNY"/></td></tr>
            </g:elseif>
            <g:else>
            %{--<tr>--}%
                %{--<td class="txtRight" scope="col">手续费：</td>--}%
                %{--<g:if test="${service.feeParams!=null}">--}%
                    %{--<td class="txtLeft" scope="col">${service?.feeParams}%</td>--}%
                %{--</g:if>--}%
                %{--<g:else>--}%
                   %{--<td class="txtLeft" scope="col">--}%
                %{--</g:else>--}%
            %{--</tr>--}%
            <tr><td class="txtRight" scope="col">服务参数：</td><td class="txtLeft" scope="col">${service?.serviceParams}</td></tr>
            </g:else>
        </table>
    </div>
</body>
</html>
