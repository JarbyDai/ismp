<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-设置登录密码</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
<div class="trnmenu">
    <span class="left trnmenutlt">设置登录密码：</span>
</div>
<form action="${createLink(controller:'login',action:'resetlogin')}" name="actionForm" id="actionForm" style="width:960px; margin:0 auto">
    <div class="serchlitst">
        <table class="tlb1">
          <tr>
            <td width="20%" class="txtRight" scope="col">
                <label for="loginname">Email：</label>
            </td>
            <td width="25%" class="txtLeft" scope="col">
                <input type="text" id="loginname" name="loginname" value="" maxLength="64"/>
                <div id="loginMsg" style="color:red">${flash.message?.encodeAsHTML()}</div>
            </td>
            <td width="55%" class="txtLeft" scope="col">
                此Email为登录时的账户名。<br/>
                点击“下一步”，系统会发一封邮件到您的登陆邮箱，请根据邮件提示设置登录密码。
            </td>
          </tr>
          <tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="下一步">

            <input type="button" class="btn mglf10" value="取消" onclick="window.location.href='${createLink(controller:'login',action:'login')}';">
            </td>
            <td class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="blue">&nbsp;</td>
            <td class="txtCenter" scope="col">&nbsp;</td>
          </tr>
        </table>
    </div>
</form>

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
			'loginname':{
				type:["email", "mobile"],
				required:true,
				depends:true,
				desc:"Email"
			}
	}
});
E.on('loginname','focus',function(){
	if(D.get("loginMsg").innerHTML!="")
		D.get("loginMsg").innerHTML="";
});
</script>
</body>
</html>