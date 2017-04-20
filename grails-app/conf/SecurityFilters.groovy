import ismp.CmOpLog
import ismp.CmOpRelation
import org.springframework.ui.ModelMap

class SecurityFilters {
    def filters = {
        loginCheck(controller: '*', action: '*') {
            before = {
                if (!controllerName) return true
                def curUrl = controllerName + "/" + (actionName == null ? "" : actionName)
                if (curUrl in ['loginInterface/authenticate', 'agentpay/pay', 'agentpay/coll', 'agentpay/payquery', 'agentpay/collquery', 'agentpay/paysinglequery', 'agentpay/collsinglequery', 'application/index', 'application/confirm', 'application/checkEmail', 'agentpay/billset']) {
                    return true
                }
                if (!session.cmCustomer && !"login".equals(controllerName) && !"captcha".equals(controllerName) && !"merGuide".equals(controllerName)) {
                    redirect(controller: "login", action: "login")
                    return false
                } else {
                    //检查权限
                    def hasPerm = true;
                    if (!((curUrl in session.modelUrlMap || curUrl in session.defModelUrlMap) || !(curUrl in session.modelMap))) {
                        hasPerm = false
                    }

                    if (session.cmCustomer?.customerCategory == 'travel') {
                        if (curUrl == 'charge/index' || curUrl == 'transfer/index' || curUrl == 'withdraw/index') {
                            hasPerm = false
                        }
                    }


                    if (!hasPerm) {
                        //log.info "noaccess"
                        render(view: "/error", model: [type: 'error', msg: "No access to this operation."])
                        return false
                    }
                }
                return true
            }
        }

        //操作日志记录
        opLog(controller: '*', action: '*') {
            after = { ModelMap m ->
                def curUrl = controllerName + "/" + (actionName == null ? "" : actionName)
                if (curUrl in ['loginInterface/authenticate', 'agentpay/pay', 'agentpay/coll', 'agentpay/payquery', 'agentpay/collquery', 'agentpay/paysinglequery', 'agentpay/collsinglequery', 'agentpay/billset']) {
                    return true
                }

                if (session.cmLoginCertificate && !['captcha'].contains(controllerName)) {
                    boolean flag = true;
                    if (m) {
                        Iterator iter = m.keySet().iterator();
                        while (iter.hasNext()) {
                            try {
                                if (m[iter.next()].hasErrors()) {
                                    flag = false
                                }
                            } catch (Exception e) {}
                        }
                    }
                    String message = flash.message
                    if(message && (message.contains('失败') || message.contains('错误'))){
                        flag = false
                    }
                    CmOpLog log = new CmOpLog()
                    log.account = session.cmLoginCertificate.loginCertificate
                    log.customerNo = session.cmCustomer.customerNo
                    log.controller = controllerName
                    log.action = actionName
                    log.operateStatus = (flag ? '0' : '1')
                    log.ip = request.getHeader('X-Real-IP') ? request.getHeader('X-Real-IP') : request.getRemoteAddr();
                    if (params.containsKey('loginpwd')) {
                        params.loginpwd = '******'
                    }
                    if (params.containsKey('password')) {
                        params.password = '******'
                    }
                    if (params.containsKey('newpassword')) {
                        params.newpassword = '******'
                    }
                    if (params.containsKey('confirm_newpassword')) {
                        params.confirm_newpassword = '******'
                    }
                    log.params = params.toString()
                    CmOpRelation opRelation = new CmOpRelation()
                    opRelation.controllers = controllerName
                    opRelation.controllerName = controllerName
                    opRelation.actions = actionName
                    opRelation.actionName = actionName
                    opRelation.save()
                    log.save()
                }

                if("login".equals(controllerName) && "logout".equals(actionName)){
                     if(session !=null )session.invalidate();
                }
                return true
            }
        }
    }
}
