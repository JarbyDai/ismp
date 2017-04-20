package dsf

//银行对应的银行代码
class TbBankOrgCode {

    static mapping = {
        version false
        id generator: 'assigned', column:'ID'
    }
    String bankCode         //银行代码(英文缩写）
    String bankNames        //总行名简称
    String branchBank       //分行名简称
    String subBranchBank   //支行名简称
    String note              //银行名全称
    String bankOrgCode      //机构代码


    static constraints = {
        bankCode(nullable:true)
        bankNames(nullable:false)
        branchBank(nullable:true)
        subBranchBank(nullable:true)
        note(nullable:true)
        bankOrgCode(nullable:false)
    }
}
