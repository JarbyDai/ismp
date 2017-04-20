<!-- 头部 -->
    	<div class="top">
        	<div class="logo"><img src="${resource(dir:'images',file:'ht_logo.jpg')}" width="284" height="91" /></div>
            <g:if test="${session.cmCustomerOperator}">
			<div class="top_rightfont">你好，${session.cmCustomerOperator?.name} [<span class="lsfong"><a href="${createLink(controller:'login',action:'logout')}">退出</a></span>] </div>
			</g:if>
        </div>
<!-- / 头部 -->