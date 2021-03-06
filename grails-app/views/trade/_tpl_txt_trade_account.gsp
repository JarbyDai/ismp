#合利宝账务明细查询
#账号：[${session.cmCustomer.customerNo}]
#起始日期：[${params.startDate}]   终止日期: [${params.endDate}]
#-----------------------------------------账务明细列表----------------------------------------
时间                      商户订单号                                  流水号                                  类型                    收入金额（+元）        支出金额（-元）        账户余额（元）         摘要
<g:each in="${acSeqList}" status="i" var="acSeq">${acSeq.dateCreated.format("yyyy-MM-dd HH:mm:ss")}          ${acSeq.transaction.outTradeNo}	                  ${acSeq.transaction.tradeNo}	                  ${acSeq.transaction.transTypeMap[acSeq.transaction.transferType]}                           +<g:formatNumber number="${acSeq.debitAmount/100}" format="#0.00#"/>                -<g:formatNumber number="${acSeq.creditAmount/100}" format="#0.00#"/>                <g:formatNumber number="${acSeq.balance/100}" format="#0.00#"/>                   ${acSeq.transaction.subjict=='null'?'':acSeq.transaction.subjict}
</g:each>
#----------------------------------------账务明细列表结束-------------------------------------
#支出合计：${out_count}笔，共-<g:formatNumber number="${out_amount/100}" format="#.00#"/>元
#收入合计：${in_count}笔，共<g:formatNumber number="${in_amount/100}" format="#.00#"/>元
#导出时间：[${new Date().format('yyyy年MM月dd日 HH:mm:ss')}]
