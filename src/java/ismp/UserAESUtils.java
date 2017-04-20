package ismp;

import ismp.UserAESKey;
import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;

/**
 * @文件名: UserAESUtils
 * @功能描述:
 * @Create by Lee zjam on 2016/6/2 13:30
 * @email: 
 * @修改记录:
 */
public class UserAESUtils {

    static final String algorithmStr = "AES/ECB/PKCS5Padding";

    private static final Object TAG = "AES";

    static private KeyGenerator keyGen;

    static private Cipher cipher;

    static boolean isInited = false;

    private static void init() {
        try {
            keyGen = KeyGenerator.getInstance("AES");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        // 初始化此密钥生成器，使其具有确定的密钥长度。
        keyGen.init(128); // 128位的AES加密
        try {
            // 生成一个实现指定转换的 Cipher 对象。
            cipher = Cipher.getInstance(algorithmStr);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        }
        // 标识已经初始化过了的字段
        isInited = true;
    }

    private static byte[] genKey() {
        if (!isInited) {
            init();
        }
        // 首先 生成一个密钥(SecretKey),
        // 然后,通过这个秘钥,返回基本编码格式的密钥，如果此密钥不支持编码，则返回 null。
        return keyGen.generateKey().getEncoded();
    }

    private static byte[] encrypt(byte[] content, byte[] keyBytes) {
        byte[] encryptedText = null;
        if (!isInited) {
            init();
        }
        /**
         * 类 SecretKeySpec 可以使用此类来根据一个字节数组构造一个 SecretKey， 而无须通过一个（基于 provider
         * 的）SecretKeyFactory。 此类仅对能表示为一个字节数组并且没有任何与之相关联的钥参数的原始密钥有用
         * 构造方法根据给定的字节数组构造一个密钥。 此构造方法不检查给定的字节数组是否指定了一个算法的密钥。
         */
        Key key = new SecretKeySpec(keyBytes, "AES");
        try {
            // 用密钥初始化此 cipher。
            cipher.init(Cipher.ENCRYPT_MODE, key);
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        }
        try {
            // 按单部分操作加密或解密数据，或者结束一个多部分操作。(不知道神马意思)
            encryptedText = cipher.doFinal(content);
        } catch (IllegalBlockSizeException  e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        }
        return encryptedText;
    }

    private static byte[] _encrypt(String content, String password) {
        try {
            byte[] keyStr = getKey(password);
            SecretKeySpec key = new SecretKeySpec(keyStr, "AES");
            Cipher cipher = Cipher.getInstance(algorithmStr);// algorithmStr
            byte[] byteContent = content.getBytes("utf-8");
            cipher.init(Cipher.ENCRYPT_MODE, key);// ʼ
            byte[] result = cipher.doFinal(byteContent);
            return result; //
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static byte[] _decrypt(byte[] content, String password) {
        try {
            byte[] keyStr = getKey(password);
            SecretKeySpec key = new SecretKeySpec(keyStr, "AES");
            Cipher cipher = Cipher.getInstance(algorithmStr);// algorithmStr
            cipher.init(Cipher.DECRYPT_MODE, key);// ʼ
            byte[] result = cipher.doFinal(content);
            return result; //
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        }
        return null;
    }

    private static byte[] getKey(String password) {
        byte[] rByte = null;
        if (password != null) {
            rByte = password.getBytes();
        } else {
            rByte = new byte[24];
        }
        return rByte;
    }

    /**
     * 将二进制转换成16进制
     *
     * @param buf
     * @return
     */
    public static String parseByte2HexStr(byte buf[]) {
        StringBuilder sb = new StringBuilder();
        for (byte aBuf : buf) {
            String hex = Integer.toHexString(aBuf & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            sb.append(hex.toUpperCase());
        }
        return sb.toString();
    }

    /**
     * 将16进制转换为二进制
     *
     * @param hexStr
     * @return
     */
    public static byte[] parseHexStr2Byte(String hexStr) {
        if (hexStr.length() < 1)
            return null;
        byte[] result = new byte[hexStr.length() / 2];
        for (int i = 0; i < hexStr.length() / 2; i++) {
            int high = Integer.parseInt(hexStr.substring(i * 2, i * 2 + 1), 16);
            int low = Integer.parseInt(hexStr.substring(i * 2 + 1, i * 2 + 2), 16);
            result[i] = (byte) (high * 16 + low);
        }
        return result;
    }

    // 注意: 这里的password(秘钥必须是16位的)
    //TODO - 自己填密约
//    private static final String keyBytes = "helipayeEalletKy";

    /**
     * 加密
     */
    public static String encrypt(String content) {
        // 加密之后的字节数组,转成16进制的字符串形式输出
        return parseByte2HexStr(_encrypt(content, UserAESKey.PERSISTENCE_KEY.getKey()));
    }

    public static String encrypt(String content, String password) {
        return parseByte2HexStr(_encrypt(content, password));
    }

    public static String encrypt(String content, UserAESKey key){
        return parseByte2HexStr(_encrypt(content, key.getKey()));
    }

    /**
     * 解密
     */
    public static String decrypt(String content) {
        // 解密之前,先将输入的字符串按照16进制转成二进制的字节数组,作为待解密的内容输入
        byte[] b = _decrypt(parseHexStr2Byte(content), UserAESKey.PERSISTENCE_KEY.getKey());
        if (b == null) {
            return null;
        }
        return new String(b);
    }

    public static String decrypt(String content, String password) {
        // 解密之前,先将输入的字符串按照16进制转成二进制的字节数组,作为待解密的内容输入
        byte[] b = _decrypt(parseHexStr2Byte(content), password);
        return new String(b);
    }

    public static String decrypt(String content, UserAESKey key) {
        // 解密之前,先将输入的字符串按照16进制转成二进制的字节数组,作为待解密的内容输入
        byte[] b = _decrypt(parseHexStr2Byte(content), key.getKey());
        return new String(b);
    }

    /*public static void main(String[] args) {
      String cont = "18217070966";
       String encrypt = encrypt(cont);
       System.out.println(encrypt);
      String res = decrypt("15C9F3F9E26800031AC5BB9A9BFE8E6E");
      System.out.println(res);
        AESMessageSigner aesencrypt=new AESMessageSigner();
        aesencrypt.setKeyWord("MYgGnQE2+DAS973vd1DFHg==");
        String filedata="HDvqi10LCBr5E/zf7Ls3mIBhfmeZJN7nSjEAdpvE8mnKy2jTYRdu7ed8XCH/EJUrt3/tFOXRC0Zf2dTFtb98qnTODno8ZcQFfRrZoGs4AQcsC/2S0MA3nN+pCRUwgH2kHa2M11GRaAY0D/jgOn0QTEo1cXXtjFfqPtCLA1doYprwYsDNnknE9pnRONm7PaVy7g0V8cUalnRdZlA8UnPdvcK4a7DYDU0hgr2uY/AhcPhErsmMsW6u1EEoxrez3dJ0x9tV6bLreYQpFjTvwG38vahptyNR907nUD8/U+41EOTPsPoec5f6PxS//dyWwy+ei9+3DiZW3fHw/LDA+R3EYbuC+BpKcoskFYm5vTfpOzDzLirkaVd4y57XPhgWw4yRnyzyi8FHruUrRpXBGAZojb3wmcUsZZoxmAX0yT6yXzQqNgEtNhqYM35yG97EhLAbo9aw3xfUEBlSvKO6fcBkXhVrjj90yvKDnBvzDt3cbeihSWgpc6bpihlGFVV6AigZxgloQeroUn4WIaP1oRzTkqilkRxAXp/LG9Xiebyvqp9qxSIZu5H6qgJOI30I2eVBJ/wPY4fxWRkJMI/4WouGef3zSMoRGKgPLlP501N4xGy4IMgsjX/YZNRQNJiJDr40YKZyZ2vG53XVke+tlm3/9ELkG7ebNkCC9iXBOQ8eQkHdXZkgiMCyLg4idJASCD+MpfDB94Ad69DMilp1Uc0a8vJXvK8DRHMtoSLapVI8n1gofjjUIm4/c+qPqY3UfunQSXitdVwbxGSAit2yl9RK/N4IW80iyUqUDQlLy5O2QjfgtBsVMpMHiezG9AKH1VgoyljNRCxcIQIEmdZcBEc/Kim5x8djI19eM4n9F8TpzmhA2ln/lxCm5o47rvABiaBQ1CVU9ijPcRngE3fHRmkL77SMUNtsO3Tb+SqqFizFfurnDw/93Ryy769tiiUXtMpEn4gYZ1BIRJwdOzMKpIEH9yaJd7xhawDJYpYJGWoY+Jk/4VNzoH5+XK/BkSjKBY+ZdNNg/Z236a2G1naD+P6eeykX8XE1StEIfnGp3O2jy2OFr0OUR56gkvoziIZpfluf7+4zRn8hAZnB5jp5p7gANmq/28i/aOVuLT0hBqi6hprQDbieYSjxO1mU8eXb0u3S6MYtIzDntDgDqfSZzzIH67+XBK57N/oDq+8C3q5ZrciD3zREnjT6z8Xkkkjpv1G/WkVcw47Xwln3x8CoQy4ECcNPuHQFj4W/YHleViBjB5ASeXTC33cjA+Aur8ozIFHILyy1M6ghp5/uUnCIGQoV/stZjUC8Vwi8KB21kOU/96R89CWbqOPXC2YNSVKdHpJEaK7dqHhgR5ihHrWuLDOEFda1aAuaguGqfk2hukxT64dYtKXYewKhMJ4PAPyaveoSnbjIrsJnBEhPIv6H736ZoUUyqXQCJLArlF3/DtVDvPpA2L0WAj++aMJxtsS4zA+TROZE2d4KsouZU1Sqkw3BusgqYdaX9dME9V1cslS96uRAe26zv8mBfkVsU/0lqNaARdxnj6dDQovdHJ1qmnkZpjYzErxUMBEqr2oXpw/ImzZvFfAX5Og48I27FVZq6RLkG/LPkB7cjYszu8rWFZZ4/GEcSEySDjQScJV11wETyKHPxem7D8Js9VAMNmreFGpkWaA19moOWV6E0pv95ZZ/5xQHpIbB3idyN/k9P/saCTnXHwhUEU/tQwnKmUumWvyy+qiMR3myhiyNvnG18PMRURt3j8Jfg/S6sEpjiWLpUW70i+f+jxYbbxLu/76Yfh54tjaDA2vhTGWSDU/DNWfQQ1VfZyrSbXiGu7o9tZLCrbjZWAZ1tqVdhQnZ4UXNbvoCirStPnVM+PcjomGD+7SwvgnVcYuPRRF1zFzVTIMBNPKy2EtZefgjJLFiyFDpecGU";
        String decryptstr=aesencrypt.decrypt(new String(filedata));
        Pattern p = Pattern.compile("\t|\r|\n");
        Matcher m = p.matcher(decryptstr);
        decryptstr = m.replaceAll("");
        System.out.print(" 解密成功!生成明文内容为：\rn"+decryptstr);

    }   */




    public static void main(String[] args) {
      //  System.out.println(encrypt("4503021",UserAESKey.PERSISTENCE_KEY));
       // System.out.println(displayngEmail("QQ@163.com"));

        //QQ****@****com
    }
    //手机号码 隐藏中间8位
    public static String displayPhoneNo(String phoneNo){
        if(isNull(phoneNo)){
            return "";
        }
       // phoneNo=decrypt(phoneNo);
        if(phoneNo.length() != 11){
            return phoneNo;
        }
        String MD ="";
        for(int i=3;i<phoneNo.length()-1;i++){
            MD=MD+"*";
        }
        String displayStr = phoneNo.replaceAll(phoneNo.substring(3,phoneNo.length()-1),MD);

        displayStr=phoneNo.substring(0,3);
        for(int i=3;i<phoneNo.length()-2;i++){
            displayStr=displayStr+"*";
        }
        displayStr=displayStr+phoneNo.substring(phoneNo.length()-2,phoneNo.length());
        return displayStr;
    }

    //身份证 隐藏中间8位
    public static String displayIdentitNo(String identitNo){

        if(isNull(identitNo)){
            return "";
        }
        String displayStr="";
        identitNo=decrypt(identitNo);
        if(identitNo.length()!=18 && identitNo.length()!=15){
            return identitNo;
        }
        displayStr=identitNo.substring(0,4);
        for(int i=4;i<identitNo.length()-2;i++){
            displayStr=displayStr+"*";
        }
        displayStr=displayStr+identitNo.substring(identitNo.length()-2,identitNo.length());
        return displayStr;


    }

    //身份证 隐藏中间4位
    public static String displayIdentitNumber(String identitNo){

        if(isNull(identitNo)){
            return "";
        }
        String displayStr="";
        //identitNo=decrypt(identitNo);
        if(identitNo.length()!=18 && identitNo.length()!=15){
            return identitNo;
        }
        displayStr=identitNo.substring(0,8);
        for(int i=8;i<identitNo.length()-4;i++){
            displayStr=displayStr+"*";
        }
        displayStr=displayStr+identitNo.substring(identitNo.length()-4,identitNo.length());
        return displayStr;


    }
    //邮箱 隐藏中间8位
    public static String displayngEmail(String  email){

        if(isNull(email)){
            return "";
        }
      //  email=decrypt(email);
        if(email.length() < 5){
            return email;
        }

        String emailstr[] =email.split("[@.]");
        if(emailstr.length!=3){
            return email;
        }
        String displayStr="";
        if(emailstr[0].length()>2){
            displayStr =emailstr[0].substring(0,2);
            for(int i=2;i<emailstr[0].length();i++){
                displayStr=displayStr+"*";
            }
            displayStr = displayStr+"@";
        }
        else{
            displayStr=emailstr[0]+"@";
        }
        for(int y=0;y<emailstr[1].length();y++){
            displayStr=displayStr+"*";
        }
        displayStr=displayStr+"*"+emailstr[2];
        return displayStr;
    }

    /**
     * 判断对象是否为空
     * @param obj
     * @return
     */
    public static boolean isNull(Object obj){
        if(obj==null||"".equals(obj.toString().trim())||"null".equalsIgnoreCase(String.valueOf(obj))){
            return true;
        }
        return false;
    }



}
