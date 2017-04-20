import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class CSRFFilters {
    // referer must match serverURL, optionally https
    static validRefererPrefix = "^${CH.config.grails.serverURL}"//.replace("http", "https?")
//    static sqlKey=[" and ", " exec "," execute ", " count ", " chr ", " mid ", " master ", " or ", " truncate ", " char ", " declare ", " join ",'\\u',"insert ", "select ", "delete ", "update ","create ","drop ","union ","having ",'%20','where ','alert','script','javascript','ascii(','iframe','<img','<IMG','<a','<A','%3cimg','%20or%20','0%','%20and%20','--','eval','%']
    static sqlKey=[" | "," & "," ; "," \$ "," % "," @ ","\\' "," \\u "," /* "," */ "," < "," > "," <> "," () "," + "," open "," sysopen "," system ",
            " ( "," ) "," and "," exec "," execute "," insert "," select "," delete "," update "," count "," drop "," * "," chr "," mid "," master ",
            " truncate "," char "," declare "," sitename "," net user "," xp_cmdshell "," or "," - "," like "," create "," table "," from "," grant "," use ",
            " group_concat "," column_name "," information_schema.columns "," table_schema "," union "," where "," join "," order "," by "," count "," -- "," # ",
            " like' "," alert "," having ",'script','javascript','ascii(','iframe','<img','<IMG','<A','<a','%3cimg','0x0d','0x0a','0x08','%20or%20','%20and%20','eval','0%','%20']
    static urlKey = ["script","alert", "|", ";", "'", "\""]
    def filters = {
        checkReferer(controller:'*', action:'*') {
            before = {
                //if (request.method.toUpperCase() == "POST") {
                    if(controllerName in ['login','captcha'])return true
                    def referer = request.getHeader('Referer')
                    if(referer && referer =~ validRefererPrefix){
                        return true
                    }else{
                        return true;
                    }
                //}
            }
        }

        checkInputParams(controller:'*', action:'*') {
            before = {
                for(param in params){
                    //println param.key+":["+param.value+"]"
                    def strParamValue=param.value as String
                    if(!(param.key in ['controller','action','sort','offset','max','order','page'])&&strParamValue){
                        for(keyw in sqlKey){
                            //println "keyw=["+keyw+"],strParamValue=["+strParamValue+"]"
                            if(strParamValue.toLowerCase().indexOf(keyw)>=0){
                                println "请求链接中存在跨站点脚本，请检查后重新输入"
                                println "请求参数========》"+params
                                println "错误文本========> "+keyw
                                render(view:"/error",model: [type:'error',msg:"您输入了非法字符，请检查后重新输入。"])
                                return false
                            }
                        }
                    }
                }
            }
        }

        checkRequestURL(uri:'/**',controller:'*', action:'*') {
            before = {
                String  url  = request.getScheme()+"://"; //请求协议 http 或 https
                url+=request.getHeader("host");  // 请求服务器
                url+=request.getRequestURI();     // 工程名
                if(request.getQueryString()!=null) //判断请求参数是否为空
                    url+="?"+request.getQueryString();   // 参数
                for (key in urlKey){
                    if(url.toLowerCase().indexOf(key)>=0){
                        println "请求链接中存在跨站点脚本，请检查后重新输入"
                        println "请求链接========》"+url
                        println "错误文本========> "+key
                        render(view:"/error",model: [type:'error',msg:"请求链接中存在跨站点脚本，请检查后重新输入。"])
                        return false
                    }
                }
            }
        }

//        checkCSRFToken(controller:'*',action:'*'){
//            before={
//                if(controllerName in ['login','captcha'])return true
//                // 从 session 中得到 csrftoken 属性
//                String sToken = (String)session.getAttribute('csrftoken');
//                if(sToken == null){
//                    // 产生新的 token 放入 session 中
//                    sToken = UUID.randomUUID().toString();
//                    session.setAttribute('csrftoken',sToken);
//                    response.addHeader('csrftoken',sToken)
//                    return true
//                }
//                else{
//                    // 从 HTTP 头中取得 csrftoken
//                    String xhrToken =request.getHeader('csrftoken')
//                    // 从请求参数中取得 csrftoken
//                    String pToken = request.getParameter('csrftoken')
//                    //println "check sToken="+sToken+",xhrToken="+xhrToken+",pToken="+pToken
//                    if(sToken != null && xhrToken != null && sToken.equals(xhrToken)){
//                        sToken = UUID.randomUUID().toString()
//                        session.setAttribute('csrftoken',sToken)
//                        response.addHeader('csrftoken',sToken)
//                        return true
//                    }else if(sToken != null && pToken != null && sToken.equals(pToken)){
//                        sToken = UUID.randomUUID().toString();
//                        session.setAttribute('csrftoken',sToken);
//                        response.addHeader('csrftoken',sToken)
//                        //println "new sToken="+sToken
//                        return true
//                    }else{
//                        redirect(controller:"login", action:"login")
//                        return false
//                    }
//                }
//            }
//        }
    }

}
