<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="layout" content="main" />
    <title>合利宝-充值</title>
    <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
    <g:javascript library="jquery"/>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
    <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>

    <script language="javascript">
        function  setBankName(names,code){
            document.getElementById('bankname').value = code;
            document.getElementById('channel').value = names;
            document.getElementById(names).checked = true;
        }
    </script>
</head>
<body>
    <g:render template="/layouts/baseInfo"/>
    <div class="main_box">
      <div class="main_left">
        <div class="zxgg">
          <div class="zxggtlt">
            <p>最新公告</p>
          </div>
          <g:render template="/layouts/news"/>
        </div>
        <div class="cpfw">
          <div class="zxggtlt">
            <p>常见问题</p>
          </div>
          <ul class="list12">
          </ul>
        </div>
      </div>
      <div class="txmenu">
        <span class="left trnmenutlt">交易管理：</span>
  	    <div class="rtnms">
            <ul>
              <li class="rtncnt blue">充值</li>
              <g:if test="${session.level3Map != null && session.level3Map['charge/list'] != null}">
                <li>
                    <a href="${request.contextPath}/${session.level3Map['charge/list'].modelPath}">充值记录</a>
                </li>
              </g:if>
            </ul>
        </div>
    </div>
    <form action="confirm" method="post" name="actionForm" id="actionForm">
        <div class="txbox">
            <input type="hidden" id="bankname" name="bankname" value=""/>
            <input type="hidden" id="channel" name="channel" value=""/>
            <ul class="rolinList" id="rolin">
                <ol>
                    <h2>企业网银</h2>
                    <div class="contents">
                        <div id="divobj1" class="SelectBank clearfix">
                            <g:each in="${channelList}" status="i" var="channelInfo">
                                    <li onclick="setBankName('${channelInfo.acquire_indexc}', '${channelInfo.acquire_code}')">
                                        <input type="radio" name="pay_channel" id="${channelInfo.acquire_indexc}" />
                                        <a href="javascript:void(0);">
                                            <img src="../images/bank/${(channelInfo.acquire_indexc)?.replace("_B2B","")+"_OUT.gif"}"  width="100" height="20" border="0" />
                                        </a>
                                        </label>
                                    </li>
                            </g:each>
                        </div>
                    </div>
                </ol>
            </ul>


            <div class="xybbtn">
                <input type="submit" class="btn mglf10" value="下一步" />
            </div>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {
        jQuery.validator.addMethod("money",function(a,b){return this.optional(b)||/^\d+(\.\d{0,2})?$/i.test(a)},"Please enter a valid amount.");
        $("#actionForm").validate({
            rules: {
                amount:{required:true,money:true,min:0.01,max:${acAccount_Main==null?0:acAccount_Main.balance/100}},
                captcha:{required:true,minlength:4}
            },
            messages: {
                amount:{required:"请输入提现金额",money:"无效金额",min:'金额值必须大于{0}',max:'金额值必须小于{0}'},
                captcha:{required:"请输入验证码",minlength:"验证码位数不对"}
            }
        });
    });

     E.on('reload-checkcode','click',function(){
		reloadAuthImg(D.get('authCodeImg'));
	});
    E.on('authCodeImg','click',function(){
		reloadAuthImg(D.get('authCodeImg'));
	});

	function reloadAuthImg(img) {
		var url = img.src.split('?')[0];
		var param = img.src.toQueryParams();
		param.r = new Date().getTime();

		var params = [];
		for(var i in param){
			params.push(i+'='+param[i]);
		}
		img.src = url + '?' + params.join('&');
	}
</script>
</body>
</html>
