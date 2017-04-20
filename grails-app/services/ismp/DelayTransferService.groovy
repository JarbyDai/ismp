package ismp

import account.AcTransaction
import com.ecard.products.utils.DateUtils
import trade.AccountCommandPackage

class DelayTransferService {

    static transactional = true
    def accountClientService

    def serviceMethod() {
        List<TradeTransfer> tradeTransferList = TradeTransfer.createCriteria().list {
            ne('delayTime','0')
            isNotNull('delayTime')
            ge 'startTransferTime', DateUtils.addTime(new Date(), -1000*3600*24)
        }
        tradeTransferList.each {
            log.info "交易id号为: ${it.id}"
            def tradeAccountCommandSaf = TradeAccountCommandSaf.findByTradeId(it.id)
            if (tradeAccountCommandSaf) {
                def tradeBase = TradeBase.get(it.id)
                if (!tradeBase) {
                    log.info '转账交易不存在;'
                } else {
                    //查询账务流水，如果存在改变转账交易状态为完成，
                    def acAccount = AcTransaction.findAllByTradeNo(tradeBase?.tradeNo)
                    if (acAccount.size() > 0) {
                        tradeBase.status = 'completed'
                        tradeBase.save flash: true, flush: true
                    } else {
                        def commandNo = tradeAccountCommandSaf.commandNo
                        def acPackage = AccountCommandPackage.findByCommandNo(commandNo)
                        log.info "account command package: $acPackage.commandList"
                        if (!acPackage) {
                            log.info '转账交易不存在;'
                        } else {
                            try {
//                                def resp = accountClientService.executeCommands(acPackage)
                                if (!true) {
                                    log.info '网络连接错误;'
                                } else {
                                    if (false) {  //转账成功
                                        tradeBase.status = 'completed'
                                        tradeBase.save flash: true, flush: true
                                    } else {  //转账失败
//                                        log.info resp
                                        tradeBase.status = 'fail'
                                        tradeBase.save failOnError: true
                                        log.info '转账交易流水号为：' + tradeBase.tradeNo + '转账失败;'
                                    }
                                }
                            } catch (Exception e) {
                                tradeBase.status = 'fail'
                                tradeBase.save failOnError: true
                                log.info '转账失败;'
                                e.printStackTrace()
                            }
                        }
                    }
                }
            } else {
                log.info '转账交易不存在;'
            }
        }
    }
}
