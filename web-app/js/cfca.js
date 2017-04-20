var CFCA_CONTROL = function(params){
    var my = this;
    var CryptoAgent = "";
    var CryptoKit = "";
    var SecEditBox = "";
    my.CryptoKit_isSelected = false;

    /**
     * 判断是否为空
     * @param value
     * @returns {boolean}
     */
    my.isNull = function(value) {
        if (typeof(value) == "function") {
            return false;
        }
        return (value == undefined || value == null || value == "" || value.length == 0);
    };

    my.defaultSetting = {
        CrytoAgentUrl_X86 : "", //ie_X86下载证书控件cab包的路径
        CrytoAgentUrl_X64 : "", //ie_X64下载证书控件cab包的路径
        CryptoKitUrl_X86 : "",  //ie_X86签名控件cab包的路径
        CryptoKitUrl_X64 : "",   //ie_X64签名控件cab包的路径
        SecEditBoxObject_X86 : "",  //ie_X86密码控件cab包的路径
        SecEditBoxObject_X64 : ""   //ie_X64密码控件cab包的路径
    };

    my.setting = {
        CrytoAgentUrl_X86 :  my.isNull(params.CrytoAgentUrl_X86) ? my.defaultSetting.CrytoAgentUrl_X86: params.CrytoAgentUrl_X86,
        CrytoAgentUrl_X64 : my.isNull(params.CrytoAgentUrl_X64) ? my.defaultSetting.CrytoAgentUrl_X64: params.CrytoAgentUrl_X64,
        CryptoKitUrl_X86 :  my.isNull(params.CryptoKitUrl_X86) ? my.defaultSetting.CryptoKitUrl_X86: params.CryptoKitUrl_X86,
        CryptoKitUrl_X64 : my.isNull(params.CryptoKitUrl_X64) ? my.defaultSetting.CryptoKitUrl_X64: params.CryptoKitUrl_X64,
        SecEditBoxObject_X86 :  my.isNull(params.SecEditBoxObject_X86) ? my.defaultSetting.SecEditBoxObject_X86: params.SecEditBoxObject_X86,
        SecEditBoxObject_X64 : my.isNull(params.SecEditBoxObject_X64) ? my.defaultSetting.SecEditBoxObject_X64: params.SecEditBoxObject_X64
    };



    /**
     * 初始化下载证书控件
     */
    var initCryptoAgent = function(){
        var cDiv = document.createElement("div");
        cDiv.style.display = 'none';
        if (navigator.appName.indexOf("Internet") >= 0 || navigator.appVersion.indexOf("Trident") >= 0) {
            if (window.navigator.cpuClass == "x86") {
                cDiv.innerHTML = "<object id=\"CryptoAgent\" codebase=\"" + my.setting.CrytoAgentUrl_X86 + "\" classid=\"clsid:FC660173-E20D-4B7C-9525-C2A600374081\" ></object>";
            } else {
                cDiv.innerHTML = "<object id=\"CryptoAgent\" codebase=\"" + my.setting.CrytoAgentUrl_X64 + "\" classid=\"clsid:CAB74D75-F039-4AE1-9E40-FC92334552F5\" ></object>";
            }
        }
        document.body.appendChild(cDiv);
        CryptoAgent = document.getElementById("CryptoAgent");
    }

    /**
     * 初始化签名控件
     */
    var initCryptoKit = function(){
        var cDiv = document.createElement("div");
        cDiv.style.display = 'none';
        if (navigator.appName.indexOf("Internet") >= 0 || navigator.appVersion.indexOf("Trident") >= 0) {
            if (window.navigator.cpuClass == "x86") {
                cDiv.innerHTML = "<object id=\"CryptoKit\" codebase=\"" + my.setting.CryptoKitUrl_X86 + "\" classid=\"clsid:F85F87C6-D116-4E71-A3FF-B75FA4BCA29F\" ></object>";
            } else {
                cDiv.innerHTML = "<object id=\"CryptoKit\" codebase=\"" + my.setting.CryptoKitUrl_X64 + "\" classid=\"clsid:C7FA6694-ABA1-4CDF-A3FE-75A5830DA848\" ></object>";
            }
        }
        document.body.appendChild(cDiv);
        CryptoKit = document.getElementById("CryptoKit");
    }

    /**
     * 初始化密码控件
     */
    var initSecEditBox = function(){
        var cDiv = document.getElementById("SecEditBoxDiv");
        if(cDiv){
            if (navigator.appName.indexOf("Internet") >= 0 || navigator.appVersion.indexOf("Trident") >= 0) {
                if (window.navigator.cpuClass == "x86") {
                    cDiv.innerHTML = my.setting.SecEditBoxObject_X86;
                } else {
                    cDiv.innerHTML = my.setting.SecEditBoxObject_X64;
                }
            }
            SecEditBox = document.getElementById("SecEditBox");
        }
    }

    /**
     * 获取p10和密钥集容器名称
     * @constructor
     */
    my.requireP10AndContainName = function(){
        var containerNameAndP10 = {'p10':'', 'containerName':''};
        try {
            var keyAlgorithm = "RSA";
            var keyLength = 2048;
            var cspName = "Microsoft Enhanced Cryptographic Provider v1.0";
            var strSubjectDN = "CN=certRequisition,O=CFCA TEST CA,C=CN";
            var res1 = CryptoAgent.CFCA_SetCSPInfo(keyLength, cspName);
            if (!res1) {
                var errorDesc = CryptoAgent.GetLastErrorDesc();
                alert(errorDesc);
                return containerNameAndP10;
            }
            var res2 = CryptoAgent.CFCA_SetKeyAlgorithm(keyAlgorithm);
            if (!res2) {
                var errorDesc = CryptoAgent.GetLastErrorDesc();
                alert(errorDesc);
                return containerNameAndP10;
            }
            var pkcs10Requisition = CryptoAgent.CFCA_PKCS10CertRequisitionwithMD5(strSubjectDN, 1, 0);
            if (!pkcs10Requisition) {
                var errorDesc = CryptoAgent.GetLastErrorDesc();
                alert(errorDesc);
                return;
            }
            containerNameAndP10['p10'] = pkcs10Requisition;
            containerNameAndP10['containerName'] = CryptoAgent.CFCA_GetContainer();
            return containerNameAndP10;
        }catch (e) {
            return containerNameAndP10;
        }
    }


    /**
     * 安装证书
     * @param containerName 容器名
     * @param signCert 证书内容
     * @returns {boolean}
     * @constructor
     */
    my.installSingleCert = function(containerName,signCert) {
        var keyAlg = 'RSA';
        var keyLength = parseInt('2048', 10);
        var csp = 'Microsoft Enhanced Cryptographic Provider v1.0';
        try {
            CryptoAgent.CFCA_SetCSPInfo(keyLength, csp);
            CryptoAgent.CFCA_SetKeyAlgorithm(keyAlg);
            CryptoAgent.CFCA_ImportSignCert(1, signCert, containerName);
            return true;
        } catch (e) {
            return false;
        }
    }

    /**
     * 选择证书
     * @param serialNumFilter  证书序列号
     * @returns {boolean}
     */
    my.selectCertificate = function(serialNumFilter){
        try {
            var bSelectCertResult = CryptoKit.SelectCertificate("", "", serialNumFilter);
            // Opera浏览器，NPAPI函数执行结果为false时，不能触发异常，需要自己判断返回值。
            if (!bSelectCertResult){
                return false;
            }
            my.CryptoKit_isSelected = true;
            return true;
        }catch (e) {
            return false;
        }
    }

    /**
     * 签名
     * @param source 需要签名的原文串
     * @returns {*} 签名信息
     */
    my.sign = function(source) {
        try {
            var signature = CryptoKit.SignMsgPKCS7(source, "SHA-1", false);
            return signature;
        } catch (e) {
            return "";
        }
    }

    my.getEncryptedPassword = function(){
        try{
            return SecEditBox.GetValue();
        }catch (e){
            return "";
        }
    }

    my.getClientRandom = function(){
        try{
            return SecEditBox.GetClientRandom();
        }catch (e){
            return "";
        }
    }

    my.setSecEditBoxClear = function(){
        try{
            SecEditBox.Clear();
        }catch (e){
            return "";
        }
    }

    /**
     * 检测是否安装下载证书插件
     * @returns {boolean}
     */
    my.checkCryptoAgentActiveX = function(){
           return CryptoAgent;
    }

    /**
     * 检测是否安装签名插件
     * @returns {boolean}
     */
    my.checkCryptoKitActiveX = function(){
        return CryptoKit ;
    }

    /**
     * 检测是否安装密码插件
     * @returns {boolean}
     */
    my.checkSecEditBoxActiveX = function(){
        return SecEditBox;
    }

    initCryptoAgent();
    initCryptoKit();
    initSecEditBox();

}

/**
 * 若加载方式不行则下载安装控件
 * @constructor
 */
var installActiveX = function(){
    if (confirm("没有安装控件，点击确定安装")) {
        var agent = "";
        var type = "";
        if (navigator.appName.indexOf("Internet") >= 0 || navigator.appVersion.indexOf("Trident") >= 0) {
            agent = "ie";
            if (window.navigator.cpuClass == "x86") {
                type = "x86"
            } else {
                type = "x64"
            }
        }
        window.location.href = "${request.contextPath}/merchant/downLoadAtv?agent=" + agent + "&type=" + type;
    }
}

/**
 * 检测是否IE浏览器
 * @returns {boolean}
 */
var checkIE = function() {
    if (navigator.appName.indexOf("Internet") < 0 && navigator.appVersion.indexOf("Trident") < 0){
        return false;
    }else{
        return true;
    }
}


/**
 * @param params   createLinkString($('#testSign').serializeArray())
 * @returns {string}  按key排序
 */
function createLinkString(params) {
    for(var i = params.length; i--; ) {
        if(params[i].name === 'sign') {
            params.splice(i, 1);
        }
    }
    params.sort();
    var linkedStr = "";
    for(i = 0; i < params.length; ++i) {
        if (i == params.length - 1) {//拼接时，不包括最后一个&字符
            linkedStr = linkedStr + params[i].name + "=" + params[i].value;
        } else {
            linkedStr = linkedStr + params[i].name + "=" + params[i].value + "&";
        }
    }

    return linkedStr;
}

function reqAndUpdate(url, cfca_control, obj){
    var result = cfca_control.requireP10AndContainName();
    var p10 = result.p10;
    var containerName = result.containerName;
    p10 = encodeURIComponent(p10);
    containerName = encodeURIComponent(containerName);
    $.ajax({
        type: "post",
        url: url,
        data: "p10=" + p10 + "&containerName=" + containerName,
        async: false,
        success: obj
    });
}
