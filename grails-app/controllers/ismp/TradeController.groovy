package ismp

import account.AcSequential
import com.ecard.products.utils.DateUtils
import jxl.*
import org.hibernate.Session
import org.hibernate.criterion.CriteriaSpecification
import org.hibernate.transform.AliasToEntityMapResultTransformer
import org.springframework.orm.hibernate3.HibernateCallback
import org.springframework.orm.hibernate3.HibernateTemplate
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFSheet

import org.codehaus.groovy.grails.commons.ConfigurationHolder
import boss.BoCustomerService
import com.burtbeckwith.grails.plugin.datasources.DatasourcesUtils
import groovy.sql.Sql
import account.AcAccount
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.hssf.usermodel.HSSFRow
import org.apache.poi.hssf.usermodel.HSSFCell
import boss.BoRefundModel
import boss.BoBankDic
import jxl.write.WritableWorkbook
import jxl.write.WritableSheet
import jxl.write.WritableFont
import jxl.write.WritableCellFormat
import jxl.write.Label
import settle.FtTrade
import common.ValidateUtil
import common.ConvertUtil

import java.text.SimpleDateFormat

class TradeController extends BaseController {
    def tradeNoService
    def exportService
    def refundService

    /*
    *  收款交易
    * */
    def sale = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        boolean isDownload = false
        if (params?.format && params.format in ["txt", "csv", "excel"]) {
            params.offset = 0
            params.max = 50000
            isDownload = true
        }

        String errmsg = ""
        String pattern = "yyyy-MM-dd HH:mm:ss"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "sale", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "sale", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "sale", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
                return
            }
        }
        def sqlStr = """
                        select
                            tb1.id as id,
                            tb1.trade_type as trade_type,
                            tb1.payment_Type as payment_Type,
                            tb1.service_Type as service_Type,
                            tb1.date_created as date_created,
                            tb1.subject as subject,
                            tb1.out_trade_no as out_trade_no,
                            tb1.trade_no as trade_no,
                            tb1.payer_name as payer_name,
                            tb1.amount as amount,
                            tb1.status as status,
                            tb1.fee_amount as fee_amount,
                            tb2.out_trade_no as b_out_trade_no,
                            tp.refund_amount as refund_amount,
                            ta.out_transaction_id as out_transaction_id
                        from
                            trade_base tb1
                        left outer join
                            trade_base tb2 on tb1.root_id = tb2.id
                        left outer join
                            trade_payment tp on tb1.id = tp.id
                        left outer join
                            trade_attached ta on tb1.trade_no = ta.trade_no
                        where
                            tb1.payee_Id ='${session.cmCustomer.id}' and
                            tb1.date_created between to_date('${params.startDate}','yyyy-mm-dd hh24:mi:ss') and to_date('${params.endDate}', 'yyyy-mm-dd hh24:mi:ss')
                            ${params.lastStartDate && params.lastEndDate ? " and tb1.last_Updated between to_date('${params.lastStartDate}','yyyy-mm-dd hh24:mi:ss') and to_date('${params.lastEndDate}', 'yyyy-mm-dd hh24:mi:ss')" : ""}
                            ${params.to ? "and (tb1.payer_name = '" + params.to + "' or tb1.payer_code = '" + params.to + "')" : ""}
                            ${params.tradeType && params.tradeType != null ? " and tb1.trade_type = '" + params.tradeType + "'" : ""}
                            ${params.paymentType && params.paymentType != null ? " and tb1.payment_type = '" + params.paymentType + "'" : ""}
                            ${params.serviceType && params.serviceType != null ? " and tb1.service_type = '" + params.serviceType + "'" : ""}
                            ${params.status ? " and tb1.status = '" + params.status + "'" : ""}
                            ${params.subject ? " and tb1.subject = '" + params.subject + "'" : ""}
                            ${(params.outTradeNo1 && TradeBase.findByOutTradeNo(params.outTradeNo1)) ? " and tb1.root_Id = '" + TradeBase.findByOutTradeNo(params.outTradeNo1).id + "'" : ""}
                            ${params.moneyMin ? " and tb1.amount >= '" + params.moneyMin + "'" : ""}
                            ${params.moneyMax ? " and tb1.amount <= '" + params.moneyMax + "'" : ""}
                            ${params.tradeNo ? " and tb1.trade_no = '" + params.tradeNo + "'" : ""}
                            ${params.outTradeNo ? " and tb1.out_trade_no = '" + params.outTradeNo + "'" : ""}
                            ${params.outTransactionId ? " and ta.out_transaction_id = '" + params.outTransactionId + "'" : ""}
                            ${isDownload ? "and ROWNUM<=" + params.max : ""}
                            ORDER BY date_created DESC
                    """

        def totalSql = """
                    SELECT COUNT(1) total_count, SUM(AMOUNT) total_amount FROM (${sqlStr})
                    """

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('ismp')
        def count = 0
        def totalamount = 0
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(sqlStr.toString())
            def totalSession = session.createSQLQuery(totalSql.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            totalSession.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            def total = totalSession.uniqueResult()
            count = total.TOTAL_COUNT
            totalamount = total.TOTAL_AMOUNT
            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)
        if (isDownload) {
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.setCharacterEncoding("GBK")
            response.contentType = "application/x-rarx-rar-compressed"
            render(template: "tpl_${params.format}_sale", model: [tradeList: result, tradeListTotal: count, totalamount: totalamount])
        } else {
            [tradeList: result, tradeListTotal: count, totalamount: totalamount]
        }
    }

    /*
   *  付款交易
   * */
    def buy = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        boolean isDownload = false
        if (params?.format && params.format in ["excel"]) {
            params.offset = 0
            params.max = 50000
            isDownload = true
        }

        String errmsg = ""
        String pattern = "yyyy-MM-dd HH:mm:ss"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "buy", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "buy", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "buy", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0, totalamount: 0])
                return
            }
        }

        def query = {
            eq('payerId', session.cmCustomer.id)
            or {
                eq('tradeType', 'payment')
                eq('tradeType', 'transfer')
                eq('tradeType', 'royalty')
            }
            if (params.to) {
                or {
                    eq('payeeName', params.to)
                    eq('payeeCode', params.to)
                }
            }
            if (params.tradeType) {
                eq('tradeType', params.tradeType)
            }
            if (params.status) {
                eq('status', params.status)
            }
            if (params.subject) {
                eq('subject', params.subject)
            }
            if (params.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                eq('tradeNo', params.tradeNo)
            }
            if (params.outTradeNo) {
                eq('outTradeNo', params.outTradeNo)
            }
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDate))
            le('dateCreated', Date.parse('yyyy-MM-dd', params.endDate))
        }

        def list = TradeBase.createCriteria().list(params, query)
        if (isDownload) {
            def totalAmount = list.sum { it.amount }
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.setCharacterEncoding("GBK")
            response.contentType = "application/x-rarx-rar-compressed"
            render(template: "tpl_${params.format}_trade_buy", model: [tradeList: list, tradeListTotal: list.size(), totalamount: totalAmount])
        } else {
            def total = TradeBase.createCriteria().get() {
                and query
                projections {
                    rowCount()
                    sum('amount')
                }
            }
            [tradeList: list, tradeListTotal: total[0], totalamount: total[1]]
        }

    }

    def refund = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        boolean isDownload = false
        if (params?.format && params.format in ["excel"]) {
            params.offset = 0
            params.max = 50000
            isDownload = true
        }

        String errmsg = ""
        String pattern = "yyyy-MM-dd"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "refund", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "refund", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "refund", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
                return
            }
        }

        def query = {
            ne('status', 'starting')
            or {
                eq('tradeType', 'refund')
                eq('tradeType', 'royalty_rfd')
            }

            or {
                eq('payerId', session.cmCustomer.id)
                eq('payeeId', session.cmCustomer.id)
            }
            if (params.to) {
                or {
                    eq('payerName', params.to)
                    eq('payerCode', params.to)
                    eq('payeeName', params.to)
                    eq('payeeCode', params.to)
                }
            }
            if (params.tradeType) {
                eq('tradeType', params.tradeType)
            }
            if (params.status) {
                eq('status', params.status)
            }
            if (params.subject) {
                eq('subject', params.subject)
            }
            if (params.outTradeNo1) {
                def tb = TradeBase.findByOutTradeNo(params.outTradeNo1)
                eq('rootId', tb?.id)
            }
            if (params.batch) {
                def refundBatch = RefundBatch.findByBatchNo(params.batch)
                eq('refundBatch', refundBatch?.id)
            }
            if (params.orderTradeNo) {
                def tb = TradeBase.findByOutTradeNo(params.orderTradeNo)
                eq('rootId', tb?.rootId)
            }
            ge('dateCreated', Date.parse('yyyy-MM-dd', params.startDate))
            le('dateCreated', Date.parse('yyyy-MM-dd', params.endDate))

            if (params.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                eq('tradeNo', params.tradeNo)
            }
            if (params.outTradeNo) {
                eq('outTradeNo', params.outTradeNo)
            }
            order("dateCreated", "desc")
        }

        def list = TradeRefund.createCriteria().list(params, query)
        if (isDownload) {
            def totalamount = list.sum { it.amount }
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.setCharacterEncoding("GBK")
            response.contentType = "application/x-rarx-rar-compressed"
            render(template: "tpl_${params.format}_refund", model: [tradeList: list, tradeListTotal: list.size(), totalamount: totalamount])
        } else {
            def total = TradeRefund.createCriteria().get() {
                and query
                projections {
                    rowCount()
                    sum('amount')
                }
            }
            [tradeList: list, tradeListTotal: total[0], totalamount: total[1]]
        }
    }

    def verify = {
        params.sort = params.sort ? params.sort : "uploadTime"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        String errmsg = ""
        String pattern = "yyyy-MM-dd"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -1, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "verify", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "verify", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }
        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "verify", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
                return
            }
        }
        def query = {
            eq('status', 'pass')
            eq('type', 'starting')
            eq('customerNo', session.cmCustomer.customerNo)
            eq('flag', true)
            if (params?.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params?.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                eq('tradeNo', params.tradeNo)
            }
            if (params.outTradeNo) {
                eq('outTradeNo', params.outTradeNo)
            }
        }
        def list = RefundAuth.createCriteria().list(params, query)
        def count = RefundAuth.createCriteria().count(query)
        [tradeList: list, tradeListTotal: count]
    }

    def authHistory = {
        params.sort = params.sort ? params.sort : "uploadTime"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        String errmsg = ""
        String pattern = "yyyy-MM-dd"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -1, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "authHistory", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "authHistory", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
            return
        }
        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "authHistory", model: [errmsg: errmsg, tradeList: null, tradeListTotal: 0])
                return
            }
        }

        def query = {
            eq('status', 'closed')
            eq('type', 'closed')
            eq('customerNo', session.cmCustomer.customerNo)
            eq('flag', true)
            if (params.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                eq('tradeNo', params.tradeNo)
            }
            if (params.outTradeNo) {
                eq('outTradeNo', params.outTradeNo)
            }
        }
        def list = RefundAuth.createCriteria().list(params, query)
        def count = RefundAuth.createCriteria().count(query)
        [tradeList: list, tradeListTotal: count]
    }
    def refundDetail = {
        def customerNo = session.cmCustomer.customerNo
        CmCustomer customer = CmCustomer.findByCustomerNo(customerNo)
        def trade = TradeRefund.findByIdAndPartnerId(params.id, customer.id)

        if (!trade || (trade.payerId != session.cmCustomer.id && (trade.payeeId != session.cmCustomer.id))) {
            writeInfoPage "没找到该交易"
            return
        }
        render(view: "detail", model: [trade: trade])
    }

    def buyDetail = {
        def customerNo = session.cmCustomer.customerNo
        def customer = CmCustomer.findByCustomerNo(customerNo)

        def trade = TradeBase.get(params.long("id"))

        //  def trade = TradeBase.findByIdAndPayeeId(params.id,customer.id)
        if (!trade || (trade.payerId != session.cmCustomer.id && (trade.payeeId != session.cmCustomer.id))) {
            writeInfoPage "没找到该交易"
            return
        }

        if (trade.tradeType == "withdraw") {
            trade = TradeWithdrawn.get(params.id)
        }
        render(view: "detail", model: [trade: trade])
    }
    def refundAuthDetail = {
        def customerNo = session.cmCustomer.customerNo
        def customer = CmCustomer.findByCustomerNo(customerNo)

        def trade = RefundAuth.findByIdAndCustomerNo(params.id, customer.customerNo)
        if (!trade || (trade.customerNo != session.cmCustomer.customerNo && (trade.operatorId != session.cmCustomerOperator.id))) {
            writeInfoPage "没找到该交易"
            return
        }
        render(view: "refundDetail", model: [trade: trade])
    }

    def refundPass = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def arr = ids.replace("[", "").split(',')
        arr = arr.collect { it as long }
        def refundAuth = RefundAuth.findAll("from RefundAuth as t where t.id in (:id)", [id: arr])
        //==============
//       for(RefundAuth ra : refundAuth){
//
//            def refundAuth1 = RefundAuth.findAllByBatchAndOutTradeNo(ra.batch, ra.outTradeNo)
//            BigDecimal totalMoney = 0
//            refundAuth1.each {
//                totalMoney += new BigDecimal(ra.amount)
//            }
//            def trade1 = TradeBase.findByOutTradeNo(ra.outTradeNo)
//            def allowRefund
//            if (trade1) {
//                allowRefund = trade1.amount - TradePayment.get(trade1.id).refundAmount
//            }
//            if(totalMoney>allowRefund){
//                 writeInfoPage "平台交易号" + ra.tradeNo + "已退款总金额大于可退金额"
//                return
//            }
//        }
        //=======================
        def results = 1
        def succ = 0
        def fail = 0
        for (RefundAuth ra in refundAuth) {
            def trade = TradeBase.findByOutTradeNoAndTradeNo(ra.outTradeNo, ra.tradeNo)
            try {
                results = refundService.refund(session.cmLoginCertificate, trade, ra.amount as long, ra.note, ra.batch?.id)

                if (results.result == 0) {
                    succ++
                    ra.authTime = new Date()
                    ra.operatorId = session.cmCustomerOperator.id
                    ra.status = 'closed'
                    ra.type = 'completed'
                    ra.save()
                } else {
                    fail++
                    ra.authTime = new Date()
                    ra.operatorId = session.cmCustomerOperator.id
                    ra.save()
                }
            } catch (e) {
                if ("refund amount is over the max".equals(e.getMessage())) {
                    writeInfoPage "平台交易号" + ra.tradeNo + "已退款金额大于交易金额"
                    return
                } else {
                    println e
                    writeInfoPage "平台交易号" + ra.tradeNo + "退款失败"
                    return
                }

            }
        }
        redirect(action: 'redirect', params: [type: "ok", succcount: succ, failcount: fail])

        //writeInfoPage "成功 "+succ+" 笔交易，失败 "+fail+"笔交易" ,"ok"                     // return
    }
    def redirect = {
        render view: '/error', model: [type: params.type, succcount: params.succcount, failcount: params.failcount]
    }
    def refundRefuse = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def arr = ids.split(',')
        arr = arr.collect { it as long }
        def refundAuth = RefundAuth.findAll("from RefundAuth as t where t.id in (:id)", [id: arr])
        refundAuth.each {
            it.authTime = new Date()
            it.operatorId = session.cmCustomerOperator.id
            it.refundRefuse = params.note
            it.status = 'closed'
            it.type = 'closed'
            it.save(flush: true, failOnError: true)
        }
        redirect(action: "verify")
    }

    def account = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        boolean isDownload = false;
        if (params?.format && params.format in ["txt", "csv", "excel"]) {
            params.max = 50000
            params.offset = 0
            isDownload = true
            log.info("--------账户明细下载-------")
        }else{
            log.info("--------账户明细查询-------")
        }

        String errmsg = ""
        String pattern = "yyyy-MM-dd HH:mm:ss"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "account", model: [errmsg: errmsg, resultList: null, resultTotal: 0, out_amount: 0, in_amount: 0, fee_amount: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "account", model: [errmsg: errmsg, resultList: null, resultTotal: 0, out_amount: 0, in_amount: 0, fee_amount: 0])
            return
        }

        def accountNo = session.cmCustomer.accountNo
        AcAccount acAccount = AcAccount.findByAccountNo(accountNo)
        AcAccount serviceAccount = AcAccount.findByAccountNameAndAccountType('客户' + acAccount.accountName + ' 在线支付服务帐户','main')
        def tradeTypeStr = ""
        def feeFlag = false
        if (!params.tradeType || params.tradeType == 'typeAll') {
            feeFlag = true
        } else {
            def tradeTypeList = params.list('tradeType')
            for (int i = 0; i < tradeTypeList.size(); i++) {
                if (tradeTypeList.get(i) == 'fee') {
                    feeFlag = true
                }
                if (i != tradeTypeList.size() - 1) {
                    tradeTypeStr += "'" + tradeTypeList.get(i) + "',"
                } else {
                    tradeTypeStr += "'" + tradeTypeList.get(i) + "'"
                }
            }
        }

        def subjectTypeStr = ""
        if (!params.subJictType || params.subJictType == 'subJictAll') {
            //subjectTypeStr = "'null','代付', '代付退款记账', '实时结算交易净额','钱包转账','微信','微信扫码支付','微信公众号支付','微信SDK支付','支付宝','支付宝服务窗','支付宝扫码'"
        } else {
            def subJictTypeList = params.list('subJictType')
            for (int i = 0; i < subJictTypeList.size(); i++) {

                if ("subJictPay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'代付',"
                }
                if ("subJictRefund".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'代付退款记账',"
                }
                if ("subJictClose".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'实时结算交易净额',"
                }
                if ("wallet".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'钱包转账',"
                }
                if ("wechat".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'微信',"
                }
                if ("wechatScanPay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'微信扫码支付',"
                }
                if ("wechatOfficialPay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'微信公众号支付',"
                }
                if ("wechatSDKPay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'微信SDK支付',"
                }
                if ("alipay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'支付宝',"
                }
                if ("alipayServer".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'支付宝服务窗',"
                }
                if ("alipayScanPay".equals(subJictTypeList.get(i).toString())) {
                    subjectTypeStr += "'支付宝扫码',"
                }

            }
            subjectTypeStr = subjectTypeStr.substring(0, subjectTypeStr.length() - 1)
        }

        String allSql = """
                  SELECT ta1.out_transaction_id,s1.CREDIT_AMOUNT, s1.ACCOUNT_ID,s1.BALANCE, s1.PRE_BALANCE, s1.DEBIT_AMOUNT, s1.ID, s1.DATE_CREATED, t1.OUT_TRADE_NO, t1.TRADE_NO, t1.TRANSFER_TYPE, t1.SUBJICT FROM ac_sequential s1
                  INNER JOIN ac_transaction t1 ON s1.transaction_id = t1.id
                  LEFT OUTER JOIN ismp.trade_attached ta1 ON t1.trade_no = ta1.trade_no
                  WHERE s1.account_no ='${accountNo}'
                  AND (s1.date_created between  to_date('${params.startDate}', 'yyyy-mm-dd hh24:mi:ss') AND to_date('${params.endDate}', 'yyyy-mm-dd hh24:mi:ss'))
                  ${tradeTypeStr ? "AND t1.transfer_type in (${tradeTypeStr})" : ""}
                  ${params.tradeNo ? "AND t1.TRADE_NO ='${params.tradeNo}'" : ""}
                  ${params.outTransactionId ? "AND ta1.OUT_TRANSACTION_ID ='${params.outTransactionId}'" : ""}
                  ${(params.direction && params.direction != 'all') ? params.direction == 'in' ? " AND s1.credit_amount=0" : params.direction == 'out' ? " AND s1.debit_amount=0" : "" : ""}
                  ${subjectTypeStr ? "AND t1.SUBJICT in (${subjectTypeStr})" : ""}
                """

        def feeSql = """
                     SELECT ta2.out_transaction_id,s2.CREDIT_AMOUNT, s2.ACCOUNT_ID, s2.BALANCE, s2.PRE_BALANCE, s2.DEBIT_AMOUNT, s2.ID, s2.DATE_CREATED, t2.OUT_TRADE_NO, t2.TRADE_NO, t2.TRANSFER_TYPE, t2.SUBJICT FROM ac_sequential s2
                    INNER JOIN ac_transaction t2 on s2.transaction_id = t2.id
                    LEFT OUTER JOIN ismp.trade_attached ta2 ON t2.trade_no = ta2.trade_no
                      WHERE s2.account_no ='${serviceAccount.accountNo}'
                      AND t2.transfer_type ='fee'
                      AND (s2.date_created between  to_date('${params.startDate}', 'yyyy-mm-dd hh24:mi:ss')
                      AND to_date('${params.endDate}', 'yyyy-mm-dd hh24:mi:ss'))
                     ${params.tradeNo ? "AND t2.TRADE_NO ='${params.tradeNo}'" : ""}
                    ${params.outTransactionId ? "AND ta2.OUT_TRANSACTION_ID ='${params.outTransactionId}'" : ""}
                    ${subjectTypeStr ? "AND t2.SUBJICT in (${subjectTypeStr})" : ""}
                   ${(params.direction && params.direction != 'all') ? params.direction == 'in' ? " AND s2.credit_amount=0" : params.direction == 'out' ? " AND s2.debit_amount=0" : "" : ""}

                """

        def querySql = """
                 SELECT t.* FROM (${allSql} ${feeFlag ? ("UNION ALL " + feeSql) : ""} ORDER BY date_created DESC) t
            """

        def totalSql = """
                 SELECT COUNT(DECODE(t.DEBIT_AMOUNT,0,null,1)) in_count, SUM(t.DEBIT_AMOUNT) in_amount, COUNT(DECODE(t.CREDIT_AMOUNT,0,null,1)) out_count, SUM(t.CREDIT_AMOUNT) out_amount FROM (${allSql}) t ${isDownload ? "WHERE ROWNUM<=" + params.max : ""}
            """


        def totalFeeSql = """
                    SELECT COUNT(1) fee_count, SUM(DECODE(TRANSFER_TYPE,'fee',CREDIT_AMOUNT,0)) fee_amount FROM (${feeSql}) t ${isDownload ? "WHERE ROWNUM<=" + params.max : ""}
                """

        HibernateTemplate ht = DatasourcesUtils.newHibernateTemplate('account')
        int count = 0
        def in_count = 0
        def in_amount = 0
        def out_count = 0
        def out_amount = 0
        def fee_amount = 0
        def fee_count = 0
        def result = ht.executeFind({ Session session ->
            def sqlQuery = session.createSQLQuery(querySql.toString())
            sqlQuery.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            def countSession = session.createSQLQuery(totalSql.toString())
            countSession.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
            def total = countSession.uniqueResult()

            if (feeFlag) {
                def feeSumSession = session.createSQLQuery(totalFeeSql.toString())
                feeSumSession.setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                def feeSum = feeSumSession.uniqueResult()
                fee_amount = feeSum.FEE_AMOUNT
                fee_count = feeSum.FEE_COUNT
            }
            in_count = total.IN_COUNT
            in_amount = total.IN_AMOUNT
            out_count = total.OUT_COUNT
            out_amount = total.OUT_AMOUNT
            count += (in_count + out_count + fee_count)
            return sqlQuery.setFirstResult(params.offset).setMaxResults(params.max).list()
        } as HibernateCallback)
        log.info("收入总笔数：" + in_count + ",收入总金额：" + in_amount + ",支出总笔数：" + out_count + ",支出总金额：" + out_amount + ",手续费总笔数："+ fee_count + ",手续费总金额："+ fee_amount + ",总笔数："+count)
        if (isDownload) {
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.contentType = "application/x-rarx-rar-compressed"
            response.setCharacterEncoding("GBK")
            render(template: "tpl_${params.format}_trade_account", model: [resultList: result, resultTotal: count, in_amount: in_amount, in_count: in_count, out_amount: out_amount, out_count: out_count, fee_amount: fee_amount])
        } else {
            [resultList: result, resultTotal: count, out_amount: out_amount, in_amount: in_amount, fee_amount: fee_amount]
        }
    }

    def getAcSequentialList(params) {
    }

    def royalty = {
        params.sort = params.sort ? params.sort : "dateCreated"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def boCustomerService = BoCustomerService.findWhere(customerId: session.cmCustomer.id, serviceCode: 'royalty', isCurrent: true, enable: true)
        def accountNo = boCustomerService.srvAccNo
        def query = {
            eq('accountNo', accountNo)
            if (params.startDate) {
                ge('dateCreated', Date.parse("yyyy-MM-dd", params.startDate))
                if (!params.endDate) {
                    le('dateCreated', Date.parse("yyyy-MM-dd", params.startDate).updated(month: Date.parse("yyyy-MM-dd", params.startDate).month + 3) + 1)
                }
            }
            if (params.endDate) {
                if (!params.startDate) {
                    ge('dateCreated', Date.parse("yyyy-MM-dd", params.endDate).updated(month: Date.parse("yyyy-MM-dd", params.endDate).month - 3));
                }
                le('dateCreated', Date.parse("yyyy-MM-dd", params.endDate) + 1)
            }
            if (params.outTradeNo != null && params.outTradeNo != '') {
                transaction {
                    eq('outTradeNo', params.outTradeNo)
                }
            }
        }

        if (params?.format && params.format in ["txt", "csv"]) {
            params.offset = null
            params.max = null
            def list = AcSequential.createCriteria().list(params, query)
            def count = AcSequential.createCriteria().count(query)

            def in_count = 0
            def in_amount = 0
            def out_count = 0
            def out_amount = 0
            list.each {
                if (it.creditAmount == 0) {
                    in_amount += it.debitAmount
                    in_count++
                }
                if (it.debitAmount == 0) {
                    out_amount += it.creditAmount
                    out_count++
                }
            }
            response.contentType = ConfigurationHolder.config.grails.mime.types[params.format]
            def filename = session.cmCustomer.customerNo + '_' + new Date().format('yyyyMMdd') + '_RoyaltyDetail'
            response.setCharacterEncoding("GBK")
            response.setHeader("Content-disposition", "attachment; filename=${filename}.${params.format}")
            render(template: "tpl_${params.format}_trade_royalty", model: [acSeqList: list, acSeqListTotal: count, out_amount: out_amount, out_count: out_count, in_count: in_count, in_amount: in_amount])
        } else {
            def list = AcSequential.createCriteria().list(params, query)
            def count = AcSequential.createCriteria().count(query)
            [acSeqList: list, acSeqListTotal: count]
        }
    }

    def detail = {
        try {
            def customerNo = session.cmCustomer.customerNo
            def customer = CmCustomer.findByCustomerNo(customerNo)
            def trade = TradeBase.get(params.id)

            if (!trade || (trade.payerId != session.cmCustomer.id && (trade.payeeId != session.cmCustomer.id))) {
                writeInfoPage "没找到该交易"
                return
            }
            if (trade.tradeType == "withdrawn") {
                trade = TradeWithdrawn.get(params.id)
            }
            [trade: trade]
        } catch (Exception e) {
            println("交易明细：" + e.printStackTrace())
        }
    }

    def accdetail = {
        def flag
        if ("1".equals(params.flag)) {
            flag = 1
        }
        def acSeq = AcSequential.get(params.id)

        def accountNo = session.cmCustomer.accountNo
        AcAccount acAccount = AcAccount.findByAccountNo(accountNo)
        AcAccount serviceAccount = AcAccount.findByAccountName('客户' + acAccount.accountName + " 在线支付服务帐户")

        if (!acSeq || (!acSeq.accountNo.equals(acAccount.accountNo) && !acSeq.accountNo.equals(serviceAccount.accountNo))) {
            writeInfoPage "没找到该交易"
            return
        }
//
//
//        def boCustomer = BoCustomerService.findWhere(customerId: session.cmCustomer.id, serviceCode: 'royalty', isCurrent: true, enable: true)
//        def accountNo = boCustomer?.srvAccNo
//        if (!acSeq || ((acSeq.accountNo != session.cmCustomer.accountNo) && (accountNo != null && acSeq.accountNo != accountNo))) {
//
//        }
        [acSeq: acSeq, flag: flag]
    }
    /**
     * 回单明细
     * 根据acseqential的ID查询出回单的详细
     */
    def receiptdetail = {
        if (!params.id) {
            writeInfoPage "没找到该交易"
            return
        }
        def acSeq = AcSequential.get(params.id);
        if (!acSeq) {
            writeInfoPage "没找到该交易"
            return
        }
        def tBase = TradeBase.findWhere(tradeNo: acSeq.transaction.tradeNo)
        //处理交易时间
        String strdate = "";
        if (tBase != null && tBase.lastUpdated != null) {
            SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
            strdate = formatter2.format(tBase.lastUpdated);
        }
        //处理手续费
        def ftTrade = FtTrade.findWhere(seqNo: acSeq.transaction.tradeNo)
        Long fee = 0;
        if (ftTrade != null && ftTrade.postFee != null && Math.abs(ftTrade.postFee) != 0) {
            fee = Math.abs(ftTrade.postFee);
        } else if (ftTrade != null && ftTrade.preFee != null && Math.abs(ftTrade.preFee) != 0) {
            fee = Math.abs(ftTrade.preFee);
        }
        [tBase: tBase, strdate: strdate, ftTrade: ftTrade, acSeq: acSeq, fee: fee]
    }
    /**
     * 回单下载
     */
    def downReceipt = {
        if (!params.id) {
            writeInfoPage "没找到该交易"
            return
        }
        def acSeq = AcSequential.get(params.id)
        if (!acSeq) {
            writeInfoPage "没找到该交易"
            return
        }
        def tBase = TradeBase.findWhere(tradeNo: acSeq.transaction.tradeNo)
        //处理交易时间
        String strdate = "";
        if (tBase != null && tBase.lastUpdated != null) {
            SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
            strdate = formatter2.format(tBase.lastUpdated);
        }
        //处理手续费
        def ftTrade = FtTrade.findWhere(seqNo: acSeq.transaction.tradeNo)
        Long fee = 0;
        if (ftTrade != null && ftTrade.postFee != null && Math.abs(ftTrade.postFee) != 0) {
            fee = Math.abs(ftTrade.postFee);
        } else if (ftTrade != null && ftTrade.preFee != null && Math.abs(ftTrade.preFee) != 0) {
            fee = Math.abs(ftTrade.preFee);
        }
        //模板下载模板
        response.contentType = "application/x-rarx-rar-compressed"
        def filename = acSeq.transaction.tradeNo + '_' + new Date().format('yyyyMMdd') + '.xls'
        response.setCharacterEncoding("utf-8")
        response.setHeader("Content-disposition", "attachment; filename=" + filename)
        render(template: "receiptdetailExcel", model: [tBase: tBase, strdate: strdate, ftTrade: ftTrade, acSeq: acSeq, fee: fee])
    }

    def batchRefund = {
        List typeList = new ArrayList()
        BoBankDic bankDic = new BoBankDic()
        bankDic.id = 0
        bankDic.name = "非核对模板上传"
        typeList.add(bankDic)
        bankDic = new BoBankDic()
        bankDic.id = 1
        bankDic.name = "核对模板上传"
        typeList.add(bankDic)
        def boCustomerService = BoCustomerService.executeQuery(" from BoCustomerService where customerId=" + session.cmCustomerOperator.customerId + " and enable=1 and isCurrent=1 and serviceCode='online'")
        def uploadtype
        if (boCustomerService) {
            uploadtype = boCustomerService.get(0).refundModelType
        } else {
            def msg = "没有退款服务"
            writeInfoPage msg
            return
        }


        [typeList: typeList, uploadtype: uploadtype]
    }
    def dispatch = {
        if (params.uploadtype == "0") {
            uncheckConfirm()
        } else if (params.uploadtype == "1") {
            confirm()
        }

    }
    def uncheckConfirm = {
        try {
            def sitems = 0//成功笔数
            double stotalMoney = 0//成功总金额
            def fitems = 0//失败笔数
            double ftotalMoney = 0//失败总金额
            List sList = new ArrayList()//成功记录,记到数据库
            List fList = new ArrayList() //失败记录，供下载用
            def boCustomerService = BoCustomerService.executeQuery(" from BoCustomerService where customerId=" + session.cmCustomerOperator.customerId + " and enable=1 and isCurrent=1 and serviceCode='online'")
            def model = BoRefundModel.findByCustomerServerId(boCustomerService.get(0).id)//.executeQuery(" from BoRefundModel where customerServerId='481'")
            def paymodel
            if (model) {
                if (model.refundModel == 'payPassword') {
                    paymodel = "payPassword"
                } else if (model.refundModel == 'recheck') {
                    paymodel = "recheck"
                }
            } else {
                paymodel = "recheck"
            }

            List str = uploadFileUncheck()
            Random random = new Random()
            def batchNo = new Date().format('yyyyMMdd') + String.valueOf(random.nextInt(1000))
            def rbf = RefundBatch.findByBatchNoAndFlag(batchNo, false)
            if (rbf) {
                rbf.delete()
            }
            def refb = RefundBatch.findByBatchNoAndFlag(batchNo, true)
            if (refb) {
                writeInfoPage "有效批次号为 ${batchNo} 的批量退款已存在，请勿重复提交数据", 'warn'
                return
            }
            def totalApply = 0
            def waitamount2 = 0

            for (int k = 0; k < str.size(); k++) {
                boolean flag = false
                def msg
                String[] details = str.get(k)

                def orderNo = details[0]
                for (int kk = 0; kk < sList.size(); kk++) {
                    if (orderNo == sList.get(kk)[0]) {
                        flag = true
                        break
                    }
                }
                for (int kk = 0; kk < fList.size(); kk++) {
                    if (orderNo == fList.get(kk)[0]) {
                        flag = true
                        break
                    }
                }
                def amount = details[1]
                def remark = String.valueOf(details[2])
                if (amount.contains("交易")) {
                    msg = "模板格式不正确"
                    writeInfoPage msg
                    return
                }

                if (!amount) {
                    msg = "第 ${k + 1} 笔交易的金额不能为0或不能空"
                    writeInfoPage msg
                    return
                }
                if (!orderNo) {
                    msg = "第 ${k + 1} 笔交易的商户订单号不能为空"
                    writeInfoPage msg
                    return
                }        // if(!/^(\d+|[1-9])(\.\d{0,2}){0,1}$/.test(amount)){ ^\\d{1,8}(\\.\\d{1,}){0,1}$

                if (!(amount ==~ /^(\d+|[1-9])(\.\d{0,2}){0,1}$/)) {
                    msg = "第 ${k + 1} 笔交易的金额为无效金额格式"
                    writeInfoPage msg
                    return
                }
                def xamount = (Double.valueOf(amount))
                //                        xamount = (amount as double)
                if (xamount < 0.01) {
                    msg = "第 ${k + 1} 笔交易的金额不能小于0.01元"
                    writeInfoPage msg
                    return
                }
                if (remark?.length() > 64) {
                    msg = "第 ${k + 1} 笔交易的备注字符长度不能超出64个字符"
                    writeInfoPage msg
                    return
                }
                if (!flag) {
//                          def tradeNo1 = details[1]


                    if (amount != '' && amount != null) {
                        amount = Double.valueOf(amount) * 100
                    }
                    if (orderNo) {
                        waitamount2 += amount
                    }

                    totalApply += amount



                    def trade = TradeBase.findByOutTradeNo(orderNo)
                    long wamountTemp = 0
                    def db = new Sql(DatasourcesUtils.getDataSource('ismp'))
                    if (trade) {
                        def waitamount = db.firstRow("select sum(amount) from refund_auth where out_trade_no=? and trade_no=? and flag=1 and status='pass'", [trade.outTradeNo, trade.tradeNo])

                        if (waitamount[0] == null) {
                            wamountTemp = 0
                        } else {
                            wamountTemp = waitamount[0]
                        }
                    }
                    Double allowRefund
                    def erallowRefund
                    if (trade) {
                        allowRefund = trade.amount - TradePayment.get(trade.id).refundAmount - wamountTemp
                    }
                    //=============
                    List listTemp = new ArrayList()
                    for (int j = 0; j < str.size(); j++) {

                        if (orderNo == str.get(j)[0]) {//查询相同的订单号
                            listTemp.add(str.get(j))
                        }
                    }
                    for (int jj = 0; jj < listTemp.size(); jj++) {
                        boolean flag1 = true
                        def orderNoTe = listTemp.get(jj)[0]; def amountTe = listTemp.get(jj)[1]; def remarkTe = listTemp.get(jj)[2]

                        if (orderNo == listTemp.get(jj)[0]) {

                            String[] err = new String[4]

                            if (!trade || (trade.payeeId != session.cmCustomer.id)) {
                                err[0] = orderNoTe; err[1] = amountTe; err[2] = "未找到匹配的商户订单号"; err[3] = remarkTe
                                flag1 = false
                                ftotalMoney += (amountTe as double)
                                fList.add(err)

                            } else if (Double.valueOf(amountTe) * 100 > allowRefund) {

                                err[0] = orderNoTe; err[1] = amountTe; err[2] = "退款金额超过可退款金额,可退款金额为" + Double.valueOf(allowRefund / 100) + "元"; ; err[3] = remarkTe
                                flag1 = false
                                ftotalMoney += (amountTe as double)
                                fList.add(err)
                            } else if (Double.valueOf(amountTe) * 100 <= allowRefund) {
                                String[] su = new String[3]
                                su[0] = orderNoTe; su[1] = amountTe; su[2] = remarkTe;
                                sList.add(su)
                            }


                        }
                        if (trade && flag1) {
                            //allowRefund=allowRefund-new BigDecimal(amountTe).movePointRight(2)
                            allowRefund = allowRefund - Double.valueOf(amountTe) * 100
                        }

                        //==============================
                        //def db = new Sql(DatasourcesUtils.getDataSource('ismp'))

                        def payment = null
                        if (trade) {
                            payment = db.firstRow("select * from gworders where id=?", [trade.tradeNo])
                        }

                        if (payment?.ROYALTY_TYPE == '10') {
                            writeInfoPage "分润交易不能发起退款"
                            return
                        }
                        if (!amountTe) {
//                                msg = "第 ${k + 1} 笔交易的金额不能为0或不能空"
//                                writeInfoPage msg
//                                return
                        } else {   //if(!/^(\d+|[1-9])(\.\d{0,2}){0,1}$/.test(amount)){
                            // "^\\d{1,8}(\\.\\d{1,3}){0,1}$"
                            if (!(amountTe ==~ /^(\d{0,8}+)(\.\d{1,2})?$/)) {
//                                    msg = "第 ${k + 1} 笔交易的金额为无效金额格式"
//                                    writeInfoPage msg
//                                    return
                            } else {
//                                    def xamount = (new BigDecimal(amountTe)) as long
//            //                        xamount = (amount as double)
//                                    if (xamount < 0.01) {
//                                        msg = "第 ${k + 1} 笔交易的金额不能小于0.01元"
//                                        writeInfoPage msg
//                                        return
//                                    }
                                def payerAccount = AcAccount.findByAccountNo(session.cmCustomer.accountNo)
                                def a1 = 0
                                def a2 = 0
                                if (trade) {
                                    if (trade.refundAmount > 0) {
                                        a1 = trade.refundAmount / 100
                                    } else {
                                        a1 = 0
                                    }
                                }

                                if (payerAccount.balance) {
                                    a2 = payerAccount.balance / 100
                                } else {
                                    a2 = 0
                                }
//                                    if (a2 < totalApply / 100) {
//                                        msg = "账户余额不足"
//                                        writeInfoPage msg
//                                        return
//                                    }
                            }
                        }

                        //==============================
                    }
                    //==============
                    //               if(trade){
                    //                      allowRefund = trade.amount-TradePayment.get(trade.id).refundAmount
                    //               }


                }
            }


            def refundBatch = new RefundBatch()
            refundBatch.BatchNo = batchNo
            //def tm = new BigDecimal(totalApply)
            def tm = Double.valueOf(totalApply)
            refundBatch.TotalAmount = tm
            refundBatch.TotalCount = str.size() as int
            fitems = fList.size()

            sitems = sList.size()
            for (int k = 0; k < sList.size(); k++) {
//                println str_result[k]
                String[] details = sList.get(k)
                def orderNo = details[0]
                def amount = details[1]
                stotalMoney += Double.valueOf(amount)
                def remark = details[2]

                def refundAuth = new RefundAuth()
                refundAuth.outTradeNo = orderNo
                def tradeNo1 = TradeBase.findByOutTradeNo(orderNo).tradeNo
                refundAuth.tradeNo = tradeNo1
                refundAuth.amount = Double.valueOf(amount) * 100
                refundAuth.customerNo = session.cmCustomer.customerNo
                refundAuth.operatorId = session.cmCustomerOperator.id
                refundAuth.note = remark
                refundAuth.uploadTime = new Date()
                refundAuth.numberNo = k + 1
                refundAuth.status = 'starting'
                refundAuth.type = 'starting'
                refundBatch.addToRefundAuth(refundAuth)
            }
            refundBatch.save(flush: true, failOnError: true)

            def rb = RefundBatch.findByBatchNo(batchNo)
            def ra = RefundAuth.findAllByBatch(rb)
            params.sort = params.sort ? params.sort : "outTradeNo"
            params.order = params.order ? params.order : "desc"
            params.max = Math.min(params.max ? params.int('max') : 50, 100)
            params.offset = params.offset ? params.int('offset') : 0
            def query = {
                eq('batch', rb)
            }

            def list = RefundAuth.createCriteria().list(params, query)
            def count = RefundAuth.createCriteria().count(query)
            exportClassroom(fList, batchNo)
            [raList: list, raTotal: count, refundAuth: ra, refundBatch: rb, paymodel: paymodel, sitems: sitems, stotalMoney: stotalMoney, fitems: fitems, ftotalMoney: ftotalMoney]
        } catch (Exception e) {
            e.printStackTrace()
            // writeInfoPage "数据错误，请检查数据正确性"
            writeInfoPage "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            return
        }
    }
    def confirm = {
        try {
            def sitems = 0//成功笔数
            Double stotalMoney = 0//成功总金额
            def fitems = 0//失败笔数
            Double ftotalMoney = 0//失败总金额
            List sList = new ArrayList()//成功记录,记到数据库
            List fList = new ArrayList() //失败记录，供下载用
            def boCustomerService = BoCustomerService.executeQuery(" from BoCustomerService where customerId=" + session.cmCustomerOperator.customerId + " and enable=1 and isCurrent=1 and serviceCode='online'")
            def model = BoRefundModel.findByCustomerServerId(boCustomerService.get(0).id)//.executeQuery(" from BoRefundModel where customerServerId='481'")
            def paymodel
            if (model) {
                if (model.refundModel == 'payPassword') {
                    paymodel = "payPassword"
                } else if (model.refundModel == 'recheck') {
                    paymodel = "recheck"
                }
            } else {
                paymodel = "recheck"
            }
            def str = uploadFile()
//            println str
            List ll = str.get(4)
            List l2 = str.get(2)
            Double sum = 0;
            for (int i = 0; i < l2.size(); i++) {
                sum += Double.valueOf(l2.get(i))
            }
            def msg
            if (l2.size() <= 0) {
                msg = "模板格式错误!"
                writeInfoPage msg
                return
            }
            def rbf = RefundBatch.findByBatchNoAndFlag(ll[0], false)
            if (rbf) {
                rbf.delete()
            }
            def refb = RefundBatch.findByBatchNoAndFlag(ll[0], true)
            if (refb) {
                writeInfoPage "有效批次号为 ${ll[0]} 的批量退款已存在，请勿重复提交数据", 'warn'
                return
            }
            if (!ll[0] || !ll[1] || !ll[2]) {
                writeInfoPage "数据错误，请检查数据正确性（批次号、总金额或总笔数为必填项）"
                return
            }
            if ((ll[2] as int) != str.get(0).size()) {
                writeInfoPage "总笔数错误"
                return
            }

            def length2 = str.get(0).size()
            String[][] str_result = new String[length2][4]
            //数组转换,行列互转
            for (int i = 0; i < 4; i++) {
                List a1 = str.get(i)
                if (a1.size() > 0) {
                    for (int j = 0; j < a1.size(); j++) {
                        def value = ""
                        if (a1.get(j) == null) {
                            value = " "
                        } else {
                            value = a1.get(j)
                        }
                        str_result[j][i] = value
                    }
                }
            }
            def totalApply = 0
            def waitamount2 = 0
            long wamount = 0
            def ableamount = 0
            //def msg
            for (int k = 0; k < str_result.length; k++) {
                boolean flag = false
                String[] details = str_result[k]

                def orderNo = details[0]
                def tradeNo1 = details[1]
                def amount = details[2]
                def remark = details[3]
                for (int kk = 0; kk < sList.size(); kk++) {
                    if (orderNo == sList.get(kk)[0] && tradeNo1 == sList.get(kk)[1]) {
                        flag = true
                        break
                    }
                }
                for (int kk = 0; kk < fList.size(); kk++) {
                    if (orderNo == fList.get(kk)[0] && tradeNo1 == fList.get(kk)[4]) {
                        flag = true
                        break
                    }
                }


                if (!orderNo) {
                    msg = "第 ${k + 1} 笔交易的商户订单号不能为空"
                    writeInfoPage msg
                    return
                }
                if (!tradeNo1) {
                    msg = "第 ${k + 1} 笔交易的平台交易号不能为空"
                    writeInfoPage msg
                    return
                }
                if (!amount) {
                    msg = "第 ${k + 1} 笔交易的金额不能空"
                    writeInfoPage msg
                    return
                }
                if (!(amount ==~ /^(\d{0,8}+)(\.\d{1,2})?$/)) {
                    msg = "第 ${k + 1} 笔交易的金额为无效金额格式"
                    writeInfoPage msg
                    return
                }
                def xamount = (Double.valueOf(amount))
                //                        xamount = (amount as double)
                if (xamount < 0.01) {
                    msg = "第 ${k + 1} 笔交易的金额不能小于0.01元"
                    writeInfoPage msg
                    return
                }

                if ((ll[1] as BigDecimal) != sum) {
                    writeInfoPage "总金额与每笔交易金额的总和不相等"
                    return
                }
                if (remark?.length() > 64) {
                    msg = "第 ${k + 1} 笔交易的备注字符长度不能超出64个字符"
                    writeInfoPage msg
                    return
                }
                if (!flag) {

                    if (amount != '' && amount != null) {
                        amount = Double.valueOf(amount)
                    }
                    if (tradeNo1) {
                        waitamount2 += amount
                    }
                    // str_result[k][2] = amount
                    totalApply += amount

                    def trade = TradeBase.findByOutTradeNoAndTradeNo(orderNo, tradeNo1)
                    long wamountTemp = 0
                    def db = new Sql(DatasourcesUtils.getDataSource('ismp'))
                    if (trade) {
                        def waitamount = db.firstRow("select sum(amount) from refund_auth where out_trade_no=? and trade_no=? and flag=1 and status='pass'", [trade.outTradeNo, trade.tradeNo])

                        if (waitamount[0] == null) {
                            wamountTemp = 0
                        } else {
                            wamountTemp = waitamount[0]
                        }
                    }

                    Double allowRefund
                    if (trade) {
                        allowRefund = trade.amount - TradePayment.get(trade.id).refundAmount - wamountTemp
                    }
                    List listTemp = new ArrayList()
                    for (int j = 0; j < str_result.length; j++) {

                        if (orderNo == str_result[j][0] && tradeNo1 == str_result[j][1]) {//查询相同的订单号
                            listTemp.add(str_result[j])
                        }
                    }

                    //def db = new Sql(DatasourcesUtils.getDataSource('ismp'))
                    for (int jj = 0; jj < listTemp.size(); jj++) {
                        boolean flag1 = true
                        def orderNoTe = listTemp.get(jj)[0]; def tradeNoTe = listTemp.get(jj)[1]; def amountTe = listTemp.get(jj)[2]; def remarkTe = listTemp.get(jj)[3];
                        if (orderNo == listTemp.get(jj)[0]) {

                            String[] err = new String[5]
                            if (!trade || (trade.payeeId != session.cmCustomer.id)) {
                                err[0] = orderNoTe; err[1] = amountTe; err[2] = "未找到匹配的商户订单号或平台交易号"; err[3] = remarkTe; err[4] = tradeNoTe;
                                ftotalMoney += Double.valueOf(amountTe)
                                flag1 = false
                                fList.add(err)
                            } else if (Double.valueOf(amountTe) * 100 > allowRefund) {

                                err[0] = orderNoTe; err[1] = amountTe; err[2] = "退款金额超过可退款金额,可退款金额为" + Double.valueOf(allowRefund / 100) + "元"; err[3] = remarkTe; err[4] = tradeNoTe
                                flag1 = false
                                ftotalMoney += Double.valueOf(amountTe)
                                fList.add(err)
                            } else if (trade && Double.valueOf(amountTe) * 100 <= allowRefund) {
                                String[] su = new String[4]
                                su[0] = orderNoTe; su[1] = tradeNoTe; su[2] = amountTe; su[3] = remarkTe;
                                sList.add(su)
                            }
                        }
                        if (trade && flag1) {
                            //allowRefund=allowRefund-new BigDecimal(amountTe).movePointRight(2)
                            allowRefund = allowRefund - Double.valueOf(amountTe) * 100
                        }


                        def payment = null
                        if (trade) {
                            payment = db.firstRow("select * from gworders where id=?", [trade.tradeNo])
                        }

                        if (payment?.ROYALTY_TYPE == '10') {
                            writeInfoPage "平台交易号 ${tradeNo1} 的分润交易不能发起退款"
                            return
                        }
                        if (!amountTe) {
//                                msg = "第 ${k + 1} 笔交易的金额不能空"
//                                //writeInfoPage msg
//                                return
                        } else {
                            if (!(amountTe ==~ /^(\d{0,8}+)(\.\d{1,2})?$/)) {
//                                    msg = "第 ${k + 1} 笔交易的金额为无效金额格式"
//                                   // writeInfoPage msg
//                                    return
                            } else {
                                //def xamount = (new BigDecimal(amountTe)) as long
                                //                        xamount = (amount as double)
                                if (xamount < 0.01) {
//                                        msg = "第 ${k + 1} 笔交易的金额不能小于0.01元"
//                                      //  writeInfoPage msg
//                                        return
                                }
                                def payerAccount = AcAccount.findByAccountNo(session.cmCustomer.accountNo)
                                def a1 = 0
                                def a2 = 0
                                if (trade && trade.refundAmount > 0) {
                                    a1 = trade.refundAmount / 100
                                } else {
                                    a1 = 0
                                }
                                if (payerAccount.balance) {
                                    a2 = payerAccount.balance / 100
                                } else {
                                    a2 = 0
                                }
//                                    if (a2 < totalApply / 100) {
//                                        msg = "账户余额不足"
//                                        writeInfoPage msg
//                                        return
//                                    }
                            }
                        }

                    }
                }


            }

            def refundBatch = new RefundBatch()
            refundBatch.BatchNo = ll[0]
            //def tm = new BigDecimal(ll[1]).movePointRight(2)
            def tm = Double.valueOf(ll[1]) * 100
            refundBatch.TotalAmount = tm
            refundBatch.TotalCount = ll[2] as int
            fitems = fList.size()
            sitems = sList.size()
            for (int k = 0; k < sList.size(); k++) {
//                println str_result[k]
                String[] details = sList[k]
                def orderNo = details[0]
                def tradeNo1 = details[1]
                def amount = details[2]
                stotalMoney += Double.valueOf(amount)
                def remark = details[3]
                def refundAuth = new RefundAuth()
                refundAuth.outTradeNo = orderNo
                refundAuth.tradeNo = tradeNo1
                refundAuth.amount = Double.valueOf(amount) * 100
                refundAuth.customerNo = session.cmCustomer.customerNo
                refundAuth.operatorId = session.cmCustomerOperator.id
                refundAuth.note = remark
                refundAuth.uploadTime = new Date()
                refundAuth.numberNo = k + 1
                refundAuth.status = 'starting'
                refundAuth.type = 'starting'
                refundBatch.addToRefundAuth(refundAuth)
            }
            refundBatch.save(flush: true, failOnError: true)

            def rb = RefundBatch.findByBatchNo(ll[0])
            def ra = RefundAuth.findAllByBatch(rb)
            params.sort = params.sort ? params.sort : "outTradeNo"
            params.order = params.order ? params.order : "desc"
            params.max = Math.min(params.max ? params.int('max') : 50, 100)
            params.offset = params.offset ? params.int('offset') : 0
            def query = {
                eq('batch', rb)
            }
            exportClassroom(fList, ll[0])
            def list = RefundAuth.createCriteria().list(params, query)
            def count = RefundAuth.createCriteria().count(query)
            [raList: list, raTotal: count, refundAuth: ra, refundBatch: rb, paymodel: paymodel, sitems: sitems, stotalMoney: stotalMoney, fitems: fitems, ftotalMoney: ftotalMoney]

        } catch (Exception e) {
            e.printStackTrace()
            // writeInfoPage "数据错误，请检查数据正确性"
            writeInfoPage "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            return
        }
    }

    def upload = {
        if (!withForm { true }.invalidToken { false }) {
            writeInfoPage "请不要重复提交数据"; return
        }

        def ids = params.ids.substring(1, params.ids.length() - 1)
        def arr = ids.split(',')
        arr = arr.collect { it as long }
        def refundAuth = RefundAuth.findAll("from RefundAuth as t where t.id in (:id)", [id: arr])
        refundAuth.each {
            it.status = 'pass'
            it.save(flush: true, failOnError: true)
        }
        List li = new ArrayList()
        li = refundAuth.tradeNo.unique()
        def db = new Sql(DatasourcesUtils.getDataSource('ismp'))
        for (String s : li) {
            def waitamount = db.firstRow("select sum(amount) from refund_auth where trade_no=? and flag=0 and status='pass'", s)
            long wamount = 0
            long wamount2 = 0
            if (waitamount[0] == null) {
                wamount = 0
            } else {
                wamount = waitamount[0]
            }
            def waitamount2 = db.firstRow("select sum(amount) from refund_auth where trade_no=? and flag=1 and status='starting'", s)
            if (waitamount2[0] == null) {
                wamount2 = 0
            } else {
                wamount2 = waitamount2[0]
            }
            def trade = TradeBase.findByTradeNo(s)
            def ableamount = (trade.amount - (trade.refundAmount + wamount2)) as long
//            if (wamount > ableamount) {
//                writeInfoPage "平台交易号为 ${s} 总退款金额 ${wamount / 100} 元大于可退金额 ${ableamount / 100} 元"
//                return null
//            }
        }
        def refundBatch = RefundBatch.findByBatchNo(params.batch)
        refundBatch.flag = true
        refundBatch.save(flush: true, failOnError: true)

        refundAuth.each {
            it.authTime = new Date()
            it.flag = true
            it.save(failOnError: true)
        }
        //======      历史
        def stotalMoney = params.stotalMoney; def sitems = params.sitems; def fitems = params.fitems; def ftotalMoney = params.ftotalMoney
        def refundHistory = new RefundHistory()
        refundHistory.batchDate = new Date()
        refundHistory.batchNo = params.batch
        refundHistory.customerNo = session.cmCustomer.customerNo
        refundHistory.succAmt = stotalMoney as double
        refundHistory.succItems = sitems as long
        refundHistory.failAmt = ftotalMoney as double
        refundHistory.failItems = fitems as long
        String path = "proFile" + File.separator + session.cmCustomer.customerNo + params.batch + ".xls"
        refundHistory.exportPath = path
        refundHistory.save(flush: true, failOnError: true)
        //==============
        flash.message = "upload"
        redirect(action: "sale")
    }

    protected uploadFile() {
        if (request instanceof MultipartHttpServletRequest) {

            InputStream is = null
            def maxFileSize = 10485760
            def resultmsg
            List list = new ArrayList()
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("upload")
            // 判断是否上传文件
            if (!orginalFile.isEmpty()) {
//                     println "orginalFile.getSize():"+orginalFile.getSize()
                if (orginalFile.getSize() < maxFileSize) {
                    is = orginalFile.getInputStream()
                    //判断当前文件的版本xls,xlxs
                    String originalFilename = orginalFile.getOriginalFilename()
                    // 获取上传文件扩展名
                    def extension = originalFilename.substring(originalFilename.indexOf(".") + 1)
                    //上传文件
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                    def name = sdf.format(new Date()) + "." + extension
                    def filepath = request.getRealPath("/") + "upload" + File.separator
                    def filename = filepath + name
                    if (!new File(filepath).exists()) {
                        new File(filepath).mkdir()
                    }
                    orginalFile.transferTo(new File(filename))
                    if (extension.toUpperCase().equals("XLS")) {
                        list = this.getXls(is)
                    } else {
//                                println filename
                        list = this.getXlxs(is)
                    }
                    return list
                } else {
                    flash.message = "上传失败，上传文件不能大于10M"
                    redirect(action: "batchRefund")
                }
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
        }
    }

    def uploadFileUncheck() {
        if (request instanceof MultipartHttpServletRequest) {

            InputStream is = null
            def maxFileSize = 10485760
            def resultmsg
            List list = new ArrayList()
            MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request
            CommonsMultipartFile orginalFile = (CommonsMultipartFile) multiRequest.getFile("upload")
            // 判断是否上传文件
            if (!orginalFile.isEmpty()) {
//                     println "orginalFile.getSize():"+orginalFile.getSize()
                if (orginalFile.getSize() < maxFileSize) {
                    is = orginalFile.getInputStream()
                    //判断当前文件的版本xls,xlxs
                    String originalFilename = orginalFile.getOriginalFilename()
                    // 获取上传文件扩展名
                    def extension = originalFilename.substring(originalFilename.indexOf(".") + 1)
                    //上传文件
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMddHHmmssssss")
                    def name = sdf.format(new Date()) + "." + extension
                    def filepath = request.getRealPath("/") + "upload" + File.separator
                    def filename = filepath + name
                    if (!new File(filepath).exists()) {
                        new File(filepath).mkdir()
                    }
                    orginalFile.transferTo(new File(filename))
                    if (extension.toUpperCase().equals("XLS")) {
                        list = this.getUncheckXls(is)
                    } else {
//                                println filename
                        list = this.getUncheckXlxs(is)
                    }
                    return list
                } else {
                    flash.message = "上传失败，上传文件不能大于10M"
                    redirect(action: "batchRefund")
                }
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
        }
    }

    def List getUncheckXls(InputStream is) {
        List list = new ArrayList()
        try {
            HSSFWorkbook workbook = new HSSFWorkbook(is)
            HSSFSheet xSheet = workbook.getSheetAt(0)
            if (xSheet == null) {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
            //循环行Row
            List li = null
            for (int rowNum = 1; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                HSSFRow xRow = xSheet.getRow(rowNum)
                if (!xRow) {
                    continue
                }
                if (!xRow.getCell(0)) {
                    continue
                }
                if (!xRow.getCell(0).getStringCellValue()) {
                    continue
                }
                li = new ArrayList()
                int cellNum = 0
//                 循环列Cell
                for (cellNum = 0; cellNum < 3; cellNum++) {
                    HSSFCell xCell = xRow.getCell(cellNum)
                    if (xCell == null) {
                        break
                    }
                    if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                        li.add(xCell.getBooleanCellValue())
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                        if (cellNum == 1) {
                            li.add(xCell.getNumericCellValue())
                        } else if (cellNum == 2) {
                            li.add(String.valueOf(xCell.getNumericCellValue()))
                        }
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_FORMULA) {
                        li.add(xCell.getCellFormula())
                    } else {
                        li.add(xCell.getStringCellValue().trim())
                    }
                }
                if (li && li.size() > 1) {
                    list.add(li)
                }
            }
            return list
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            redirect(action: "batchRefund")
        }
    }

    def List getUncheckXlxs(InputStream is) {
        List list = new ArrayList()
        try {
            XSSFWorkbook xwb = new XSSFWorkbook(is)
            XSSFSheet xSheet = xwb.getSheetAt(0)
            if (xSheet != null) {
                //循环行Row
                for (int rowNum = 1; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                    if (xSheet.getRow(rowNum) != null) {
                        XSSFRow xRow = xSheet.getRow(rowNum)
                        List li = new ArrayList()
                        if (!xRow) {
                            continue
                        }
                        if (!xRow.getCell(0)) {
                            continue
                        }
                        if (!xRow.getCell(0).getStringCellValue()) {
                            continue
                        }
                        int cellNum = 0
//                     循环列Cell
                        for (cellNum = 0; cellNum <= xRow.getLastCellNum(); cellNum++) {
//                                    XSSFCell xCelll =  xRow.getCell(1)
//                                    println  new java.math.BigDecimal(xCelll.getNumericCellValue())
                            if (xRow.getCell(cellNum) != null) {
                                XSSFCell xCell = xRow.getCell(cellNum)
                                if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                                    li.add(xCell.getBooleanCellValue())
                                } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                    if (cellNum == 1) {
                                        li.add(xCell.getNumericCellValue())
                                    } else if (cellNum == 2) {
                                        li.add(String.valueOf(xCell.getNumericCellValue()))
                                    }
                                } else {
                                    li.add(xCell.getStringCellValue().trim())
                                }
                            }
                        }
                        list.add(li)
                    }
                }
                return list
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            redirect(action: "batchRefund")
        }
    }

    def List getXls(InputStream is) {
        List list = new ArrayList()
        try {
            HSSFWorkbook workbook = new HSSFWorkbook(is)
            HSSFSheet xSheet = workbook.getSheetAt(0)
            if (xSheet == null) {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
            //循环行Row
            List li = null
            for (int rowNum = 3; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                HSSFRow xRow = xSheet.getRow(rowNum)
                if (!xRow) {
                    continue
                }
                if (!xRow.getCell(0)) {
                    continue
                }
                if (!xRow.getCell(0).getStringCellValue()) {
                    continue
                }
                li = new ArrayList()
                int cellNum = 0
//                 循环列Cell
                for (cellNum = 0; cellNum <= 3; cellNum++) {
                    HSSFCell xCell = xRow.getCell(cellNum)
                    if (xCell == null) {
                        break
                    }
                    if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                        li.add(xCell.getBooleanCellValue())
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                        if (cellNum == 1) {
                            li.add(new BigDecimal(xCell.getNumericCellValue()))
                        }
                        if (cellNum == 2) {
                            li.add(xCell.getNumericCellValue())
                        }
                        if (cellNum == 3) {
                            li.add(xCell.getNumericCellValue())
                        }
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_FORMULA) {
                        li.add(xCell.getCellFormula())
                    } else {
                        li.add(xCell.getStringCellValue().trim())
                    }
                }
                if (li && li.size() > 1) {
                    list.add(li)
                }
            }
            HSSFRow xRow = xSheet.getRow(1)
            li = new ArrayList()
            for (int cellNum = 0; cellNum < 3; cellNum++) {
                HSSFCell xCell = xRow.getCell(cellNum)
                if (xCell != null) {
                    if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                        li.add(xCell.getBooleanCellValue())
                    } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                        li.add(xCell.getNumericCellValue())
                    } else {
                        li.add(xCell.getStringCellValue())
                    }
                }
            }
            list.add(li)

            def length = list.size()
            String[][] str_result = new String[4][length - 1]
            //数组转换,行列互转
            for (int i = 0; i < length - 1; i++) {
                List a1 = list.get(i)
                if (a1.size() > 0) {
                    for (int j = 0; j < 4; j++) {
                        def value = ""
                        if (a1.get(j) == null) {
                            value = " "
                        } else {
                            value = a1.get(j)
                        }
                        str_result[j][i] = value
                    }
                }
            }
            List aList = new ArrayList()
            aList = str_result
            aList.add(list.get(length - 1))
            is.close()
            return aList
        } catch (Exception e) {
            e.printStackTrace()
            flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
            redirect(action: "batchRefund")
        }
    }

    def List getXlxs(InputStream is) {
        List list = new ArrayList()
        try {
            XSSFWorkbook xwb = new XSSFWorkbook(is)
            XSSFSheet xSheet = xwb.getSheetAt(0)
            if (xSheet != null) {
                //循环行Row
                for (int rowNum = 3; rowNum <= xSheet.getLastRowNum(); rowNum++) {
                    if (xSheet.getRow(rowNum) != null) {
                        XSSFRow xRow = xSheet.getRow(rowNum)
                        List li = new ArrayList()
                        if (!xRow) {
                            continue
                        }
                        if (!xRow.getCell(0)) {
                            continue
                        }
                        if (!xRow.getCell(0).getStringCellValue()) {
                            continue
                        }
                        int cellNum = 0
//                     循环列Cell
                        for (cellNum = 0; cellNum <= xRow.getLastCellNum(); cellNum++) {
//                                    XSSFCell xCelll =  xRow.getCell(1)
//                                    println  new java.math.BigDecimal(xCelll.getNumericCellValue())
                            if (xRow.getCell(cellNum) != null) {
                                XSSFCell xCell = xRow.getCell(cellNum)
                                if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                                    li.add(xCell.getBooleanCellValue())
                                } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                    if (cellNum == 1) {
                                        li.add(new BigDecimal(xCell.getNumericCellValue()))
                                    }
                                    if (cellNum == 2) {
                                        li.add(xCell.getNumericCellValue())
                                    }
                                    if (cellNum == 3) {
                                        li.add(xCell.getNumericCellValue())
                                    }
                                } else {
                                    li.add(xCell.getStringCellValue().trim())
                                }
                            }
                        }
                        list.add(li)
                    }
                }

                if (xSheet.getRow(1) != null) {
                    XSSFRow xRow = xSheet.getRow(1)
                    List li = new ArrayList()
                    for (int cellNum = 0; cellNum < 3; cellNum++) {
                        if (xRow.getCell(cellNum) != null) {
                            XSSFCell xCell = xRow.getCell(cellNum)
                            if (xCell.getCellType() == XSSFCell.CELL_TYPE_BOOLEAN) {
                                li.add(xCell.getBooleanCellValue())
                            } else if (xCell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                                li.add(xCell.getNumericCellValue())
                            } else {
                                li.add(xCell.getStringCellValue().trim())
                            }
                        }
                    }
                    list.add(li)
                }

                def length = list.size()
                String[][] str_result = new String[4][length - 1]
                //数组转换,行列互转
                for (int i = 0; i < length - 1; i++) {
                    List a1 = list.get(i)
                    if (a1.size() > 0) {
                        for (int j = 0; j < 4; j++) {
                            def value = ""
                            if (a1.get(j) == null) {
                                value = " "
                            } else {
                                value = a1.get(j)
                            }
                            str_result[j][i] = value
                        }
                    }
                }
                List aList = new ArrayList()
                aList = str_result
                aList.add(list.get(length - 1))
                is.close()
                println aList
                return aList
            } else {
                flash.message = "上传失败，请确认上传文件中格式跟模板一样，并且有相应数据！"
                redirect(action: "batchRefund")
            }
        } catch (Exception e) {
            e.printStackTrace()
        }
    }

    def getcardfile = {
        def filepath = request.getRealPath("/") + "file" + File.separator + "checktemplate.xls"
        println filepath
        // 下载本地文件
        String fileName = "checktemplate.xls".toString(); // 文件的默认保存名
        // 读到流中
        InputStream is = new FileInputStream(filepath);// 文件的存放路径
        // 设置输出的格式
        response.reset();
        response.setContentType("bin");
        response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        // 循环取出流中的数据
        byte[] b = new byte[100];
        int len;
        while ((len = is.read(b)) > 0)
            response.getOutputStream().write(b, 0, len);
        is.close();
    }
    def uncheckcardfile = {
        def filepath = request.getRealPath("/") + "file" + File.separator + "unchecktemplate.xls"
        println filepath
        // 下载本地文件
        String fileName = "unchecktemplate.xls".toString(); // 文件的默认保存名
        // 读到流中
        InputStream is = new FileInputStream(filepath);// 文件的存放路径
        // 设置输出的格式
        response.reset();
        response.setContentType("bin");
        response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        // 循环取出流中的数据
        byte[] b = new byte[100];
        int len;
        while ((len = is.read(b)) > 0)
            response.getOutputStream().write(b, 0, len);
        is.close();
    }
    def confirmRefund = {
        if (!withForm { true }.invalidToken { false }) {
            writeInfoPage "请不要重复提交数据"; return
        }
        def cmCustomerOperator = session.cmCustomerOperator
        def fitems = params.fitems
        def ftotalMoney = params.ftotalMoney
        def sitems = params.sitems
        def stotalMoney = params.stotalMoney
        def shapass = (cmCustomerOperator.id + "p" + params.pw).encodeAsSHA1()
        if (shapass != cmCustomerOperator.payPassword) {
            def boCustomerService = BoCustomerService.executeQuery(" from BoCustomerService where customerId=" + session.cmCustomerOperator.customerId + " and enable=1 and isCurrent=1 and serviceCode='online'")
            def model = BoRefundModel.findByCustomerServerId(boCustomerService.get(0).id)//.executeQuery(" from BoRefundModel where customerServerId='481'")
            def paymodel
            if (model) {
                if (model.refundModel == 'payPassword') {
                    paymodel = "payPassword"
                } else if (model.refundModel == 'reCheck') {
                    paymodel = "reCheck"
                }
            } else {
                paymodel = "reCheck"
            }

            def rb = RefundBatch.findByBatchNo(params.batch)
            def ra = RefundAuth.findAllByBatch(rb)
            params.sort = params.sort ? params.sort : "numberNo"
            params.order = params.order ? params.order : "asc"
            params.max = Math.min(params.max ? params.int('max') : 10, 100)
            params.offset = params.offset ? params.int('offset') : 0
            def query = {
                eq('batch', rb)
            }
            def list = RefundAuth.createCriteria().list(params, query)
            def count = RefundAuth.createCriteria().count(query)
            flash.message = "您输入的支付密码不正确，请重新输入"
            render(view: "payPasswordPage", model: [raList: list, raTotal: count, refundAuth: ra, refundBatch: rb, paymodel: paymodel, sitems: sitems, stotalMoney: stotalMoney, fitems: fitems, ftotalMoney: ftotalMoney])

            // return
        } else {
            def refundBatch = RefundBatch.findByBatchNo(params.batch)
            refundBatch.flag = true
            refundBatch.save(flush: true, failOnError: true)

            //======      历史
            def refundHistory = new RefundHistory()
            refundHistory.batchDate = new Date()
            refundHistory.batchNo = params.batch
            refundHistory.customerNo = session.cmCustomer.customerNo
            refundHistory.succAmt = stotalMoney as double
            refundHistory.succItems = sitems as long
            refundHistory.failAmt = ftotalMoney as double
            refundHistory.failItems = fitems as long
            String path = "proFile" + File.separator + session.cmCustomer.customerNo + params.batch + ".xls"
            refundHistory.exportPath = path
            refundHistory.save(flush: true, failOnError: true)
            //=============
            refundPass()
        }

    }
//    protected uploadFile(HttpServletRequest request, String name) {
//        def f = request.getFile(name)//得到file
//        def url =""
//        if (!f.empty) {
//            def fileName = f.getOriginalFilename() //得到文件名称
//            def filePath = "grails-app/upload/" //设置上传路径
//            url = filePath + fileName              //文件上传的路径+文件名
//            def file = new File(filePath + fileName)
//            if (file) {
//               file.delete()
//            }
//            file.mkdirs()         //如果file不存在自动创建
//            try{
//              f.transferTo(file)   //上传}
//            }catch(IOException e){
//               e.printStackTrace()
//               writeInfoPage "文件已存在"
//            }
//        }
//        return url
//    }
    def exportClassroom(List list, String batchNo) throws Exception {

        try {

            String filepath = request.getRealPath("/") + "proFile" + File.separator + session.cmCustomer.customerNo + batchNo + ".xls"
            File file = new File(filepath)
            if (file.exists()) {
                file.delete()
            }
            OutputStream os = new FileOutputStream(file, true); //是否追加
            WritableWorkbook wbook = Workbook.createWorkbook(os); //建立excel文件
            WritableSheet wsheet = wbook.createSheet("失败数据", 0); //工作表名称
            //设置Excel字体
            WritableFont wfont = new WritableFont(WritableFont.ARIAL, 16,
                    WritableFont.BOLD, false,
                    jxl.format.UnderlineStyle.NO_UNDERLINE,
                    jxl.format.Colour.BLACK);
            WritableCellFormat titleFormat = new WritableCellFormat(wfont);
            String[] title = new String[4]//{ "商户订单号"; "退款金额"; "错误原因" };
            title[0] = "商户订单号"; title[1] = "退款金额"; title[2] = "错误原因"; title[3] = "退款备注";
            //设置Excel表头
            for (int i = 0; i < title.length; i++) {
                Label excelTitle = new Label(i, 0, title[i], titleFormat);
                wsheet.addCell(excelTitle);
            }
            int c = 1; //用于循环时Excel的行号
            for (int i = 0; i < list.size(); i++) {
                String[] details = list.get(i)
                def orderNo = details[0]
                def amount = details[1]
                def reason = details[2]
                def note = details[3]
                Label content1 = new Label(0, c, orderNo);
                Label content2 = new Label(1, c, amount);
                Label content3 = new Label(2, c, reason);
                Label content4 = new Label(3, c, note);
                wsheet.addCell(content1);
                wsheet.addCell(content2);
                wsheet.addCell(content3);
                wsheet.addCell(content4);
                c++;
            }
            wbook.write(); //写入文件
            wbook.close();
            os.close();
        } catch (Exception e) {

            throw new Exception("导出文件出错");

        }

    }

    def uploadFail = {
        def filepath = request.getRealPath("/") + "proFile" + File.separator + session.cmCustomer.customerNo + params.id + ".xls"
        println filepath
        // 下载本地文件
        String fileName = session.cmCustomer.customerNo + params.id + ".xls"; // 文件的默认保存名
        // 读到流中
        InputStream is = new FileInputStream(filepath);// 文件的存放路径
        // 设置输出的格式
        response.reset();
        response.setContentType("bin");

        response.addHeader("Content-Disposition", "attachment; filename=\"" + java.net.URLEncoder.encode(fileName) + "\"");
        // 循环取出流中的数据
        byte[] b = new byte[100];
        int len;
        while ((len = is.read(b)) > 0)
            response.getOutputStream().write(b, 0, len);
        is.close();
    }
    def makedefault = {
        def boCustomerService = BoCustomerService.executeQuery(" from BoCustomerService where customerId=" + session.cmCustomerOperator.customerId + " and enable=1 and isCurrent=1 and serviceCode='online'")
        boCustomerService.get(0).refundModelType = params.uploadtype
        boCustomerService.get(0).save()
        redirect(action: "batchRefund")
    }
    def payPasswordPage = {
        def batchNo = params.batch
        def sitems = params.sitems
        def fitems = params.fitems
        def stotalMoney = params.stotalMoney
        def ftotalMoney = params.ftotalMoney
        def rb = RefundBatch.findByBatchNo(batchNo)
        def ra = RefundAuth.findAllByBatch(rb)
        params.sort = params.sort ? params.sort : "numberNo"
        params.order = params.order ? params.order : "asc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0
        def query = {
            eq('batch', rb)
        }
        def list = RefundAuth.createCriteria().list(params, query)
        def count = RefundAuth.createCriteria().count(query)

        [raList: list, raTotal: count, refundAuth: ra, refundBatch: rb, sitems: sitems, stotalMoney: stotalMoney, fitems: fitems, ftotalMoney: ftotalMoney]
    }

    def walletRefund = {
        params.sort = params.sort ? params.sort : "orderId"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        String errmsg = ""
        String pattern = "yyyy-MM-dd"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "walletRefund", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "walletRefund", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "walletRefund", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
                return
            }
        }

        def query = getQuery('check')

        List<UserWalletTrade> userWalletTradeInstanceList = UserWalletTrade.createCriteria().list(params, query)
        Integer count = UserWalletTrade.createCriteria().count(query)
        [userWalletTradeInstanceList: userWalletTradeInstanceList, userWalletTradeInstanceTotal: count]
    }

    def walletRefundPass = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def arr = ids.replace("[", "").split(',')
        arr = arr.collect { it as long }
        List<UserWalletTrade> walletRefunds = UserWalletTrade.createCriteria().list {
            eq('status', '0')
            eq('merchantId', session.cmCustomer.customerNo)
            eq('tradeType', 'refundReq')
            'in'('id', arr)
        }
        def succ = 0
        def fail = 0
        walletRefunds.each {
            UserOrder userOrder = UserOrder.findByOrderId(it.orderId)
            if (userOrder.status != 'refund' || (userOrder.amount - userOrder.refundedAmount) > it.amount) {
                fail++
                it.note = '钱包退款通过审核失败'
                it.status = '1'
            } else {
                succ++
                //   it.note = '钱包退款通过审核成功'
                it.status = '5'
            }
            it.save(flush: true, failOnError: true)
        }
        redirect(action: 'redirect', params: [type: "ok", succcount: succ, failcount: fail])
    }

    def walletRefundRefuse = {
        def ids = params.ids.substring(0, params.ids.length() - 1)
        def arr = ids.replace("[", "").split(',')
        arr = arr.collect { it as long }
        List<UserWalletTrade> walletRefunds = UserWalletTrade.createCriteria().list {
            eq('status', '0')
            eq('merchantId', session.cmCustomer.customerNo)
            eq('tradeType', 'refundReq')
            'in'('id', arr)
        }
        walletRefunds.each {
            it.note = params.note
            it.status = '1'
            it.save(flush: true, failOnError: true)
        }
        redirect(action: "walletRefund")
    }

    def walletRefundRefuseHistory = {
        params.sort = params.sort ? params.sort : "orderId"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        String errmsg = ""
        String pattern = "yyyy-MM-dd"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -1, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "walletRefundRefuseHistory", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "walletRefundRefuseHistory", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "walletRefundRefuseHistory", model: [errmsg: errmsg, userWalletTradeInstanceList: null, userWalletTradeInstanceTotal: 0])
                return
            }
        }

        def query = getQuery('refuse')
        List<UserWalletTrade> userWalletTradeInstanceList = UserWalletTrade.createCriteria().list(params, query)
        Integer count = UserWalletTrade.createCriteria().count(query)
        [userWalletTradeInstanceList: userWalletTradeInstanceList, userWalletTradeInstanceTotal: count]
    }

    protected getQuery(action) {
        return {
            if (action == 'check') {
                eq('status', '0')
            } else if (action == 'refuse') {
                eq('status', '1')
            }
            eq('merchantId', session.cmCustomer.customerNo)
            eq('tradeType', 'refundReq')
            ge('reqDate', Date.parse("yyyy-MM-dd", params.startDate))
            le('reqDate', Date.parse("yyyy-MM-dd", params.endDate) + 1)
            if (params.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                eq('transNo', params.tradeNo)
            }
            if (params.outTradeNo) {
                eq('orderId', params.outTradeNo)
            }
        }
    }

    def walletConsume = {
        params.sort = params.sort ? params.sort : "reqDate"
        params.order = params.order ? params.order : "desc"
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        params.offset = params.offset ? params.int('offset') : 0

        boolean isDownload = false
        if (params?.format && params.format in ["txt", "csv", "excel"]) {
            params.offset = 0
            params.max = 50000
            isDownload = true
        }
        String errmsg = ""
        String pattern = "yyyy-MM-dd HH:mm:ss"
        if (!params.endDate) {
            params.endDate = DateUtils.getDateStr(new Date(), pattern)
        }
        if (!params.startDate) {
            params.startDate = DateUtils.getAddMonthStr(params.endDate, -3, pattern)
        }
        if (DateUtils.equalsDate(params.startDate, params.endDate, pattern) == 1) {
            errmsg = "开始时间不能大于结束时间！！！！！"
            render(view: "walletConsume", model: [errmsg: errmsg, userWalletTradeInstanceList: null, tradeListTotal: 0, params: params])
            return
        }
        if (!DateUtils.isCorrectGapMonth(params.startDate, params.endDate, 3, pattern)) {
            errmsg = "您查询的时间范围不能大于三个月时间！！！！！"
            render(view: "walletConsume", model: [errmsg: errmsg, userWalletTradeInstanceList: null, tradeListTotal: 0, params: params])
            return
        }

        if (params.amountMin || params.amountMax) {
            try {
                if (params.amountMin) {
                    params.moneyMin = ConvertUtil.moneyTransformLong(params.amountMin)
                }
                if (params.amountMax) {
                    params.moneyMax = ConvertUtil.moneyTransformLong(params.amountMax)
                }
            } catch (RuntimeException e) {
                errmsg = "无效金额，请重新输入"
                render(view: "walletConsume", model: [errmsg: errmsg, userWalletTradeInstanceList: null, tradeListTotal: 0, params: params])
                return
            }
        }

        def query = {
            def types = ['mobileRecharge', 'ewalletPay', 'refundReq', 'refundTrans']
            inList("tradeType", types)
            if (params.tradeType) {
                eq('tradeType', params.tradeType)
            }
            if (params.status) {
                eq('status', params.status)
            }
            eq('merchantId', session.cmCustomer.customerNo)    //added by xyj 20161124
            ge('reqDate', Date.parse(pattern, params.startDate))
            le('reqDate', Date.parse(pattern, params.endDate) + 1)
            if (params.moneyMin) {
                ge('amount', params.moneyMin)
            }
            if (params.moneyMax) {
                le('amount', params.moneyMax)
            }
            if (params.tradeNo) {
                like('transNo', '%' + params.tradeNo + '%')
            }
            if (params.outTradeNo) {
                like('orderId', '%' + params.outTradeNo + '%')
            }
        }

        def list = UserWalletTrade.createCriteria().list(params, query)
        if (isDownload) {
            def totalamount = list.sum { it.amount }
            def filename = 'Excel-' + new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + '.xls'
            response.setHeader("Content-disposition", "attachment; filename=" + filename)
            response.setCharacterEncoding("GBK")
            response.contentType = "application/x-rarx-rar-compressed"
            render(template: "tpl_${params.format}_walletConsume", model: [tradeList: list, tradeListTotal: list.size(), totalamount: totalamount])
        } else {
            def total = UserWalletTrade.createCriteria().get() {
                and query
                projections {
                    rowCount()
                    sum('amount')
                }
            }
            [tradeList: list, tradeListTotal: total[0], totalamount: total[1], params: params]
        }
    }
}
