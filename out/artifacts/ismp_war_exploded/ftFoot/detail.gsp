<%@ page import="ismp.TradeBase; settle.FtSrvTradeType" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-结算查询</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>

    <script type="text/javascript">
        function search(obj) {
            if (obj) {
                if ($("offset"))
                    $("offset").value = 0;
            }
            $("#searchform").submit();
        }
    </script>
</head>
<body>
    <div class="trnmenu">
        <span class="left trnmenutlt">结算信息</span>
    </div>
    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">订单支付日期范围</th>
            <th class="txtCenter" scope="col">结算日期</th>
            <th class="txtCenter" scope="col">订单笔数</th>
            <th class="txtCenter" scope="col">订单金额（元）</th>
            <th class="txtCenter" scope="col">退款金额（元）</th>
            <th class="txtCenter" scope="col">订单净额（元）</th>
            <th class="txtCenter" scope="col">手续费金额（元）</th>
            <th class="txtCenter" scope="col">结算金额（元）</th>
          </tr>
          <tr>
            <td scope="col" class="blue">${a1}-${a2}</td>
            <td scope="col" class="blue">${b}</td>
            <td class="txtCenter" scope="col">${c}</td>
            <td class="txtCenter" scope="col">${d}</td>
            <td class="txtCenter" scope="col">${e}</td>
            <td class="txtCenter" scope="col">${f}</td>
            <td class="txtCenter" scope="col"><strong style="color:green">${g}</strong></td>
            <td class="txtCenter" scope="col"><strong style="color:red">${h}</strong></td>
          </tr>
        </table>
        <div class="trnmenu">
            <span class="left trnmenutlt">结算明细</span>
        </div>
        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">序号</th>
            <th class="txtCenter" scope="col">流水号</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">支付时间</th>
            <th class="txtCenter" scope="col">交易类型</th>
            <th class="txtCenter" scope="col">交易金额（元）</th>
            <th class="txtCenter" scope="col">手续费金额（元）</th>
          </tr>
            <g:each in="${result}" status="i" var="trade">
                <tr>
                    <td class="txtCenter" scope="col">${i + 1}</td>
                    <td class="txtCenter" scope="col">${trade.SEQ_NO}</td>
                    <td class="txtCenter" scope="col">${TradeBase.findByTradeNo(trade.SEQ_NO)?.outTradeNo}</td>
                    <td scope="col" class="blue"><g:formatDate format="yyyy.MM.dd HH:mm:ss" date="${trade.BILL_DATE}"/></td>
                    <td class="txtCenter" scope="col">${FtSrvTradeType.findByTradeCode(trade.TRADE_CODE)?.tradeName}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red">${Math.abs(trade.AMOUNT).toBigDecimal().divide(100,2,0).toPlainString()}</strong></td>
                    <td class="txtCenter" scope="col">
                        <strong style="color:green">
                            <g:if test="${trade.POST_FEE}">${Math.abs(trade.POST_FEE).toBigDecimal().divide(100,2,0).toPlainString()}</g:if>
                            <g:elseif test="${trade.PRE_FEE}">${Math.abs(trade.PRE_FEE).toBigDecimal().divide(100,2,0).toPlainString()}</g:elseif>
                        </strong>
                    </td>
                </tr>
            </g:each>
        </table>
        <g:form controller="ftFoot" action="detail" method="post" name="searchform">
            <g:hiddenField name="pay_no" value="${pay_no}"/>
            <g:hiddenField name="ref_no" value="${ref_no}"/>
            <g:hiddenField name="a1" value="${a1}"/>
            <g:hiddenField name="a2" value="${a2}"/>
            <g:hiddenField name="b" value="${b}"/>
            <g:hiddenField name="c" value="${c}"/>
            <g:hiddenField name="d" value="${d}"/>
            <g:hiddenField name="e" value="${e}"/>
            <g:hiddenField name="f" value="${f}"/>
            <g:hiddenField name="g" value="${g}"/>
            <g:hiddenField name="h" value="${h}"/>

            <div class="page">
              <g:pageNavi total="${total}"/>
            </div>
        </g:form>
         <table class="tlb1">
          <tr>
            <td scope="col" class="txtCenter">
                <input type="button" class="btn mglf10" value="返回" onclick="javascript:history.back()"/>
            </td>
          </tr>
        </table>
    </div>
</body>
</html>