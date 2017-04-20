%{--<%@ page import="boss.BoNews" %> --}%
<%@ page import="trade.AccountCommandPackage;" %>
%{--<%@ page import="ismp.GetRandom" %>
<%@ page import="javax.servlet.http.Cookie" %> --}%
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝商户服务-登录</title>
    <link href="${resource(dir: 'css', file: 'login.css')}?t=${new Date().getTime()}" rel="stylesheet" type="text/css"/>
    <link href="${resource(dir: 'css', file: 'publicStyle.css')}?t=${new Date().getTime()}" rel="stylesheet" type="text/css"/>
%{--    <script charset="utf-8" src="${resource(dir: 'js', file: 'arale.js')}?t=${new Date().getTime()}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'xbox.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'decode.js')}"></script>
    <SCRIPT src="${resource(dir: 'js', file: 'ScrollPic.js')}" type=text/javascript></SCRIPT>
    <g:javascript library="jquery"/>       --}%
    <script charset="utf-8" src="${resource(dir:'js/jquery',file:'jquery-1.8.2.js')}"></script>

    <style>
    .reload-code {
        margin-left: 5px;
        position: relative;
        top: 0px;
        cursor: pointer;
    }

    .btn {
        border: 0 none;
        cursor: pointer;

        width: 71px;
        height: 26px;

        color: #fff;

        vertical-align: middle;

        text-align: center;

        float: left;

    }

    .btn:hover {
    }

    .baocuo {

        width: 160px;
        height: 20px;
        background: #f3f8fc;;
        line-height: 15px;
        color: #006dba;
        float: left;
        margin: 1px 0 0 15px;
        display: inline;

        border: 1px solid #b2d1ff;

        padding: 2px 0px 0px 2px
    }

    /*字符串截取*/
    .aa {
        height: 30px;
        line-height: 24px;
        margin: 0px;
        color: #000;
    }
    .ocx_style{border:1px solid #7F9DB9; width:130px; height:15px;color:#000; background:#fff}
    .down{border:1px solid #7F9DB9;	line-height: 20px;text-align:center}
    </style>
</head>

<body onload="">
language:<input type="button" value="中文" onclick="location='?lang=zh_CN';">
<input type="button" value="English" onclick="location='?lang=en';">
<div class="login_top txtRight"><div class="login_topcnt"><!--登录 - 注册 | 合利宝首页 | --><a style="color:#fff;" href="http://www.helipay.com/index.html" target="_blank"><g:message code="login.officialWebsite"></g:message> </a> | <g:message code="login.serviceLine"/>：4000-966-263</div>
</div>
<div class="login_menu">
	<div class="login_menucnt">
       <div class="login_logo"><img src="${resource(dir: 'images/login', file: 'logo.gif')}" width="218" height="57" /></div>
    %{--   <div class="login_logo"><img src="images/login/logo.gif" width="218" height="57" /></div>   --}%
      <div class="login_menurt">
          <ul>
              <li><a href="#" class="login_menurtcnt"><g:message code="login.menu.homePage" /></a>

              </li>
              <li><a href="http://www.helipay.com/pro.htm" target="_blank"><g:message code="login.menu.ourProd" /></a></li>
              <li><a href="http://www.helipay.com/Scheme.htm" target="_blank"><g:message code="login.menu.solution" /></a></li>
              <li><a href="${createLink(controller: "merGuide",action: "index")}" target="_blank"><g:message code="login.menu.applyInstruction" /></a></li>
          </ul>
      </div>
  </div>
</div>
<div class="login_ber"><img src="${resource(dir: 'images/login', file: 'ber.jpg')}" width="990" height="415" />
%{--<div class="login_ber"><img src="images/login/ber.jpg" width="990" height="415" />   --}%
     <div class="login_box" style="height:345px;">
     <div id="login_wrap" class="pop-login-wrap">
       <p class="txtLeft fnt14 biaoti b"><g:message code="login.box.userLogin" /></p>
       <div class="login_cuowu" id="welcomeMsgTr" style="display:none">
            <p id="showMsg"></p>
       </div>
       <div class="login_zhengque" id="welcomeMsgTr1" style="display:none">
            <p id="showMsg1"></p>
       </div>
       <div id="login">
             <g:if test="${errmsg}">
                 <div id="loginMsg" class="login_cuowu"><P>${errmsg.encodeAsHTML()}</P></div>
             </g:if>
       </div>
       <!-- 登录 [[ -->
       %{--<g:form id="loginID" action="authenticate" method="post" name="loginForm"  onsubmit="return false;">--}%
       <form action="authenticate" id="loginID" method="post" name="loginForm"  onsubmit="return false;">

            <input type="hidden" name="clientrandom" id="clientrandom" value=""/>
            <input type="hidden" name="loginpwd" id="loginpwd" value=""/>
            <table width="280" class="login_tab">
              <tr>
                <td width="66" class="txtRight fnt14" scope="col"><g:message code="login.box.account" />     </td>
                <td colspan="2" class="txtLeft" scope="col">
                  %{--<input type="text" name="loginname" id="loginname" class="login_input" tabindex="1" maxlength="64" value="${params.loginname}" onblur="queryWelcomeMsg()"/> --}%
                  <input type="text"  name="loginname" id="loginname" class="login_input" tabindex="1" maxlength="64" value="${params.loginname}"/>
                </td>
              </tr>
              <tr>
                <td class="txtRight"><g:message code="login.box.password" /></td>
                <td colspan="2" class="txtLeft">
                    %{--<script type="text/javascript">IntPassGuardCtrl("_ocx_password","0","1","","ocx_style");</script>--}%
                    %{--<script type="text/javascript">SetPassGuardCtrl("_ocx_password",40,"","","");</script>--}%
                    %{--<input type="password" name="loginpwd" id="loginpwd" class="login_input" tabindex="1" maxlength="64" value=""/>--}%
                    <div id="SecEditBoxDiv"></div>
                </td>
              </tr>
                <tr>
                    <td class="txtRight fnt14"><g:message code="login.box.validateCode" /></td>
                    <td width="62" class="txtLeft"><input type="text" name="captcha" id="captcha" class="login_yxm" style="width:60px" tabindex="3" maxlength="4"/></td>
                    <td width="136" class="txtLeft"><img id="LoginCaptcha" class="reload-code" onclick="refreshLoginCaptcha();"  src="${createLink(controller: 'captcha', action: 'index')}" title="点击图片刷新校验码" alt="点击图片刷新校验码" width="80" height="20"/></td>
                </tr>
                <tr>
                    <td class="txtRight fnt14"><g:message code="login.box.phoneCode" /></td>
                    <td width="62" class="txtLeft"><input type="text" name="mobileCaptcha" id="mobileCaptcha" class="login_yxm" style="width:60px" tabindex="3" maxlength="6"  value="${params.mobileCaptcha}" /></td>
                    <td width="136" class="txtLeft"><button type="button" id="yzmBtn" style="width: 85px;line-height: 23px;border: none" onclick="getAuthCodes(this, '${createLink(controller: 'login', action: 'getMobileCaptcha')}');">获取验证码</button><span class="reqiue d-ib" id="yzmst"></span></td>
                </tr>

                <tr>
                <td height="60">&nbsp;</td>
                <td colspan="2">
                    <div class="login_btn">
                        <input id="btn-submit" type="submit" class="login_btn" name="submit_btn" tabindex="4" value="<g:message code="login.box.login" />" />
                    </div>
                </td>
            </tr>
        </table>
    %{--</g:form>--}%
       </form>
     <!-- 登录 ]] -->

       <p class="advisory-phone gray"> <a href="${createLink(controller: 'login', action: 'forget_login')}" target="_parent"><g:message code="login.box.forgetPwd" /></a></p>
   </div>
   </div>
   </div>

   <div class="login_tjfw"><g:message code="login.extra.function" /></div>
   <div class="pra-intro">

   <div class="pra-intro-con"><a href="#" target="_blank"><img src="${resource(dir: 'images/login', file: 'jsq.gif')}" width="329" height="175" /></a></div>

   <div class="pra-intro-con"><a href="#" target="_blank"><img src="${resource(dir: 'images/login', file: 'js2.gif')}" width="329" height="175" /></a></div>

   <div class="pra-intro-con"><a href="#" target="_blank"><img src="${resource(dir: 'images/login', file: 'js1.gif')}" width="315" height="175" /></a></div>

   </div>
   <div class="login_hzjg"><div class="login_hzyh"><h1 style="height:20px;"><span class="left"><g:message code="login.cooperateBank" /></span><span class="right"><a href="http://www.helipay.com/blank.html" target="_blank"> <g:message code="login.more" />>></a></span></h1>

   <ul>
   <li><A href="http://www.icbc.com.cn/" target=_blank><IMG title=进入中国工商银行网站 width="127" height="40" src="${resource(dir: 'images/bankpng', file: 'icbc.png')}"></A></li>
   <li><A href="http://www.abchina.com/" target=_blank><IMG src="${resource(dir: 'images/bankpng', file: 'abc.png')}" width="127" height="40"
                       title=进入中国农业银行网站></A></li>
   <li><A href="http://www.ccb.com/" target=_blank><IMG title=进入中国建设银行网站 width="127" height="40"
                       src="${resource(dir: 'images/bankpng', file: 'ccb.png')}"></A></li>
   <li><A href="http://www.cmbchina.com/" target=_blank><IMG width="127" height="40"
                       title=进入招商银行网站 src="${resource(dir: 'images/bankpng', file: 'cmb.png')}"></A></li>
   <li><A href="http://www.bankcomm.com/" target=_blank><IMG width="127" height="40"
                       title=进入交通银行网站 src="${resource(dir: 'images/bankpng', file: 'bankcomm.png')}"></A></li>
   <li><A href="http://www.cebbank.com/" target=_blank><IMG width="127" height="40" title=进入光大银行网站
                       src="${resource(dir: 'images/bankpng', file: 'ceb.png')}"></A></li>
   <li><A href="http://www.sdb.com.cn/" target=_blank><IMG width="127" height="40"
                       title=进入深圳发展银行网站 src="${resource(dir: 'images/bankpng', file: 'sdb.png')}"></A></li>
   <li><A href="http://www.hxb.com.cn/" target=_blank><IMG width="127" height="40"
                       title=进入华夏银行网站 src="${resource(dir: 'images/bankpng', file: 'hxb.png')}"></A></li>
   <li><A href="http://www.spdb.com.cn/" target=_blank><IMG width="127" height="40" title=进入浦发银行网站
                       src="${resource(dir: 'images/bankpng', file: 'spdb.png')}"></A></li>
   <li><A href="http://www.boc.cn/" target=_blank><IMG title=进入中国银行网站 width="127" height="40"
                       src="${resource(dir: 'images/bankpng', file: 'boc.png')}"></A></li>
   </ul>
   </div>
   <div class="login_gg"><h1><g:message code="login.bulletin" /></h1>
   %{--<ul class="list12" style="height:135px;">--}%
      %{--<g:if test="${newsCount > 4}">--}%
            %{--<marquee scrollAmount="2" scrollDelay="90"  onmouseover="this.stop()" onmouseout="this.start()"  direction="up" style="width:100%;height:100%;">--}%
                %{--<g:each in="${boNews}" var="x" status="i">--}%
                    %{--<g:if test="${i<10 && x.msgColumn=='合利宝'}">--}%
                        %{--<li>${x.dateCreated.format("yyyy-MM-dd")}&nbsp;&nbsp;<a title="${x.content}">${AccountCommandPackage.getContentStr(x.content)}</a></li>--}%
                    %{--</g:if>--}%
                %{--</g:each>--}%
            %{--</marquee>--}%
      %{--</g:if>--}%
      %{--<g:else>--}%
            %{--<g:each in="${boNews}" var="x" status="i">--}%
                %{--<g:if test="${i<10 && x.msgColumn=='合利宝'}">--}%
                    %{--<li>${x.dateCreated.format("yyyy-MM-dd")}&nbsp;&nbsp;<a title="${x.content}">${AccountCommandPackage.getContentStr(x.content)}</a></li>--}%
                %{--</g:if>--}%
            %{--</g:each>--}%
      %{--</g:else>--}%
  %{--</ul>--}%

            <g:if test="${newsCount > 5}">
                <div id="news" style="overflow:hidden;height:135px;">
                    <ul id="news1" class="list12">
                        <g:each in="${boNews}" var="x" status="i">
                            <g:if test="${i==0}">
                                <li>&nbsp;</li>
                            </g:if>
                            <g:if test="${i<10 && x.msgColumn=='合利宝'}">
                                <li>${x.dateCreated.format("yyyy-MM-dd")}&nbsp;&nbsp;<a title="${x.content}">${AccountCommandPackage.getContentStrForLogin(x.content)}</a></li>
                            </g:if>
                        </g:each>
                    </ul>
                    <ul id="news2" class="list12"></ul>
                </div>
            </g:if>
            <g:else>
                <ul class="list12" style="height:160px;">
                    <g:each in="${boNews}" var="x" status="i">
                        <g:if test="${i<10 && x.msgColumn=='合利宝'}">
                            <li>${x.dateCreated.format("yyyy-MM-dd")}&nbsp;&nbsp;<a title="${x.content}">${AccountCommandPackage.getContentStrForLogin(x.content)}</a></li>
                        </g:if>
                    </g:each>
                </ul>
            </g:else>
</div>
</div>
<g:javascript library="jquery.base64"/>
<script src="${resource(dir: 'js', file: 'cfca.js')}" type="text/javascript"></script>
<script type="text/javascript">
    var plugins="";
    window.onload=function(){
        if (top.location.href != this.location.href) {
            top.location.href = this.location.href;
        }
        if (checkIE())  {
            plugins = new CFCA_CONTROL({
                'SecEditBoxObject_X86' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x86.cab')}\" classid=\"clsid:79A6DFE5-41A5-492A-8BD9-EDEC688B480B\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>",
                'SecEditBoxObject_X64' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x64.cab')}\" classid=\"clsid:AC5B3B4E-83A4-4D27-9BA6-2936E6A2B2DB\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>"
            });
        }else {
            alert("请使用IE浏览器");
        }
    }

   //<!CDATA[
    function g(o) {
        return document.getElementById(o);
    }
    function HoverLi(n) {
//如果有N个标签,就将i<=N;
//本功能非常OK,兼容IE7,FF,IE6
        for (var i = 1; i <= 3; i++) {
            g('tb_' + i).className = 'normaltab';
            g('tbc_0' + i).className = 'undis';
        }
        g('tbc_0' + n).className = 'dis';
        g('tb_' + n).className = 'hovertab';
    }
    //如果要做成点击后再转到请将<li>中的onmouseover 改成 onclick;
    //]]>

    function refreshLoginCaptcha() {

        $('#LoginCaptcha').attr("src", "${createLink(controller:'captcha',action:'index')}?" + Math.random() * 100000);

    }

    function init() {
        if (top.location.href != this.location.href) {
            top.location.href = this.location.href;
        }
    }


    var queryWelcomeMsg = function() {

        if ($('#loginname').val().trim() == '' || $('#loginname').val().trim() == '请输入Email或手机号') {

        } else {
            if ($('#loginname').val().toLowerCase().indexOf("where ") != -1) {
                document.getElementById("welcomeMsgTr").style.display = '';
                document.getElementById("showMsg").innerText = "不存在此用户";
                return false;
            }
            var a = "queryWelcomeMsg?loginname=" + encodeURL($('#loginname').val().trim());
            var b =
            {

                success:function(c) {

                    if (document.getElementById("loginMsg")) {
                        document.getElementById("loginMsg").style.display = 'none';
                    }
                    var d = c.responseText;
                    if (d != "false") {
                        document.getElementById("welcomeMsgTr").style.display = 'none';
                        document.getElementById("showMsg").innerText = "";
                        document.getElementById("welcomeMsgTr1").style.display = '';
                        document.getElementById("showMsg1").innerText = d;
                    } else {
                        document.getElementById("welcomeMsgTr1").style.display = 'none';
                        document.getElementById("showMsg1").innerText = '';
                        document.getElementById("welcomeMsgTr").style.display = '';
                        document.getElementById("showMsg").innerText = "不存在此用户";
                    }
                },failure:function(c) {
                AP.widget.xBox.hide();
                alert("脚本出现错误,请稍后再试")
            }
            };
            AP.ajax.asyncRequest("POST", a, b)
        }
    };

    function encodeLoginName(){
        var loginname = $("#loginname").val();
        var username = $("#username");
        username.val($.base64.btoa(loginname));
    }

    var loginBtn = $('#btn-submit')

    E.on(loginBtn, "click", function(e) {
        if(!checkIE()){
            alert("请使用IE浏览器");
            return;
        }

        if ($('#mobileCaptcha').val().trim() == '') {
            alert("请输入手机验证码");
            $('#mobileCaptcha').focus();
            return;
        }

        if(plugins.checkSecEditBoxActiveX() == false || !plugins.checkCryptoKitActiveX() || !plugins.checkCryptoAgentActiveX()){
            alert("请确保安全控件已正确安装！");
            return;
        }

        var clientRandom = plugins.getClientRandom();
        var encryptedPassword = plugins.getEncryptedPassword();
        if(!encryptedPassword){
            alert("密码不能为空");
            return;
        }
        if(!encryptedPassword){
            alert("不支持该浏览器");
            return;
        }
        encodeLoginName();
        var loginForm=document.getElementById("loginID");
        $("#clientrandom").val(clientRandom);
        $("#loginpwd").val(encryptedPassword);
        plugins.setSecEditBoxClear();
//        alert("loginForm:"+loginForm);
        loginForm.submit();

    });


    var txt_loginname = $('#loginname')
    E.on(txt_loginname, "focus", function(e) {

        if (txt_loginname.val() == '请输入Email')txt_loginname.val('');
    });

    E.on(txt_loginname, "blur", function(e) {

        if (txt_loginname.val().trim() == '')txt_loginname.val('请输入Email');

    });

    E.on(txt_loginname, "click", function(e) {
        if (txt_loginname.val() == '')document.getElementById("login").style.display = 'none';

    });


//    function click() {
//        if (event.button==2) {
//            alert("对不起,禁止该功能");
//        }
//    }
//    document.onmousedown=click


    function getAuthCodes(o, path){
        var loginname = document.getElementById("loginname").value;
        if(loginname==""){
            alert('登录名不能为空！！！');
            return false;
        }
        $.get(path, {loginname: loginname, cur: new Date().getTime()}, function(data, status) {
            if(data.status === "0000000000") {
                getCode(o, 60);
            } else {
                alert(data.reason)
            }
        }).fail(function() {alert("内部系统通讯异常，请稍后再试")});
    }
    //获取验证码
    function getCode(obj,n){
        var t=obj.innerHTML;
        (function(){
            if(n>0){
                obj.disabled=true;
                obj.innerHTML='倒计时'+(n--)+'秒';
                setTimeout(arguments.callee,1000);
            }else{
                obj.disabled=false;
                obj.innerHTML=t;
            }
        })();
    }

</script>

</body>
</html>
