<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="layout" content="main"/>
    <title>合利宝-企业信息</title>
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
                <th class="txtLeft" scope="col" colspan="2">
                    <b>企业信息</b>
                    <span>
                    <g:if test="${session.level3Map != null && session.level3Map['merchant/info/MerchantIDBut'] != null}">
					    <a id="midA" href="#" class="ft-normal fn-ml10 MerchantIDBut" style="color:blue">查询商户编号(MID)</a>|
                    </g:if>

                    <g:if test="${session.level3Map != null && session.level3Map['merchant/info/APIKeyBut'] != null}">
                        <a id="apiKeyA" href="#" class="ft-normal APIKeyBut" style="color:blue">查询安全校验码(Key)</a>
                    </g:if>
					</span>
                </th>
            </tr>
            <tr id="midTr" style="display:none">
                <td class="txtRight" scope="col" width="150">查询商户编号(MID)：</td>
                <td class="txtLeft" scope="col">以下Merchant ID 请保存，在支付接口集成时，需要使用：<span style="color:red;">${session.cmCustomer.customerNo}</span></td>
            </tr>
            <tr id="apiKeyTr" style="display:none">
                <td class="txtRight" scope="col" width="150">查询安全校验码(Key)：</td>
                <td class="txtLeft" scope="col">以下安全校验码请保存，在支付接口集成时，需要使用：<span style="color:red">${session.cmCustomer.apiKey}</span></td>
            </tr>
            <tr><td class="txtRight" scope="col" width="150">营业执照编码：</td><td class="txtLeft" scope="col" width="800">${cmCorporationInfo.businessLicenseCode}</td></tr>
            <tr><td class="txtRight" scope="col">组织机构代码：</td><td class="txtLeft" scope="col">${cmCorporationInfo.organizationCode}</td></tr>
            <tr><td class="txtRight" scope="col">企业税号：</td><td class="txtLeft" scope="col">${cmCorporationInfo.taxRegistrationNo}</td></tr>
            <tr><td class="txtRight" scope="col">执照登记时间：</td><td class="txtLeft" scope="col">${cmCorporationInfo.registrationDate?.format("yyyy-MM-dd")}</td></tr>
            <tr><td class="txtRight" scope="col">执照有效期：</td><td class="txtLeft" scope="col">${cmCorporationInfo.licenseExpires?.format("yyyy-MM-dd")}</td></tr>
            <tr><td class="txtRight" scope="col">经营范围：</td><td class="txtLeft" scope="col">${cmCorporationInfo.businessScope}</td></tr>
            <tr><td class="txtRight" scope="col">注册资金(万)：</td><td class="txtLeft" scope="col">${cmCorporationInfo.registeredFunds}</td></tr>
            <tr><td class="txtRight" scope="col">注册地：</td><td class="txtLeft" scope="col">${cmCorporationInfo.registeredPlace}</td></tr>
            <tr><td class="txtRight" scope="col">公司人数：</td><td class="txtLeft" scope="col">${cmCorporationInfo.numberOfStaff}</td></tr>
            <tr><td class="txtRight" scope="col">法人：</td><td class="txtLeft" scope="col">${cmCorporationInfo.legal}</td></tr>
            <tr><td class="txtRight" scope="col">办公地址：</td><td class="txtLeft" scope="col">${cmCorporationInfo.officeLocation}</td></tr>
            <tr><td class="txtRight" scope="col">公司电话：</td><td class="txtLeft" scope="col">${cmCorporationInfo.companyPhone}</td></tr>
            <tr><td class="txtRight" scope="col">邮编：</td><td class="txtLeft" scope="col">${cmCorporationInfo.zipCode}</td></tr>
            <tr><td class="txtRight" scope="col">联系人：</td><td class="txtLeft" scope="col">${cmCorporationInfo.bizMan}</td></tr>
            <tr><td class="txtRight" scope="col">联系人电话：</td><td class="txtLeft" scope="col">${cmCorporationInfo.bizPhone}</td></tr>
            <tr><td class="txtRight" scope="col">联系人手机：</td><td class="txtLeft" scope="col">${cmCorporationInfo.bizMPhone}</td></tr>
        </table>
    </div>

<script>
    $(document).ready(function(){

      $("#midA").click(function(){
      $("#midTr").toggle();
      });

      $("#apiKeyA").click(function(){
      $("#apiKeyTr").toggle();
      });
    });
</script>
</body>
</html>
