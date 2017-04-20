package dsf

/**
 * Created with IntelliJ IDEA.
 * User: Administrator
 * Date: 14-12-23
 * Time: 下午7:38
 * To change this template use File | Settings | File Templates.
 */
class TbAutoagentBankAccount {
    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_tb_autoagent_bankAccount']
        //id composite:['merchantId', 'bankName']
        version false
    }

    String merchantId
    String bankName
    String bankAccount
    String bankAccountName
    String innerAccount

    static constraints = {
        merchantId(size: 1..25, blank: false)
        bankName(size: 1..40, blank: false)
        bankAccount(size: 1..30, blank: false)
        bankAccountName(size: 1..60, blank: false)
        innerAccount(size: 1..30, blank: false)
    }
}
