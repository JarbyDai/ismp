<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-申请提现</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="prototype"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'PassGuardCtrl1026.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'cfca.js')}"></script>
</head>
<body>
    <g:render template="/layouts/baseInfo"/>
    <input type = "hidden" id="serialNumber" value="${merchant?.serialNumber}"/>
    <input type = "hidden" id="containerName" value="${merchant?.containerName}" />
    <input type = "hidden" id="signCert" value="${merchant?.signCert}" />
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
              <li class="rtncnt blue">申请提现</li>
              <g:if test="${session.level3Map != null && session.level3Map['withdraw/list'] != null}">
                <li>
                    <a href="${request.contextPath}/${session.level3Map['withdraw/list'].modelPath}">提现记录</a>
                </li>
              </g:if>
            </ul>
        </div>
    </div>
    <form  action="save" method="post" name="actionForm" id="actionForm">
        <input type="hidden" name="amount" id="amount" value="${params.amount}">
        <input type="hidden" name="payPass" id="payPass" value=""/>
        <input type="hidden" name="clientrandom" id="clientrandom" value=""/>
        <input type="hidden" name="signContent" id="signContent" value=""/>
        <div class="txbox">
            <dl>
              <dt>您的合利宝账户：</dt>
              <dd>${session.cmCustomer?.name.encodeAsHTML()}&nbsp;(${session.cmCustomerOperator.defaultEmail})</dd>
              <dt>银行名称：</dt>
              <dd>${cmCustomerBankAccount.bankCode}${cmCustomerBankAccount.branch}${cmCustomerBankAccount.subbranch}</dd>
              <dt>开户名：</dt>
              <dd>${cmCustomerBankAccount.bankAccountName}</dd>
              </dl>
              <table class="txtlb">
                <tr>
                  <th colspan="2" scope="col">请确认以下的信息是否正确，以确保您的提款成功。</th>
                </tr>
                <tr>
                  <td width="149" class="txtRight">真实姓名</td>
                  <td width="439" class="txtLeft">${cmCustomerBankAccount.bankAccountName}</td>
                </tr>
                <tr>
                  <td class="txtRight">提现银行账户</td>
                  <td class="txtLeft">${cmCustomerBankAccount.bankAccountNo}</td>
                </tr>
                <tr>
                  <td class="txtRight">提现金额</td>
                  <td class="txtLeft"><span class="doler">${params.amount?.encodeAsHTML()}元</span></td>
                </tr>
              </table>
              <div class="txing">
                <p>到账时间:预计明日24：00之前，请耐心等待</p>
              </div>
            <dl>
              <dt>手机验证码：</dt>
              <dd>
                <input name="mobile_captcha" id="mobile_captcha" type="text" maxlength="6"/>
                <input id="btn_reload" class="serchbtn" type="button" value="获取验证码" />
              </dd>
              <dt>支付密码：</dt>
              <dd style="padding-top:10px;">
                %{--<input name="paypass" id="paypass" type="password" maxlength="40"/>--}%
                  <div id="SecEditBoxDiv"></div>
              </dd>
            </dl>
            <div class="xybbtn">
                <input type="button" class="btn mglf10" value="确认" onclick="dosave()"/>
            </div>
          </div>
    </form>
  </div>

<script>
    var plugins = "";
    window.onload = function(){
        if (checkIE())  {
            plugins = new CFCA_CONTROL({
                'CrytoAgentUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x86.cab')}",
                'CrytoAgentUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x64.cab')}",
                'CryptoKitUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.helipay.x86.cab')}",
                'CryptoKitUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.helipay.x86.cab')}",
                'SecEditBoxObject_X86' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x86.cab')}\" classid=\"clsid:79A6DFE5-41A5-492A-8BD9-EDEC688B480B\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>",
                'SecEditBoxObject_X64' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x64.cab')}\" classid=\"clsid:AC5B3B4E-83A4-4D27-9BA6-2936E6A2B2DB\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>"
            });
        }else {
            alert("请使用IE浏览器");
        }
    }

    E.on('btn_reload','click',function(){
        var btn_reload = D.get("btn_reload");
        btn_reload.disabled = true;
        smsTool.sendCaptcha()
    });

    var Server={
        sendRequest : function(url,data,callback){
            new Ajax.Request(url,{asynchronous:true,evalScripts:true,onSuccess:function(e){callback(e)},parameters:data});
        }
    }

    var timer0;
    var smsTool = {
        sendCaptcha : function(){
            var btn_reload = D.get("btn_reload");
            btn_reload.disabled = true;
            Server.sendRequest('${createLink(controller:'withdraw',action:'sendMobileCaptcha')}','',this.callbackSuccess);
        },
        callbackSuccess : function(response){
            timer0=setInterval("timere()",1000);
//            var btn_reload = D.get("btn_reload");
//            btn_reload.disabled = false;
        }
    }

    var time=60;
    function timere()
    {
      if(time==0){
          document.getElementById("btn_reload").disabled  = false;
          document.getElementById("btn_reload").value =" 获取验证码 ";
          clearInterval(timer0);
          time = 60;
          return false;
      }
        time = time-1;
        document.getElementById("btn_reload").value = "  剩 余("+time+")  ";
    }

    function updateCert(){
        var url = "${request.contextPath}/merchant/updatecert";
        reqAndUpdate(url, plugins,function(data){
            var resultMsg = eval(data);
            if (resultMsg.success == "0") {
                $("#serialNumber").val(resultMsg.serialNumber);
                plugins.installSingleCert(resultMsg.containerName, resultMsg.signCert);
            }
        });
    }

    function downCert(){
        var url = "${request.contextPath}/merchant/downcert";
        reqAndUpdate(url, plugins,function(data){
            var resultMsg = eval(data);
            if(resultMsg.success == "0"){
                $("#serialNumber").val(resultMsg.serialNumber);
                plugins.installSingleCert(resultMsg.containerName, resultMsg.signCert)
            }
        });
    }

     function dosave(){

         if(!checkIE()){
             alert("请使用IE浏览器");
             return;
         }

        if ($('#mobile_captcha').val().trim() == '') {

            alert("请输入手机验证码");

            $('#mobile_captcha').focus();

            return false;

        }

         if(plugins.checkSecEditBoxActiveX() == false || !plugins.checkCryptoKitActiveX() || !plugins.checkCryptoAgentActiveX()){
             alert("请确保安全控件已正确安装！");
             return;
         }

         var clientrandom = plugins.getClientRandom();
         var encryptedPassword = plugins.getEncryptedPassword();
         if(!encryptedPassword){
             alert("密码不能为空");
             return;
         }

         if(!encryptedPassword){
             alert("不支持该浏览器");
             return;
         }

         $("#clientrandom").val(clientrandom);
         $("#payPass").val(encryptedPassword);
         plugins.setSecEditBoxClear();

         if($("#serialNumber").val()){
             if(!plugins.installSingleCert($("#containerName").val(), $("#signCert").val())){
                 updateCert();
             }
         }else{
             downCert();
         }

         if(!plugins.selectCertificate($("#serialNumber").val())){
             alert("浏览器不兼容");
             return;
         }

         var signSource = "amount:"+$('#amount').val()+"|payPass:"+encryptedPassword+"|clientrandom:"+clientrandom;
         var signContent = plugins.sign(signSource);
         $("#signContent").val(signContent);
         $("#actionForm").submit();
     }
</script>
</body>
</html>
