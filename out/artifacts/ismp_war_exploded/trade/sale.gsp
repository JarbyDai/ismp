<%@ page import=" ismp.TradeRefund; ismp.TradePayment; ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-付款交易</title>
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
<div class="trnmenu"> <span class="left trnmenutlt">交易管理：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">收款交易</li>
        <g:if test="${session.level3Map != null && session.level3Map['trade/buy'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['trade/buy'].modelPath}">付款交易</a>
            </li>
        </g:if>

        <g:if test="${session.level3Map != null && session.level3Map['trade/refund'] != null}">
            <li>
                <a href="${request.contextPath}/${session.level3Map['trade/refund'].modelPath}">退款交易</a>
            </li>
        </g:if>
    </ul>
  </div>
</div>
<form action="sale" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div id="saleMsg">
        <g:if test="${errmsg}">
            <div id="saltMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div id="saletMsg">
        <g:if test="${lastErrMsg}">
            <div id="lastMsg" class="serch"><P>${lastErrMsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
          <tr>
            <td width="820" scope="col">&nbsp;&nbsp;交易创建日期
                <g:textField name="startDate" value="${params.startDate}" readonly="readonly"/>
                 &nbsp;&nbsp;到&nbsp;&nbsp;
                <g:textField name="endDate" value="${params.endDate}" readonly="readonly"/>
                 平台交易号:<input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="40"/>
                银行订单号:<input name="outTradeNo1" type="text" id="outTradeNo1" value="${params.outTradeNo1}" maxlength="80"/>
            </td>
         </tr>
          <tr>
              <td width="820" scope="col">&nbsp;&nbsp;交易完成日期
                  <g:textField name="lastStartDate" value="${params.lastStartDate}" readonly="readonly"/>
                   &nbsp;&nbsp;到&nbsp;&nbsp;
                  <g:textField name="lastEndDate" value="${params.lastEndDate}" readonly="readonly"/>
                  交易对方: <input name="to" type="text" id="tradeOpp" value="${params.to}" maxlength="80"/>
                  商品名称:<input name="subject" type="text" id="subject" value="${params.subject}" maxlength="80"/>
              </td>
          </tr>
          <tr>
                <td width="820" scope="col">
                    &nbsp;&nbsp;第三方支付号：&nbsp;&nbsp;<input name="outTransactionId" type="text" id="outTransactionId" value="${params.outTransactionId}" maxlength="80"/>
                    &nbsp;&nbsp;商户订单号：&nbsp;&nbsp;<input name="outTradeNo" type="text" id="outTradeNo" value="${params.outTradeNo}" maxlength="80"/>
                    金额区间:
                    <input type="text" name="amountMin" id="amountMin" maxlength="10" value="${params.amountMin}"/>
                    -<input type="text" name="amountMax" id="amountMax" maxlength="10" value="${params.amountMax}"/>元
                </td>
          </tr>
          <tr>
              <td  width="820" scope="col">支付方式:
                <g:select name="paymentType" value="${params.paymentType}" from="${ismp.TradeBase.paymentTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
                服务类型:
                <g:select name="serviceType" value="${params.serviceType}" from="${ismp.TradeBase.serviceTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
                交易状态:
                <g:select name="status" value="${params.status}" from="${TradeBase.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
                交易类型：&nbsp;&nbsp;<g:select name="tradeType" value="${params.tradeType}" from="${ismp.TradeBase.tradeTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
                <input type="submit" class="serchbtn" value="搜索" />
                <input type="button" onclick="clearContents()" class="serchbtn" value="清除" />
             </td>
          </tr>
        </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">交易类型</th>
            <th class="txtCenter" scope="col">创建时间</th>
              <th class="txtCenter" scope="col">支付方式</th>
              <th class="txtCenter" scope="col">服务类型</th>
            <th class="txtCenter" scope="col">商品名称</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">银行订单号</th>
            <th class="txtCenter" scope="col">平台交易号</th>
            <th class="txtCenter" scope="col">第三方支付单号</th>
            <th class="txtCenter" scope="col">交易对方</th>
            <th class="txtCenter" scope="col">金额（元）</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">已退款金额(元)</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr>
                    <td class="txtCenter" scope="col">${TradeBase.tradeTypeMap[trade.TRADE_TYPE]}</td>
                    <td scope="col" class="blue">${trade.DATE_CREATED?.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${TradeBase.paymentTypeMap[trade.PAYMENT_TYPE]}</td>
                    <td class="txtCenter" scope="col">${TradeBase.serviceTypeMap[trade.SERVICE_TYPE]}</td>
                    <td class="txtCenter" scope="col">${trade.SUBJECT}</td>
                    <td class="txtCenter" scope="col">${trade.OUT_TRADE_NO}</td>
                    <td class="txtCenter" scope="col">${trade.B_OUT_TRADE_NO}</td>
                    <td class="txtCenter" scope="col">${trade.TRADE_NO}</td>
                    <td class="txtCenter" scope="col">${trade.OUT_TRANSACTION_ID}</td>
                    <td class="txtCenter" scope="col">${trade.PAYER_NAME == '访客公用账户' ? '' : trade.PAYER_NAME}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.AMOUNT ? trade.AMOUNT/100 : 0}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${TradeBase.statusMap[trade.STATUS]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:if test="${trade.REFUND_AMOUNT && trade.REFUND_AMOUNT>0}"><g:formatNumber currencyCode="CNY" number="${trade.REFUND_AMOUNT/100}" type="currency"/></g:if></strong></td>
                    <td class="txtCenter" scope="col">
                    <g:if test="${session.level3Map != null && session.level3Map['trade/detail'] != null}">
                        <a href="${request.contextPath}/${session.level3Map['trade/detail'].modelPath}/${trade.ID}" style="color:blue">详细</a>
                    </g:if>

                    <g:if test="${trade.TRADE_TYPE == 'payment' && trade.STATUS == 'completed' && trade.AMOUNT > trade.REFUND_AMOUNT}">
                        <g:if test="${session.level3Map != null && session.level3Map['refund/index'] != null}">
                            <g:if test="${session.level3Map != null && session.level3Map['trade/detail'] != null}">|</g:if>
                            <a href="${request.contextPath}/${session.level3Map['refund/index'].modelPath}/${trade.ID}" style="color:blue">退款申请</a>
                        </g:if>
                    </g:if>

                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
            <g:if test="${tradeListTotal>0}">
                <div class="elxdwn blue"><a href="#" class="download-excel">下载统计结果</a></div>
            </g:if>
            <g:if test="${totalamount}">
                <div class="total_num" style="width:auto; height:31px; line-height:31px; text-align:left; float:left; margin-left:10px; background-position:-130px 10px; padding-left:20px; ">总金额：${totalamount/100}</div>
            </g:if>
          <g:pageNavi total="${tradeListTotal}"/>
          </div>
    </div>
</form>

<script type="text/javascript">
    function clearContents(){
        $(':input') .not(':button, :submit, :reset, :hidden')
                .val('')
                .removeAttr('checked')
                .removeAttr('selected');
        return false;
    }
    $(function() {
        var dateConfig ={
            showSecond: true,
            timeFormat: 'hh:mm:ss'
        }
        $('#startDate, #endDate, #lastStartDate,#lastEndDate').datetimepicker(dateConfig);
    });

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
        }, "日期输入非法!");
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
        }, "时间范围不能超过三个月！");
        $("#searchform").validate({
            rules: {
                amountMin:{money:true,range:[0.00,100000000]},
                amountMax:{money:true,range:[0.00,100000000],ge:"#amountMin"},
                endDate:{compareDate:"#startDate",rangeDate:"#startDate"},
                lastEndDate:{compareDate:"#lastStartDate",rangeDate:"#lastStartDate"}


            },
            messages: {
                amountMin:{money:"无效金额",range:"无效金额范围"},
                amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
                endDate:{compareDate:"结束日期必须大于开始日期",rangeDate:"交易创建日期时间范围必须3个月内"},
                lastEndDate:{compareDate:"结束日期必须大于开始日期",rangeDate:"交易完成日期时间范围必须3个月内"}
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
            f.action = "sale";
            f.method = "post";
        }

    });
</script>
</body>
</html>
