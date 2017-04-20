package cfca;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.security.PrivateKey;
import java.util.Date;
import java.util.Properties;

import ismp.Merchant;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cfca.sadk.algorithm.common.Mechanism;
import cfca.sadk.algorithm.common.PKIException;
import cfca.sadk.lib.crypto.JCrypto;
import cfca.sadk.lib.crypto.Session;
import cfca.sadk.util.Base64;
import cfca.sadk.util.KeyUtil;
import cfca.sadk.util.Signature;
import cfca.sadk.x509.certificate.X509Cert;
import cfca.sadk.x509.certificate.X509CertVerifier;
import org.springframework.core.io.ClassPathResource;


public class RSAUtil {

    private static Log log = LogFactory.getLog(RSAUtil.class);

    private static String pfxPath = "";

    private static String pfxPass = "";

    private static String cerPath = "";

    static Session session = null;
    static{
        try {
            Properties prop = new Properties();
            InputStream in = new ClassPathResource("app-config.properties").getInputStream();
            prop.load(in);
            in.close();
            pfxPath = prop.getProperty("pfx.path").trim();
            pfxPass = prop.getProperty("pfx.pass").trim();
            pfxPass = prop.getProperty("cer.path").trim();
            JCrypto.getInstance().initialize(JCrypto.JSOFT_LIB, null);
            session = JCrypto.getInstance().openSession(JCrypto.JSOFT_LIB);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 验证合利宝通知签名数据
     * @param sourceStr
     * @param signStr
     * @param charset
     * @return
     */
    public static boolean checkSign(Merchant merchant,String sourceStr,String signStr,String charset){

        boolean b = false;
        try {
            byte[] sourceData = sourceStr.getBytes(charset);
            byte[] signData = cfca.sadk.util.Base64.decode(signStr.getBytes());

            Signature sigUtil = new Signature();
            X509Cert userCert = sigUtil.getSignerX509CertFromP7SignData(signData);

            if(!merchant.getSerialNumber().equals(String.valueOf(userCert.getSerialNumber())) && !merchant.getSerialNumber().equals((userCert.getStringSerialNumber())) ){
                log.error("证书customerNo["+merchant.getCustomerNo()+"]序列号不匹配，服务器序列号："+merchant.getSerialNumber()+",商户证书序列号："+userCert.getStringSerialNumber());
                return b;
            }
//            if(!merchant.getSubject().equals(userCert.getSubject())){
//                log.error("商户["+merchant.getCustomerNo()+"]证书主题不匹配,服务器DN："+merchant.getSubject()+",商户证书DN："+userCert.getSubject());
//                return b;
//            }
//            if(!X509CertVerifier.verifyCertDate(userCert)){
//                log.error("商户["+customerNo+"]证书已过有效期:"+ userCert.getNotBefore() + "---" + userCert.getNotAfter());
//                return b;
//            }else{
//                log.info("商户["+customerNo+"]证书有效期:"+ userCert.getNotBefore() + "---" + userCert.getNotAfter());
//            }
//            X509CertVerifier.updateTrustCertsMap(ocaFilePath);
//            if(!X509CertVerifier.validateCertSign(userCert)){
//                log.error("商户["+customerNo+"]证书不是根证书颁发");
//                return b;
//            }
//            if (!X509CertVerifier.verifyCertByCRLOutLine(userCert, crlFilePath)) {
//                log.info("商户["+customerNo+"]证书已经被注销");
//                return b;
//            }
        return new cfca.sadk.util.Signature().p7VerifyMessageDetach(sourceData, signData, session);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("消息分离验证签名异常："+e.getMessage());
            return false;
        }
    }


    /**
     * 签名提交到合利宝的业务数据
     * @param sourceStr
     * @param charset
     * @return
     */
    public static String sign(String sourceStr,String charset){
        try {
            log.info("消息分离签名------------------------:sourceStr"+sourceStr+",charset:"+charset);
            PrivateKey priKey = KeyUtil.getPrivateKeyFromPFX(pfxPath,pfxPass);
            X509Cert cert = new X509Cert(new FileInputStream(cerPath));
            byte[] signByte =  new cfca.sadk.util.Signature().p7SignMessageDetach(Mechanism.SHA256_RSA,sourceStr.getBytes(charset),priKey, cert, session);
            return new String(Base64.encode(signByte));
        } catch (Exception e) {
            e.printStackTrace();
            log.error("消息分离签名异常："+e.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
        try {
            X509Cert cert = new X509Cert(new FileInputStream(cerPath));
            System.out.println("序列号："+cert.getSerialNumber());
            System.out.println("证书DN："+cert.getSubject());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (PKIException e) {
            e.printStackTrace();
        }
    }

}
