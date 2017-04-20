<%@ page import="account.AcTransaction; account.AcSequential; ismp.TradePayment; ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-账务明细</title>
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
        function clearContents(){
            $(':input') .not(':button, :submit, :reset, :hidden')
                    .val('')
                    .removeAttr('checked')
                    .removeAttr('selected');
            return false;
        }
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
      <li class="rtncnt blue">账务明细</li>
        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/accountin'] != null}">--}%
            %{--<li>--}%
            %{--<a href="${request.contextPath}/${session.level3Map['trade/accountin'].modelPath}">收入</a>--}%
            %{--</li>--}%
        %{--</g:if>--}%
        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/accountout'] != null}">--}%
            %{--<li>--}%
            %{--<a href="${request.contextPath}/${session.level3Map['trade/accountout'].modelPath}">支出</a>--}%
            %{--</li>--}%
        %{--</g:if>--}%
    </ul>
  </div>
</div>
<form action="account" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <g:hiddenField name="ids" id="ids"/>
    <g:hiddenField name="batch" value="${flash.message}"/>
    <div id="accoutMsg">
        <g:if test="${errmsg}">
            <div id="accoutMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
      <tr>
        <td width="252" scope="col" colspan="4">&nbsp;&nbsp;资金流向:
            <input type="radio" name="direction" value="in" id="account-in" <g:if test="${params.direction=='in'||actionName=='accountin'}">checked</g:if>/>收入
            <input type="radio" name="direction" value="out" id="account-out" <g:if test="${params.direction=='out'||actionName=='accountout'}">checked</g:if>/>支出
            <input type="radio" name="direction" value="all" id="account-all" <g:if test="${(params.direction==null||params.direction=='all')&&actionName=='account'}">checked</g:if>/>所有
            交易号:
            <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="80"/>
            第三方支付单号:
            <input name="outTransactionId" type="text" id="outTransactionId" value="${params.outTransactionId}" maxlength="80"/>
        </td>
        <td scope="col">
            <input type="submit" class="serchbtn" value="搜索" />
            <input type="button" onclick="clearContents()" class="serchbtn" value="清除" />
        </td>
        <td scope="col"></td>
      </tr>
      <tr>
        <td scope="col" colspan="4">&nbsp;&nbsp;开始日期:
            <g:textField name="startDate" value="${params.startDate}" readonly="readonly"/>
            &nbsp;&nbsp;结束日期:
            <g:textField name="endDate" value="${params.endDate}" readonly="readonly"/>
        </td>
        <td scope="col"></td>
        <td scope="col"></td>
      </tr>
      <tr>
            <td scope="col" colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;类型:
                <input type="checkbox" name="tradeType" value="typeAll" id="typeAll" <g:if test="${params.tradeType=='typeAll'||params.tradeType==null}">checked</g:if>/>所有
                <input type="checkbox" name="tradeType" value="charge" id="charge" <g:if test="${'charge' in params.tradeType}">checked</g:if>/>充值
                <input type="checkbox" name="tradeType" value="withdrawn" id="withdrawn" <g:if test="${'withdrawn' in params.tradeType}">checked</g:if>/>提现
                <input type="checkbox" name="tradeType" value="payment" id="payment" <g:if test="${'payment' in params.tradeType}">checked</g:if>/>支付
                <input type="checkbox" name="tradeType" value="fee" id="fee" <g:if test="${'fee' in params.tradeType}">checked</g:if>/>手续费
                %{--<input type="checkbox" name="tradeType" value="fee_rfd" id="fee_rfd" <g:if test="${'fee_rfd' in params.tradeType}">checked</g:if>/>退手续费--}%
                <input type="checkbox" name="tradeType" value="transfer" id="transfer" <g:if test="${'transfer' in params.tradeType}">checked</g:if>/>转账
                %{--<input type="checkbox" name="tradeType" value="royalty" id="royalty" <g:if test="${'royalty' in params.tradeType}">checked</g:if>/>分润--}%
                %{--<input type="checkbox" name="tradeType" value="royalty_rfd" id="royalty_rfd" <g:if test="${'royalty_rfd' in params.tradeType}">checked</g:if>/>退分润--}%
                <input type="checkbox" name="tradeType" value="refund" id="refund" <g:if test="${'refund' in params.tradeType}">checked</g:if>/>退款
                %{--<input type="checkbox" name="tradeType" value="frozen" id="frozen" <g:if test="${'frozen' in params.tradeType}">checked</g:if>/>冻结--}%
                %{--<input type="checkbox" name="tradeType" value="unfrozen" id="unfrozen" <g:if test="${'unfrozen' in params.tradeType}">checked</g:if>/>解冻结--}%
                <input type="checkbox" name="tradeType" value="agentpay" id="agentpay" <g:if test="${'agentpay' in params.tradeType}">checked</g:if>/>代付
                %{--<input type="checkbox" name="tradeType" value="agentcoll" id="agentcoll" <g:if test="${'agentcoll' in params.tradeType}">checked</g:if>/>代收--}%
                <input type="checkbox" name="tradeType" value="settle" id="settle" <g:if test="${'settle' in params.tradeType}">checked</g:if>/>结算
                <input type="checkbox" name="tradeType" value="adjust" id="adjust" <g:if test="${'adjust' in params.tradeType}">checked</g:if>/>调账
            </td>
            </tr>

          <tr>
              <td scope="col" colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;摘要:
                  <input type="checkbox" name="subJictType" value="subJictAll" id="subJictAll" <g:if test="${params.subJictType=='subJictAll'||params.subJictType==null}">checked</g:if>/>所有
                  <input type="checkbox" name="subJictType" value="subJictPay" id="subJictPay" <g:if test="${'subJictPay' in params.subJictType}">checked</g:if>/>代付
                  <input type="checkbox" name="subJictType" value="subJictRefund" id="subJictRefund" <g:if test="${'withdrawn' in params.subJictType}">checked</g:if>/>代付退款记账
                  <input type="checkbox" name="subJictType" value="subJictClose" id="subJictClose" <g:if test="${'subJictClose' in params.subJictType}">checked</g:if>/>实时结算交易净额
                  <input type="checkbox" name="subJictType" value="wallet" id="wallet"  <g:if test="${'wallet' in params.subJictType}">checked</g:if>/>钱包转账
                  <input type="checkbox" name="subJictType" value="wechat" id="wechat" <g:if test="${'wechat' in params.subJictType}">checked</g:if>/>微信
                  <input type="checkbox" name="subJictType" value="wechatScanPay" id="wechatScanPay" <g:if test="${'wechatScanPay' in params.subJictType}">checked</g:if>/>微信扫码
                  <input type="checkbox" name="subJictType" value="wechatOfficialPay" id="wechatOfficialPay" <g:if test="${'wechatOfficialPay' in params.subJictType}">checked</g:if>/>微信公众号
                  <input type="checkbox" name="subJictType" value="wechatSDKPay" id="wechatSDKPay"  <g:if test="${'wechatSDKPay' in params.subJictType}">checked</g:if>/>微信SDK支付
                  <input type="checkbox" name="subJictType" value="alipay" id="alipay" <g:if test="${'alipay' in params.subJictType}">checked</g:if>/>支付宝
                  <input type="checkbox" name="subJictType" value="alipayServer" id="alipayServer" <g:if test="${'alipayServer' in params.subJictType}">checked</g:if>/>支付宝服务窗
                  <input type="checkbox" name="subJictType" value="alipayScanPay" id="alipayScanPay" <g:if test="${'alipayScanPay' in params.subJictType}">checked</g:if>/>支付宝扫码
              </td>
          </tr>
    </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">创建时间</th>
            %{--<th class="txtCenter" scope="col">商户订单号</th>--}%
            <th class="txtCenter" scope="col">交易号</th>
            <th class="txtCenter" scope="col">第三方支付单号</th>
            <th class="txtCenter" scope="col">类型</th>
            <th class="txtCenter" scope="col">收入（元）</th>
            <th class="txtCenter" scope="col">支出（元）</th>
            <th class="txtCenter" scope="col">账户余额（元）</th>
            <th class="txtCenter" scope="col">摘要</th>
            <th class="txtCenter" scope="col">详细</th>
          </tr>
            <g:each in="${resultList}" status="i" var="result">
                <tr>
                    <td scope="col" class="blue">${result.DATE_CREATED?.format("yyyy-MM-dd HH:mm:ss")}</td>
                    %{--<td class="txtCenter" scope="col">${(result.OUT_TRADE_NO && result.OUT_TRADE_NO == '0') ? '' : result.OUT_TRADE_NO}</td>--}%
                    <td class="txtCenter" scope="col">${result.TRADE_NO}</td>
                    <td class="txtCenter" scope="col">${result.OUT_TRANSACTION_ID}</td>
                    <td class="txtCenter" scope="col">${AcTransaction.transTypeMap[result.TRANSFER_TYPE]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:green"><g:if test="${result.DEBIT_AMOUNT && result.DEBIT_AMOUNT>0}">+<g:formatNumber currencyCode="CNY" number="${result.DEBIT_AMOUNT ? result.DEBIT_AMOUNT/100 : 0}" type="currency"/></g:if></strong></td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:if test="${result.CREDIT_AMOUNT && result.CREDIT_AMOUNT>0}">-<g:formatNumber currencyCode="CNY" number="${result.CREDIT_AMOUNT ? result.CREDIT_AMOUNT/100 : 0}" type="currency"/></g:if></strong></td>
                    <td class="txtCenter" scope="col"><strong><g:formatNumber currencyCode="CNY" number="${result.BALANCE ? result.BALANCE/100 : 0}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${result.SUBJICT == 'null' ? '' : result.SUBJICT?.encodeAsHTML()}</td>
                    <td class="txtCenter" scope="col">
                        <g:if test="${session.level3Map != null && session.level3Map['trade/accdetail'] != null}">
                            <a href="${request.contextPath}/${session.level3Map['trade/accdetail'].modelPath}/${result.ID}" style="color:blue">查看</a>
                        </g:if>
                        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/receiptdetail'] != null&&result != null && result.transaction!= null&&result.transaction.transferType!='frozen'&&result.transaction.transferType!='unfrozen'&&result.transaction.transferType!='agentpay'&&result.transaction.transferType!='agentcoll'}">--}%
                               %{--|&nbsp;<a href="${request.contextPath}/${session.level3Map['trade/receiptdetail'].modelPath}/${result.id}" style="color:blue" target="_blank">回单</a>--}%
                        %{--</g:if>--}%
                    </td>
                </tr>
            </g:each>
        </table>

        <div class="page">
          <g:pageNavi total="${resultTotal}"/>
            <g:if test="${resultTotal>0}">
                <div class="elxdwn blue"><a href="#" class="download-excel">下载Excel</a></div>
                <div class="total_num" style="width:auto; height:31px; line-height:31px; text-align:left; float:left; margin-left:10px; background-position:-130px 10px;  ">总收入：<g:formatNumber currencyCode="CNY" number="${in_amount ? in_amount/100 : 0}" type="currency"/></div>
                <div class="total_num" style="width:auto; height:31px; line-height:31px; text-align:left; float:left; margin-left:10px; background-position:-130px 10px; ">总支出：<g:formatNumber currencyCode="CNY" number="${out_amount ? out_amount/100 :0}" type="currency"/></div>
                <div class="total_num" style="width:auto; height:31px; line-height:31px; text-align:left; float:left; margin-left:10px; background-position:-130px 10px;  ">手续费：<g:formatNumber currencyCode="CNY" number="${fee_amount ? fee_amount/100 : 0}" type="currency"/></div>
            </g:if>
        </div>
    </div>
</form>

<script type="text/javascript">
    $(function() {
        var dates=new Date();
        var dateConfig ={
            showSecond: true,
            timeFormat: 'hh:mm:ss'
        }
        $('#startDate, #endDate').datetimepicker(dateConfig);
    });

    $(document).ready(function() {
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
    			endDate:{compareDate:"#startDate",rangeDate:"#startDate"}
    		},
    		messages: {
    			endDate:{compareDate:"结束日期必须大于开始日期",rangeDate:"日期范围必须3个月内"}
    		}
    	});

        /*
    	* 不可选与可选
    	* disabl
    	* Id：    DOMID
    	* check： 1."checked"为选中 2."unchecked"为不选中
    	* disabl： 1."disabl"不可操作 2."undisabl"可操作
    	*/
    	function disabl(Id, check, disabl) {
    		if (check == "checked") {
    			D.get(Id).checked = true;
    		} else if (check == "unchecked") {
    			D.get(Id).checked = false;
    		}
    		if (disabl == "disabl") {
    			D.get(Id).disabled = true;
    			D.get(Id).readOnly = true;
    		} else if (disabl == "undisabl") {
    			D.get(Id).disabled = false;
    			D.get(Id).readOnly = false;
    		}
    	}

        function checke() {
            if (D.get("account-in").checked) {
                disabl("charge", "null", "undisabl");
                disabl("withdrawn", "unchecked", "disabl");
            }
            if (D.get("account-out").checked) {
                disabl("charge", "unchecked", "disabl");
                disabl("withdrawn", "null", "undisabl");
            }
            if (D.get("account-all").checked) {
                disabl("charge", "null", "undisabl");
                disabl("withdrawn", "null", "undisabl");
            }
        }

        E.on(D.get("account-in"), "click", function(e) {
            checke();
        });

        E.on(D.get("account-out"), "click", function(e) {
            checke();
        });

        E.on(D.get("account-all"), "click", function(e) {
            checke();
        });
        checke();

        E.on(D.get("typeAll"), "click", function(e) {
            if (D.get("typeAll").checked) {
                disabl("charge", "unchecked", "null");//充值
                disabl("withdrawn", "unchecked", "null");//提现
                disabl("transfer", "unchecked", "null");//转账
                disabl("payment", "unchecked", "null");//支付
                disabl("fee", "unchecked", "null");//服务费
//                disabl("fee_rfd", "unchecked", "null");//服务费
//                disabl("royalty", "unchecked", "null");//服务费
//                disabl("royalty_rfd", "unchecked", "null");//服务费
                disabl("refund", "unchecked", "null");//服务费
//                disabl("frozen", "unchecked", "null");//服务费
//                disabl("unfrozen", "unchecked", "null");//服务费
                disabl("agentpay", "unchecked", "null");//服务费
//                disabl("agentcoll", "unchecked", "null");//服务费
                disabl("settle", "unchecked", "null");//服务费
                disabl("adjust", "unchecked", "null");//服务费
            }
            checke();
        });
//        E.on([D.get("payment"), D.get("charge"), D.get("transfer"), D.get("withdrawn"), D.get("fee"), D.get("refund"), D.get("refund_rfd"), D.get("fee_rfd"), D.get("frozen"), D.get("unfrozen"), D.get("royalty"),D.get("royalty_rfd"),D.get("agentpay"),D.get("agentcoll")], "click", function(e) {
        E.on([D.get("payment"), D.get("charge"), D.get("transfer"), D.get("withdrawn"), D.get("fee"), D.get("refund"), D.get("refund_rfd"),D.get("agentpay"),D.get("settle"),D.get("adjust")], "click", function(e) {
            disabl("typeAll", "unchecked", "null");//所有
        });


        E.on(D.get("subJictAll"), "click", function(e) {
            if (D.get("subJictAll").checked) {
                disabl("subJictPay", "unchecked", "null");//代付
                disabl("subJictRefund", "unchecked", "null");//代付退款记账
                disabl("subJictClose", "unchecked", "null");//实时结算交易净额
                disabl("wallet", "unchecked", "null");//钱包转账
                disabl("wechat", "unchecked", "null");//微信
                disabl("wechatScanPay", "unchecked", "null");//微信扫码
                disabl("wechatOfficialPay", "unchecked", "null");//微信公众号
                disabl("wechatSDKPay", "unchecked", "null");//微信SDK支付
                disabl("alipay", "unchecked", "null");//支付宝
                disabl("alipayServer", "unchecked", "null");//支付宝服务窗
                disabl("alipayScanPay", "unchecked", "null");//支付宝扫码
            }
            checke();
        });
        E.on([D.get("subJictPay"), D.get("subJictRefund"), D.get("subJictClose"),D.get("wallet"), D.get("wechat"), D.get("wechatScanPay"),D.get("wechatOfficialPay"), D.get("wechatSDKPay"), D.get("alipay"), D.get("alipayServer"), D.get("alipayScanPay")], "click", function(e) {
            disabl("subJictAll", "unchecked", "null");//所有
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
    		download("excel");
    		E.preventDefault(e);
    	});
    	function download(type){
    		var f = D.get("searchform");
    		f.action=f.action+"?format="+type;
    		f.submit();
    		f.action = "account";
    		f.method = "post";
    	};

    });
</script>
</body>
</html>
