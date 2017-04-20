<%@ page import="dsf.TbAgentpayDetailsInfo; dsf.TbAgentpayInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-代付交易</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script type="text/javascript">
        function clearContents(){
            $(':input') .not(':button, :submit, :reset, :hidden')
                    .val('')
                    .removeAttr('checked')
                    .removeAttr('selected');
            return false;
        }
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
<div class="trnmenu">
  <span class="left trnmenutlt">代付交易：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">代付交易</li>
    </ul>
  </div>
</div>
<form action="agentpayhis" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div id="agentpayhisMsg">
        <g:if test="${errmsg}">
            <div id="agentpayhistMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
          <tr>
            <td scope="col" width="400">&nbsp;&nbsp;开始日期:
                <g:textField name="startDate" value="${params.startDate}" readonly="readonly" size="8"/>
                &nbsp;&nbsp;结束日期:
                <g:textField name="endDate" value="${params.endDate}" readonly="readonly" size="8"/>
            </td>
            <td width="252" scope="col">批次号:
              <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="40"/>
            </td>
             </tr>
          <tr>
              <td width="252" scope="col">交易号:
              <input name="detatlNo" type="text" id="detatlNo" value="${params.detatlNo}" maxlength="40"/>
          </td>
              <td width="252" scope="col">商户订单号:
                  <input name="custorder" type="text" id="custorder" value="${params.custorder}" maxlength="60"/>
              </td>
              </tr>
          <tr>
              <td width="252" scope="col"> 处理状态
                  <g:select name="batchStatus" value="${params.batchStatus}" from="${TbAgentpayDetailsInfo.tradeStatusMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
              </td>
              <td width="252" scope="col">收款人:
                  <input name="tradeCardname" type="text" id="tradeCardname" value="${params.tradeCardname}" maxlength="60"/>
              </td>
          <tr>
          <tr>
              <td width="252" scope="col"> 退款状态
              <g:select name="tradeRefued" value="${params.tradeRefued}" from="${TbAgentpayDetailsInfo.tradeRefuedMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
              交易反馈状态
                 <g:select name="tradeFeedbackcode" value="${params.tradeFeedbackcode}" from="${TbAgentpayDetailsInfo.tradeFeedbackcodeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}"/>
               </td>
              <td width="252" scope="col">反馈原因:
                  <input name="tradeReason" type="text" id="tradeReason" value="${params.tradeReason}" maxlength="100"/>
              </td>
          <tr>
            <td scope="col">
                <input type="submit" class="serchbtn" value="搜索" />
                <input type="button" onclick="clearContents()" class="serchbtn" value="清除" />
            </td>
                              </tr>
      </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">类型</th>
            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">批次号</th>
            <th class="txtCenter" scope="col">交易号</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">收款人名称</th>
            <th class="txtCenter" scope="col">收款人银行</th>
            %{--<th class="txtCenter" scope="col">总数</th>
            <th class="txtCenter" scope="col">总金额（元）</th>   --}%
            <th class="txtCenter" scope="col">处理状态</th>
            <th class="txtCenter" scope="col">交易反馈状态</th>
            <th class="txtCenter" scope="col">手续费</th>
            <th class="txtCenter" scope="col">结算方式</th>
            <th class="txtCenter" scope="col">实付金额（元）</th>
            <th class="txtCenter" scope="col">备注</th>
            <th class="txtCenter" scope="col">反馈原因</th>
            <th class="txtCenter" scope="col">退款状态</th>
            %{--<th class="txtCenter" scope="col">上传文件名</th>--}%
            %{--<th class="txtCenter" scope="col">操作</th>--}%
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr>
                    <td class="txtCenter" scope="col">${TbAgentpayInfo.batchTypeMap[trade.BATCH_TYPE]}</td>
                    <td scope="col" class="blue"><g:formatDate date="${trade.BATCH_SYSDATE}" format="yyyy-MM-dd HH:mm:ss"/></td>
                    <td class="txtCenter" scope="col">${trade.BATCH_ID}</td>
                    <td class="txtCenter" scope="col">${trade.DETAIL_ID}</td>
                    <td class="txtCenter" scope="col">${trade.TRADE_CUSTORDER}</td>
                    <td class="txtCenter" scope="col">${trade.TRADE_CARDNAME}</td>
                    <td class="txtCenter" scope="col">${trade.TRADE_ACCOUNTNAME}</td>
                    %{--<td class="txtCenter" scope="col"><strong style="color:green;">${trade.BATCH_COUNT}</strong></td>
                    <td class="txtCenter" scope="col"><strong style="color:red;"><g:formatNumber currencyCode="CNY" number="${trade.BATCH_AMOUNT}" type="currency"/></strong></td>   --}%
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.tradeStatusMap[trade.TRADE_STATUS]}</td>
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.tradeFeedbackcodeMap[trade.TRADE_FEEDBACKCODE]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:purple;"><g:formatNumber currencyCode="CNY" number="${trade.TRADE_FEE}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.feeTypeMap[trade.BATCH_FEETYPE]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.TRADE_AMOUNT}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${trade.BATCH_REMARK1}</td>
                    <td class="txtCenter" scope="col">${trade.TRADE_REASON}</td>
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.tradeRefuedMap[trade.TRADE_REFUED]}</td>
                    %{--<td class="txtCenter" scope="col">${trade.BATCH_FILENAME}</td>--}%
                    %{--<td class="txtCenter" scope="col">--}%
                        %{--<g:if test="${session.level3Map != null && session.level3Map['tbAgentpayInfo/detaillist'] != null}">--}%
                          %{--<a href="${request.contextPath}/${session.level3Map['tbAgentpayInfo/detaillist'].modelPath}?id=${trade.DETAIL_ID}&tradeflag=1" style="color:blue;">查看明细</a>--}%
                        %{--</g:if>--}%
                    %{--</td>--}%
                </tr>
            </g:each>
        </table>
        <div class="page">
            <g:if test="${tradeListTotal>0}">
                <div class="elxdwn blue"><a href="javascript:void(0)" onclick="download('xls')">下载统计结果</a></div>
                <g:if test="${totalamount}">
                    <div class="total_num" style="width:auto; height:31px; line-height:31px; text-align:left; float:left; margin-left:10px; background-position:-130px 10px; padding-left:20px; ">总金额：<g:formatNumber currencyCode="CNY" number="${totalamount}" type="currency"/></div>
                </g:if>
            </g:if>
          <g:pageNavi total="${tradeListTotal}"/>
          </div>
    </div>
</form>

<script type="text/javascript">
  $(function() {
      var dateConfig ={
          dateFormat: 'yy-mm-dd',
          changeYear: true,
          changeMonth: true
      }
      $('#startDate, #endDate').datepicker(dateConfig);
    $("#filename").val("");
    $("#batchStatus").val("");
  });

$(document).ready(function() {

      $("#serch").click(function(){

        $("#filename").val("");
        $("#batchStatus").val("");
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
			amountMin:{money:"无效金额",range:"无效金额范围"},
			amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
			startDate:{dateISO:"无效时间格式"},
			endDate:{dateISO:"无效时间格式",compareDate:"结束日期必须大于开始日期"}
		}
	});
});


function download(type){
	var f = D.get("searchform");
	f.action="${createLink(controller: 'tbAgentpayInfo', action: 'agentpayhis')}?format="+type;

	f.submit();
    f.method = "post";
    f.action = "agentpayhis";

  };

</script>
</body>
</html>
