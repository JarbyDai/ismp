    <link charset="utf-8" rel="stylesheet" href="${resource(dir:'css',file:'xbox.css')}" media="all" />
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <g:javascript library="jquery"/>

	<!--修改登录密码 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="loginPass">
			<div class="xbox-title">
				<h2>修改登录密码</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv1">
					<form method="post" action="#" name="" id="loginPassForm" name="loginPassForm">
						<input type="hidden" value="${createLink(controller:'operator',action: 'savechangeloginpass')}" id="actionUrl" name="actionUrl"/>
                    	<fieldset>

                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item">
                    				<label class="fm-label">请输入当前登录密码：</label>
									<input class="i-text" type="password" name="curloginpass" id="curloginpass" value="" maxlength="40"/>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item">
                    				<label class="fm-label">请输入新的登录密码：</label>
									<input class="i-text" type="password" name="newloginpass" id="newloginpass" value="" maxlength="40"/>
									<div class="fm-explain" style="color:red;">密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</div>
                    			</div>
                    			<div class="fm-item">
                    				<label class="fm-label">请确认新的登录密码：</label>
									<input class="i-text" type="password" name="confirm_newloginpass" id="confirm_newloginpass" value="" maxlength="40"/>
									<div class="fm-explain" style="color:red;">密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</div>
                    			</div>
                    			<div class="fm-item fn-clear">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="确定"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--修改登录密码  end xbox -->


%{--<g:if test="${session.cmCustomerOperator.roleSet=='finance'}">--}%
	<!--修改支付密码 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="payPass">
			<div class="xbox-title">
				<h2>修改支付密码</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv1">
  第一步：点击“获取验证码”按钮，系统将会发送一个手机验证码到您绑定的手机上。<br>
  第二步：输入手机上收到的手机验证码、新的支付密码、新的支付密码确认，然后点击“确定”按钮。<br>
					<form method="post" action="#" name="" id="payPassForm" name="payPassForm">
						<input type="hidden" value="${createLink(controller:'operator',action: 'sendDynamicKey')}" id="actionPayUrl1" name="actionPayUrl1"/>
						<input type="hidden" value="${createLink(controller:'operator',action: 'savechangepaypass')}" id="actionPayUrl2" name="actionPayUrl2"/>
                    	<fieldset>
                    		
                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item" style="float:left">
                    				<label class="fm-label">请输入手机验证码：</label>
									<span style="float:left;"><input class="i-text i-text-mobilecaptcha" style="margin:2px;" type="text" name="mobile_captcha" id="mobile_captcha" value="" maxlength="6"/></span><span style="float:left;"><input type="button" class="serchbtn" id="getMC1" value="获取验证码">&nbsp;</span>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item" style="float:left">
                    				<label class="fm-label">请输入新的支付密码：</label>
									<input class="i-text" type="password" name="newpaypass" id="newpaypass" value="" maxlength="40"/>
                                    <div class="fm-explain" style="color:red;">密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</div>
                    			</div>
                    			<div class="fm-item" style="float:left">
                    				<label class="fm-label">请确认新的支付密码：</label>
									<input class="i-text" type="password" name="confirm_newpaypass" id="confirm_newpaypass" value="" maxlength="40"/>
                                    <div class="fm-explain" style="color:red;">密码长度必须大于8位，且必须是数字、字母和特殊字符组合而成</div>
                    			</div>
                    			<div class="fm-item fn-clear" style="float:left">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="确定"></span>
                    			</div>
                    			<div class="fm-item" style="float:left">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--修改支付密码  end xbox -->
%{--</g:if>--}%

		<!--绑定手机 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="bindMobile">
			<div class="xbox-title">
				<h2>绑定手机</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv1">
					<form method="post" action="#" name="" id="bindMobileForm1" name="bindMobileForm1">
						<input type="hidden" value="${createLink(controller: 'operator',action:'bindMobile2')}" id="bindMobileUrl1" name="bindMobileUrl"/>
                    	<fieldset>
                    		<legend>第1步</legend>
                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item">
                    				<label class="fm-label">请输入您要绑定的手机号：</label>
									<input class="i-text" style="margin:2px;" type="text" name="mobile" id="mobile" value="" maxlength="40"/>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear"> 
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="下一步"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
					<form method="post" action="#" name="" id="bindMobileForm2" name="bindMobileForm2" class="fn-hide">
						<input type="hidden" value="${createLink(controller: 'operator',action:'saveBindMobile')}" id="bindMobileUrl2" name="bindMobileUrl2"/>
                    	<fieldset>
                    		<legend>第2步</legend>
                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item">
                    				<label class="fm-label">请输入手机验证码：</label>
									<input class="i-text i-text-mobilecaptcha" type="text" name="bind_mobile_captcha" id="bind_mobile_captcha" value="" maxlength="6"/> 
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear"> 
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="下一步"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--绑定手机  end xbox -->
	<!--修改绑定的手机 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="updateBindMobile">
			<div class="xbox-title">
				<h2>更改手机</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv2">
					<form method="post" action="#" name="updateMobileForm1" id="updateMobileForm1">
                        <input type="hidden" value="${createLink(controller:'operator',action: 'mobileDynamicKey')}" id="actionUpdate1"/>
                        <input type="hidden" value="${createLink(controller: 'operator',action:'updateMobileNew')}" id="updateMobileUrl1"/>
                    	<fieldset>
                    		<legend>第1步:输入原手机校验码</legend>
                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item" style="float:left">
                    				<label class="fm-label">原手机校验码：</label>
                                    <span style="float:left;"><input class="i-text i-text-mobilecaptcha" style="margin:2px;" type="text" id="mobileCaptcha" value="" maxlength="6"/></span><span style="float:left;"><input type="button" class="serchbtn" id="getMC2" value="获取验证码" onclick="get1()"></span>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear" style="float:left">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass1" value="下一步"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
					<form method="post" action="#" id="updateMobileForm2" name="updateMobileForm2" class="fn-hide">
                        <input type="hidden" value="${createLink(controller:'operator',action: 'newMobileDynamicKey')}" id="actionUpdate2"/>
						<input type="hidden" value="${createLink(controller: 'operator',action:'checkMobileInfo')}" id="checkMobileInfo"/>
						<input type="hidden" value="${createLink(controller: 'operator',action:'saveUpdateMobile')}" id="updateMobileUrl2"/>
                    	<fieldset>
                    		<legend>第2步：校验新手机号码</legend>
                    		<div class="fm-input" id="fm-input-key">
                                <div class="fm-item" style="float:left">
                    				<label class="fm-label">新手机号码：</label>
									<input class="i-text" type="text" name="new_mobile" id="new_mobile" value="" maxlength="11"/>
                                    <div id="checkResult" style="display:none;"></div>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item" style="float:left">
                    				<label class="fm-label">新手机验证码：</label>
									<span style="float:left;"><input class="i-text i-text-mobilecaptcha" style="margin:2px;" type="text" name="mobile_captcha2" id="mobile_captcha2" value="" maxlength="6"/></span><span style="float:left;"><input type="button" class="serchbtn" id="getMC3" value="获取验证码"></span>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear" style="float:left;">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="确定"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--修改绑定的手机  end xbox -->

	<!--修改安全校验码 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="apiKeyPass">
			<div class="xbox-title">
				<h2>修改安全校验码</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv1">
					<form method="post" action="#" id="apiKeyPassForm" name="apiKeyPassForm">
						<input type="hidden" value="${createLink(controller:'operator',action: 'savechangeapikey')}" id="apiKeyUrl" name="apiKeyUrl"/>
                    	<fieldset>
                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item">
                    				<label class="fm-label">您现在的安全校验码是：${session.cmCustomer.apiKey}</label><br>
                    				<label class="fm-label">确定修改吗？</label>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="修改"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--修改安全校验码  end xbox -->

	<!--修改个性化信息 xbox -->
	<div class="fn-hide">
		<div  class="xbox-container" id="welcomeMsg">
			<div class="xbox-title">
				<h2>修改个性化信息</h2>
				<a id="J_xbox_colse" href="#" class="xbox-close-link">关闭</a>
			</div>
			<div class="line line-title"></div>
			<div id="mainDiv1">
					<form method="post" action="#" id="welcomeMsgForm" name="welcomeMsgForm">
						<input type="hidden" value="${createLink(controller:'operator',action: 'savechangewelcomemsg')}" id="welcomeMsgUrl" name="welcomeMsgUrl"/>
                    	<fieldset>

                    		<div class="fm-input" id="fm-input-key">
                    			<div class="fm-item">
                    				<label class="fm-label">请输入个性化信息：</label>
									<input class="i-text" name="newwelcomemsg" id="newwelcomemsg" value="" maxlength="15"/>
									<div class="fm-explain"></div>
                    			</div>
                    			<div class="fm-item fn-clear">
                    				 <span><input type="submit" class="btn mglf10" id="submitPass" value="确定"></span>
                    			</div>
                    			<div class="fm-item">
                    				<span class="loading-text fn-hide">
                    					正在处理，请稍候
                    				</span>
                    			</div>
                    		</div>
                    	</fieldset>
                    </form>
			</div>
		</div>
	</div>
	<!--修改个性化信息  end xbox -->

    <script charset="utf-8" src="${resource(dir:'js',file:'xbox.js')}"></script>
    <script charset="utf-8" src="${resource(dir:'js',file:'decode.js')}"></script>
    <script charset="utf-8" src="${resource(dir:'js',file:'xbox_operator.js')}"></script>

<script type="text/javascript" language="javascript">

//E.on(D.get("getMC2"),"click",function()
//{
//	updateMobileCaptcha2();
//});
var timer1;
function get1()
{
	var a=D.get("actionUpdate1").value;
    document.getElementById("getMC2").disabled = true;
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
                timer1=setInterval("timer()",1000);
			}
		},failure:function(c)
		{
			AP.widget.xBox.hide();
			alert("脚本出现错误,请稍后再试")
		}
	};
	AP.ajax.asyncRequest("POST",a,b);
};
var time1=60;
function timer()
{
  if(time1==0){
      document.getElementById("getMC2").disabled  = false;
      document.getElementById("getMC2").value =" 发送验证码 ";
      clearInterval(timer1);
      time1 = 60;
      return false;
  }
    time1 = time1-1;
    document.getElementById("getMC2").value = "  剩 余("+time1+")  ";
}

/*检查手机号有效性*/
E.on(D.get("new_mobile"),"blur",function(){
    if(D.get("new_mobile").value!=""){
      var a=D.get("checkMobileInfo").value;
	  a+="?new_mobile=" + encodeURL(D.get('new_mobile').value.trim());
	var b=
    {
		success:function(c)
		{
			var d=c.responseText;
			if(d != "")
			{
				document.getElementById("checkResult").style.display = "";
                document.getElementById("checkResult").innerText = d;
			}else{
				if(d.indexOf("<title>登录</title>")>0)
				{
					alert("您的登录已超时，请重新登录");
					self.parent.AP.widget.xBox.hide();
					self.parent.location.reload();
				}else{
					document.getElementById("checkResult").style.display = "none";
				}
			}
		},failure:function(c){
                AP.widget.xBox.hide();
                alert(c.responseText);
                alert("脚本出现错误,请稍后再试");
        }
	};
	AP.ajax.asyncRequest("POST",a,b);
    }
});
E.on(D.get("new_mobile"), "focus", function(e) {
         document.getElementById("checkResult").style.display = "none";
    });
</script>