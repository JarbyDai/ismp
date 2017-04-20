<%@ page import="dsf.TbAgentpayDetailsInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-封箱订单</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-1.8.2.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-1.9.0.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-timepicker-addon-chn.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script type="text/javascript">
        function search(obj){
            if(obj){
                if($("offset"))
                $("offset").value=0;
            }
            $("#searchform").submit();
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">代收付：</span>
  <div class="rtnms">
    <ul>
      <li class="rtncnt blue">批次明细</li>
    </ul>
  </div>
</div>
<g:form action="boxlist" method="post" name="searchform" style="width:960px; margin:0 auto">
    <g:hiddenField name="format"/>
    <g:hiddenField name="id" value="${batch.id}"/>
    <div class="serch">
      <p>基本信息</p>
          <table class="serchtlb">
          <tr>
            <td width="252" scope="col">
                商户名称：${session.cmCustomer.name}
            </td>
            <td  width="252" scope="col">
                上传文件名：${batch.batchFilename}
            </td>
            <td  width="252" scope="col">
                业务类型：<g:if test="${batch.batchType=='S'}">代收业务</g:if><g:if test="${batch.batchType=='F'}">代付业务</g:if>
            </td>
          </tr>
          <tr>
            <td scope="col">
                &nbsp;&nbsp;总笔数：<strong style="color:green">${batch.batchCount}</strong>&nbsp;笔
            </td>
            <td scope="col">
                &nbsp;&nbsp;&nbsp;&nbsp;总金额：<strong style="color:red"><g:formatNumber currencyCode="CNY" number="${batch.batchAmount}" type="currency"/></strong>&nbsp;元
            </td>
            <td scope="col">
                <input type="button" name="btnSub" id="btnSub" class="serchbtn" value="确认提交" onclick="mysubmit('${batch.id}')"/>
            </td>
          </tr>
        </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">序号</th>
            <th class="txtCenter" scope="col">开户名</th>
            <th class="txtCenter" scope="col">客户账号</th>
            <th class="txtCenter" scope="col">公/私</th>
            <th class="txtCenter" scope="col">金额（元）</th>
            <th class="txtCenter" scope="col">币种</th>
            <th class="txtCenter" scope="col">手机号</th>
            <th class="txtCenter" scope="col">证件类型</th>
            <th class="txtCenter" scope="col">证件号</th>
            <g:if test="${batch.batchType=='S'}">
                <th class="txtCenter" scope="col">用户协议号</th>
            </g:if>
            <th class="txtCenter" scope="col">备注</th>
            <th class="txtCenter" scope="col">检验结果</th>
            <th class="txtCenter" scope="col">操作</th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr style="height:80px;">
                    <td class="txtCenter" scope="col">${trade.tradeNum}</td>
                    <td class="txtCenter" scope="col">${trade.tradeCardname}</td>
                    <td class="txtCenter" scope="col">${trade.tradeAccountname}<br>${trade.tradeBranchbank},${trade.tradeSubbranchbank}<br>${trade.tradeCardnum}<br>${trade.tradeProvince},${trade.tradeCity}</td>
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.accountTypeMap[trade.tradeAccounttype]}</td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.tradeAmount}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col">${trade.tradeAmounttype}</td>
                    <td class="txtCenter" scope="col">${trade.tradeMobile}</td>
                    <td class="txtCenter" scope="col">${TbAgentpayDetailsInfo.certificateTypeMap[trade.certificateType]}</td>
                    <td class="txtCenter" scope="col">${trade.certificateNum}</td>
                    <g:if test="${batch.batchType=='S'}">
                        <td class="txtCenter" scope="col">${trade.contractUsercode}</td>
                    </g:if>
                    <td class="txtCenter" scope="col">${trade.tradeRemark}</td>
                    <td class="txtCenter" scope="col">${trade.errMsg}</td>
                    <td class="txtCenter" scope="col">
                        <a href="#" onclick="myconedit('${trade.id}')" style="color:blue;"> 编辑</a>
                        |
                        <a href="#" onclick="myconfirm('${trade.id}')" style="color:blue;"> 删除</a>
                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
            <g:if test="${tradeListTotal>0}">
                <div class="elxdwn blue"><a href="#" class="download-txt">下载TXT</a></div>
                <div class="elxdwn blue"><a href="#" class="download-exc">下载CSV</a></div>
                <div class="elxdwn blue"><a href="#" class="download-excel">下载Excel</a></div>
            </g:if>
          <g:pageNavi total="${tradeListTotal}"/>
        </div>
    </div>
</g:form>

<script type="text/javascript">

//----------下载部分处理-------
E.on(D.query(".download-exc"),"click",function(e){
	download("csv");
	E.preventDefault(e);
});
E.on(D.query(".download-txt"),"click",function(e){
	download("txt");
	E.preventDefault(e);
});
  E.on(D.query(".download-excel"),"click",function(e){
	download("xls");
	E.preventDefault(e);
});
function download(type){
	var f = D.get("searchform");
    $("#format").val(type)
	f.submit();
    $("#format").val("")
};
function myconfirm(id){
     if(confirm("您确认执行删除操作吗？")){
         window.document.location.href = "${createLink(controller:'tbAgentPayBox',action:'agentinfodel')}?tradeid="+id;
     }
}
function myconedit(id){

     window.document.location.href = "${createLink(controller:'tbAgentPayBox',action:'boxupdate')}?tradeid="+id;
}
    function mysubmit(id){
       if(confirm("您确认执行提交操作吗？")){
         window.document.location.href = "${createLink(controller:'tbAgentPayBox',action:'boxsubmit')}?id="+id;
     }
    }

</script>
</body>
</html>
