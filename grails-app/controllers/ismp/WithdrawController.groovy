package ismp

import account.AcAccount
import cfca.PKCS12
import cfca.RSAUtil
import cfca.TripleDES
import org.codehaus.groovy.grails.commons.ConfigurationHolder

import java.text.SimpleDateFormat

class WithdrawController extends BaseController {
    def beforeInterceptor = [action: this.&checkMobile]
    def withdrawService
    def operatorService

    protected checkMobile = {
        def cmCustomer = CmCustomer.get(session.cmCustomer.id)
        if (cmCustomer.status == 'init') {
            writeInfoPage "用户状态错误，不能做提现操作，请联系合利宝客服。", 'warn'
            return
        }
        if (cmCustomer.status in ['disabled', 'deleted']) {
            writeInfoPage "用户状态错误，不能做提现操作，请联系合利宝客服。", 'warn'
            session.cmCustomer = null
            return
        }
        def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(session.cmCustomer, true)
        if (!cmCustomerBankAccount) {
            writeInfoPage "您没有指定默认账户，系统无法做提现操作，请联系合利宝客服。"
            return
        }
        if (!session.cmCustomerOperator.defaultMobile) {
            writeInfoPage "您还没有绑定手机，不能进行提现操作，请先绑定手机。"
            return
        }
    }

    protected checkParams() {
        def res = [result: true, msg: 'ok']
        def amount = 0
        try {
            BigDecimal strAmount = new BigDecimal(params.amount)
            if (strAmount > 20000000) {
                res.result = false
                res.msg = "单笔提现金额不能超过20000000，请重新输入"
                return res
            }
            strAmount = strAmount.multiply(new BigDecimal(100))
            log.info "strAmount=" + strAmount
            amount = strAmount as Long
            if (amount < 1) {
                res.result = false
                res.msg = "金额不能小于0.01元"
                return res
            }
            params._amount = amount
        } catch (Exception e) {
            res.result = false
            res.msg = "无效金额，请重新输入"
            return res
        }
        log.info "amount=" + amount
        return res
    }

    def index = {
        def accountNo = session.cmCustomer.accountNo
        def acAccount_Main = AcAccount.findByAccountNo(accountNo)
        def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(session.cmCustomer, true)
        [acAccount_Main: acAccount_Main, cmCustomerBankAccount: cmCustomerBankAccount]
    }

    def step2 = {
        /* if (withForm {true}.invalidToken {false}) {
             writeInfoPage  "请勿重复提交数据"
             return;
         }*/

        def accountNo = session.cmCustomer.accountNo
        def acAccount_Main = AcAccount.findByAccountNo(accountNo)
        def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(session.cmCustomer, true)

        if (grailsApplication.config.verifyCaptcha != 'false' && !session.captcha?.isCorrect(params.captcha?.toUpperCase())) {
            session.captcha = null
            flash.message = '验证码不正确，请重新输入'
            render(view: 'index', model: [acAccount_Main: acAccount_Main, cmCustomerBankAccount: cmCustomerBankAccount])
            return
        }
        session.captcha = null
        //检查页面验证码
        def res = checkParams()
        if (res.result == false) {
            writeInfoPage res.msg
            return
        }

        def payAmount = params._amount

        CmTransactionQuota transactionQuota = CmTransactionQuota.findByCustomerNoAndBizType(session.cmCustomer.customerNo, 'WITHDRAW')
        if (transactionQuota) {
            boolean flag = false
            if (payAmount / 100 > transactionQuota.singleLimit) {
                flash.message = '提现金额超过单笔限额'
                flag = true
            } else if ((payAmount / 100 + transactionQuota.dayTotalAmount) > transactionQuota.singleDayLimit) {
                flash.message = '提现累计金额超过单日限额'
                flag = true
            } else if ((transactionQuota.dayTotalNumber + 1) > transactionQuota.singleDayNum) {
                flash.message = '提现累计次数超过单日限定次数'
                flag = true
            } else if ((payAmount / 100 + transactionQuota.monthlyTotalAmount) > transactionQuota.monthlyLimit) {
                flash.message = '提现累计金额超过单月限额'
                flag = true
            }
            if (flag) {
                render(view: 'index', model: [acAccount_Main: acAccount_Main, cmCustomerBankAccount: cmCustomerBankAccount])
                return
            }
        }
        Merchant merchant = Merchant.createCriteria().get {
            eq('customerNo', session.cmCustomer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime', new Date())
        }
        [acAccount_Main: acAccount_Main, cmCustomerBankAccount: cmCustomerBankAccount, servernum: "MDEyMzQ1Njc4OWFiY2RlZg==", merchant: merchant]
    }

    def sendMobileCaptcha = {
        def mobile_captcha = KeyUtils.getRandNumberKey(6)
        def content = '提现确认：您本次提现操作的验证码是' + mobile_captcha + '。【合利宝】'
        def cmCustomer_payer = session.cmCustomer
        def cmCustomerOperator_payer = session.cmCustomerOperator
        operatorService.sendMobileCaptcha(cmCustomer_payer, cmCustomerOperator_payer, cmCustomerOperator_payer.defaultMobile, content, mobile_captcha, 'withdrawal')
        render "ok"
    }

    def save = {
//        if (!withForm {true}.invalidToken {false}) {writeInfoPage "请不要重复提交数据" ;return}
        String amount = params.amount
        String payPass = params.payPass
        String clientrandom = params.clientrandom
        String signContent = params.signContent

        Merchant merchant = Merchant.createCriteria().get {
            eq('customerNo', session.cmCustomer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime', new Date())
        }
        if(!merchant){
            log.info("服务器上找不到该用户的有效证书，交易拒绝");
            writeInfoPage "服务器上找不到有效证书，交易拒绝"
            return
        }

        String signSource = "amount:" + amount + "|payPass:" + payPass + "|clientrandom:" + clientrandom
        if (RSAUtil.checkSign(merchant, signSource, signContent, "UTF-8")) {
            String pfxFileName = ConfigurationHolder.config.verifyCerPath;
            String pfxPassword = "123456";
            String RSAEncryptedDataBase64 = clientrandom;
            String RSBase64 = "MDEyMzQ1Njc4OWFiY2RlZg==";
            String tripleDESEncryptedDataBase64 = payPass;
            String payPwd = "";
            try {
                byte[] plainRCBinary = PKCS12.RSADecrypt(pfxFileName, pfxPassword, RSAEncryptedDataBase64);
                byte[] plainPWDBase64Binary = TripleDES.DecryptCipher(RSBase64, plainRCBinary, tripleDESEncryptedDataBase64);
                String plainPWDBase64 = new String(plainPWDBase64Binary);
                payPwd = plainPWDBase64
            } catch (Exception e) {
                e.printStackTrace();
            }
            def res = checkParams()
            if (res.result == false) {
                writeInfoPage res.msg
                return
            }
            def payAmount = params._amount

            CmTransactionQuota transactionQuota = CmTransactionQuota.findByCustomerNoAndBizType(session.cmCustomer.customerNo, 'WITHDRAW')
            if (transactionQuota) {
                boolean flag = false
                if (payAmount / 100 > transactionQuota.singleLimit) {
                    flash.message = '提现金额超过单笔限额'
                    flag = true
                } else if ((payAmount / 100 + transactionQuota.dayTotalAmount) > transactionQuota.singleDayLimit) {
                    flash.message = '提现累计金额超过单日限额'
                    flag = true
                } else if ((transactionQuota.dayTotalNumber + 1) > transactionQuota.singleDayNum) {
                    flash.message = '提现累计次数超过单日限定次数'
                    flag = true
                } else if ((payAmount / 100 + transactionQuota.monthlyTotalAmount) > transactionQuota.monthlyLimit) {
                    flash.message = '提现累计金额超过单月限额'
                    flag = true
                }
                if (flag) {
                    writeInfoPage flash.message
                    return
                }
            }

            //检查支付密码
            if (!payPwd) {
                writeInfoPage "请输入支付密码"
                return
            }
            def payer = session.cmCustomerOperator
            def str_pass = (payer.id + 'p' + payPwd).encodeAsSHA1()
            if (payer.payPassword != str_pass) {
                writeInfoPage "支付密码错误"
                return
            }
            //检查手机校验码
            def query = {
                eq('useType', 'withdrawal')
                eq('parameter', payer.id as String)
                eq('sendType', 'mobile')
                eq('isUsed', false)
                ge("timeExpired", new Date())
            }
            def cmDynamicKeyList = CmDynamicKey.createCriteria().list([sort: "id", order: 'desc'], query)
            def cmDynamicKey = (cmDynamicKeyList && cmDynamicKeyList.size() > 0) ? cmDynamicKeyList.first() : null
            if (grailsApplication.config.verifyCaptcha != 'false' && ((!cmDynamicKey) || (params.mobile_captcha != cmDynamicKey.verification))) {
                writeInfoPage "手机验证码错误，请重新输入"
                return
            }
            try {
                def msgreturn = withdrawService.withdrawal(cmDynamicKey, session.cmLoginCertificate, payAmount)
                if (msgreturn == 'true') {
                    writeInfoPage "提现操作成功", 'ok'
                } else {
                    log.info msgreturn
                    writeInfoPage "提现操作失败"
                }
            } catch (Exception e) {
                e.printStackTrace()
                writeInfoPage "提现操作失败"
            }
        } else {
            writeInfoPage "签名验证失败"
        }
    }

    def list = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            eq('payerId', session.cmCustomer.id)
            eq('tradeType', 'withdrawn')

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
        def list = TradeWithdrawn.createCriteria().list(params, query)
        def count = TradeWithdrawn.createCriteria().count(query)
        [tradeList: list, tradeListTotal: count]
    }
}
