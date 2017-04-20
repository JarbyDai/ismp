package ismp;

/**
 * Created with IntelliJ IDEA.
 * User: pc2
 * Date: 16-5-27
 * Time: 上午10:59
 * To change this template use File | Settings | File Templates.
 */
public enum UserAESKey {

    //COMMUNICATION_KEY("helipayeEalletKy"), //手机端通信密钥
    //COMMUNICATION_PC_KEY("helipayeEallPcKy"),  //PC端通信密钥
    PERSISTENCE_KEY("abdfabdfabdfabdf") ;//数据库AES加密解密密钥



    private final String key;

    private UserAESKey(String key) {
        this.key = key;
    }

    public String getKey() {
        return key;
    }
}
