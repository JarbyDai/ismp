package ismp

class UserOrder {
    static mapping = {
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator',params: [sequence_name: 'seq_user_order', initial_value: 1])
        version false
    }
    String orderId        //订单号
    String userId         //客户号
    String customerId    //商家商户号
    String orderTitle    //订单标题，订单总体说明，如：手机充值，购买商品，购买服务，理财等等
    String orderDetail   //订单详情，包括商品名称、商品编号，数量、单价等信息
    Long amount           //订单金额
    Long refundedAmount //已退款金额
    Date dateCreated
    Date lastUpdated
    String status
    String note

    static constraints = {
        orderId(maxSize:30,nullable: false,unique: true)
        customerId(maxSize:30,nullable: true)
        orderTitle(maxSize:64,nullable: false)
        orderDetail(maxSize:255,nullable: false)
        refundedAmount(nullable: true)
        status(maxSize:16,inList:['created','completed','canceled','refused','waitReceive'])
        note(maxSize:100,nullable: true)
        version(nullable: true)
    }

    def static statusMap = ['created':'等待支付', 'canceled':'撤销', 'refused':'风控拒绝', 'waitReceive':'等待收货', 'refund':'等待退款', 'completed':'完成', 'refunded':'退款完成']
}
