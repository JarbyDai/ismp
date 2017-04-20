<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-接口证书更新</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">代收付：</span>
  <div class="rtnms">
    <ul>
        <li>
        <a href="${request.contextPath}/${session.level3Map['agentpay/certlist'].modelPath}">证书列表</a>
        </li>
        <li class="rtncnt blue">更新证书</li>
    </ul>
  </div>
</div>
<g:form method="post" controller="agentpay" action="certreupload" enctype="multipart/form-data" style="width:960px; margin:0 auto">
    <g:hiddenField name="bizId" value="${bizId}" />
    <div class="serchlitst">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <table class="tlb1">
          <tr>
            <td width="60%" class="txtLeft b" scope="col" colspan="2" style="color:red;padding-left:35px;">
                更新证书将会使原有证书被覆盖，请谨慎操作！
            </td>
            <td width="40%" class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">选择证书：</td>
            <td  scope="col" class="txtLeft">
                <input type="file" name="certFile" style="width:350px;height:24px;"/>
            </td>
          </tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="确定">
              <input type="button" class="btn mglf10" value="取消" onclick="window.location.href='${createLink(controller:'agentpay',action:'certlist')}';">
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
</body>
</html>
