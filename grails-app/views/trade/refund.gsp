<%@ page import="ismp.RefundBatch; ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-退款交易</title>
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
<div class="trnmenu"> <span class="left trnmenutlt">交易管理：</span>
  <div class="rtnms">
    <ul>
        <g:if test="${session.level3Map != null && session.level3Map['trade/sale'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['trade/sale'].modelPath}">付款交易</a>
            </li>
        </g:if>
        <g:if test="${session.level3Map != null && session.level3Map['trade/buy'] != null}">
            <li>
                <a href="${request.contextPath}/${session.level3Map['trade/buy'].modelPath}">收款交易</a>
            </li>
        </g:if>
        <li class="rtncnt blue">退款交易</li>
    </ul>
  </div>
</div>
<form action="refund" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div id="refundMsg">
        <g:if test="${errmsg}">
            <div id="refundyMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
          <tr>
            <td width="252" scope="col">&nbsp;&nbsp;开始日期:
                <g:textField name="startDate" value="${params.startDate}" readonly="readonly" size="8"/>
            </td>
            <td width="252" scope="col">
                &nbsp;&nbsp;结束日期:
                <g:textField name="endDate" value="${params.endDate}" readonly="readonly" size="8"/>
            </td>
            <td width="252" scope="col">商户订单号:
              <input name="orderTradeNo" type="text" id="orderTradeNo" value="${params.orderTradeNo}" maxlength="80"/>
            </td>
            <td scope="col">
                <input type="submit" class="serchbtn" value="搜索" />
                <input type="button" onclick="clearContents()" class="serchbtn" value="清除" />
            </td>
          </tr>
      </table>
      <table class="serchtlb"  id="serchmore">
          <tr>
            <td scope="col" width="252"> 平台交易号:
                <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="40"/>
            </td>
            <td scope="col" width="252">&nbsp;&nbsp;交易对方:
              <input name="to" type="text" id="tradeOpp" value="${params.to}" maxlength="80"/>
            </td>
            <td scope="col" colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;状态:
              <g:select name="status" value="${params.status}" from="${ismp.TradeBase.statusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
            </td>
          </tr>
          <tr>
            <td scope="col">银行订单号:
              <input name="outTradeNo1" type="text" id="outTradeNo1" value="${params.outTradeNo1}" maxlength="80"/>
            </td>
            <td scope="col">退款订单号:
              <input name="outTradeNo" type="text" id="outTradeNo" value="${params.outTradeNo}" maxlength="80"/>
            </td>
            <td scope="col" colspan="3">退款批次号:
              <input name="batch" type="text" id="batch" value="${params.batch}" maxlength="80"/>
            </td>
          </tr>
          <tr>
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
            <th class="txtCenter" scope="col">退款订单号</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">银行订单号</th>
            <th class="txtCenter" scope="col">平台交易号</th>
            <th class="txtCenter" scope="col">交易对方</th>
            <th class="txtCenter" scope="col">金额（元）</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">退款批次号</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr>
                    <td class="txtCenter" scope="col">${trade.tradeTypeMap[trade.tradeType]}</td>
                    <td scope="col" class="blue">${trade.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${trade.outTradeNo}</td>
                    <td class="txtCenter" scope="col">${TradeBase.findByRootIdAndTradeType(trade.rootId, 'payment')?.outTradeNo}</td>
                    <td class="txtCenter" scope="col">${TradeBase.findByRootIdAndTradeType(trade.rootId, 'charge')?.outTradeNo}</td>
                    <td class="txtCenter" scope="col">${trade.tradeNo}</td>
                    <td class="txtCenter" scope="col"><g:if test="${trade.tradeType=='royalty_rfd'}">${trade.payerName}</g:if><g:else>${trade.payerName=='访客公用账户'?'':trade.payeeName}</g:else></td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.amount/100}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${ismp.TradeBase.statusMap[trade.status]}</td>
                    <td class="txtCenter" scope="col">${trade.refundBatch?(RefundBatch.findById(trade.refundBatch)?.BatchNo):''}</td>
                    <td class="txtCenter" scope="col">
                       <g:if test="${session.level3Map != null && session.level3Map['trade/refundDetail'] != null}">
                            <a href="${request.contextPath}/${session.level3Map['trade/refundDetail'].modelPath}/${trade.id}" style="color:blue">详细</a>
                       </g:if>
                    </td>
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

    function clearContents(){
        $("#tradeNo").val("");
        $("#status").val("");
        $("#tradeOpp").val("");
        $("#outTradeNo1").val("");
        $("#outTradeNo").val("");
        $("#batch").val("");
        $("#amountMin").val("");
        $("#amountMax").val("");
    }
    $(function() {

        var dateConfig ={
            dateFormat: 'yy-mm-dd',
            changeYear: true,
            changeMonth: true
        }
        $('#startDate, #endDate').datepicker(dateConfig);

//        $("#tradeNo").val("");
//        $("#status").val("");
//        $("#tradeOpp").val("");
//        $("#outTradeNo1").val("");
//        $("#outTradeNo").val("");
//        $("#batch").val("");
//        $("#amountMin").val("");
//        $("#amountMax").val("");
    });

    $(document).ready(function() {

      $("#serch").click(function(){

//        $("#tradeNo").val("");
//        $("#status").val("");
//        $("#tradeOpp").val("");
//        $("#outTradeNo1").val("");
//        $("#outTradeNo").val("");
//        $("#batch").val("");
//        $("#amountMin").val("");
//        $("#amountMax").val("");
      });

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
				if(startDate==""||value=="")
				{
					return true;
				}else{
					var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
                    var date3  =date1.setMonth(date1.getMonth()+3);
					var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
					return (date2-date3)<= 0;
				}
	    }, "Please enter 90 days range value.");
        $("#searchform").validate({
            rules: {
                amountMin:{money:true,range:[0.01,100000000]},
                amountMax:{money:true,range:[0.01,100000000],ge:"#amountMin"},
                startDate:{dateISO:true},
                endDate:{dateISO:true,compareDate:"#startDate",rangeDate:"#startDate"}
            },
            messages: {
                amountMin:{money:"无效金额",range:"无效金额范围"},
                amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
                startDate:{dateISO:"无效时间格式"},
                endDate:{dateISO:"无效时间格式",compareDate:"结束日期必须大于开始日期",rangeDate:"日期范围必须3个月内"}
            }
        });

        E.on(D.query(".download-excel"), "click", function(e) {
            download("excel");
            E.preventDefault(e);
        });
        function download(type) {
            var f = D.get("searchform");
            f.action = f.action + "?format=" + type;
            f.submit();
            f.action = "refund";
            f.method = "post";
        }

        ;
    });
</script>
</body>
</html>
