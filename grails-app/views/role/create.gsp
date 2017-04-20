<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-新增角色</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">系统管理：</span>
  <div class="rtnms">
    <ul>
        <g:if test="${session.level3Map != null && session.level3Map['role/list'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['role/list'].modelPath}">角色列表</a>
            </li>
        </g:if>
      <li class="rtncnt blue">新增角色</li>
    </ul>
  </div>
</div>
<g:form action="save" name="actionForm" style="width:960px; margin:0 auto">
    <div class="serchlitst">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${cmCustomerOperatorInstance}">
            <div class="message">
                <g:renderErrors bean="${cmCustomerOperatorInstance}" as="list" />
            </div>
        </g:hasErrors>
        <table class="tlb1">
          <tr>
            <td width="20%" class="txtRight" scope="col">所属系统：</td>
            <td width="21%" class="txtLeft"  scope="col">
                ${roleInstance?.belongSys}
            </td>
            <td width="59%" class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">角色名称：</td>
            <td  scope="col" class="txtLeft">
                <input type="text" id="roleName" name="roleName" value="${roleInstance?.roleName}" maxlength="32"/>
            </td>
            <td class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">创建时间：</td>
            <td  scope="col" class="txtLeft">
                ${roleInstance?.createTime.format("yyyy-MM-dd HH:mm:ss")}
            </td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">状态：</td>
            <td  scope="col" class="txtLeft">
                <g:select name="roleStatus" from="${roleInstance.roleStatusMap}" value="${roleInstance?.roleStatusMap?.encodeAsHTML()}" optionKey="key" optionValue="value"/>
            </td>
          </tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="确定">
              <input type="button" class="btn mglf10" value="取消" onclick="window.location.href='${createLink(controller:'role',action:'list')}';">
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
