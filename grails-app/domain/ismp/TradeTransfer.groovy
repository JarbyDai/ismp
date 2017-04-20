package ismp

class TradeTransfer extends TradeBase {

    String submitType
    Long customerOperId
    String submitter
    String submitIp
    //转账是否需要审批
    String transferModel

    String delayTime = 0

    Date startTransferTime  //到账时间

    static constraints = {
        submitType(maxSize: 32, inList: ['manual', 'automatic'])
        submitter(maxSize: 32)
        submitIp(maxSize: 20)
        transferModel(nullable: true)
        delayTime(nullable: true, maxSize: 2, inList: delayTimeMap.keySet().toList())
        startTransferTime(nullable: true)
    }
    def static submitTypeMap = ['manual': '人工提交', 'automatic': '接口提交']
    def static delayTimeMap = ['0': '立即到账', '1': '一小时', '4': '四小时', '8': '八小时', '24': '二十四小时']
}
