package account

class AcTransaction {
    //id
    //指令id

    //外部指令序号，外部指令凭证，判重
    String commandSeqno
    //指令类型, transfer - 转账, freeze - 冻结, unfreeze - 解冻, error - 错误记录
    String commandType
    //结果码:见ErrorCodeException 定义
    String resultCode = '00'
    //事务凭证码，返回的唯一指令流水
    String transactionCode
    //发起账户
    AcAccount fromAccount
    //转到账户号
    AcAccount toAccount
    //发起账户号
    String fromAccountNo
    //转到账户号
    String toAccountNo
    //转账金额
    Long amount = 0
    //币种
    String currency = 'CNY'
    //转账类型，payment, transfer, refund, charge, withdrawn, royalty, royalty_rfd, frozen, unfrozen, fee, fee_rfd
    String transferType
    //交易流水号，外部系统交易流水号
    String tradeNo
    //外部订单号，保存
    String outTradeNo
    //事务序号,保存用，指令集内部顺序
    Integer transactionOrder
    //事务备注
    String note
    //事务摘要
    String subjict
    //创建时间
    Date dateCreated
    // 业务类型
    String srvType

    static constraints = {
        commandSeqno(size: 1..36, blank: false)
        commandType(size: 1..20, blank: false)
        resultCode(size: 1..4, blank: false)
        transactionCode(size: 1..16, blank: false)
        fromAccount(nullable: true)
        toAccount(nullable: true)
        fromAccountNo(size: 1..24, nullable: true)
        toAccountNo(size: 1..24, nullable: true)
        currency(size: 1..4, nullable: true)
        transferType(size: 1..16, nullable: true)
        tradeNo(size: 1..36, nullable: true)
        outTradeNo(size: 1..64, nullable: true)
        transactionOrder(nullable: false)
        note(size: 0..32, nullable: true)
        subjict(size: 1..1000, nullable: true)
        srvType(size: 1..20, nullable: true)
    }

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_ac_transaction']
    }

    def static transTypeMap = [payment: '支付', transfer: '转账',refundRef:'银行退款', refund: '退款', charge: '充值', withdrawn: '提现', royalty: '分润', royalty_rfd: '退分润', frozen: '冻结', unfrozen: '解冻', fee: '手续费', fee_rfd: '退手续费', agentpay:'代付',agentcoll:'代收', adjust:'调账', settle:'结算','void':'撤销',withdrawnRef:'提现失败']
    def static srvTypeMap = [onlinePay: '在线支付', royalty: '分润', agentCol:'代收', agentPay:'代付',mobilePay:'手机支付',personPortal:'个人门户',virtualAcc:'虚拟账户',settle:'清结算系统', 'offlinepay':'线下充值']
    def static noteMap = [代付: '代付',代付退款记账: '代付退款记账', 实时结算交易净额:'实时结算交易净额',钱包转账:'钱包转账',微信:'微信',微信扫码支付:'微信扫码支付',微信公众号支付:'微信公众号支付',null:'null',实时结算交易净额和null:'实时结算交易净额和null']

}
