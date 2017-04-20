<%@ page import="ismp.Merchant; model.Model" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="layout" content="main"/>
<title>合利宝-接口证书管理</title>
<link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
<script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
<script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
<g:javascript library="jquery"/>
<script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
<script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
<script charset="utf-8" src="${resource(dir: 'js', file: 'cfca.js')}"></script>
<script language="javascript" type="text/javascript">
    window.onload = function () {
        if(checkIE()){
            cfca_control = new CFCA_CONTROL({
                'CrytoAgentUrl_X86' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x86.cab')}",
                'CrytoAgentUrl_X64' : "${resource(dir: 'ocx', file: 'CryptoKit.CertEnrollment.helipay.x64.cab')}"
            });
        }else{
            alert("请使用IE浏览器");
        }
    }

    var cfca_control = "";
    function updateCert(){
        var url = "${request.contextPath}/merchant/updatecert";
        reqAndUpdate(url, cfca_control,function(data){
            var resultMsg = eval(data);
            if (resultMsg.success == "0") {
                if(!cfca_control.installSingleCert(resultMsg.containerName, resultMsg.signCert)){
                    alert("浏览器不兼容，请更换你的浏览器");
                    return;
                }
            }
            alert(resultMsg.message);
            window.location.href = "${request.contextPath}/merchant/certlist";
        });
    }

    function downCert(){
        var url = "${request.contextPath}/merchant/downcert";
        reqAndUpdate(url, cfca_control,function(data){
            var resultMsg = eval(data);
            if(resultMsg.success == "0"){
                if(!cfca_control.installSingleCert(resultMsg.containerName, resultMsg.signCert)){
                    alert("浏览器不兼容");
                    return;
                }
            }
            alert(resultMsg.message);
            window.location.href = "${request.contextPath}/merchant/certlist";
        });
    }

    function submitForm() {
        if(!checkIE()){
            alert("请使用IE浏览器");
            return;
        }

        if(!cfca_control.checkCryptoAgentActiveX()){
            alert("请确保安全控件已正确安装！");
            return;
        }

        if($("#serialNumber").val()){
            if(!cfca_control.installSingleCert($("#containerName").val(), $("#signCert").val())){
                updateCert();
            }else{
                alert("安装成功");
            }
        }else{
            downCert();
        }
    }

    function search(obj) {
        if (obj) {
            if ($("#offset"))
                $("#offset").val('0')
        }
        window.location.href = "${request.contextPath}/merchant/certlist?offset="+$("#offset").val()+"&max="+$("#max").val();
    }

</script>
</head>

<body>
<input type = "hidden" id="serialNumber" value="${merchant?.serialNumber}"/>
<input type = "hidden" id="containerName" value="${merchant?.containerName}" />
<input type = "hidden" id="signCert" value="${merchant?.signCert}" />
<div class="trnmenu">
    <div class="rtnms">
        <ul>
            <li class="rtncnt blue">证书列表</li>
        </ul>
    </div>
</div>

<div class="serchlitst">
    <table class="tlb1">
        <tr>
            <th class="txtCenter" scope="col">证书序列号</th>
            <th class="txtCenter" scope="col">申请时间</th>
            <th class="txtCenter" scope="col">证书有效期</th>
            <th class="txtCenter" scope="col">是否可用</th>
            <th class="txtCenter" scope="col">商户号</th>
            <th class="txtCenter" scope="col">申请人</th>
            <th class="txtCenter" scope="col">操作</th>
        </tr>
        <g:each in="${certList}" status="i" var="cert">
            <tr>
                <td class="txtCenter" scope="col">${cert.serialNumber}</td>
                <td class="txtCenter" scope="col"><g:formatDate date="${cert.createTime}" format="yyyy-MM-dd HH:mm:ss"/></td>
                <td class="txtCenter" scope="col"><g:formatDate date="${cert.applyTime}" format="yyyy/ MM/ dd"/> 到 <g:formatDate
                        date="${cert.expiredTime}" format="yyyy/ MM/ dd"/></td>
                <td class="txtCenter" scope="col">${Merchant.availableMap[cert.available]}</td>
                <td class="txtCenter" scope="col">${customerNo}</td>
                <td class="txtCenter" scope="col">${cert.operator}</td>
                <td class="txtCenter" scope="col">
                    <g:if test="${cert.available == '0' && cert.expiredTime - new Date() < 30}"><!-- 正常使用中 -->
                        <a href="javascript:void(0)" onclick="submitForm('updatecert')" style="color:blue">更新</a>
                    </g:if>
                    <a href="${createLink(action: 'certdetaillist')}/${cert.id}" style="color:blue">详细信息</a>
                </td>
            </tr>
        </g:each>
    </table>

    <div class="page">
        <div class="elxdwn blue"><div onclick="submitForm()" style="cursor: pointer" >申请证书</div></div>
        <g:pageNavi total="${certCount}"/>
    </div>
</div>
</body>
</html>
