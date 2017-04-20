<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
      <title>修改登录密码</title>
        <meta http-equiv="content-type" content="text/html; charset=GBK"/>
        <meta http-equiv="pragma" content="no-cache"/>
        <meta http-equiv="cache-control" content="no-cache"/>
        <meta http-equiv="cache-control" content="no-store"/>
        <meta http-equiv="expires" content="0"/>
  </head>
  <body>

  修改登录密码：<br>
  <form action="${createLink(controller:'operator',action: 'savechangeloginpass')}" method="post">
      请输入当前登录密码：<input id="password" name="password" type="password" maxlength="40"><br>
      请输入新的登录密码：<input id="newpassword" name="newpassword" type="password" maxlength="40"><br>
      请确认新的登录密码：<input id="confirm_newpassword" name="confirm_newpassword" type="password" maxlength="40"><br>
      <input type="submit" value="下一步"><br>
      ${flash.message.encodeAsHTML()}
  </form>

  </body>
</html>