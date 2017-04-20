<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-修改操作员信息</title>
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
        <g:if test="${session.level3Map != null && session.level3Map['operator/list'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['operator/list'].modelPath}">操作员列表</a>
            </li>
        </g:if>
      <li class="rtncnt blue">修改操作员</li>
    </ul>
  </div>
</div>
<g:form action="update" name="actionForm" style="width:960px; margin:0 auto">
    <g:hiddenField name="id" value="${cmCustomerOperatorInstance?.id}" />
    <g:hiddenField name="version" value="${cmCustomerOperatorInstance?.version}" />
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
            <td width="20%" class="txtRight" scope="col">角 色：</td>
            <td width="21%" class="txtLeft"  scope="col">
                <label for="roleSet"></label>
                <g:select name="roleSet" from="${cmCustomerOperatorInstance.roleSetMap}" value="${cmCustomerOperatorInstance?.roleSet.encodeAsHTML()}" optionKey="key" optionValue="value" />
            </td>
            <td width="59%" class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td class="txtRight" scope="col">姓 名：</td>
            <td  scope="col" class="txtLeft">
                <input type="text" name="name" id="name" value="${cmCustomerOperatorInstance?.name.encodeAsHTML()}" maxLength="32"/>
            </td>
            <td class="txtLeft" scope="col">&nbsp;</td>
          </tr>
          <tr>
            <td scope="col">&nbsp;</td>
            <td  scope="col" class="txtLeft">
              <input type="submit" class="btn mglf10" name="submit_btn" value="确定">

            <input type="button" class="btn mglf10" value="取消" onclick="window.location.href='${createLink(controller:'operator',action:'list')}';">
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

<script>
new AP.widget.Validator(
{
	formId:"actionForm",
	ruleType:"id",
	onSubmit:true,
	onSuccess: function() {

	},
	rules:{
			'name':{required:true,desc:"姓名"}
	}
});
</script>
</body>
</html>
