<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="layout" content="main" />
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="cache-control" content="no-cache"/>
<meta http-equiv="cache-control" content="no-store"/>
<meta http-equiv="expires" content="0"/>
<title>合利宝-绑定手机</title>
<link charset="utf-8" rel="stylesheet" href="${resource(dir:'css',file:'hetong.css')}" media="all" />
<link charset="utf-8" rel="stylesheet" href="${resource(dir:'css',file:'mystyle.css')}" media="all" />
<script charset="utf-8" src="${resource(dir:'js',file:'arale.js')}"></script>
<script charset="utf-8" src="${resource(dir:'js',file:'pa.js')}"></script>
  </head>
  <body>
  <div class="content">

          <form method="post" action="${createLink(controller:'login',action: 'saveHistoryUserBindMobile')}" id="actionForm">
          <input type="hidden" value="${createLink(controller:'login',action: 'send')}" id="actionUrl"/>
          <input type="hidden" name="method" value="mobile">
		  <input type="hidden" id="id" name="id" value="${cmCustomerOperator}">
          <input type="hidden" id="mobile" name="mobile" value="${mobile}">
        	<h1>绑定手机</h1>
			<h2 ><strong>请输入您手机上收到的验证码</strong></h2>
			<div class="content_t" style="height:80px;">

                        <div class="fm-item" style="margin-left:200px;height:40px;">
							<label class="fm-label" for="captcha" style="margin-top:0">手机验证码：</label>
							<input name="captcha" id="captcha" class="i-text i-text-mobilecaptcha" type="text" maxlength="6" value=""/>
                            <div class="fm-explain">点击“获取验证码”按钮，输入您手机上收到的验证码。</div>
                            <span><input id="getCaptcha" name="btn" type="button" value="获取验证码" class="anniu_2" style="margin-left:100px; margin-top:-44px;"/></span>
						</div>
                        <div class="fm-item" style="margin-left:200px;">
							<div id="Msg" class="fm-error" style="color:red">${flash.message?.encodeAsHTML()}</div>
						</div>
			</div>
       		<div class="anniu">
                   <span id="btn1"><input type="submit"class="anniu_2" style="margin-left:400px;" value="确定" tabindex="4"/> <br></span>
			</div>
		</form>
  </div>
<script>
new AP.widget.Validator(
{
	formId:"actionForm",
	ruleType:"id",
	onSubmit:true,
	onSuccess: function()
	{
		return false
	},rules:{
			'captcha':{
				minLength:6,
				required:true,
				depends:true,
				desc:"手机验证码"
			}
	}
});
E.on('captcha','focus',function(){
	if(D.get("Msg").innerHTML!="")
		D.get("Msg").innerHTML="";
});
E.on(D.get("getCaptcha"),"click",function()
{
    document.getElementById("getCaptcha").disabled = true;
	sendMobileCaptchaAjax();
});
var timer;
var sendMobileCaptchaAjax=function()
{
	var a=D.get("actionUrl").value;
	a+="?mobile="+escape(D.get("mobile").value);
	a+="&id="+escape(D.get("id").value);

	var b=
	{
		success:function(c)
		{
			var d=c.responseText;
			if(d!="ok")
			{
				if(d.indexOf("<title>登录</title>")>0)
				{
					alert("您的登录已超时，请重新登录");
					self.parent.AP.widget.xBox.hide();
					self.parent.location.reload();
				}else{
					alert(d);
				}
			}else{
				alert("系统已经发送一条手机验证码到您绑定的手机上了，请查收");
                timer=setInterval("time1()",1000);
			}
		},failure:function(c)
		{
			AP.widget.xBox.hide();
			alert("脚本出现错误,请稍后再试。");
		}
	};
	AP.ajax.asyncRequest("POST",a,b)
};
var time=60;
function time1()
{
  if(time==0){
      document.getElementById("getCaptcha").disabled  = false;
      document.getElementById("getCaptcha").value =" 获取验证码 ";
      clearInterval(timer);
      time = 60;
      return false;
  }
    time = time-1;
    document.getElementById("getCaptcha").value = "  剩 余("+time+")  ";
}
</script>
  </body>
</html>