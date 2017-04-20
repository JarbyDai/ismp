<%@ page import="ismp.TradePayment; ismp.TradeBase" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-退款审核</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>

    <script type="text/javascript">

        javascript:window.history.forward(1);
        function KeyDown(){
            if   ((event.keyCode==8)&&
              (event.srcElement.type!="text"&&event.srcElement.type!="textarea"&&event.srcElement.type!="password")){
                 event.keyCode=0;
                 event.returnvalue=false;
              }
        }

        function search(obj) {
            if (obj) {
                if ($("offset"))
                    $("offset").value = 0;
            }
            $("#searchform").submit();
        }
        function checkAllBox() {
            var len = document.getElementsByName("box").length;
            for (i = 0; i < len; i++) {
                if (document.getElementById("allBox").checked) {
                    document.getElementsByName("box")[i].checked = true;
                }
                else {
                    document.getElementsByName("box")[i].checked = false;
                }
            }
        }

        function selectCheck() {
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }

            document.getElementById("ids").value=ids;

            if (flag == 0) {
                alert("请选择要审核的退款！");
                return false;
            }
            else {
                window.location.href='${createLink(controller:'trade',action:'refundPass')}'+ '?ids='+ids ;
            }
        }

        function refundRefuse(){
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }
            document.getElementById("ids").value=ids;

            if (flag == 0) {
                alert("请选择要审核的退款！");
                return false;
            }else {
               appPass();
            }

        }

        function appPass() {
            document.getElementById("reason").style.display = '';
            return false;
        }
        function checkReason() {
            var len = document.getElementsByName("box").length;
            var ids="";
            var flag = 0;
            for (i = 0; i < len; i++) {
                if (document.getElementsByName("box")[i].checked) {
                    ids=ids+document.getElementsByName("box")[i].value+",";
                    flag = 1;
                }
            }
            document.getElementById("ids").value=ids;

            if (document.getElementById("note").value == '请输入拒绝原因' || document.getElementById("note").value == '') {
                alert("请输入拒绝原因!");
            } else {
                var reason = document.getElementById("note").value;
                document.forms[0].action="${createLink(controller:'trade',action:'refundRefuse')}"
                document.forms[0].ids.value=ids;
                document.forms[0].submit();
                //window.location.href='${createLink(controller:'trade',action:'refundRefuse')}'+ '?ids='+ids +'&note=' + reason;
            }
        }
    </script>
</head>
<body>
<div class="trnmenu"> <span class="left trnmenutlt">交易管理：</span>
  <div class="rtnms">
    <ul>
        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/sale'] != null}">--}%
            %{--<li>--}%
            %{--<a href="${request.contextPath}/${session.level3Map['trade/sale'].modelPath}">付款交易</a>--}%
            %{--</li>--}%
        %{--</g:if>--}%
        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/buy'] != null}">--}%
            %{--<li>--}%
            %{--<a href="${request.contextPath}/${session.level3Map['trade/buy'].modelPath}">收款交易</a>--}%
            %{--</li>--}%
        %{--</g:if>--}%
        %{--<g:if test="${session.level3Map != null && session.level3Map['trade/refund'] != null}">--}%
            %{--<li>--}%
                %{--<a href="${request.contextPath}/${session.level3Map['trade/refund'].modelPath}">退款交易</a>--}%
            %{--</li>--}%
        %{--</g:if>--}%
        <li class="rtncnt blue">退款审核</li>
        <g:if test="${session.level3Map != null && session.level3Map['trade/authHistory'] != null}">
            <li>
                <a href="${request.contextPath}/${session.level3Map['trade/authHistory'].modelPath}">审核拒绝记录</a>
            </li>
        </g:if>
    </ul>
  </div>
</div>
<g:form action="verify" method="post" name="searchform" id="searchform" style="width:960px; margin:0 auto">
    <g:hiddenField name="ids" id="ids"/>
    <g:hiddenField name="batch" value="${flash.message}"/>
    <div id="verifyMsg">
        <g:if test="${errmsg}">
            <div id="verifytMsg" class="serch"><P>${errmsg.encodeAsHTML()}</P></div>
        </g:if>
    </div>
    <div class="serch">
      <p>搜索</p>
      <table class="serchtlb">
      <tr>
        <td width="252" scope="col"> &nbsp;&nbsp;&nbsp;&nbsp;平台交易号:
            <input name="tradeNo" type="text" id="tradeNo" value="${params.tradeNo}" maxlength="40"/>
        </td>
        <td width="252" scope="col" colspan="3">商户订单号:
          <input name="outTradeNo" type="text" id="outTradeNo" value="${params.outTradeNo}" maxlength="80"/>
        </td>
        <td scope="col"></td>
        <td scope="col">
            <input type="submit" class="serchbtn" value="搜索" />
            <input type="button" onclick="clearContents()" class="serchbtn" value="清除" />
        </td>
        <td scope="col"></td>
      </tr>
      <tr>
        <td scope="col" colspan="2">&nbsp;&nbsp;退款金额区间:
          <input type="text" name="amountMin" id="amountMin" maxlength="10" value="${params.amountMin}"/>
          -<input type="text" name="amountMax" id="amountMax" maxlength="10" value="${params.amountMax}"/>元
        </td>
        <td scope="col" colspan="4">&nbsp;&nbsp;&nbsp;&nbsp;开始日期:
            <g:textField name="startDate" value="${params.startDate}" readonly="readonly" size="10"/>
            &nbsp;&nbsp;结束日期:
            <g:textField name="endDate" value="${params.endDate}" readonly="readonly" size="10"/>
        </td>
      </tr>
    </table>
    </div>

    <div class="serchlitst">

        <table class="tlb1">
          <tr>
            <th class="txtCenter" scope="col">创建时间</th>
            <th class="txtCenter" scope="col">商户订单号</th>
            <th class="txtCenter" scope="col">平台交易号</th>
            <th class="txtCenter" scope="col">交易金额（元）</th>
            <th class="txtCenter" scope="col">退款金额（元）</th>
            <th class="txtCenter" scope="col">全选<input type="checkbox" id="allBox" name="allBox" onclick="checkAllBox();"></th>
          </tr>
            <g:each in="${tradeList}" status="i" var="trade">
                <%
                    def tb = TradeBase.findByOutTradeNoAndTradeNo(trade.outTradeNo,trade.tradeNo)
                %>
                <tr>
                    <td scope="col" class="blue">${trade.uploadTime.format("yyyy-MM-dd HH:mm:ss")}</td>
                    <td class="txtCenter" scope="col">${trade.outTradeNo}</td>
                    <td class="txtCenter" scope="col">${trade.tradeNo}</td>
                    <td class="txtCenter" scope="col"><strong style="color:green"><g:formatNumber currencyCode="CNY" number="${tb.amount/100}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col"><strong style="color:red"><g:formatNumber currencyCode="CNY" number="${trade.amount/100}" type="currency"/></strong></td>
                    <td class="txtCenter" scope="col"><g:checkBox name="box" value="${trade.id}" checked="false"  ></g:checkBox></td>
                </tr>
            </g:each>
            <tr style="display:none" id="reason">
                <td colspan="6">
                    <div id="messages" align="left">
                        <font color="red">拒绝原因：</font> <input type="text" name="note" maxlength="64" style="width:500px;height:20px; margin-top:3px" id="note" onfocus="value = ''" value="请输入拒绝原因"/>
                        <span>(最多可输入64个字)<input type="button" name="button" class="serchbtn" value="确定" onclick="checkReason()"/></span>
                    </div>
                </td>
            </tr>
        </table>
        <div class="page">
          <g:pageNavi total="${tradeListTotal}"/>
        </div>
        <g:if test="${tradeListTotal>0}">
            <table align="center">
                <tr>

                    <g:if test="${session.level3Map != null && session.level3Map['trade/refundPass'] != null}">
                            <td align="center">
                                <input type="button" onclick="selectCheck();" class="serchbtn" value="审核通过">
                            </td>
                    </g:if>
                     <g:if test="${session.level3Map != null && session.level3Map['trade/refundRefuse'] != null}">
                            <td align="center">
                                <input type="button" onclick="refundRefuse();" class="serchbtn" value="审核拒绝">
                            </td>
                    </g:if>
                </tr>
            </table>
        </g:if>
    </div>
</g:form>

<script type="text/javascript">
    function clearContents(){
        $("#tradeNo").val("");
        $("#outTradeNo").val("");
        $("#amountMin").val("");
        $("#amountMax").val("");
        $("#startDate").val("");
        $("#endDate").val("");
    }
    $(function() {
        var dates=new Date();
        var diff=dates.setYear(dates.getFullYear()-2);
        var yearsday=(new Date()-diff)/86400000;
        $("#startDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -yearsday, maxDate: "+0D" });
        $("#endDate").datepicker({ dateFormat: 'yy-mm-dd', changeYear: true, changeMonth: true,minDate: -yearsday, maxDate: "+0D" });
    });

    $(document).ready(function() {
        jQuery.validator.addMethod("money", function(a, b) {
            return this.optional(b) || /^\d+(\.\d{0,2})?$/i.test(a)
        }, "Please enter a valid amount.");
        jQuery.validator.addMethod("ge", function(value, element, param) {
            var target = $(param).unbind(".validate-equalTo").bind("blur.validate-equalTo", function() {
                $(element).valid();
            });
            if (target.val() == "" || value == "") return true;
            else return parseFloat(value) >= parseFloat(target.val());
        }, "Please enter a valid value.");
        jQuery.validator.addMethod("rangeDate", function(value, element, param) {
				var startDate = jQuery(param).val();
				if(startDate==""||value=="")
				{
					return true;
				}else{
					var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
                    var date3  =date1.setMonth(date1.getMonth()+3);
					var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
					return (date2-date3)<= 0;
				}
	    }, "Please enter 90 days range value.");
        jQuery.validator.addMethod("compareDate", function(value, element, param) {
            var startDate = jQuery(param).val();
            if (startDate == "" || value == "") {
                return true;
            } else {
                var date1 = new Date(Date.parse(startDate.replaceAll("-", "/")));
                var date2 = new Date(Date.parse(value.replaceAll("-", "/")));
                return date1 <= date2;
            }
        }, "Please enter a valid value.");
        $("#searchform").validate({
            rules: {
                amountMin:{money:true,range:[0.01,100000000]},
                amountMax:{money:true,range:[0.01,100000000],ge:"#amountMin"},
                startDate:{dateISO:true},
                endDate:{dateISO:true,compareDate:"#startDate",rangeDate:"#startDate"}
            },
            messages: {
                amountMin:{money:"无效金额",range:"无效金额范围"},
                amountMax:{money:"无效金额",range:"无效金额范围",ge:"无效金额范围"},
                startDate:{dateISO:"无效时间格式"},
                endDate:{dateISO:"无效时间格式",compareDate:"结束日期必须大于开始日期",rangeDate:"日期范围必须3个月内"}
            }
        });
    });
</script>
</body>
</html>
