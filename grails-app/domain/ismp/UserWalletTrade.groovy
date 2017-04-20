package ismp

class UserWalletTrade {

    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_user_trade', initial_value: 1], column: 'trade_id')
    }

    String clientNo           // 客户唯一编号
    String tradeType          // 交易类型
    String currency           // 币种代码，如：CNY
    Long amount               // 交易金额
    Long accamount            // 实际交易金额
    Long previousBalance      // 上期余额
    Long currentBalance       // 当期余额
    String targetAccount      // 对方账号
    String targetAccountType  // 对方账号类型,1：钱包账户，2：银行卡号
    String targetName         // 对方名称
    String targetDepositBank  // 对方开户行
    Long fee                  // 手续费
    Date reqDate            // 交易申请时间
    Date completeDate       //交易完成时间
    String orderId          //订单号
    String merchantId       //订单商户号
    String serverOrderId    //服务端订单号（例如第三方电话充值平台生成的订单号）
    String clientTransNo    //终端交易流水号
    String transNo          //本钱包平台交易流水号
    String serverTransNo    //通道服务器交易流水号
    String inOut            //资金进出方向，1：进，2：出
    String status            //交易状态，0:待处理/待审核, 1:失败，2:处理中，3:成功, 4:已退款, 5:商户审核通过
    String checkFlag        //对账标志，0:未对账，1:已对账
    String note               // 交易结果说明
    String digest             // 摘要
    String purpose            // 用途
    String reserve1            // 备用

    static constraints = {
        clientNo(nullable: false)
        tradeType(nullable: false)
        currency(nullable: true)
        amount(nullable: false)
        accamount(nullable: true)
        previousBalance(nullable: true)
        currentBalance(nullable: true)
        targetAccount(nullable: false)
        targetAccountType(nullable: false)
        targetName(nullable: true)
        targetDepositBank(nullable: true)
        fee(nullable: true)
        reqDate(nullable: false)
        completeDate(nullable: true)
        orderId(nullable: true)
        merchantId(nullable: true)
        serverOrderId(nullable: true)
        clientTransNo(nullable: true)
        transNo(nullable:true)
        serverTransNo(nullable: true)
        inOut(nullable: true)
        status(nullable: true)
        checkFlag(nullable: true)
        note(nullable: true)
        digest(nullable: true)
        purpose(nullable: true)
        reserve1(nullable: true)

    }

    def static tradeMap = ['transferToWallet': '转账', 'rechargeWallet': '钱包充值','withdraw': '提现','mobileRecharge': '手机充值','ewalletPay':'支付','refundReq':'退款申请','refundTrans':'退款','transferIn':'转入']
    def static inOutMap = ['1': '进', '2': '出']
    def static statusMap = ['0':'待审核','1': '失败', '2': '处理中','3':'成功','4':'已退款','5':'审核通过']
    def static checkMap = ['0': '未对账', '1': '已对账']
}