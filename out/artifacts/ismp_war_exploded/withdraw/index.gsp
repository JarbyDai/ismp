<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-申请提现</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
    <g:render template="/layouts/baseInfo"/>
    <div class="main_box">
      <div class="main_left">
        <div class="zxgg">
          <div class="zxggtlt">
            <p>最新公告</p>
          </div>
          <g:render template="/layouts/news"/>
        </div>
        <div class="cpfw">
          <div class="zxggtlt">
            <p>常见问题</p>
          </div>
          <ul class="list12">
          </ul>
        </div>
      </div>
      <div class="txmenu">
        <span class="left trnmenutlt">交易管理：</span>
  	    <div class="rtnms">
            <ul>
              <li class="rtncnt blue">提现</li>
              <g:if test="${session.level3Map != null && session.level3Map['withdraw/list'] != null}">
                <li>
                    <a href="${request.contextPath}/${session.level3Map['withdraw/list'].modelPath}">提现记录</a>
                </li>
              </g:if>
            </ul>
        </div>
    </div>
<form action="step2" method="post" name="actionForm" id="actionForm">
  <div class="txbox">
  	<dl>

        <g:if test="${acAccount_Main!=null&&acAccount_Main.balance>0}">
            <dt>您的合利宝账户：</dt>
            <dd>${session.cmCustomer?.name.encodeAsHTML()}&nbsp;(${session.cmCustomerOperator.defaultEmail})</dd>
            <dt>银行名称：</dt>
            <dd>${cmCustomerBankAccount.bankCode}${cmCustomerBankAccount.branch}${cmCustomerBankAccount.subbranch}</dd>
            <dt>开户名：</dt>
            <dd>${cmCustomerBankAccount.bankAccountName}</dd>
            <dt>银行账号：</dt>
            <dd>${cmCustomerBankAccount.bankAccountNo}</dd>
            <dt>您的可用余额：</dt>
            <dd><span class="doler"><g:formatNumber currencyCode="CNY" number="${acAccount_Main==null?0:acAccount_Main.balance/100}" type="currency"/>元</span></dd>
            <dt>申请提现金额：</dt>
            <dd><input name="amount" id="amount" value="${params.amount}" type="text" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" maxlength="12"/>&nbsp;元</dd>
            <dt>校验码：</dt>
            <dd>
                <input type="text" name="captcha" id="captcha" maxlength="4" value="${params.captcha}"/>
                <img align="absMiddle" id="authCodeImg" src="../captcha/index?t=${new Date().getTime()}" alt="请输入您看到的内容" width="100" height="30" style="cursor:pointer"/>
                <span class="blue" id="reload-checkcode" style="cursor:pointer;">看不清，换一张</span>
            </dd>
            <g:if test="${flash.message?.encodeAsHTML()} != ''">
                <dt></dt>
                <dd>
                    <div id="loginMsg" style="color:red">${flash.message?.encodeAsHTML()}</div>
                </dd>
            </g:if>
        </g:if>
        <g:else><h3 style="margin-top:10px;">因您的可用余额为0，所以无法进行提现操作</h3></g:else>
    </dl>
    <div class="xybbtn">
        <g:if test="${acAccount_Main!=null&&acAccount_Main.balance>0}">
    	    <input type="submit" class="btn mglf10" value="下一步" />
        </g:if>
    </div>
  </div>
 </form>
  </div>

<script>
    $(document).ready(function() {
        jQuery.validator.addMethod("money",function(a,b){return this.optional(b)||/^\d+(\.\d{0,2})?$/i.test(a)},"Please enter a valid amount.");
        $("#actionForm").validate({
            rules: {
                amount:{required:true,money:true,min:0.01,max:${acAccount_Main==null?0:acAccount_Main.balance/100}},
                captcha:{required:true,minlength:4}
            },
            messages: {
                amount:{required:"请输入提现金额",money:"无效金额",min:'金额值必须大于{0}',max:'金额值必须小于{0}'},
                captcha:{required:"请输入验证码",minlength:"验证码位数不对"}
            }
        });
    });

     E.on('reload-checkcode','click',function(){
		reloadAuthImg(D.get('authCodeImg'));
	});
    E.on('authCodeImg','click',function(){
		reloadAuthImg(D.get('authCodeImg'));
	});

	function reloadAuthImg(img) {
		var url = img.src.split('?')[0];
		var param = img.src.toQueryParams();
		param.r = new Date().getTime();

		var params = [];
		for(var i in param){
			params.push(i+'='+param[i]);
		}
		img.src = url + '?' + params.join('&');
	}
</script>
</body>
</html>
