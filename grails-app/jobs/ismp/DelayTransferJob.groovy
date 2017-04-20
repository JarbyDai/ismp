package ismp

import account.AcTransaction
import com.ecard.products.utils.DateUtils
import trade.AccountCommandPackage

/**
 * Created with IntelliJ IDEA.
 * User: heli50
 * Date: 16-12-19
 * Time: 上午11:29
 * To change this template use File | Settings | File Templates.
 */
class DelayTransferJob {
    def accountClientService
    def cmTransactionQuotaService

    static triggers = {
       simple name: 'riskSynTrigger', startDelay:1000*10, repeatInterval:200*1000
    }
    def execute(){
        log.info '-------延时转账定时任务开始-------'
//        delayTransferService.serviceMethod()
        TradeBase.withTransaction {
            List<TradeTransfer> tradeTransferList = TradeTransfer.createCriteria().list {
                ne('delayTime','0')
                isNotNull('delayTime')
                eq ('status','processing')
                le 'startTransferTime', new Date()
                ge 'startTransferTime', DateUtils.addTime(new Date(), -1000*600)
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
                                    def resp = accountClientService.executeCommands(acPackage)
                                    if (!resp) {
                                        tradeBase.status = 'fail'
                                        tradeBase.save flash: true, flush: true
                                        log.info '网络连接错误;'
                                    } else {
                                        if (resp.result) {  //转账成功
                                            tradeBase.status = 'completed'
                                            tradeBase.save flash: true, flush: true
                                            cmTransactionQuotaService.quotaSuccessHandle(CmCustomer.get(tradeBase.payerId).customerNo, 'TRANSFER', tradeBase.amount/100)
                                        } else {  //转账失败
//                                        log.info resp
                                            tradeBase.status = 'fail'
                                            tradeBase.save flash: true, flush: true
                                            log.info '转账交易流水号为：' + tradeBase.tradeNo + '转账失败;'
                                        }
                                    }
                                } catch (Exception e) {
                                    tradeBase.status = 'fail'
                                    tradeBase.save flash: true, flush: true
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
        log.info '-------延时转账定时任务结束-------'
    }
}
