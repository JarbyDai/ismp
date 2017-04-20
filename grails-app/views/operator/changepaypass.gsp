<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <title>修改支付密码</title>
      <meta http-equiv="pragma" content="no-cache"/>
      <meta http-equiv="cache-control" content="no-cache"/>
      <meta http-equiv="cache-control" content="no-store"/>
      <meta http-equiv="expires" content="0"/>
      <g:javascript library="prototype" />
      <style>
      #message{
          color:green
      }
      #error{
          color:red
      }
      </style>
      <script>
        function step1()
        {
          $("message").innerText='您的操作已提交，请稍候...';
          $("btn1").hide();
          $("error").innerText='';
          new Ajax.Request('${createLink(controller:'operator',action:'sendDynamicKey')}',
                {
                    asynchronous:true,
                    evalScripts:true,
                    onSuccess:function(e){
                        step1_res(e)
                    }
                }
          );
          return false;
        }
        function step1_res(response)
        {
          $("message").innerText='';
          if(response.responseText!='ok')
          {
              $("error").innerHTML=response.responseText;
              $("btn1").show();
          }else{
              $("error").innerHTML='';
              $("btn1").hide();
              $("layer2").show();
          }
        }

        function savePaypass()
        {
            $("message").innerHTML='您的操作已提交，请稍候...';
            $("btn2").hide();
            $("error").innerHTML='';
            var formparams="mobile_captcha="+$("mobile_captcha").value+"&newpassword="+$("newpassword").value+"&confirm_newpassword="+$("confirm_newpassword").value;
            new Ajax.Request('${createLink(controller:'operator',action:'savechangepaypass')}',{asynchronous:true,evalScripts:true,onSuccess:function(e){savePaypass_res(e)},parameters:formparams});
            return false;
        }
        function savePaypass_res(response)
        {
          $("message").innerText='';
          if(response.responseText!='ok')
          {
              $("error").innerHTML=response.responseText;
              $("btn2").show();
          }else{
              $("error").innerHTML='';
              $("message").innerHTML='修改支付密码成功';
          }
        }
      </script>
  </head>
  <body>

  修改支付密码：<br>
  第一步：点击“获取动态口令码按钮”，系统将会发送一个动态口令到您绑定的手机上。<br>
  第二步：输入手机上收到的动态口令码、新的支付密码、新的支付密码确认，然后点击“确定”按钮。<br><br>
  <div id="layer1">
      <span id="btn1"><input type="button" value="获取动态口令码" onclick="step1()"><br></span>
  </div>

  <div id="layer2" style='display:none'>
      请输入您手机上收到的验证码：<input id="mobile_captcha" name="mobile_captcha" type="text" maxlength="40"><br>
      请输入新的支付密码：<input id="newpassword" name="newpassword" type="password" maxlength="40"><br>
      请确认新的支付密码：<input id="confirm_newpassword" name="confirm_newpassword" type="password" maxlength="40"><br>
      <span id="btn2"><input type="button" value="下一步" onclick="savePaypass();"><br></span>
  </div>

  <div id="message"></div>
  <div id="error"></div>

  </body>
</html>