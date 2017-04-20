<%@ page import="ismp.UserAESUtils; ismp.CmCustomer; account.AcAccount" %>
<%@ page import="ismp.CmCorporationInfo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-账户信息</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
</head>
<body>
    <%
        def accountNo=session.cmCustomer.accountNo
        def acAccount_Main=AcAccount.findByAccountNo(accountNo)
        def acAccount_Frozen=AcAccount.findByParentIdAndAccountType(acAccount_Main?.id,'freeze')
    %>
    <div class="main_box">
      <div class="main_left">
        <div class="zxgg">
          <div class="zxggtlt">
            <p class="b blue">
                <b style="color:black;">账户信息</b>&nbsp;&nbsp;<a href="${request.contextPath}/${session.level3Map['index/account'].modelPath}">返回首页</a>
            </p>
          </div>
          <table class="tlb1">
              <tr>
                <td width="35%" class="txtRight" scope="col">账户类型：</td>
                <td width="65%" class="txtLeft" scope="col">企业</td>
              </tr>
              <tr>
                <td class="txtRight">可用余额：</td>
                <td class="txtLeft"><g:if test="${acAccount_Main}"><g:formatNumber currencyCode="CNY" number="${acAccount_Main.balance/100}" type="currency"/></g:if><g:else>0</g:else>元
                    <g:if test="${session.level3Map != null && session.level3Map['trade/account'] != null}">
                        <span>| <a href="${request.contextPath}/${session.level3Map['trade/account'].modelPath}"><span class="blue">收支明细</span></a></span>
                    </g:if>
                </td>
              </tr>
              <tr>
                <td class="txtRight">冻结余额：</td>
                <td class="txtLeft">￥0.00元</td>
              </tr>
          </table>
        </div>
        </div>
          <div class="txmenu"><span class="left trnmenutlt">基本信息：</span></div>
          <div class="securety"><table class="securetytlb">
          <tr>
            <td width="100" class="txtRight" scope="col"> 公司名称：</td>
            <td class="txtLeft" scope="col">${session.cmCustomer?.name.encodeAsHTML()}</td>
            <td width="100" class="txtRight" scope="col">E-mail账户名：</td>
            <td class="txtLeft" scope="col">${UserAESUtils.displayngEmail(session.cmCustomerOperator.defaultEmail)}</td>
          </tr>
          <tr>
            <td class="txtRight">账户状态：</td>
            <td class="txtLeft"><span class="txtRight">${CmCustomer.statusMap[session.cmCustomer?.status]}</span></td>
            <td class="txtRight">注册时间：</td>
            <td class="txtLeft"><span class="txtRight">${session.cmCustomer?.dateCreated}</span></td>
          </tr>
          <tr>
            <td class="txtRight">手机号：</td>
            <td class="txtLeft">
                <span class="txtRight">
                    ${UserAESUtils.displayPhoneNo(session.cmCustomerOperator.defaultMobile.encodeAsHTML())}
                </span>
            </td>
            <td class="txtRight">上次登录时间：</td>
            <td class="txtLeft"><span class="txtRight">${session.lastLoginTime?session.lastLoginTime:"本次为首次登录！"}</span></td>
          </tr>
        </table>
      </div>
      <g:if test="${session.level3Map != null && session.level3Map['security/index'] != null}">
          <div class="txmenu">
              <span class="left trnmenutlt">安全设置：</span>
          </div>
          <div class="securety">
            <table class="tlb1">
              <g:if test="${session.level3Map != null && session.level3Map['operator/savechangeloginpass'] != null}">
                  <tr>
                    <td width="11%" class="txtRight" scope="col">登录密码</td>
                    <td class="txtLeft" scope="col" style="color:green;">&nbsp;&nbsp;上次登录时间： ${session.lastLoginTime?session.lastLoginTime:"本次为首次登录！"}</td>
                    <td width="14%" class="txtLeft" scope="col">
                        <input type="button" class="btn mglf10 loginPassBut" value="修改" />
                    </td>
                  </tr>
              </g:if>

              <g:if test="${session.level3Map != null && session.level3Map['operator/savechangepaypass'] != null}">
                  <tr>
                    <td class="txtRight">支付密码</td>
                    <td class="txtLeft">&nbsp; </td>
                    <td class="txtLeft">
                        <input type="button" class="btn mglf10 payPassBut" value="修改" />
                    </td>
                  </tr>
               </g:if>

              <g:if test="${session.level3Map != null && session.level3Map['operator/saveBindMobile'] != null}">
                  <tr>
                    <td class="txtRight">手机绑定</td>
                    <td class="txtLeft" style="color:green;">&nbsp;&nbsp;${UserAESUtils.displayPhoneNo(session.cmCustomerOperator.defaultMobile.encodeAsHTML())}&nbsp;&nbsp;绑定手机后，您可以免费享受手机找回密码等功能</td>
                    <td class="txtLeft">
                        <input type="button" class="btn mglf10 updateBindMobileBut" value="修改" />
                    </td>
                  </tr>
              </g:if>
            </table>
          </div>
      </g:if>
    </div>
    <g:render template="/layouts/changePass"/>
</body>
</html>
