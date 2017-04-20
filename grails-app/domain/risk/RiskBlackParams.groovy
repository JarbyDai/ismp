package risk

/**
 * 黑名单参数
 */
class RiskBlackParams {

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_risk_black_params']
    }

    String paramsType
    String paramsValue
    String remark

    static constraints = {
        paramsType(maxSize: 20)
        paramsValue(maxSize: 200)
        remark(maxSize: 200,nullable: true)
    }

    def static  paramsTypeMap = ['1':'银行卡号','2':'身份证号码','3':'手机号码','4':'IP']

}
