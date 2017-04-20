package risk


class RiskBlackLog {

    static mapping = {
        id generator: 'sequence', params: [sequence: 'seq_risk_black_log']
    }

    String customerNo //客户号
    String customerType //客户类型
    String paramsType //参数类型
    String paramsValue //参数值
    String message     //描述 银行号：xxxxxxxx 存在银行卡号黑名单中
    String ip //操作ip
    Date createTime //创建时间

    static constraints = {
        customerNo (maxSize: 20,nullable: true)
        customerType (maxSize: 20,nullable: true)
        paramsType(maxSize: 20)
        paramsValue(maxSize: 200)
        message()
        ip(maxSize: 20,nullable: true)
        createTime()
    }

    def static paramsTypeMap = ['1':'银行卡号','2':'身份证号码','3':'手机号码','4':'IP']
    def static customerTypeMap = ['P':'个人','C':'企业']
}
