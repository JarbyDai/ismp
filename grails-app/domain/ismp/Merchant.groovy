package ismp

class Merchant {

    static mapping = {
        table 'CM_CUSTOMER_CERTIFICATE'
        version false
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_cm_customer_certificate', initial_value: 1])
    }
    String available            //是否可用
    String customerNo           //商户号
    String operator             //操作人
    String serialNumber         //证书序列号
    String subject              //DN
    String containerName        //密钥容器名称
    String signCert             //证书内容
    String checkStatus          //审核状态
    Date createTime             //申请时间
    Date applyTime              //证书开始时间
    Date expiredTime            //过期日期
    Date lastTime               //最后更新时间

    static constraints ={
        available(maxSize:2,blank: false)
        customerNo(maxSize:20,blank: false)
        operator(maxSize:20,blank: false)
        serialNumber(maxSize:20,blank: false)
        subject(maxSize:100,blank: false)
        containerName(maxSize:50,blank: false)
        signCert(maxSize:3000,blank: false)
        checkStatus(maxSize:2,blank: false)
        lastTime(nullable:true)
    }

    def static  availableMap = ['0':'激活','1':'吊销']
    def static  checkStatusMap = ['0':'已审核','1':'未审核']
}
