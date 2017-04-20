package ismp

class CmTransactionQuota {

    String customerNo //商户号
    String customerType //商户类型
    String bizType //业务类型
    Double singleLimit //单笔限额
    Double singleDayLimit //单日限额
    Double dayTotalAmount = 0 //单日累计金额
    Integer singleDayNum //单日最大交易次数
    Integer dayTotalNumber = 0 //单日累计次数
    Double monthlyLimit //单月限额
    Double monthlyTotalAmount = 0 //单月金额累计
    Date createDate //创建时间
    String createOper //创建人
    Date editDate //修改时间
    String editOper //修改人

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_transaction_quota']
        version(false)
    }

    static constraints = {
        customerNo(maxSize: 20)
        customerType(maxSize: 10)
        bizType(maxSize: 20)
        dayTotalAmount(nullable: true)
        dayTotalNumber(nullable: true)
        monthlyLimit(nullable: true)
        monthlyTotalAmount(nullable: true)
        createOper(maxSize: 20)
        editOper(maxSize: 20)
    }

    static bizTypeMap = ['QUICK_PAYMENT':'快捷支付','GATEWAY_PAYMENT':'网关支付', 'CHARGE' : '充值', 'WITHDRAW' : '提现', 'TRANSFER' : '转账', 'REFUND' : '退款']
    static customerTypeMap = ['P':'个人','C':'企业']
}
