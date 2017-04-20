<%@ page import="java.text.DecimalFormat; dsf.TbAgentpayDetailsInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-代收付交易编辑</title>
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
    <div class="trnmenu">
        <span class="left trnmenutlt">代收付交易编辑：</span>
    </div>
    <div class="main_box">
      	<g:form name="searchform" id="searchform" action="boxupdateinfo">
              <g:hiddenField name="batchId" id="batchId" value="${batchId}" />
              <g:hiddenField name="tradeId" id="tradeId" value="${trade?.id}" />
              <g:hiddenField name="statustrade" id="statustrade" value="update" />
              <div class="serchlitst">
                 <g:if test="${flash.message}">
                    <div class="message"><font color="red">${flash.message}</font></div>
                 </g:if>

                 <table class="tlb1" >
                     <tr>
                         <td width="150" class="txtRight b"><font color="red">* </font>序号:</td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeNum" id="tradeNum" readonly="true" value="${trade.tradeNum==null?'':trade.tradeNum.toString()}" /></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>银行帐号:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeCardnum" id="tradeCardnum" value="${trade.tradeCardnum==null?'':trade.tradeCardnum.toString()}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>开户名:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeCardname" id="tradeCardname" value="${trade.tradeCardname==null?'':trade.tradeCardname}" /></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>开户行:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeAccountname" id="tradeAccountname" value="${trade.tradeAccountname==null?'':trade.tradeAccountname}"  /></td>
                         <td class="txtLeft">例如：中国工商银行，或中国建设银行</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>分行:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeBranchbank" id="tradeBranchbank" value="${trade.tradeBranchbank==null?'':trade.tradeBranchbank}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">例如：天津分行</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>支行:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeSubbranchbank" id="tradeSubbranchbank" value="${trade.tradeSubbranchbank==null?'':trade.tradeSubbranchbank}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">例如：和平区支行</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>账户类型:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:select name="tradeAccounttype" id="tradeAccounttype" value="${trade?.tradeAccounttype}" from="${dsf.TbAgentpayDetailsInfo.accountTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>金额:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><input type="text" id="tradeAmount" name="tradeAmount" value="<g:formatNumber number="${trade.tradeAmount}" format="#0.00#"/>" ></td>
                         <td class="txtLeft" style="padding-left:10px;">最高限额以协议为准</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>币种:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeAmounttype" id="tradeAmounttype" value="${trade.tradeAmounttype==null?'':trade.tradeAmounttype}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">CNY</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>省:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeProvince" id="tradeProvince" value="${trade.tradeProvince==null?'':trade.tradeProvince}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">例如：天津</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">* </font>市:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeCity" id="tradeCity" value="${trade.tradeCity==null?'':trade.tradeCity}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">例如：天津</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b>手机号:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeMobile" id="tradeMobile" value="${trade.tradeMobile==null?'':trade.tradeMobile}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">11位数字</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b>证件类型:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:select name="certificateType" id="certificateType" value="${trade?.certificateType}" from="${dsf.TbAgentpayDetailsInfo.certificateTypeMap}" optionKey="key" optionValue="value" noSelection="${['':'-请选择-']}" class="right_top_h2_input"/></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b>证件号:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="certificateNum" id="certificateNum" value="${trade.certificateNum==null?'':trade.certificateNum}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b>用户协议号:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="contractUsercode" id="contractUsercode" value="${trade.contractUsercode==null?'':trade.contractUsercode}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">15位数字</td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b>商户订单号:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeCustorder" id="tradeCustorder" value="${trade.tradeCustorder==null?'':trade.tradeCustorder}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;"></td>
                     </tr>
                     <tr>
                         <td class="txtRight b"><b><font color="red">*</font>备注:</b></td>
                         <td class="txtLeft" style="padding-left:10px;"><g:textField name="tradeRemark" id="tradeRemark" value="${trade?.tradeRemark}"  /></td>
                         <td class="txtLeft" style="padding-left:10px;">最多20个字符</td>
                     </tr>
                     <tr>
                         <td colspan="3">
                             <input type="submit" class="btn mglf10" value="保存修改" />
                             &nbsp;&nbsp;&nbsp;&nbsp;
                             <input type="button" id="back" name="back" class="btn mglf10" value="返回" />
                         </td>
                     </tr>
                 </table>
            </div>
        </g:form>
    </div>


<script type="text/javascript">

$(document).ready(function() {
     $("#back").removeAttr('onclick');
    $("#back").click(function(){
          window.document.location.href = "${createLink(controller:'tbAgentPayBox',action:'boxlist')}?id="+${batchId};
    });
    jQuery.validator.addMethod("stringCheck", function(value, element) {
            return this.optional(element) || /^[\u0391-\uFFE5\w]+$/.test(value);
        }, "<br><font color=red size=1>只能包括中英文、数字和下划线。</font>");
    jQuery.validator.addMethod("money", function(a, b) {
            return this.optional(b) || /^\d+(\.\d{0,2})?$/i.test(a)
        }, "Please enter a valid amount.");
    jQuery.validator.addMethod("accountCheck", function(value, element) {
            return this.optional(element) || /^([0-9]|-){9,32}$/.test(value);
        }, "<br><font color=red size=1>只能包括数字或横杠。</font>");
	$("#searchform").validate({
		rules: {
			tradeCardname:{required:true,stringCheck:true,maxlength:25},
            tradeAccountname:{required:true,stringCheck:true,maxlength:25},
            tradeCardnum:{required:true, accountCheck:true},
            tradeBranchbank:{required:true,stringCheck:true,maxlength:25},
            tradeSubbranchbank :{required:true,stringCheck:true,maxlength:25},
            tradeProvince :{required:true,stringCheck:true, maxlength:8},
            tradeCity :{required:true,stringCheck:true, maxlength:15},
            tradeAmount :{required:true, money:true, range:[0.01,999999999]},
            tradeAccounttype :{required:true},
            certificateNum :{stringCheck:true, maxlength:33,minlength:8},
            tradeMobile :{stringCheck:true, maxlength:11},
            //tradeCustorder :{required:true,stringCheck:true, maxlength:30},
            tradeRemark:{required:true,stringCheck:true,maxlength:20}
		},
		messages: {
			tradeCardname:{required:"<br><font color=red size=1>请输入客户名称。</font>",maxlength:"<br><font color=red size=1>您输入的客户名称长度超过{0}个字符。</font>"},
            tradeAccountname:{required:"<br><font color=red size=1>请选择客户开户行。</font>",maxlength:"<br><font color=red size=1>您输入的银行名称长度超过{0}个字符。</font>"},
            tradeCardnum:{required:"<br><font color=red size=1>请输入客户账号。</font>", accountCheck:"<br><font color=red size=1>账户号只能输入数字或横杠，,并且长度在9-32之间。</font>"},
            tradeBranchbank:{required:"<br><font color=red size=1>请输入分行。</font>",maxlength:"<br><font color=red size=1>您输入的分行长度超过{0}个字符。</font>"},
            tradeSubbranchbank:{required:"<br><font color=red size=1>请输入支行。</font>",maxlength:"<br><font color=red size=1>您输入的支行长度超过{0}个字符。</font>"},
            tradeProvince :{required:"<br><font color=red size=1>请输入省份。</font>",maxlength:"<br><font color=red size=1>您输入的省份长度超过{0}个字符。</font>"},
            tradeCity :{required:"<br><font color=red size=1>请输入市。</font>",maxlength:"<br><font color=red size=1>您输入的市长度超过{0}个字符。</font>"},
            tradeAmount :{required:"<br><font color=red size=1>请输入金额。</font>", money:"<br><font color=red size=1>无效金额。</font>",range:"<br><font color=red size=1>输入的金额不在 {0} 和 {1} 之间。</font>"},
            tradeAccounttype :{required:"<br><font color=red size=1>请选择账户类型。</font>"},
            certificateNum:{maxlength:"<br><font color=red size=1>您输入的证件号长度超过{0}个字符。</font>",minlength:"<br><font color=red size=1>您输入的证件号长度至少为{0}个字符。</font>"},
            tradeMobile:{maxlength:"<br><font color=red size=1>您输入的手机号长度超过{0}个数字。</font>"},
           // tradeCustorder:{required:"<br><font color=red size=1>请输入商户订单号。</font>",maxlength:"<br><font color=red size=1>您输入的商户订单号长度超过{0}个字符。</font>"},


            tradeRemark:{required:"<br><font color=red size=1>请输入备注。</font>",maxlength:"<br><font color=red size=1>您输入的用途长度超过{0}个字符。</font>"}
		}
	});
});

</script>
</body>
</html>