package com.ecard.products.utils;

import cfca.ra.toolkit.CFCARAClient;
import cfca.ra.toolkit.exception.RATKException;
import org.springframework.core.io.ClassPathResource;
import java.io.InputStream;
import java.util.Properties;

public class CFCARAClientUtils {
    // 连接超时时间 毫秒
    public static int connectTimeout = 3000;
    // 读取超时时间 毫秒
    public static int readTimeout = 30000;
    // URL（http、https方式）
    public static String url = "";

    // 服务器ip（socket、ssl socket方式）
    public static String ip ="";
    // 服务器端口（socket、ssl socket方式）
    public static int port =9443;
    // 通信证书配置
    public static String keyStorePath ="";
    public static String keyStorePassword ="";
    // 信任证书链配置
    public static String trustStorePath ="";
    public static String trustStorePassword ="";

    static{
        try {
            Properties prop = new Properties();
            InputStream in = new ClassPathResource("app-config.properties").getInputStream();
            prop.load(in);
            connectTimeout = Integer.parseInt(prop.getProperty("merchant.connectTimeout").trim());
            readTimeout = Integer.parseInt(prop.getProperty("merchant.readTimeout").trim());
            url = prop.getProperty("merchant.certificateUrl").trim();
            ip = prop.getProperty("merchant.certificateIp").trim();
            port = Integer.parseInt(prop.getProperty("merchant.certificatePort").trim());
            keyStorePath = prop.getProperty("merchant.keyStorePath").trim();
            keyStorePassword = prop.getProperty("merchant.keyStorePassword").trim();
            trustStorePath = prop.getProperty("merchant.trustStorePath").trim();
            trustStorePassword = prop.getProperty("merchant.trustStorePassword").trim();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 客户端与RA之间为短链接
    // 该方法仅作为demo示例，使用时直接创建CFCARAClient对象即可
    // 连接参数不变时，多次调用可使用同一CFCARAClient对象，无需重新创建
    public static CFCARAClient getCFCARAClient() throws RATKException {
        int type = 2;
        CFCARAClient client = null;
        switch (type) {
        case 1:
            // 初始化为http连接方式，指定url
            client = new CFCARAClient(url, connectTimeout, readTimeout);
            break;
        case 2:
            // 初始化为https连接方式，指定url，另需配置ssl的证书及信任证书链
            client = new CFCARAClient(url, connectTimeout, readTimeout);
            client.initSSL(keyStorePath, keyStorePassword, trustStorePath, trustStorePassword);
            // 如需指定ssl协议、算法、证书库类型，使用如下方式
             //client.initSSL(keyStorePath, keyStorePassword, trustStorePath, trustStorePassword, "SSL", "IbmX509", "IbmX509", "JKS", "JKS");
            break;
        case 3:
            // 初始化为socket 连接方式，指定ip和端口
            client = new CFCARAClient(ip, port, connectTimeout, readTimeout);
            break;
        case 4:
            // 初始化为ssl socket 连接方式，指定ip和端口，另需配置ssl的证书及信任证书链
            client = new CFCARAClient(ip, port, connectTimeout, readTimeout);
            client.initSSL(keyStorePath, keyStorePassword, trustStorePath, trustStorePassword);
            // 如需指定ssl协议、算法、证书库类型，使用如下方式
            // client.initSSL(keyStorePath, keyStorePassword, trustStorePath, trustStorePassword, "SSL", "IbmX509", "IbmX509", "JKS", "JKS");
            break;
        default:
            break;
        }
        return client;
    }
}
