<%@ page import="ismp.UserAESUtils; role.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-操作员管理</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script>
        function search(obj){
            if(obj){
                if($("offset"))
                $("offset").value=0;
            }
            document.getElementById("searchform").submit();
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">系统管理：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">操作员列表</li>
        <g:if test="${session.level3Map != null && session.level3Map['operator/create'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['operator/create'].modelPath}">新增操作员</a>
            </li>
        </g:if>
    </ul>
  </div>
</div>
<form action="list" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div class="serchlitst">
        <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
        </g:if>
        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">姓名</th>
            <th class="txtCenter" scope="col">主Email</th>
            <th class="txtCenter" scope="col">主手机</th>
            <th class="txtCenter" scope="col">角色</th>
            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${cmCustomerOperatorInstanceList}" status="i" var="cmCustomerOperator">
                <tr>
                    <td class="txtCenter" scope="col">${cmCustomerOperator.name.encodeAsHTML()}</td>
                    <td class="txtCenter" scope="col">${cmCustomerOperator.defaultEmail.encodeAsHTML()}</td>
                    <td class="txtCenter" scope="col">${cmCustomerOperator.defaultMobile?cmCustomerOperator?.defaultMobile?.encodeAsHTML():"未绑定手机"}</td>
                    <td class="txtCenter" scope="col"><g:if test="${cmCustomerOperator.roleSet}">${Role.get(Integer.valueOf(cmCustomerOperator.roleSet))?.roleName}</g:if></td>
                    <td class="blue" scope="col">${cmCustomerOperator.dateCreated.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${cmCustomerOperator.statusMap[cmCustomerOperator.status]}</td>
                    <td class="txtCenter" scope="col">
                        <g:if test="${cmCustomerOperator.id!=session.cmCustomerOperator.id}">
                            <g:if test="${session.level3Map != null && session.level3Map['operator/updateStatus'] != null}">
                                <a href="${request.contextPath}/${session.level3Map['operator/updateStatus'].modelPath}/${cmCustomerOperator.id}" style="color:blue"><g:if test="${cmCustomerOperator.status=='normal'}">停用</g:if><g:if test="${cmCustomerOperator.status=='disabled'}">启用</g:if><g:if test="${cmCustomerOperator.status=='locked'}">解锁</g:if><g:if test="${cmCustomerOperator.status=='deleted'}">　　</g:if></a>
                           </g:if>
					       <g:if test="${session.level3Map != null && session.level3Map['operator/resetLoginPass'] != null}">
                               <g:if test="${session.level3Map != null && session.level3Map['operator/updateStatus'] != null}">|</g:if>
                                <a href="${request.contextPath}/${session.level3Map['operator/resetLoginPass'].modelPath}/${cmCustomerOperator.id}" style="color:blue">重置登录密码</a>
                           </g:if>
                           <g:if test="${session.level3Map != null && session.level3Map['operator/edit'] != null}">
                               <g:if test="${(session.level3Map != null && session.level3Map['operator/updateStatus'] != null) || (session.level3Map != null && session.level3Map['operator/resetLoginPass'] != null)}">|</g:if>
                                <a href="${request.contextPath}/${session.level3Map['operator/edit'].modelPath}/${cmCustomerOperator.id}" style="color:blue">修改</a>
                           </g:if>
                         </g:if>
                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
          <g:pageNavi total="${cmCustomerOperatorInstanceTotal}"/>
          </div>
    </div>
</form>
</body>
</html>
