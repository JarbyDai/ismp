<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-服务信息</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">服务类型</th>
            <th class="txtCenter" scope="col">生效时间</th>
            <th class="txtCenter" scope="col">到期时间</th>
            <th class="txtCenter" scope="col">状态</th>
            <th class="txtCenter" scope="col">详情</th>
          </tr>
            <g:each in="${boCustomerServiceList}" status="i" var="boCustomerService">
                <tr>
                    <td class="txtCenter" scope="col">${boCustomerService.serviceMap[boCustomerService.serviceCode]}</td>
                    <td class="blue" scope="col">${boCustomerService.startTime?.format('yyyy-MM-dd HH:mm:ss')}</td>
                    <td class="blue" scope="col">${boCustomerService.endTime?.format('yyyy-MM-dd HH:mm:ss')}</td>
                    <td class="txtCenter" scope="col">
                        <g:if test="${boCustomerService.enable==true}">
                            <strong style="color:green">有效</strong>
                        </g:if>
                        <g:else>
                            <strong style="color:red">过期</strong>
                        </g:else>
                    </td>
                    <td class="txtCenter" scope="col">
                        <g:if test="${session.level3Map != null && session.level3Map['merchant/servicedetail'] != null}">
                            <a href="${request.contextPath}/${session.level3Map['merchant/servicedetail'].modelPath}/${boCustomerService.id}" style="color:blue">查看</a>
                        </g:if>
                    </td>
                </tr>
            </g:each>
        </table>
    </div>
</body>
</html>
