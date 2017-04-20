<%@ page import="ismp.UserWalletTrade; ismp.UserOrder;  ismp.TradeRefund; ismp.TradePayment; ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-钱包消费</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-1.8.2.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-1.9.0.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-timepicker-addon-chn.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>

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
<div class="trnmenu"> <span class="left trnmenutlt">钱包交易：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">消费交易</li>
    </ul>
  </div>
</div>
<form action="walletConsume" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div id="walletConsumeMsg">
        <g:if test="${errmsg}">
            <div id="walletConsumetMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <table class="serchtlb">
          <tr>
            <td colspan="3" scope="col">&nbsp;&nbsp;开始日期:
                <g:textField name="startDate" value="${params.startDate}" readonly="readonly"/>
            </td>
            <td colspan="3" scope="col">&nbsp;&nbsp;结束日期:
                <g:textField name="endDate" value="${params.endDate}" readonly="readonly"/>
            </td>
            <td colspan="5" scope="col">&nbsp;&nbsp;商户订单号:
              <input name="outTradeNo" type="text" id="outTradeNo" value="${params.outTradeNo}" maxlength="80"/>
                &nbsp;&nbsp;<input type="submit" class="serchbtn" value="搜索" />
                &nbsp;&nbsp;<input type="button" class="serchbtn" value="清空" onclick="toEmpty()" />
            </td>

          </tr>
          <tr>
            <td colspan="3" scope="col">&nbsp;&nbsp;平台交易号:
                <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="40"/>
            </td>
            <td scope="col" colspan="3">&nbsp;&nbsp;交易类型:
              <g:select name="tradeType" value="${params.tradeType}" from="${['mobileRecharge': '手机充值','ewalletPay':'支付','refundReq':'退款申请','refundTrans':'退款']}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
            </td>
              <td scope="col" colspan="5">&nbsp;&nbsp;金额区间:
                  <input type="text" name="amountMin" id="amountMin" maxlength="10" value="${params.amountMin}"/>
                  -<input type="text" name="amountMax" id="amountMax" maxlength="10" value="${params.amountMax}"/>元
              </td>
          </tr>
      </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">类型</th>
            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">平台交易号</th>
            <th class="txtCenter" scope="col">交易对方</th>
            <th class="txtCenter" scope="col">金额（元）</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">已退款金额(元)</th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">

                <tr>
                    <td class="txtCenter" scope="col">${ismp.UserWalletTrade.tradeMap[trade.tradeType]}</td>
                    <td scope="col" class="blue">${trade.reqDate.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${trade.orderId}</td>
                    <td class="txtCenter" scope="col">${trade.transNo}</td>
                    <td class="txtCenter" scope="col">${trade.targetName}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.amount/100}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${UserWalletTrade.statusMap[trade.status]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:if test="${UserOrder.findByOrderId(trade.orderId)?.refundedAmount>0}"><g:formatNumber currencyCode="CNY" number="${UserOrder.findByOrderId(trade.orderId)?.refundedAmount/100}" type="currency"/></g:if></strong></td>
                </tr>
            </g:each>
        </table>
        <div class="page">
            <g:if test="${tradeListTotal>0}">
                <div class="elxdwn blue"><a href="#" class="download-excel">下载统计结果</a></div>
            </g:if>
          <g:pageNavi total="${tradeListTotal}"/>
          </div>
    </div>
</form>

<script type="text/javascript">

    $(function() {
        var dates = new Date();
        var dateConfig ={
            showSecond: true,
            timeFormat: 'hh:mm:ss',
        }
        $('#startDate, #endDate').datetimepicker(dateConfig);
    });

    function toEmpty(){
        $("#outTradeNo").val("");
        $("#tradeType").val("");
        $("#tradeNo").val("");
        $("#amountMin").val("");
        $("#amountMax").val("");
    }
    $(document).ready(function() {

        jQuery.validator.addMethod("money", function(a, b) {
            return this.optional(b) || /^\d+(\.\d{0,2})?$/i.test(a)
        }, "Please enter a valid amount.");
        jQuery.validator.addMethod("ge", function(value, element, param) {
            var target = $(param).unbind(".validate-equalTo").bind("blur.validate-equalTo", function() {
                $(element).valid();
            });
            if (target.val() == "" || value == "") return true;
            else return parseFloat(value) >= parseFloat(target.val());
        }, "Please enter a valid value.");
        jQuery.validator.addMethod("compareDate", function(value, element, param) {
            var startDate = jQuery(param).val();
            if (startDate == "" || value == "") {
                return true;
            } else {
                var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
                var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
                return date1 <= date2;
            }
        }, "Please enter a valid value.");
        jQuery.validator.addMethod("rangeDate", function(value, element, param) {
            var startDate = jQuery(param).val();
            if (startDate == "" || value == "") {
                return true;
            } else {
                var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
                var date3 = date1.setMonth(date1.getMonth() + 3);
                var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
                return (date2 - date3) <= 0;
            }
        }, "Please enter 90 days range value.");
        $("#searchform").validate({
            rules: {
                amountMin:{money:true,range:[0.00,100000000]},
                amountMax:{money:true,range:[0.00,100000000],ge:"#amountMin"},
                endDate:{compareDate:"#startDate",rangeDate:"#startDate"}
            },
            messages: {
                amountMin:{money:"无效金额",range:"无效金额范围"},
                amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
//                startDate:{dateISO:"无效时间格式"},
                endDate:{compareDate:"结束日期必须大于开始日期",rangeDate:"日期范围必须3个月内"}
            }
        });


        //----------下载部分处理-------
        E.on(D.query(".download-exc"), "click", function(e) {
            download("csv");
            E.preventDefault(e);
        });
        E.on(D.query(".download-txt"), "click", function(e) {
            download("txt");
            E.preventDefault(e);
        });
        E.on(D.query(".download-excel"), "click", function(e) {
            download("excel");
            E.preventDefault(e);
        });
        function download(type) {
            var f = D.get("searchform");
            f.action = f.action + "?format=" + type;
            f.submit();
            f.action = "walletConsume";
            f.method = "post";
        }

        ;
    });
    var j = 0;
    function refund(i) {
        if (j != 0 && j != i) {
            document.getElementById(j).style.display = 'none';
        }
        document.getElementById(i).style.display = '';
        j = i;
    }

    function closes(i) {
        document.getElementById(i).style.display = 'none';
    }
</script>
</body>
</html>
