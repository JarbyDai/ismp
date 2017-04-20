<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-设置登录密码</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="prototype"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
<div class="trnmenu">
    <span class="left trnmenutlt">设置登录密码：</span>
</div>
<form action="${createLink(controller:'login',action: 'saveBindMobile')}" name="actionForm" id="actionForm" style="width:960px; margin:0 auto">
    <input type="hidden" name="method" value="email">
    <input type="hidden" name="id" value="${cmCustomerOperatorId}">
    <input type="hidden" name="verification" value="${verification}">
    <div class="serchlitst">
        <table class="tlb1">
          <tr>
            <td class="txtRight" scope="col">
                <label for="mobile">请输入您要绑定的手机号：</label>
            </td>
            <td class="txtLeft" scope="col">
                <input type="text" id="mobile" name="mobile" value="" maxLength="64"/>
            </td>
            <td class="txtLeft" scope="col">
            </td>
          </tr>
          <tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="下一步">
              <input type="button" class="btn mglf10" value="登陆合利宝" style="margin-left:16px" onclick="window.location='${createLink(controller:'login',action:'login')}'"/>
            </td>
            <td class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtCenter" scope="col">&nbsp;</td>
            <td scope="col">&nbsp;</td>
            <td scope="col">&nbsp;</td>
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
                'mobile':{
                    minLength:11,
                    required:true,
                    depends:true,
                    desc:"手机号"
                }
        }
    });
    E.on('mobile','focus',function(){
        if(D.get("loginMsg").innerHTML!="")
            D.get("loginMsg").innerHTML="";
    });
</script>
</body>
</html>