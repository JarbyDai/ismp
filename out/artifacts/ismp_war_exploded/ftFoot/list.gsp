<%@ page import="ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-结算查询</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>

    <script type="text/javascript">
        function search(obj) {
            if (obj) {
                if ($("offset"))
                    $("offset").value = 0;
            }
            $("#searchform").submit();
        }

        function validatetime(){
            var s = $('#startDate').val();
            var e = $('#endDate').val();
            if(''!= s && '' != e && s > e){
                alert('日期输入颠倒，请重新输入')
                return false;
            }else{
                $("#searchform").submit();
                return true;
            }
        }

        function clearTime() {
            $('#startDate').val('');
            $('#endDate').val('');
            $('#startDate').focus();
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">结算管理：</span>
  %{--<div class="rtnms">--}%
    %{--<ul>--}%
      %{--<li class="rtncnt blue">结算查询</li>--}%
    %{--</ul>--}%
  %{--</div>--}%
</div>
<form action="list" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
      <tr>
        <td scope="col" colspan="2">&nbsp;&nbsp;开始日期:
            <g:textField name="startDate" value="${params.startDate}" readonly="readonly" size="10"/>
            &nbsp;&nbsp;结束日期:
            <g:textField name="endDate" value="${params.endDate}" readonly="readonly" size="10"/>
        </td>
        <td scope="col"></td>
        <td scope="col">
            <input type="submit" class="serchbtn" value="搜索" />
        </td>
        <td scope="col"></td>
        <td scope="col"></td>
      </tr>
      <tr>
        <td width="252" scope="col">
            &nbsp;&nbsp;结算周期:<span style="color:red;">${ft_cycle}</span>
        </td>
        <td width="252" scope="col">
            &nbsp;&nbsp;订单金额:<span style="color:red;">${(sum.PAY_AMOUNT == 0 || sum.PAY_AMOUNT) ? Math.abs(sum.PAY_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString() : '0.00'}</span>
        </td>
        <td width="252" scope="col">
            &nbsp;&nbsp;退款金额:<span style="color:red;">${(sum.REF_AMOUNT == 0 || sum.REF_AMOUNT) ? Math.abs(sum.REF_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString() : '0.00'}</span>
        </td>
        <td scope="col"></td>
        <td scope="col"></td>
        <td scope="col"></td>
      </tr>
      <tr>
        <td width="252" scope="col">
            &nbsp;&nbsp;订单净额：<span style="color:red;">${((sum.PAY_AMOUNT == 0 || sum.PAY_AMOUNT) && (sum.REF_AMOUNT == 0 || sum.REF_AMOUNT)) ? (Math.abs(sum.PAY_AMOUNT) - Math.abs(sum.REF_AMOUNT)).toBigDecimal().divide(100,2,0).toPlainString() : '0.00'}</span>
        </td>
        <td width="252" scope="col">
            &nbsp;&nbsp;即扣手续费金额：<span style="color:red;">${(0 == sum.PAY_FEE || sum.PAY_FEE) ? sum.PAY_FEE.toBigDecimal().divide(100,2,0).toPlainString() : '0.00'}</span>
        </td>
        <td width="252" scope="col">
            &nbsp;&nbsp;结算金额：<span style="color:red;">${((sum.PAY_AMOUNT == 0 || sum.PAY_AMOUNT) && (sum.REF_AMOUNT == 0 || sum.REF_AMOUNT) && (0 == sum.PAY_FEE || sum.PAY_FEE)) ? (Math.abs(sum.PAY_AMOUNT) - Math.abs(sum.REF_AMOUNT) - sum.PAY_FEE).toBigDecimal().divide(100,2,0).toPlainString() : '0.00'}</span>
        </td>
        <td scope="col"></td>
        <td scope="col"></td>
        <td scope="col"></td>
      </tr>
    </table>
  </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">订单支付日期范围</th>
            <th class="txtCenter" scope="col">结算日期</th>
            <th class="txtCenter" scope="col">订单笔数</th>
            <th class="txtCenter" scope="col">订单金额（元）</th>
            <th class="txtCenter" scope="col">退款金额（元）</th>
            <th class="txtCenter" scope="col">订单净额（元）</th>
            <th class="txtCenter" scope="col">手续费金额（元）</th>
            <th class="txtCenter" scope="col">结算金额（元）</th>
            <th class="txtCenter" scope="col">结算明细</th>
          </tr>
            <g:each in="${result}" status="i" var="foot">
                <tr>
                    <td scope="col" class="blue"><g:formatDate format="yyyy.MM.dd" date="${foot.MIN_TRADE_DATE}"/>-<g:formatDate format="yyyy.MM.dd" date="${foot.MAX_TRADE_DATE}"/></td>
                    <td scope="col" class="blue">${foot.FOOT_DATE.format("yyyy-MM-dd")}</td>
                    <td class="txtCenter" scope="col">${foot.TRANS_NUM}</td>
                    <td class="txtCenter" scope="col">${Math.abs(foot.PAY_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString()}</td>
                    <td class="txtCenter" scope="col">${Math.abs(foot.REF_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString()}</td>
                    <td class="txtCenter" scope="col">${(Math.abs(foot.PAY_AMOUNT) - Math.abs(foot.REF_AMOUNT)).toBigDecimal().divide(100,2,0).toPlainString()}</td>
                    <td class="txtCenter" scope="col"><strong style="color:green">${foot.PAY_FEE.toBigDecimal().divide(100,2,0).toPlainString()}</strong></td>
                    <td class="txtCenter" scope="col"><strong style="color:red">${(Math.abs(foot.PAY_AMOUNT) - Math.abs(foot.REF_AMOUNT) - foot.PAY_FEE).toBigDecimal().divide(100,2,0).toPlainString()}</strong></td>
                    <td class="txtCenter" scope="col">
                        <g:link controller="ftFoot" action="detail" params="[pay_no:foot.PAY_NO,ref_no:foot.REF_NO,a1:foot.MIN_TRADE_DATE.format('yyyy-MM-dd'),a2:foot.MAX_TRADE_DATE.format('yyyy-MM-dd'),b:foot.FOOT_DATE.format('yyyy-MM-dd'),c:foot.TRANS_NUM,d:Math.abs(foot.PAY_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString(),e:Math.abs(foot.REF_AMOUNT).toBigDecimal().divide(100,2,0).toPlainString(),f:(Math.abs(foot.PAY_AMOUNT) - Math.abs(foot.REF_AMOUNT)).toBigDecimal().divide(100,2,0).toPlainString(),g:foot.PAY_FEE.toBigDecimal().divide(100,2,0).toPlainString(),h:(Math.abs(foot.PAY_AMOUNT) - Math.abs(foot.REF_AMOUNT) - foot.PAY_FEE).toBigDecimal().divide(100,2,0).toPlainString()]" style="color:blue;">结算明细</g:link>
                    </td>
                </tr>
            </g:each>
        </table>
        <div class="page">
          <g:pageNavi total="${total}"/>
        </div>
    </div>
</form>

<script type="text/javascript">
    $(function() {
        $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -365, maxDate: "+0D" });
        $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -365, maxDate: "+0D" });
    });
</script>
</body>
</html>
