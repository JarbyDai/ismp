<%@ page import="model.Model" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-角色管理</title>
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
      <li class="rtncnt blue">角色列表</li>
        <g:if test="${session.level3Map != null && session.level3Map['role/create'] != null}">
            <li>
            <a href="${request.contextPath}/${session.level3Map['role/create'].modelPath}">新增角色</a>
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
            <th class="txtCenter" scope="col">角色名称</th>
            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${roleInstanceList}" status="i" var="roleList">
                <tr>
                    <td class="txtCenter" scope="col">${roleList.roleName}</td>
                    <td class="blue" scope="col">${roleList.createTime.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${roleList.roleStatusMap[roleList.roleStatus]}</td>
                    <td class="txtCenter" scope="col">
                            <g:if test="${(roleList.id != session.role.id[0]) && (roleList.customerId != '0')}">
                                <g:if test="${session.level3Map != null && session.level3Map['model/list'] != null}">
                                    <a href="${request.contextPath}/${session.level3Map['model/list'].modelPath}/${roleList.id}" style="color:blue">权限设置</a>
                                </g:if>
                                <g:if test="${session.level3Map != null && session.level3Map['role/edit'] != null}">
                                    <g:if test="${session.level3Map != null && session.level3Map['model/list'] != null}">|</g:if>
                                    <a href="${request.contextPath}/${session.level3Map['role/edit'].modelPath}/${roleList.id}" style="color:blue">名称修改</a>
                                </g:if>
                                <g:if test="${session.level3Map != null && session.level3Map['role/updateStatus'] != null}">
                                     <g:if test="${(session.level3Map != null && session.level3Map['model/list'] != null) || (session.level3Map != null && session.level3Map['role/edit'] != null)}">|</g:if>
                                    <a href="${request.contextPath}/${session.level3Map['role/updateStatus'].modelPath}/${roleList.id}" style="color:blue"><g:if test="${roleList.roleStatus=='normal'}">关闭</g:if><g:elseif test="${roleList.roleStatus=='close'}">启动</g:elseif></a>
                                </g:if>
                                <g:if test="${session.level3Map != null && session.level3Map['role/remove'] != null}">
                                    <g:if test="${(session.level3Map != null && session.level3Map['model/list'] != null) || (session.level3Map != null && session.level3Map['role/edit'] != null) || (session.level3Map != null && session.level3Map['role/updateStatus'] != null)}">|</g:if>
                                    <a href="${request.contextPath}/${session.level3Map['role/remove'].modelPath}/${roleList.id}" onclick="return confirm('确定删除此角色吗？')" style="color:blue">删除</a>
                                </g:if>
                            </g:if>
                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
          <g:pageNavi total="${roleInstanceTotal}"/>
          </div>
    </div>
</form>
</body>
</html>
