<%@ page import="account.AcTransaction" %>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=GBK">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 12">
<style id="template_26326_Styles">
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
.font57821
	{color:windowtext;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;}
.xl733956
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"0_ ";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl637821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"\@";
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl647821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"\@";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl657821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl667821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:white;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"\@";
	text-align:center;
	vertical-align:middle;
	border-top:.5pt solid windowtext;
	border-right:.5pt solid windowtext;
	border-bottom:none;
	border-left:.5pt solid windowtext;
	background:#0070C0;
	mso-pattern:black none;
	white-space:nowrap;}
.xl677821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"\@";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl687821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:General;
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl697821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:000000;
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl707821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"\@";
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl717821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl727821
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:black;
	font-size:11.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-number-format:"0\.00_ ";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
ruby
	{ruby-align:left;}
rt
	{color:windowtext;
	font-size:9.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:宋体;
	mso-generic-font-family:auto;
	mso-font-charset:134;
	mso-char-type:none;}
-->
</style>
</head>

<body>
<!--[if !excel]>　　<![endif]-->
<!--下列信息由 Microsoft Office Excel 的“发布为网页”向导生成。-->
<!--如果同一条目从 Excel 中重新发布，则所有位于 DIV 标记之间的信息均将被替换。-->
<!----------------------------->
<!--“从 EXCEL 发布网页”向导开始-->
<!----------------------------->

<div id="template_26326" align=center x:publishsource="Excel">

<table border=0 cellpadding=0 cellspacing=0 width=1524 class=xl637821
 style='border-collapse:collapse;table-layout:fixed;width:1143pt'>
 <col class=xl637821 width=95 style='mso-width-source:userset;mso-width-alt:
 5760;width:91pt'>
 <col class=xl637821 width=147 style='mso-width-source:userset;mso-width-alt:
 5704;width:110pt'>
 <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
 5704;width:130pt'>
 <col class=xl637821 width=173 style='mso-width-source:userset;mso-width-alt:
 7600;width:130pt'>
 <col class=xl637821 width=75 style='mso-width-source:userset;mso-width-alt:
 4400;width:56pt'>
 <col class=xl637821 width=83 style='mso-width-source:userset;mso-width-alt:
 4656;width:62pt'>
 <col class=xl637821 width=86 style='mso-width-source:userset;mso-width-alt:
 4752;width:65pt'>
 <col class=xl637821 width=96 style='mso-width-source:userset;mso-width-alt:
 3300;width:72pt'>
 <col class=xl637821 width=136 style='mso-width-source:userset;mso-width-alt:
 4352;width:102pt'>
 <col class=xl637821 width=80 style='mso-width-source:userset;mso-width-alt:
 2560;width:60pt'>
 <col class=xl637821 width=136 style='mso-width-source:userset;mso-width-alt:
 4352;width:102pt'>
 <col class=xl637821 width=81 style='mso-width-source:userset;mso-width-alt:
 2592;width:61pt'>
 <col class=xl637821 width=84 span=3 style='mso-width-source:userset;
 mso-width-alt:2688;width:63pt'>
 <col class=xl637821 width=124 style='mso-width-source:userset;mso-width-alt:
 5704;width:93pt'>
 <tr height=18 style='height:13.5pt'>
  <td height=18 class=xl637821 colspan=2 width=202 style='height:13.5pt;
  width:151pt'>合利宝账务明细查询<span style='mso-spacerun:yes'>&nbsp;</span></td>
  <td class=xl637821 width=173 style='width:130pt'>账号：[${session.cmCustomer.customerNo}]</td>
  <td class=xl637821 width=96 style='width:72pt'></td>
  <td class=xl637821 width=169 style='width:127pt'>起始日期：[${params.startDate}]   终止日期: [${params.endDate}]</td>
  <td class=xl637821  width=136 style='width:102pt'></td>
  <td class=xl637821 width=136 style='width:120pt'></td>
  <td class=xl637821 width=80 style='width:60pt'></td>
  <td class=xl637821 width=136 style='width:102pt'></td>
  <td class=xl637821 width=81 style='width:61pt'></td>
  <td class=xl637821 width=84 style='width:63pt'></td>
  <td class=xl637821 width=84 style='width:63pt'></td>
  <td class=xl637821 width=84 style='width:63pt'></td>
  <td class=xl637821 width=124 style='width:93pt'></td>
 </tr>
    <tr height=18 style='height:13.5pt'>
        <td height=18 class=xl637821 style='height:13.5pt'></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
    </tr>
 <tr height=18 style='height:13.5pt'>
  <td height=18 class=xl637821 colspan=2 width=202 style='height:13.5pt;width:151pt'>收入总记录数：${in_count}</td>
  <td class=xl637821>支出总记录数：${out_count}</td>
  <td class=xl637821></td>
  <td class=xl637821 colspan=2>总记录数：${resultTotal}</td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
 </tr>
    <tr height=18 style='height:13.5pt'>
        <td height=18 class=xl637821 style='height:13.5pt'></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
        <td class=xl637821></td>
    </tr>
 <tr height=18 style='height:13.5pt'>
  <td height=18 class=xl637821 colspan=2 width=202 style='height:13.5pt;width:151pt'>收入总金额：<g:formatNumber number="${in_amount ? in_amount/100 : 0}" format="#0.00#"/></td>
  <td class=xl637821>支出总金额：<g:formatNumber number="${out_amount ? out_amount/100 : 0}" format="#0.00#"/></td>
  <td class=xl637821></td>
  <td class=xl637821 colspan=2>手续费：<g:formatNumber number="${fee_amount ? fee_amount/100 : 0}" format="#0.00#"/></td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821 colspan=2></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
 </tr>
 <tr height=18 style='height:13.5pt'>
  <td height=18 class=xl637821 style='height:13.5pt'></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
  <td class=xl637821></td>
 </tr>
 <tr class=xl637821 height=18 style='height:13.5pt'>
  <td class=xl667821 style='border-left:none'>时间</td>
  <td class=xl667821 style='border-left:none'>商户订单号</td>
  <td class=xl667821 style='border-left:none'>流水号</td>
 <td class=xl667821 style='border-left:none'>第三方支付单号</td>
 <td class=xl667821 style='border-left:none'>类型</td>
  <td class=xl667821 style='border-left:none'>收入金额（+元）</td>
  <td class=xl667821 style='border-left:none'>支出金额（-元）</td>
  <td class=xl667821 style='border-left:none'>账户余额（元）</td>
  <td class=xl667821 style='border-left:none'>摘要</td>
 </tr>
<g:each in="${resultList}" status="i" var="result">
 <tr height=18 style='height:13.5pt'>
  <td  class=xl677821 style='border-left:none'>${result.DATE_CREATED?.format("yyyy-MM-dd HH:mm:ss")}</td>
  <td class=xl677821 style='border-left:none'>${result.OUT_TRADE_NO == '0'?'':result.OUT_TRADE_NO}</td>
  <td class=xl677821 style='border-left:none'>${result.TRADE_NO}</td>
  <td class=xl677821 style='border-left:none'>${result.OUT_TRANSACTION_ID}</td>
  <td class=xl657821  align=right style='border-left:none'>${AcTransaction.transTypeMap[result.TRANSFER_TYPE]}</td>
  <td class=xl657821  align=right style='border-left:none'> +<g:formatNumber number="${result.DEBIT_AMOUNT ? result.DEBIT_AMOUNT/100 : 0}" format="#0.00#"/></td>
  <td class=xl657821  align=right style='border-left:none'>-<g:formatNumber number="${result.CREDIT_AMOUNT ? result.CREDIT_AMOUNT/100 : 0}" format="#0.00#"/></td>
  <td class=xl657821  align=right style='border-left:none'><g:formatNumber number="${result.BALANCE ? result.BALANCE/100 : 0}" format="#0.00#"/></td>
  <td class=xl657821  align=right style='border-left:none'> ${result.SUBJICT == 'null' ? '' : result.SUBJICT?.encodeAsHTML()}</td>
 </tr>
 </g:each>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=95 style='width:91pt'></td>
  <td width=147 style='width:110pt'></td>
  <td width=147 style='width:110pt'></td>
  <td width=173 style='width:130pt'></td>
  <td width=75 style='width:56pt'></td>
  <td width=83 style='width:62pt'></td>
  <td width=86 style='width:65pt'></td>
  <td width=96 style='width:72pt'></td>
 </tr>
 <![endif]>
</table>

</div>


<!----------------------------->
<!--“从 EXCEL 发布网页”向导结束-->
<!----------------------------->
</body>

</html>
