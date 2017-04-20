package common;

import java.math.BigDecimal;

/**
 * Created with IntelliJ IDEA.
 * User: heli50
 * Date: 16-12-1
 * Time: 下午6:15
 * To change this template use File | Settings | File Templates.
 */
public class ConvertUtil {

    public static Long moneyTransformLong(String money){
        long amount = 0;

        if(!ValidateUtil.isMoney(money))
            throw new RuntimeException("金额格式错误");

        BigDecimal strAmount = new BigDecimal(money);
        strAmount = strAmount.multiply(new BigDecimal(100));
        amount = strAmount.longValue();
        return amount;
    }

}
