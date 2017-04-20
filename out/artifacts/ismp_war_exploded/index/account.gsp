<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-首页</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script>
        var plugins = "";
        window.onload = function(){
            if (checkIE())  {
                plugins = new CFCA_CONTROL({
                    'CrytoAgentUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x86.cab')}",
                    'CrytoAgentUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x64.cab')}",
                    'CryptoKitUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.Ultimate.x86.cab')}",
                    'CryptoKitUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.Ultimate.x64.cab')}",
                    'SecEditBoxObject_X86' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x86.cab')}\" classid=\"clsid:79A6DFE5-41A5-492A-8BD9-EDEC688B480B\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>",
                    'SecEditBoxObject_X64' : "<object id=\"SecEditBox\" codebase=\"${resource(dir:'/ocx',file:'SecEditCtl.HELIPAY.x64.cab')}\" classid=\"clsid:AC5B3B4E-83A4-4D27-9BA6-2936E6A2B2DB\" width=\"155\" height=\"25\"><param name=\"MinLength\" value=\"6\"/><param name=\"MaxLength\" value=\"16\"/><param name=\"IntensityRegExp\" value=\"(^[!-~]*[A-Za-z]+[!-~]*[0-9]+[!-~]*$)|(^[!-~]*[0-9]+[!-~]*[A-Za-z]+[!-~]*$)\"/><param name=\"ServerRandom\" value=${servernum}/></object>"
                });
            }else {
                alert("请使用IE浏览器");
            }
        }
    </script>
</head>
<body>
    <g:render template="/layouts/baseInfo"/>
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
      <div class="zjjyb">
        <div class="zxggtlt">
          <p><span class="zxgcnt">最新交易列表&nbsp;</span>
            <g:if test="${session.level3Map != null && session.level3Map['trade/account'] != null}">
                <span>| <a href="${request.contextPath}/${session.level3Map['trade/account'].modelPath}">账务明细</a></span>
            </g:if>
            <g:if test="${session.level3Map != null && session.level3Map['charge/list'] != null}">
                <span>| <a href="${request.contextPath}/${session.level3Map['charge/list'].modelPath}">充值记录</a></span>
            </g:if>
            <g:if test="${session.level3Map != null && session.level3Map['withdraw/list'] != null}">
                <span>| <a href="${request.contextPath}/${session.level3Map['withdraw/list'].modelPath}">提现记录</a></span>
            </g:if>
            <g:if test="${session.level3Map != null && session.level3Map['trade/refund'] != null}">
                <span>| <a href="${request.contextPath}/${session.level3Map['trade/refund'].modelPath}">退款记录</a></span>
            </g:if>
          </p>
        </div>
        <table class="tlb1">
            <g:each in="${tradeList}" status="i" var="trade">
              <tr>
                <td width="20%" scope="col">${trade.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                <td width="46%"  scope="col" class="blue">${trade.tradeTypeMap[trade.tradeType]}</td>
                <td width="9%" class="txtCenter" scope="col">
                    <strong class="hsfong" style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.amount/100}" type="currency"/></strong>
                </td>
                <td width="14%" class="txtCenter" scope="col">${ismp.TradeBase.statusMap[trade.status]}</td>
                <td width="11%" class="txtCenter" scope="col">
                   <g:if test="${session.level3Map != null && session.level3Map['trade/buyDetail'] != null}">
                        <a href="${request.contextPath}/${session.level3Map['trade/buyDetail'].modelPath}/${trade.id}" style="color:blue">详细</a>
                   </g:if>
                </td>
              </tr>
             </g:each>
        </table>
      </div>
      <div class="ad1"><img src="${resource(dir: 'images/rongimg', file: 'ad1.png')}" width="693" height="107" /></div>
    </div>
</body>
</html>
