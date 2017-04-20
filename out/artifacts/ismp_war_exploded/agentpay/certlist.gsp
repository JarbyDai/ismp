<%@ page import="model.Model" %>
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
    <script>
        function search(obj){
            function createCert() {
                window.location.href = "${createLink(controller:'agentpay',action:'certedit')}";
            }
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">代收付：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">证书列表</li>
        <li>
        <a href="${request.contextPath}/agentpay/certedit">新增证书</a>
        </li>
    </ul>
  </div>
</div>
    <div class="serchlitst">
        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">证书类型</th>
            <th class="txtCenter" scope="col">上传时间</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${certList}" status="i" var="cert">
                <tr>
                    <td class="txtCenter" scope="col">${cert.certName}</td>
                    <td class="blue" scope="col">${cert.certDate?.format('yyyy-MM-dd HH:mm:ss')}</td>
                    <td class="txtCenter" scope="col">
                        <a href="${createLink(controller:'agentpay',action:'certedit')}/${cert.id}" style="color:blue">更新</a>
                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
            <div class="elxdwn blue"><g:link controller="agentpay" action="downcert">合利宝委托结算证书下载</g:link></div>
        </div>
    </div>
</body>
</html>
