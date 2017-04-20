package ismp

/**
 * Created with IntelliJ IDEA.
 * User: heli50
 * Date: 16-1-5
 * Time: 下午12:29
 * To change this template use File | Settings | File Templates.
 */
class CmCustomerCertificateRecord {
    static mapping = {
        table 'CM_CUSTOMER_CERTIFICATE_RECORD' //商户证书申请记录
        version false
        id(generator: 'org.hibernate.id.enhanced.SequenceStyleGenerator', params: [sequence_name: 'seq_cm_certificate_record', initial_value: 1])
    }

    String customerNo           //商户号
    String status              //状态 0：成功，1：失败
    String operateType         //操作类型
    String operator            //申请人
    Date createTime             //申请时间
    Date lastTime              //最后修改时间

    static constraints ={
        customerNo(maxSize:20,blank: false)
        status(maxSize:2,blank: false)
        operator(maxSize:20,blank: false)
        operateType(maxSize:2,black:false)
        lastTime(nullable:true)
    }

    def static  statusMap = ['0':'成功','1':'失败']
    def static  operateTypeMap = ['0':'申请','1':'更新','2':'吊销']
}
