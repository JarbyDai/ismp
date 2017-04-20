package ismp

import cfca.RSAUtil
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import account.AcAccount
import boss.BoBankDic
import boss.BoAcquirerAccount
import boss.BoMerchant
import java.text.SimpleDateFormat

class ChargeController extends BaseController {

    def dataSource_ismp

    def index = {
        def accountNo = session.cmCustomer.accountNo
        def acAccount_Main = AcAccount.findByAccountNo(accountNo)
        def acAccount_Frozen = AcAccount.findByParentIdAndAccountType(acAccount_Main?.id, 'freeze')

        def dbIsmp =  new groovy.sql.Sql(dataSource_ismp)
        def channelSql = """select t.id,
                                t.acquire_code,
                                t.acquire_indexc,
                                t.bankid,
                                t.channel_type
                             from gwchannel t
                            where t.acquire_indexc not like 'COMM%'
                            and t.acquire_indexc in (select b.channel_code from cm_customer_channel b where b.CUSTOMER_ID=${session.cmCustomer.id})
                             and t.bank_type = '1'
                             and t.channel_type = '2'
                              and t.channel_sts = '0'
                          """
        def channelList = dbIsmp.rows(channelSql)

        [acAccount_Main: acAccount_Main, acAccount_Frozen: acAccount_Frozen, channelList: channelList]
    }
    def confirm = {
        def accountNo = session.cmCustomer.accountNo
        def acAccount_Main = AcAccount.findByAccountNo(accountNo)
        def acAccount_Frozen = AcAccount.findByParentIdAndAccountType(acAccount_Main?.id, 'freeze')

        // 渠道 直连B2C、银联B2C、直连B2B、银联B2B
        def channelMap = new HashMap<String, String>()
        // 更新0927关于加入B2B充值
        def payChannel = params.bankname.toUpperCase()
        def bankDic = BoBankDic.findByCode(payChannel)
        log.info 'normal BoBankDic is ' + bankDic
        if (bankDic) {
            def accountList = BoAcquirerAccount.findAllByBankAndStatus(bankDic, 'normal')
            log.info 'normal BoAcquirerAccount is ' + accountList
            if (accountList) {
                def list = BoMerchant.findAllByChannelStsAndAcquirerAccountInList('0', accountList)
                log.info 'normal Merchant is ' + list
                if (list) {
                    for (BoMerchant bm: list) {
                        String key = bm.channelType
                        if (bm.bankType == '1' && !channelMap.get(key)) {
                            log.info 'add Normal Channel ' + bm.acquireIndexc
                            channelMap.put(key, bm.acquireIndexc)
                        }
                    }
                }
            }
        }

        def unionDic = BoBankDic.findByCode('unionpay')
        log.info 'unp BoBankDic is ' + unionDic
        if (unionDic) {
            def accountList = BoAcquirerAccount.findAllByBank(unionDic, 'normal')
            log.info 'unp BoAcquirerAccount is ' + accountList
            if (accountList) {

                //UNP-PSBC
                def unpChannel = ('UNP-' + payChannel).toUpperCase()
                log.info 'unp B2C channel ' + unpChannel
                //UNP-PSBC_B2B
                def unpB2BChannel = ('UNP-' + payChannel + '_B2B').toUpperCase()
                log.info 'unp B2B channel ' + unpB2BChannel

                def unpList = BoMerchant.createCriteria().list {
                    eq('channelSts', '0')
                    or {
                        eq('acquireIndexc', unpChannel)
                        eq('acquireIndexc', unpB2BChannel)
                    }
                    //eq('acquireIndexc',unpChannel)
                    'in'('acquirerAccount', accountList)
                }
                if (unpList) {
                    for (BoMerchant bm: unpList) {
                        String key = bm.channelType
                        if (bm.bankType == '1' && !channelMap.get(key)) {
                            log.info 'add UNP Channel ' + bm.acquireIndexc
                            channelMap.put(key, bm.acquireIndexc)
                        }
                    }
                }
/*
                //UNP-PSBC_B2B
                def unpB2BChannel = ('UNP-'+ payChannel + '_B2B').toUpperCase()
                log.info 'unp B2B channel ' + unpB2BChannel
                def unpB2BList = BoMerchant.createCriteria().list {
                   eq('channelSts','0')
                   eq('acquireIndexc',unpB2BChannel)
                   'in'('acquirerAccount',accountList)
                }
                if(unpB2BList){
                   for(BoMerchant bm : unpList){
                       String key = bm.channelType
                       if(!channelMap.get(key)){
                           channelMap.put(key, bm.acquireIndexc)
                       }
                   }
                }*/
            }
        }

        log.info 'Map size is ' + channelMap.size()
        if (!channelMap) {
            writeInfoPage "没有银行渠道"
            return
        }
        Merchant merchant = Merchant.createCriteria().get {
            eq('customerNo', session.cmCustomer.customerNo+session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime',new Date())
        }
        [acAccount_Main: acAccount_Main, acAccount_Frozen: acAccount_Frozen, channelMap: channelMap, "bankname": params.bankname, merchant:merchant]
    }

    def reconfirm = {

    }
    def create = {

        /*if(!withForm{true}.invalidToken {false}){
         writeInfoPage  "请勿重复提交数据"
         return;
      }*/

        def accountNo = session.cmCustomer.accountNo
        def acAccount_Main = AcAccount.findByAccountNo(accountNo)

        Merchant merchant = Merchant.createCriteria().get {
            eq('customerNo', session.cmCustomer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime', new Date())
        }
        if(!merchant){
            log.info("服务器上找不到有效证书，交易拒绝");
            writeInfoPage "服务器上找不到有效证书，交易拒绝"
            return
        }

        String signContent = params.signContent
        String signSource = "bankname:"+params.bankname
        signSource += "|buyer_name:"+params.buyer_name
        signSource += "|buyer_id:"+params.buyer_id
        signSource += "|preference:"+params.preference
        if(params.preference == 'SPDB_B2B'||params.preference == 'CMBC_B2B'){
            signSource += "|payCusNo:"+params.payCusNo
        }
        if(params.preference == 'BOCM_B2B'){
            signSource += "|amount:"+params.payCusNoid
        }
        signSource += "|amount:"+params.amount

        if(!RSAUtil.checkSign(merchant,signSource,signContent,"UTF-8")){
            writeInfoPage "数据可能被篡改，交易拒绝"
            return;
        }

        if (params.payCusNo) {
            maps.'pay_cus_no' = params.payCusNo
        }
        def msg = "";
        def xamount = 0;
        if (!params.amount) {
            msg = "金额不能空";
        } else {
            if (!(params.amount ==~ /^(\d{0,8}+)(\.\d{1,2})?$/)) {
                msg = "无效金额格式"
            } else {
                xamount = (params.amount as double)
                if (xamount < 0.01) {
                    msg = "金额不能小于0.01元"
                }
            }
        }
        if(msg){
            writeInfoPage msg
            return
        }

        CmTransactionQuota transactionQuota = CmTransactionQuota.findByCustomerNoAndBizType(session.cmCustomer.customerNo, 'CHARGE')
        if (transactionQuota) {
            boolean flag = false
            if (xamount > transactionQuota.singleLimit) {
                msg = '充值金额超过单笔限额'
                flag = true
            } else if ((xamount + transactionQuota.dayTotalAmount) > transactionQuota.singleDayLimit) {
                msg = '充值累计金额超过单日限额'
                flag = true
            } else if ((transactionQuota.dayTotalNumber + 1) > transactionQuota.singleDayNum) {
                msg = '充值累计次数超过单日限定次数'
                flag = true
            } else if ((xamount / 100 + transactionQuota.monthlyTotalAmount) > transactionQuota.monthlyLimit) {
                msg = '充值累计金额超过单月限额'
                flag = true
            }
            if (flag) {
                writeInfoPage msg
                return
            }
        }

        // 更新0927关于加入B2B充值
        def payChannel = params.bankname.toUpperCase()
        def bankDic = BoBankDic.findByCode(payChannel)
        def list
        if (bankDic) {
            def accountList = BoAcquirerAccount.findAllByBankAndStatus(bankDic, 'normal')
            list = BoMerchant.findAllByChannelStsAndAcquirerAccountInList('0', accountList)
        } else {
            def unionDic = BoBankDic.findByCode('unionpay')
            if (!unionDic) {
                writeInfoPage "没有银行渠道"
                return
            }
            def accountList = BoAcquirerAccount.findAllByBank(unionDic, 'normal')
            if (!accountList) {
                writeInfoPage "没有银行渠道"
                return
            }
            //UNP-PSBC
            def unpChannel = ('UNP-' + payChannel).toUpperCase()
            list = BoMerchant.createCriteria().list {
                eq('channelSts', '0')
                eq('acquireIndexc', unpChannel)
                'in'('acquirerAccount', accountList)
            }
            log.info 'UNP BoMerchant list is ' + list
        }
        if (!list) {
            writeInfoPage "没有银行渠道"
            return
        }

        params.service = "create_charge";
        params.currency = "CNY";
        params._input_charset = grailsApplication.config.grails.views.gsp.encoding;
        println 'this is test----------------- '
        def preference
        if(params.preference) {
           preference= params.preference.replaceFirst('UNP-', '')
        }
       def maps = ["service": params.service,
                "currency": params.currency,
                "charset": params._input_charset,
                "amount": params.amount,
                "buyer_name": params.buyer_name,
                "buyer_id": params.buyer_id,
                "preference": preference,
                "create_date":  new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date())
        ];

        log.info 'ok le '
        def sign = FormFunction.createMD5Sign(maps, ConfigurationHolder.config.cashier.MD5_KEY, params._input_charset)
        println maps;
        maps.sign = sign;
        println url: grailsApplication.config.charge.targetUrl + "?" + FormFunction.params2string(maps)
        redirect(url: grailsApplication.config.charge.targetUrl + "?" + FormFunction.params2string(maps));


    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            eq('payeeId', session.cmCustomer.id)
            eq('tradeType', 'charge')

            if (!params.startDate) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd")
                Calendar calendar = Calendar.getInstance()
                params.endDate = sdf.format(calendar.getTime())
                calendar.add(Calendar.MONTH, -3)
                params.startDate = sdf.format(calendar.getTime())
            }

            String startDate = String.valueOf(params.startDate)
            int year = Integer.valueOf(startDate.substring(0, 4))
            int month = Integer.valueOf(startDate.substring(5, 7)) - 1
            int day = Integer.valueOf(startDate.substring(8, 10))
            Calendar calendar = Calendar.getInstance()
            calendar.set(year, month, day)
            ge('dateCreated', calendar.getTime())

            String endDate = String.valueOf(params.endDate)
            year = Integer.valueOf(endDate.substring(0, 4))
            month = Integer.valueOf(endDate.substring(5, 7)) - 1
            day = Integer.valueOf(endDate.substring(8, 10))
            calendar = Calendar.getInstance()
            calendar.set(year, month, day)
            le('dateCreated', calendar.getTime())
//            if (params.startDate) {
//                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDate))
//                if (!params.endDate) {
//                    le('dateCreated',Date.parse("yyyy-MM-dd", params.startDate).updated(month:Date.parse("yyyy-MM-dd", params.startDate).month+3)+1)
//                }
//            }
//            if (params.endDate) {
//                if (!params.startDate) {
//                    ge('dateCreated',Date.parse("yyyy-MM-dd", params.endDate).updated(month:Date.parse("yyyy-MM-dd", params.endDate).month-3));
//                }
//                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDate) + 1)
//            }
        }
        def list = TradeBase.createCriteria().list(params, query)
        def count = TradeBase.createCriteria().count(query)
        [tradeList: list, tradeListTotal: count]
    }
}