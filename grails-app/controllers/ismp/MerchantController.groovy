package ismp

import boss.BoAgentPayServiceParams
import boss.BoCustomerService
import cfca.ra.common.vo.request.CertServiceRequestVO
import cfca.ra.common.vo.response.CertServiceResponseVO
import cfca.ra.toolkit.CFCARAClient
import cfca.ra.toolkit.exception.RATKException
import com.ecard.products.utils.CFCARAClientUtils
import grails.converters.JSON
import org.codehaus.groovy.grails.commons.ConfigurationHolder
import role.Role

import java.text.SimpleDateFormat

class MerchantController extends BaseController {
    def info = {
        def cmCorporationInfo = CmCorporationInfo.findByCustomerNo(session.cmCustomer.customerNo)
        [cmCorporationInfo: cmCorporationInfo]
    }

    def service = {
        def boCustomerServiceList = BoCustomerService.findAllByCustomerIdAndIsCurrent(session.cmCustomer.id, true)
        [boCustomerServiceList: boCustomerServiceList]
    }

    def bankaccount = {
        def cmCustomerBankAccount = CmCustomerBankAccount.findByCustomerAndIsDefault(session.cmCustomer, true)
        [cmCustomerBankAccount: cmCustomerBankAccount]
    }

    def servicedetail = {

        def customerNo = session.cmCustomer.customerNo
        def customer = CmCustomer.findByCustomerNo(customerNo)
        def service = BoCustomerService.findByIdAndCustomerId(params.id, customer.id)
//         def serviceParams = BoAgentPayServiceParams.get(service.id)
        if (!service || service.customerId != session.cmCustomer.id) {
            writeInfoPage "没找到该服务信息"
            return
        }

        [service: service]
    }

    //证书列表查看
    def certlist = {
        params.sort = params.sort ? params.sort : "createTime"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        def customer = session.cmCustomer
        def cmCustomerOperator =  session.cmCustomerOperator
        def roleId = cmCustomerOperator.roleSet
        def role = Role.get(roleId.toInteger())
        def query = {
            if (role.customerId == '0')
                like 'customerNo', customer.customerNo + '%'
            else
                eq('customerNo', customer.customerNo + session.cmCustomerOperator.id)
        }
        def merchantList = Merchant.createCriteria().list(params, query)
        def certCount = Merchant.createCriteria().count(query)
        Merchant merchant = Merchant.createCriteria().get {
            eq('customerNo', customer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime', new Date())
        }
        [certList: merchantList, merchant: merchant, certCount: certCount, max: params.max, customerNo: customer.customerNo]
    }
    //证书详细信息查看
    def certdetaillist = {
        def merchant = Merchant.get(Long.parseLong(params.id))
        [certMessage: merchant, customerNo: session.cmCustomer.customerNo]
    }

    //更新证书
    def updatecert = {
        log.info("---执行更新证书操作---");
        def customer = session.cmCustomer
        def containerName = params.containerName
        def signCert
        def serialNumber
        def message
        def success = '1'
        Map<String, String> result = new HashMap<String, String>()
        def query = {
            eq('customerNo', customer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
            ge('expiredTime', new Date())
        }
        def certificateList = Merchant.createCriteria().list(query)
        if (certificateList.size() > 0) {
            def certificate = certificateList.get(0)
            //更新记录
            CmCustomerCertificateRecord cmCustomerCertificateRecord = new CmCustomerCertificateRecord();
            cmCustomerCertificateRecord.createTime = new Date()
            cmCustomerCertificateRecord.customerNo = customer.customerNo + session.cmCustomerOperator.id
            cmCustomerCertificateRecord.operator = session.cmCustomerOperator.name
            cmCustomerCertificateRecord.status = '1'
            cmCustomerCertificateRecord.operateType = '1'
            cmCustomerCertificateRecord.save(flush: true, failOnError: true)

            String txCode = "1201"
            String dn = certificate.subject
            String p10 = params.p10
            log.info("更新证书p10：" + p10);
            try {
                CFCARAClient client = CFCARAClientUtils.getCFCARAClient();
                CertServiceRequestVO certServiceRequestVO = new CertServiceRequestVO();
                certServiceRequestVO.setTxCode(txCode);
                certServiceRequestVO.setDn(dn);
                certServiceRequestVO.setP10(p10);
                CertServiceResponseVO certServiceResponseVO = (CertServiceResponseVO) client.process(certServiceRequestVO);
                log.info("更新证书resultCode：" + certServiceResponseVO.getResultCode())
                log.info("更新证书结果信息：" + certServiceResponseVO.getResultMessage())
                if (CFCARAClient.SUCCESS.equals(certServiceResponseVO.getResultCode())) {
                    signCert = certServiceResponseVO.getSignatureCert()
                    serialNumber = certServiceResponseVO.getSerialNo()
                    success = '0';
                    message = "更新证书成功"

                    //更新记录修改
                    cmCustomerCertificateRecord.status = '0'
                    cmCustomerCertificateRecord.lastTime = new Date()
                    cmCustomerCertificateRecord.save(flush: true, failOnError: true)

                    //吊销旧证书
                    certificate.lastTime = new Date()
                    certificate.available = '1'
                    certificate.save(flush: true, failOnError: true)

                    //新证书记录
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss")
                    Merchant merchant = new Merchant()
                    merchant.subject = dn
                    merchant.serialNumber = serialNumber
                    merchant.operator = session.cmCustomerOperator.name
                    merchant.customerNo = customer.customerNo + session.cmCustomerOperator.id
                    merchant.signCert = signCert
                    merchant.checkStatus = '0'
                    merchant.containerName = containerName
                    merchant.applyTime = new Date()
                    merchant.createTime = sdf.parse(certServiceResponseVO.getStartTime())
                    merchant.expiredTime = sdf.parse(certServiceResponseVO.getEndTime())
                    merchant.lastTime = new Date()
                    merchant.available = '0'
                    merchant.save(flush: true, failOnError: true)
                }
            } catch (RATKException e) {
                e.printStackTrace();
            }
        } else {
            message = "该证书不存在"
            log.info("该证书不存在");
        }
        result.put("message", message)
        result.put("signCert", signCert)
        result.put("serialNumber", serialNumber)
        result.put("containerName", containerName)
        result.put("success", success)
        render result as JSON
    }

    //下载证书
    def downcert = {
        log.info("---执行下载证书操作---");
        params.sort = params.sort ? params.sort : "createTime"
        params.order = params.order ? params.order : "desc"
        params.max = 1
        def containerName = params.containerName
        def signCert
        def message
        def serialNumber
        def success = '1'
        Map<String, String> result = new HashMap<String, String>()
        def customer = session.cmCustomer
        def query = {
            eq('customerNo', customer.customerNo + session.cmCustomerOperator.id)
            eq('available', '0')
        }
        List<Merchant> certificateList = Merchant.createCriteria().list(query)
        success = '0';
        if (certificateList.size() == 0) {
            CmCustomerCertificateRecord cmCustomerCertificateRecord = new CmCustomerCertificateRecord();
            cmCustomerCertificateRecord.createTime = new Date()
            cmCustomerCertificateRecord.customerNo = customer.customerNo + session.cmCustomerOperator.id
            cmCustomerCertificateRecord.operator = session.cmCustomerOperator.name
            cmCustomerCertificateRecord.status = '1'
            cmCustomerCertificateRecord.operateType = '0'
            cmCustomerCertificateRecord.save(flush: true, failOnError: true)
            String txCode = "1101";
            String certType = "1";
            String customerType = "2";
            String userName = session.cmCustomerOperator.name;
            String identType = "8";
            String identNo = customer.businessLicenseCode;
            String keyAlg = "RSA";
            String keyLength = "2048";
            String branchCode = "678";
            String p10 = params.p10;
            log.info("申请p10证书：" + p10)
            try {
                CFCARAClient client = CFCARAClientUtils.getCFCARAClient();
                CertServiceRequestVO certServiceRequestVO = new CertServiceRequestVO();
                certServiceRequestVO.setTxCode(txCode);
                certServiceRequestVO.setCertType(certType);
                certServiceRequestVO.setCustomerType(customerType);
                certServiceRequestVO.setUserName(userName);
                certServiceRequestVO.setIdentType(identType);
                certServiceRequestVO.setIdentNo(identNo);
                certServiceRequestVO.setKeyLength(keyLength);
                certServiceRequestVO.setKeyAlg(keyAlg);
                certServiceRequestVO.setBranchCode(branchCode);
                certServiceRequestVO.setP10(p10);
                CertServiceResponseVO certServiceResponseVO = (CertServiceResponseVO) client.process(certServiceRequestVO);
                log.info("申请证书resultCode：" + certServiceResponseVO.getResultCode());
                log.info("申请证书结果信息：" + certServiceResponseVO.getResultMessage());
                if (CFCARAClient.SUCCESS.equals(certServiceResponseVO.getResultCode())) {
                    message = "证书申请成功";
                    signCert = certServiceResponseVO.getSignatureCert()
                    serialNumber = certServiceResponseVO.getSerialNo()
                    cmCustomerCertificateRecord.status = '0'
                    cmCustomerCertificateRecord.lastTime = new Date()
                    cmCustomerCertificateRecord.save(flush: true, failOnError: true)
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss")
                    Merchant merchant = new Merchant()
                    merchant.subject = certServiceResponseVO.getDn()
                    merchant.serialNumber = serialNumber
                    merchant.operator = session.cmCustomerOperator.name
                    merchant.customerNo = customer.customerNo + session.cmCustomerOperator.id
                    merchant.signCert = signCert
                    merchant.checkStatus = '0'
                    merchant.containerName = containerName
                    merchant.applyTime = new Date()
                    merchant.createTime = sdf.parse(certServiceResponseVO.getStartTime())
                    merchant.expiredTime = sdf.parse(certServiceResponseVO.getEndTime())
                    merchant.lastTime = new Date()
                    merchant.available = '0'
                    merchant.save(flush: true, failOnError: true)
                } else {
                    success = "1";
                    message = "证书申请失败，数据异常";
                    log.info(certServiceResponseVO.getResultMessage());
                }
            } catch (RATKException e) {
                success = "1";
                message = "证书申请失败,参数错误或连接RA系统出错";
                log.error("证书申请失败,参数错误或连接RA系统出错")
                e.printStackTrace()
            }
        } else {
            message = "证书安装成功"
            containerName = certificateList.get(0).containerName
            signCert = certificateList.get(0).signCert
            serialNumber = certificateList.get(0).serialNumber
        }
        log.info(message)
        result.put("message", message)
        result.put("signCert", signCert)
        result.put("containerName", containerName)
        result.put("serialNumber", serialNumber)
        result.put("success", success)
        render result as JSON
    }

    def downLoadAtv = {
        String path = ''
        String fileName = ConfigurationHolder.config.npCryptoKit.certEnrollment.fileName
        if (params.agent == 'ie') {
            if (params.type == 'x86') {
                path = ConfigurationHolder.config.ieX86.CryptoKitPath
            } else {
                path = ConfigurationHolder.config.ieX64.CryptoKitPath
            }
        }
        try {
            log.info("文件路径：" + path)
            File file = new File(path)
            if (!file.exists()) {
                log.error("找不到该文件路径：" + path)
            }
            response.setHeader("Content-disposition", "attachment; filename=" + fileName)
            response.contentType = "application/x-msdownload"
            response.setCharacterEncoding("UTF-8")
            FileInputStream fis = new FileInputStream(file)
            BufferedInputStream bis = new BufferedInputStream(fis)
            byte[] b = new byte[1024]
            long i = 0;
            OutputStream out = response.getOutputStream()
            while (i < file.size()) {
                int j = bis.read(b, 0, 1024)
                i += j;
                out.write(b, 0, j)
            }
            out.flush()
            out.close()
            bis.close()
        } catch (IOException e) {
            log.error("文件下载失败....")
            e.printStackTrace()
        }
    }
}
