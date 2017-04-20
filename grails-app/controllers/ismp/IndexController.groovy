package ismp

import account.AcAccount
import boss.BoNews
import ismp.TradeBase
import java.text.SimpleDateFormat

class IndexController {

    def index = {redirect(action: account)}

    def account={
        //def accountNo=CmCustomerAccountMapping.findByCustomerAndAccountType(session.cmCustomer,'main')?.accountNo
        def accountNo=session.cmCustomer.accountNo
        //println  "accountNo="+accountNo
        def acAccount_Main=AcAccount.findByAccountNo(accountNo)
        def acAccount_Frozen=AcAccount.findByParentIdAndAccountType(acAccount_Main?.id,'freeze')

        def PWDmsg = ""
        def lpwdT = session.cmCustomerOperator.lastPWChangeTime
        def now = new Date();
        if(lpwdT){//1323158635196 //1323160938874
            long days = (now.time - lpwdT.time)/1000/60/60/24
            if(days > 90)
                PWDmsg = "您的登陆密码已经超过90天未修改!请及时更改登陆密码!"
            else if(days > 80)
                PWDmsg = "您的登陆密码已经 "+ days + " 天未修改!请及时更改登陆密码!"
//            else if(days > 80)
//                PWDmsg = "您的登陆密码即将过期，请及时更改登陆密码!"
//            else
//                PWDmsg = "您的登陆密码还有 "+ (90 - days) + " 天过期!请及时更改登陆密码!"
        }

        def queryTrade = {
//            eq('dateCreated', Date.parse("yyyy-MM-dd", (new SimpleDateFormat("yyyy-MM-dd")).format(new Date())))
            or {
                eq('payeeId', session.cmCustomer.id)
                eq('payerId', session.cmCustomer.id)
            }
        }
        params.offset = 0
        params.max = 5
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        def tradeList = TradeBase.createCriteria().list(params, queryTrade)

        [acAccount_Main:acAccount_Main,acAccount_Frozen:acAccount_Frozen,PWDMsg:PWDmsg,tradeList:tradeList]
    }
}
