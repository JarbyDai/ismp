<%@ page import="dsf.TbAgentpayDetailsInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-批次明细</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script type="text/javascript">
        function search(obj){
            if(obj){
                if($("offset"))
                $("offset").value=0;
            }
            $("#searchform").submit();
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">代收付：</span>
  <div class="rtnms">
    <ul>
        <li class="rtncnt blue">批次明细</li>
    </ul>
  </div>
</div>
<g:form action="detaillist" method="post" name="searchform" style="width:960px; margin:0 auto">
    <g:hiddenField name="format"/>
    <input name="id" type="hidden" id="id" value="${params.id}"/>
    <input name="tradeflag" type="hidden" id="tradeflag" value="${params.tradeflag}"/>
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
            <td width="252" scope="col">批次明细交易号:
              <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="80"/>
            </td>
            <td scope="col">
                <input type="submit" class="serchbtn" value="搜索" />
            </td>
            <td scope="col" class="blue">
                <a href="#" id="serch">更多条件</a>
            </td>
          </tr>
      </table>
      <table class="serchtlb" style="display:none" id="serchmore">
          <tr>
            <td scope="col" width="252">&nbsp;收/付款人:
                <input name="tradeCardname" type="text" id="tradeCardname" value="${params.tradeCardname}" maxlength="40"/>
            </td>
            <td scope="col" width="252">&nbsp;&nbsp;&nbsp;&nbsp;开户行:
              <input name="tradeAccountname" type="text" id="tradeAccountname" value="${params.tradeAccountname}" maxlength="80"/>
            </td>
            <td scope="col" colspan="2">处理状态:
              <g:select name="tradeStatus" value="${params.tradeStatus}" from="${TbAgentpayDetailsInfo.tradeStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" />
            </td>
            <td scope="col">交易状态:
              <g:select name="tradeFeedbackcode" value="${params.tradeFeedbackcode}" from="${['成功','失败']}" noSelection="${['':'-请选择-']}" />
            </td>
          </tr>
      </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>

            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">流水号</th>
            <th class="txtCenter" scope="col">交易号</th>
            <th class="txtCenter" scope="col">客户账户</th>
            <th class="txtCenter" scope="col">交易金额（元）</th>
            <th class="txtCenter" scope="col">帐户类型</th>
            <th class="txtCenter" scope="col">收/付款人</th>
            <th class="txtCenter" scope="col">证件类型</th>
            <th class="txtCenter" scope="col">证件号</th>
            <th class="txtCenter" scope="col">手机号</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">用户协议号</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">备注</th>
            %{--<g:if test="${tradeflag==0}" >--}%
                <th class="txtCenter" scope="col">交易状态</th>
                <th class="txtCenter" scope="col">反馈原因</th>
                <th class="txtCenter" scope="col">完成时间</th>
            %{--</g:if>--}%
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr style="height:80px;">
                    <td scope="col" class="blue">${trade.tradeSubdate.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${trade.tradeNum}</td>
                    <td class="txtCenter" scope="col">${trade.id}</td>
                    <td class="txtCenter" scope="col">${trade.tradeAccountname}<br>${trade.tradeBranchbank},${trade.tradeSubbranchbank}<br>${trade.tradeCardnum}<br>${trade.tradeProvince},${trade.tradeCity}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.tradeAmount}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${trade.accountTypeMap[trade.tradeAccounttype]}</td>
                    <td class="txtCenter" scope="col">${trade.tradeCardname}</td>
                    <td class="txtCenter" scope="col">${trade.certificateTypeMap[trade.certificateType]}</td>
                    <td class="txtCenter" scope="col">${trade.certificateNum}</td>
                    <td class="txtCenter" scope="col">${trade.tradeMobile}</td>
                    <td class="txtCenter" scope="col">${trade.tradeStatusMap[trade.tradeStatus]}</td>
                    <td class="txtCenter" scope="col">${trade.contractUsercode}</td>
                    <td class="txtCenter" scope="col">${trade.tradeCustorder}</td>
                    <td class="txtCenter" scope="col">${trade.tradeRemark}</td>
                    %{--<g:if test="${tradeflag==0}" >--}%
                        <td class="txtCenter" scope="col">${trade.tradeFeedbackcode}</td>
                        <td class="txtCenter" scope="col">${trade.tradeReason}</td>
                        <td scope="col" class="blue">${trade.tradeDonedate?trade.tradeDonedate.format("yyyy-MM-dd HH:mm:ss"):""}</td>
                    %{--</g:if>--}%
                </tr>
            </g:each>
        </table>
        <div class="page">
            <g:if test="${tradeListTotal>0}">
                <div class="elxdwn blue"><a href="#" class="download-txt">下载TXT</a></div>
                <div class="elxdwn blue"><a href="#" class="download-exc">下载CSV</a></div>
                <div class="elxdwn blue"><a href="#" class="download-excel">下载Excel</a></div>
            </g:if>
          <g:pageNavi total="${tradeListTotal}"/>
          </div>
    </div>
</g:form>

<script type="text/javascript">
  $(function() {
    $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -30, maxDate: "+0D" });
    $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -30, maxDate: "+0D" });

    $("#tradeCardname").val("");
    $("#tradeAccountname").val("");
    $("#tradeFeedbackcode").val("");
    $("#tradeStatus").val("");
  });

$(document).ready(function() {

      $("#serch").click(function(){

        $("#tradeCardname").val("");
        $("#tradeAccountname").val("");
        $("#tradeFeedbackcode").val("");
        $("#tradeStatus").val("");
      });

	jQuery.validator.addMethod("money",function(a,b){return this.optional(b)||/^\d+(\.\d{0,2})?$/i.test(a)},"Please enter a valid amount.");
	jQuery.validator.addMethod("ge", function(value, element, param) {
		var target = $(param).unbind(".validate-equalTo").bind("blur.validate-equalTo", function() {
				$(element).valid();
			});
			if(target.val()==""||value=="") return true;
			else return parseFloat(value) >= parseFloat(target.val());
	}, "Please enter a valid value.");
	jQuery.validator.addMethod("compareDate", function(value, element, param) {
				var startDate = jQuery(param).val();
				if(startDate==""||value=="")
				{
					return true;
				}else{
					var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
					var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
					return date1 <= date2;
				}
	}, "Please enter a valid value.");
	$("#searchform").validate({
		rules: {
			amountMin:{money:true,range:[0.01,100000000]},
			amountMax:{money:true,range:[0.01,100000000],ge:"#amountMin"},
			startDate:{dateISO:true},
			endDate:{dateISO:true,compareDate:"#startDate"}
		},
		messages: {
//			amountMin:{money:"无效金额",range:"无效金额范围"},
//			amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
			startDate:{dateISO:"无效时间格式"},
			endDate:{dateISO:"无效时间格式",compareDate:"结束日期必须大于开始日期"}
		}
	});
});

//----------下载部分处理-------
E.on(D.query(".download-exc"),"click",function(e){
	download("csv");
	E.preventDefault(e);
});
E.on(D.query(".download-txt"),"click",function(e){
	download("txt");
	E.preventDefault(e);
});
  E.on(D.query(".download-excel"),"click",function(e){
	download("xls");
	E.preventDefault(e);
});
function download(type){
	var f = D.get("searchform");
    $("#format").val(type)
	f.submit();
    $("#format").val("")
};
</script>
</body>
</html>
