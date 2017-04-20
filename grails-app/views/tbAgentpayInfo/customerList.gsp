<%@ page import="dsf.TbBizCustomer" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>合利宝-客户信息列表</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir:'css',file:'style.css')}" media="all" />
    <link charset="utf-8" rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" media="all" />
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-1.8.2.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-1.9.0.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js/jquery', file: 'jquery-ui-timepicker-addon-chn.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script charset="utf-8" src="${resource(dir:'js',file:'arale.js')}?t=${new Date().getTime()}"></script>
    <script charset="utf-8" src="${resource(dir:'js',file:'common.js')}"></script>
    <script type="text/javascript">

        function search(obj){
            if(obj){
                if($("offset"))
                $("offset").value=0;
            }
            $("#searchform").submit();
        }

        function winClose()
        {
            window.parent.win1.close();
        }
    </script>
</head>
<body>
<div class="trnmenu">
    <span class="left trnmenutlt">代收付：</span>
</div>
<form action="customerList" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div class="serch">
      <p>搜索</p>
          <table class="serchtlb">
          <tr>
            <td width="350" scope="col">
                <g:hiddenField name="bizType" id="bizType" value="${params?.bizType}" />
                <g:select name="reqSearch" value="${params?.reqSearch}" from="${TbBizCustomer.requiredMap}" optionKey="key" optionValue="value" class="right_top_h2_input" />
                <input name="resultSearch" type="text" class="i-text i-text-s" id="resultSearch" value="${params?.resultSearch}" maxlength="40" />
            </td>
            <td scope="col">
                <input type="submit" class="serchbtn" value="搜索" />
            </td>
          </tr>
        </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">选择</th>
            <th class="txtCenter" scope="col">客户名称</th>
            <th class="txtCenter" scope="col">省份</th>
            <th class="txtCenter" scope="col">地市</th>
            <th class="txtCenter" scope="col">开户行</th>
            <th class="txtCenter" scope="col">分行</th>
            <th class="txtCenter" scope="col">支行</th>
            <th class="txtCenter" scope="col">银行账号</th>
            <th class="txtCenter" scope="col">证件类型</th>
            <th class="txtCenter" scope="col">证件号</th>
            <th class="txtCenter" scope="col">手机号</th>
            <th class="txtCenter" scope="col">备注</th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <tr>
                    <td class="txtCenter" scope="col">
                        <input type="checkbox" name="tradeId" id="tradeId" value="${trade.id},${trade.cardName},${trade.province},${trade.city},${trade.bank},${trade.branchBank},${trade.subbranchBank},${trade.cardNum},${trade.accountType},${trade.contractCode},${trade.remark},${trade.certificateType},${trade.certificateNum},${trade.tradeMobile}"/>
                    </td>
                    <td class="txtCenter" scope="col">${trade.cardName}</td>
                    <td class="txtCenter" scope="col">${trade.province}</td>
                    <td class="txtCenter" scope="col">${trade.city}</td>
                    <td class="txtCenter" scope="col">${trade.bank}</td>
                    <td class="txtCenter" scope="col">${trade.branchBank}</td>
                    <td class="txtCenter" scope="col">${trade.subbranchBank}</td>
                    <td class="txtCenter" scope="col">${trade.cardNum}</td>
                    <td class="txtCenter" scope="col">${trade.certificateTypeMap[trade.certificateType]}</td>
                    <td class="txtCenter" scope="col">${trade.certificateNum}</td>
                    <td class="txtCenter" scope="col">${trade.tradeMobile}</td>
                    <td class="txtCenter" scope="col">${trade.remark}</td>
                </tr>
            </g:each>
        </table>
        <div class="page">
          <g:pageNavi total="${tradeListTotal}"/>
        </div>
        <table class="tlb1" >
             <tr>
                 <td>
                     <input type="button" name="btnChk" id="btnChk" class="btn mglf10" value="选中">
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <input type="button" id="btnDel" name="btnClear" class="btn mglf10" value="清除" />
                     &nbsp;&nbsp;&nbsp;&nbsp;
                     <input type="button" id="btnExt" name="btnClear" class="btn mglf10" value="退出" onclick="winClose()" />
                 </td>
             </tr>
        </table>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function(){
            $("#btnChk").removeAttr('onclick');
            $("#btnChk").click(function(){
                  var aa = "";
                  var c = 0;
                  $("input[type='checkbox']:checkbox:checked").each(function(){
                    c = c + 1;
                    aa=$(this).val();
                  });
                 if(c!=1){
                     alert("只能选中一条记录！");
                     return false;
                 }
                var objs = aa.split(",");
                //window.parent.document.forms(0).tradeId.value = objs[0];
                //window.parent.document.forms(0).tradeCardname.value = objs[1];
                window.parent.document.getElementById("tradeId").value = objs[0];
                window.parent.document.getElementById("tradeCardname").value = objs[1];
                window.parent.document.getElementById("tradeCardname").focus();
                window.parent.document.getElementById("tradeCardnum").value = objs[7];
                window.parent.document.getElementById("tradeCardnum").focus();
                window.parent.document.getElementById("tradeAccountname").value = objs[4];
                window.parent.document.getElementById("tradeAccountname").focus();
                window.parent.document.getElementById("tradeProvince").value = objs[2];
                window.parent.document.getElementById("tradeProvince").focus();
                window.parent.document.getElementById("tradeCity").value =objs[3];
                window.parent.document.getElementById("tradeCity").focus();
                window.parent.document.getElementById("tradeBranchbank").value = objs[5];
                window.parent.document.getElementById("tradeBranchbank").focus();
                window.parent.document.getElementById("tradeSubbranchbank").value = objs[6];
                window.parent.document.getElementById("tradeSubbranchbank").focus();
                window.parent.document.getElementById("tradeAccounttype").value = objs[8];
                window.parent.document.getElementById("tradeAccounttype").focus();
                window.parent.document.getElementById("contractUsercode").value = objs[9];
                if(window.parent.document.getElementById("contractUsercode").type=='text'){
                    window.parent.document.getElementById("contractUsercode").focus();
                }
                window.parent.document.getElementById("certificateType").value = objs[11];
                window.parent.document.getElementById("certificateType").focus();
                window.parent.document.getElementById("certificateNum").value = objs[12];
                window.parent.document.getElementById("certificateNum").focus();
                window.parent.document.getElementById("tradeMobile").value = objs[13];
                window.parent.document.getElementById("tradeMobile").focus();
                window.parent.document.getElementById("tradeRemark").value = objs[10];
                window.parent.document.getElementById("tradeRemark").focus();
                //alert("aaaaaaaaaaaaaaaaaa");
                window.parent.win1.close();
                //alert("bbb:");
                //window.close();
            });

            $("#btnDel").removeAttr('onclick');
            $("#btnDel").click(function(){
                var ids = "";
                var c = 0;
                  $("input[type='checkbox']:checkbox:checked").each(function(){
                    c = c + 1;
                    ids = ids + "," + $(this).val().split(",")[0];
                  });
                 if(c==0){
                     alert("至少选中一条记录！");
                     return false;
                 }
                var type = $("#bizType").val();
                var ids = ids.substr(1);
                if(confirm("您确认执行删除操作吗？")){
                    window.document.location.href = "${createLink(controller:'tbAgentpayInfo',action:'delCustomer')}?bizType=" + type + "&ids=" + ids;
                }
            });

           /* $("#btnExt").removeAttr('onclick');
            $("#btnExt").click(function(){
                alert("exit");
                var w = parent.win1;
                alert(w);
                var ws = window.parent.win1;
                alert(ws)
                window.parent.win1.close();
            });*/

        });

</script>
</body>
</html>
