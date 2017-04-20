<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-新增操作员</title>
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
  <span class="left trnmenutlt">系统管理：</span>
  <div class="rtnms">
    <ul>
        <g:if test="${session.level3Map != null && session.level3Map['operator/list'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['operator/list'].modelPath}">操作员列表</a>
            </li>
        </g:if>
      <li class="rtncnt blue">新增操作员</li>
    </ul>
  </div>
</div>
<g:form action="save" name="actionForm" style="width:960px; margin:0 auto">
    <input type="hidden" value="${createLink(controller:'operator',action: 'sendMobileCaptcha')}" id="actionUrl" name="actionUrl"/>
    <div class="serchlitst">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${cmCustomerOperatorInstance}">
            <div class="message">
                <g:renderErrors bean="${cmCustomerOperatorInstance}" as="list" />
            </div>
        </g:hasErrors>
        <table class="tlb1">
          <tr>
            <td width="20%" class="txtRight" scope="col">角 色：</td>
            <td width="21%" class="txtLeft"  scope="col">
                <label for="roleSet"></label>
                <g:select name="roleSet" from="${cmCustomerOperatorInstance.roleSetMap}" value="${cmCustomerOperatorInstance?.roleSet?.encodeAsHTML()}" optionKey="key" optionValue="value"  />
            </td>
            <td width="59%" class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">姓 名：</td>
            <td  scope="col" class="txtLeft">
                <input type="text" name="name" id="name" value="${cmCustomerOperatorInstance?.name?.encodeAsHTML()}" maxLength="32"/>
            </td>
            <td class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">Email：</td>
            <td  scope="col" class="txtLeft">
                <input type="text" id="defaultEmail" name="defaultEmail" value="${cmCustomerOperatorInstance?.defaultEmail?.encodeAsHTML()}" maxLength="64"/>
            </td>
            <td class="txtLeft" scope="col">
                此Email为登录时的账户名，不可更改。<br/>
                成功添加操作员后，请通知该操作员登录邮箱，根据邮件提示设置登录密码。
            </td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">手机验证码：</td>
            <td  scope="col" class="txtLeft">
                <input type="text" style="width:70px;" id="mobile_captcha" name="mobile_captcha" value="" maxLength="6"/>
                <input type="button" class="serchbtn" id="btn_reload" name="btn" value="获取验证码" />
            </td>
            <td class="txtLeft" scope="col">点击“获取验证码”按钮，输入您手机上收到的验证码。</td>
          </tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="确定">

            <input type="button" class="btn mglf10" value="取消" onclick="window.location.href='${createLink(controller:'operator',action:'list')}';">
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
</g:form>

<script type="text/javascript" language="javascript">

    E.on(D.get("btn_reload"),"click",function()
    {
        sendMobileCaptchaAjax();
        document.getElementById("btn_reload").disabled = true;
    });
    var timer;
    var sendMobileCaptchaAjax=function()
    {
        var a=D.get("actionUrl").value;

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
                alert("脚本出现错误,请稍后再试")
            }
        };
        AP.ajax.asyncRequest("POST",a,b)
    };
    var time=60;
    function time1()
    {
      if(time==0){
          document.getElementById("btn_reload").disabled  = false;
          document.getElementById("btn_reload").value =" 发送验证码 ";
          clearInterval(timer);
          time = 60;
          return false;
      }
        time = time-1;
        document.getElementById("btn_reload").value = "  剩 余("+time+")  ";
    }

    /*检查邮箱有效性*/
    E.on(D.get("defaultEmail"),"blur",function()
    {
        var a="checkEmailInfo?defaultEmail=" + encodeURL($('#defaultEmail').val().trim());

        var b=
        {

            success:function(c)
            {
                var d=c.responseText;
                if(d != "false")
                {
                    document.getElementById("checkresult").style.display = ""
                    document.getElementById("checkresult").innerText = d;
                }else{
                    if(d.indexOf("<title>登录</title>")>0)
                    {
                        alert("您的登录已超时，请重新登录");
                        self.parent.AP.widget.xBox.hide();
                        self.parent.location.reload();
                    }else{
                        alert(d);
                    }
                }
            }
        };
        AP.ajax.asyncRequest("POST",a,b)
    });

    E.on($('#defaultEmail'), "focus", function(e) {
         document.getElementById("checkresult").style.display = "none"
    });

    new AP.widget.Validator(
    {
        formId:"actionForm",
        ruleType:"id",
        onSubmit:true,
        onSuccess: function() {

        },
        rules:{
                'name':{required:true,desc:"姓名"},
                'mobile_captcha':{required:true,desc:"手机验证码"},
                'defaultEmail':{type:'email',required:true,desc:"Email"}
        }
    });
</script>
</body>
</html>
