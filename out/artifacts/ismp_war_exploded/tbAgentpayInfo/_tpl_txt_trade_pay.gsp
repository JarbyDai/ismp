<%@ page import="dsf.TbAgentpayDetailsInfo; dsf.TbAgentpayInfo" %>
# 合利宝代收付批次查询
# 账    号：[${session.cmLoginCertificate.loginCertificate}]
# 起始日期：[${params.startDate}]      终止日期: [${params.endDate}]
#-----------------------------------------交易批次列表----------------------------------------
# 类型,创建时间, 批次号,交易号, 商户订单号,收款人名称,处理状态,交易反馈状态, 手续费（元）, 结算方式, 实付金额（元）, 备注,反馈原因,退款状态
<g:each in="${tradeList}" status="i" var="trade">${TbAgentpayInfo.batchTypeMap[trade.BATCH_TYPE]}	,<g:formatDate date="${trade.BATCH_SYSDATE}" format="yyyy-MM-dd HH:mm:ss"/>	,${trade.BATCH_ID}	,${trade.DETAIL_ID}	,${trade.TRADE_CUSTORDER},${trade.TRADE_CARDNAME}
    ,${TbAgentpayDetailsInfo.tradeStatusMap[trade.TRADE_STATUS]},${TbAgentpayDetailsInfo.tradeFeedbackcodeMap[trade.TRADE_FEEDBACKCODE]},<g:formatNumber currencyCode="CNY" number="${trade.TRADE_FEE}" format="#0.00#" />,${TbAgentpayDetailsInfo.feeTypeMap[trade.BATCH_FEETYPE]},
    <g:formatNumber currencyCode="CNY" number="${trade.TRADE_AMOUNT}" format="#0.00#" />  ,${trade.BATCH_REMARK1.toString()},${trade.TRADE_REASON},${TbAgentpayDetailsInfo.tradeRefuedMap[trade.TRADE_REFUED]}
</g:each>
#-------------------------------------------------------------------------------------------
# 交易笔数：${tradeListTotal}笔
# 交易总额：<g:formatNumber number="${totalamount}" format="#0.00#"/>元
# 导出时间：[${new Date().format('yyyy年MM月dd日 HH:mm:ss')}]      用户：${session.cmCustomer.registrationName}