<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-批次审核</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">批次审核：</span>
      <div class="main_box">
      	  <g:form name="actionForm" onkeypress="if(event.keyCode==13){return false;}">
             <input type="hidden" name="id" id="id" value="${trade.id}"/>
             <div class="serchlitst">
                <g:if test="${flash.message}">
                    <div class="message"><font color="red">${flash.message}</font></div>
                </g:if>
                     <table class="tlb1" >
                         <tr>
                             <td class="txtRight b" width="150">批次交易号：</td><td class="txtLeft">${trade?.id}</td>
                             <td class="txtRight b" width="150">交易类型：</td><td class="txtLeft">${trade?.batchTypeMap[trade?.batchType]}</td>
                         </tr>
                         <tr>
                             <td class="txtRight b">总数：</td><td class="txtLeft"><strong style="color:green;">${trade.batchCount}</strong>&nbsp;笔</td>
                             <td class="txtRight b">总金额：</td><td class="txtLeft"><strong style="color:red;"><g:formatNumber currencyCode="CNY" number="${trade?.batchAmount}" type="currency"/></strong>&nbsp;元</td>
                         </tr>
                         <tr>
                             <td class="txtRight b">创建时间：</td><td class="txtLeft">${trade.batchDate}</td>
                             <td class="txtRight b">状态：</td><td class="txtLeft">${trade?.statusMap[trade?.batchStatus]}</td>
                         </tr>
                         <g:if test="${trade.batchType=='F'}">
                            <tr>
                                 <td class="txtRight b">手续费：</td><td class="txtLeft"><strong style="color:purple;"><g:formatNumber currencyCode="CNY" number="${trade.batchFee}" type="currency"/>&nbsp;元</strong></td>
                                 <td class="txtRight b">实付金额： </td><td class="txtLeft"><strong style="color:red;"><g:formatNumber currencyCode="CNY" number="${trade.batchAccamount}" type="currency"/>&nbsp;元</strong></td>
                            </tr>
                            <tr>
                                 <td class="txtRight b">结算方式：</td><td class="txtLeft">${trade?.feeTypeMap[trade?.batchFeetype]}</td>
                                 <td class="txtRight b"></td><td class="txtLeft"></td>
                         </g:if>
                         <tr>
                             <td class="txtRight b">
                                审核意见：
                             </td>
                             <td class="txtLeft" colspan="3">
                                 <input name="batchRemark1" id="batchRemark1" type="text" maxlength="64"/>
                             </td>
                         </tr>
                         <tr>
                             <td colspan="4">
                                 <g:actionSubmit action="verifySuccess" class="btn mglf10" value="审核通过"></g:actionSubmit>
                                 &nbsp;&nbsp;&nbsp;&nbsp;
                                 <g:actionSubmit action="verifyRefuse" class="btn mglf10" value="审核拒绝"></g:actionSubmit>
                                 &nbsp;&nbsp;&nbsp;&nbsp;
                                 <input type="button" id="back" name="back" class="btn mglf10" value="返回" onClick="javascript:history.go(-1);"/>
                             </td>
                         </tr>
                     </table>

             </div>
          </g:form>
      </div>
    <script type="text/javascript">

        $(document).ready(function(){

            $("#actionForm").validate({
                rules: {
                    batchRemark1:{required:true,maxlength:15}
                },
                messages: {
                    batchRemark1:{required:"<font color=red>请输入审核意见。</font>",maxlength:"<font color=red>您输入的长度超过{0}个字符。</font>"}

                }
            });
        });

    </script>
</body>
</html>