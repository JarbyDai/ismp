<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="pragma" content="no-cache"/>
        <meta http-equiv="cache-control" content="no-cache"/>
        <meta http-equiv="cache-control" content="no-store"/>
        <meta http-equiv="expires" content="0"/>
        <meta name="layout" content="main"/>
		<title>合利宝-设置登录密码</title>
</head>
<body>
    <div class="main_box">
        <div class="tipsico"><img src="${resource(dir:'images/info',file:'Gnome.png')}" width="64" height="64" /></div>
        <div class="tipstxt">
          <p>系统已经发送一封重置登录密码的邮件到您的邮箱中，请登录邮箱，点击邮件里面的链接重新设置登录密码。</p>
          <table style="margin-top:30px;">
                     <tr>
                        <td></td>
                        <td></td>
                        <td>
                         <input type="button" class="btn mglf10" value="返回" style="margin-left:16px" onclick="window.location='${createLink(controller:'login',action:'forget_login')}'"/>
                        </td>
                        <td>
                         <input type="button" class="btn mglf10" value="登陆合利宝" style="margin-left:16px" onclick="window.location='${createLink(controller:'login',action:'login')}'"/>
                        </td>
                     </tr>
                 </table>
        </div>
    </div>
</body>
</html>
