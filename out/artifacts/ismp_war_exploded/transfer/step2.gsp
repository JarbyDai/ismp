<%@ page import="ismp.TradeTransfer; ismp.GetRandom" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-转账确认</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="prototype"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'cfca.js')}" type="text/javascript"></script>
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
              <li class="rtncnt blue">单笔转账</li>
              <g:if test="${session.level3Map != null && session.level3Map['transfer/index'] != null}">
                <li>
                    <a href="${request.contextPath}/${session.level3Map['transfer/index'].modelPath}">转账记录</a>
                </li>
              </g:if>
              <g:if test="${session.level3Map != null && session.level3Map['transfer/check'] != null}">
                <li>
                    <a href="${request.contextPath}/${session.level3Map['transfer/check'].modelPath}">转账审核</a>
                </li>
              </g:if>
            </ul>
        </div>
    </div>
  <form action="save" method="post" name="actionForm" id="actionForm">
    <input type="hidden" id="to" name="to" value="${params.to}">
    <input type="hidden" id="amount" name="amount" value="${params.amount}">
    <input type="hidden" id="subject" name="subject" value="${params.subject}">
    <input type="hidden" id="comment" name="comment" value="${params.comment}">
    <input type="hidden" id="payPass" name="payPass"  value=""/>
    <input type="hidden" id="clientrandom" name="clientrandom" value=""/>
    <input type="hidden" name="signContent" id="signContent" value=""/>
  <div class="txbox">
  	<dl>
    	<dt>对方账户：</dt>
        <dd>${params.to.encodeAsHTML()}</dd>
        <dt>对方姓名：</dt>
        <dd>${customerOperator_payee.name}</dd>
        <g:if test="${customerOperator_payee.customer.type in ['C','A']}">
            <dt>对方公司名称：</dt>
            <dd>${customerOperator_payee.customer.registrationName}</dd>
        </g:if>
        <dt>付款理由：</dt>
        <dd>${params.subject?.encodeAsHTML()}</dd>
        <dt>备注：</dt>
        <dd>${params.comment?.encodeAsHTML()}</dd>
        </dl>
        <dl>
        <table class="txtlb">
            <tr>
              <th colspan="2" scope="col">请确认以下的信息是否正确，以确保您的转账成功。</th>
            </tr>
            <tr>
              <td width="149" class="txtRight">对方账户</td>
              <td width="439" class="txtLeft">${params.to.encodeAsHTML()}</td>
            </tr>
            <tr>
              <td class="txtRight">付款金额</td>
              <td class="txtLeft"><span class="doler">${params.amount.encodeAsHTML()}元</span></td>
            </tr>
        </table>
        </dl>
        <dl>
          <dt>手机验证码：</dt>
          <dd>
            <input name="mobile_captcha" id="mobile_captcha" type="text" maxlength="6"/>
            <input id="btn_reload" class="serchbtn" type="button" value="获取验证码" />
          </dd>
          <dt>支付密码：</dt>
          <dd style="padding-top: 10px;">
            %{--<input name="paypass" id="paypass" type="password" maxlength="40"/>--}%
              <div id="SecEditBoxDiv"></div>
          </dd>
            <dt>选择到账时间：</dt>
          <dd>
            <g:select name="delayTime" value="${params.delayTime}" from="${TradeTransfer.delayTimeMap}" style="margin-top: 18px" optionKey="key" optionValue="value" />
          </dd>
    </dl>
    <div class="xybbtn">
        <input type="button" class="btn mglf10" value="确认" onclick="doSave()"/>
    </div>
  </div>
  </form>
  </div>

<script type="text/javascript">
AralePreload = [];
var AP = AP || {};
</script>
    <script>
        E.onDOMReady(function(){
            new AP.widget.Validator({
            formId: "actionForm",
            ruleType:"id",
            onSubmit: true,
            loadClass: "loading-text",
            errorTrack: true,
            onSuccess: function() {
                //新开窗口时需要使按钮不可点
                var submitBtn = D.query(':submit',D.get(this.formId))[0];
                D.addClass(submitBtn.parentNode, 'btn-ok-disabled');
                submitBtn.disabled = true;
            },
            rules: {
                'paypass':{
                    required: true,
                    desc: '支付密码'
                },
                'captcha_mobile':{
                    required: true,
                    desc: '手机验证码'
                }
              }
            });
    });

    E.on('btn_reload','click',function(){
        var btn_reload = D.get("btn_reload");
        btn_reload.disabled = true;
        smsTool.sendCaptcha();
    });

    var Server={
        sendRequest : function(url,data,callback){
            new Ajax.Request(url,{asynchronous:true,evalScripts:true,onSuccess:function(e){callback(e)},parameters:data});
        }
    }

    var timer0;
    var smsTool = {
        sendCaptcha : function(type){
            Server.sendRequest('${createLink(controller:'transfer',action:'sendMobileCaptcha')}','',this.callbackSuccess);
        },
        callbackSuccess : function(response){
            timer0=setInterval("timere()",1000);
//            var btn_reload = D.get("btn_reload");
//            btn_reload.disabled = false;
        }
    }

    var time=60;
    function timere(){
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

    var plugins = "";
    window.onload = function(){
        if (checkIE())  {
            plugins = new CFCA_CONTROL({
                'CrytoAgentUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x86.cab')}",
                'CrytoAgentUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x64.cab')}",
                'CryptoKitUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.Ultimate.x86.cab')}",
                'CryptoKitUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.Ultimate.x86.cab')}",
                'SecEditBoxObject_X86' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x86.cab')}\" classid=\"clsid:79A6DFE5-41A5-492A-8BD9-EDEC688B480B\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>",
                'SecEditBoxObject_X64' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x64.cab')}\" classid=\"clsid:AC5B3B4E-83A4-4D27-9BA6-2936E6A2B2DB\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>"
            });
        }else {
            alert("请使用IE浏览器");
        }
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

    function doSave(){
        if(!checkIE()){
            alert("请使用IE浏览器");
            return;
        }

        if ($('#mobile_captcha').val().trim() == '') {
            alert("请输入手机验证码");
            $('#mobile_captcha').focus();
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
        $("#clientrandom").val(clientRandom);
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

        var signSource = "amount:"+$("#amount").val();
        signSource += "|payPass:"+encryptedPassword;
        signSource += "|to:"+$("#to").val();
        signSource += "|subject:"+$("#subject").val();
        signSource += "|comment:"+$("#comment").val();

        var signContent = plugins.sign(signSource);
        $("#signContent").val(signContent);
        $("#actionForm").submit();
    }
</script>
</body>
</html>
