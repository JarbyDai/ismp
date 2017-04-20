package ismp

class CmTransactionQuotaService {

    static transactional = true

    /**
     * 交易成功后处理限额中的金额、次数累计
     * @param customerNo  客户号
     * @param bizType  业务类型
     * @param amount  交易金额
     * @return  返回一个map， isSuccess: 0表示失败，1表示成功；msg: 返回信息
     */
   def quotaSuccessHandle(String customerNo, String bizType, Double amount) {
        CmTransactionQuota transactionQuota = CmTransactionQuota.findByCustomerNoAndBizType(customerNo, bizType)
        if(transactionQuota){
            transactionQuota.dayTotalAmount += amount
            transactionQuota.dayTotalNumber ++
            transactionQuota.monthlyTotalAmount += amount
            transactionQuota.save(failOnError: true, flush: true)
        }
    }
}
