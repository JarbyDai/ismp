package ismp

/**
 * Created with IntelliJ IDEA.
 * User: admin
 * Date: 16-10-27
 * Time: 上午10:52
 * To change this template use File | Settings | File Templates.
 */
class TradeAttached {

    String id
    String service
    String mchId
    String transactionId
    String outTransactionId
    String outTradeNo
    String body
    Long totalFee
    String mchCreateIp
    String notifyUl
    String tradeType
    String timeEnd
    String remark1
    String remark2
    String remark3
    String bankType

    static mapping = {
        table 'trade_attached'
        cache   usage: 'read-only'
        version false
        id  type: 'string',column:"TRADE_NO"
    }

    static constraints = {
        service(maxSize: 32,nullable: true)
        mchId(maxSize: 32,nullable: true)
        transactionId(maxSize: 32,nullable: true)
        outTransactionId(maxSize: 32,nullable: true)
        outTradeNo(maxSize: 32,nullable: true)
        body(maxSize: 255,nullable: true)
        totalFee(maxSize: 19)
        mchCreateIp(maxSize: 16,nullable: true)
        notifyUl(maxSize: 255,nullable: true)
        tradeType(maxSize: 16,nullable: true)
        timeEnd(maxSize: 32,nullable: true)
        remark1(maxSize: 255,nullable: true)
        remark2(maxSize: 255,nullable: true)
        remark3(maxSize: 255,nullable: true)
        bankType(maxSize: 16,nullable: true)
    }

}
