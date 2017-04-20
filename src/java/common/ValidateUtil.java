package common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: heli50
 * Date: 16-12-1
 * Time: 下午5:45
 * To change this template use File | Settings | File Templates.
 */
public class ValidateUtil {
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    /**
     * 验证两个日期的月数差距是否在gapMonth范围内
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @param gapMonth  相差月数
     * @return
     */
    public static boolean isCorrectGapMonth(Date startDate, Date endDate, int gapMonth) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        calendar.add(Calendar.MONTH,gapMonth);
        long startTime = calendar.getTime().getTime();
        long endTime = endDate.getTime();
        long times = startTime - endTime;
        if(times >= 0)
            return true;
        return false;
    }

    /**
     * 验证是否金额格式
     * @param money 金额
     * @return
     */
    public static boolean isMoney(String money){
        java.util.regex.Pattern pattern=java.util.regex.Pattern.compile("^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d{1,2}))?$");
        java.util.regex.Matcher match=pattern.matcher(money);
        if(match.matches())
            return true;
        else
            return false;
    }

}
