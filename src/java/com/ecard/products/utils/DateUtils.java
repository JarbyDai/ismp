package com.ecard.products.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {

    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private static SimpleDateFormat sdfTime = new SimpleDateFormat("HHmm");

    private static SimpleDateFormat sdf8 = new SimpleDateFormat("yyyyMMdd");


    public static String getDefaultDateBySDF8(){
        return sdf8.format(new Date());
    }


    /**
     * 截取日期字符串
     * 当参数为空时，默认获取当前日期
     * 格式：YYYY-MM-DD
     */
    public static String getDate(Date d){
        if(d == null){
            return sdf.format(new Date());
        }
        return sdf.format(d);
    }

    public static String getDefaultDate(){
        return sdf.format(new Date());
    }

    /**
     * 获取时间字符串
     * 当参数为空时，默认获取当前时间
     * 格式：HHmm
     */
    public static String  getTime(Date d){
        if(d == null){
            return sdfTime.format(new Date());
        }
        return sdfTime.format(d);
    }

    public static String  getDefaultTime(){
        return sdfTime.format(new Date());
    }


    public static Date string2date(String ds){
        String fmt = "yyyy-MM-dd";
        SimpleDateFormat sdf = new SimpleDateFormat(fmt);
        try {
            return sdf.parse(ds);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Date addDateByOne(Date ds){
        //
        return new Date(ds.getTime()+24*3600*1000-1);
    }

    /**
     * 增加时间
     * @param date 日期
     * @param time ms
     * @return
     */
    public static Date addTime(Date date, long time){
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(date.getTime()+time);
        return calendar.getTime();
    }

    /**
     * 增加时间
     * @param date 日期
     * @param time ms
     * @return
     * @throws ParseException
     */
    public static String addTime(String date, long time) throws ParseException{
        return sdf.format(addTime(sdf.parse(date),time));
    }
    /**
     * 增加时间
     * @param date 日期
     * @param time ms
     * @param pattern 格式
     * @return
     * @throws ParseException
     */
    public static String addTime(String date, long time,String pattern) throws ParseException{
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        return dateFormat.format(addTime(dateFormat.parse(date),time));
    }

    /**
     *增加月
     * @param date 日期
     * @param month 月数
     * @return 新的日期
     * @throws java.text.ParseException
     */
    public static Date addMonth(Date date, int month){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH,month);
        return calendar.getTime();
    }

    /**
     *增加月
     * @param date 日期
     * @param month 月数
     * @return 新的日期
     * @throws java.text.ParseException
     */
    public static String getAddMonthStr(String date, int month) throws  ParseException{
        return sdf.format(addMonth(sdf.parse(date), month));
    }

    /**
     *增加月
     * @param date 日期
     * @param month 月数
     * @param pattern 格式
     * @return
     * @throws java.text.ParseException
     */
    public static String getAddMonthStr(String date, int month,String pattern) throws  ParseException{
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        return dateFormat.format(addMonth(dateFormat.parse(date),month));
    }

    /**
     *
     * @param date 日期
     * @return 该日期转换成的字符串日期
     */
    public static String getDateStr(Date date){
        return sdf.format(date.getTime());
    }

    /**
     *
     * @param date 日期
     * @param pattern 格式
     * @return 该日期转换成的字符串日期
     */
    public static String getDateStr(Date date, String pattern) throws ParseException{
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        return dateFormat.format(date.getTime());
    }

    /**
     * 比较两个日期
     * @param startDate
     * @param endDate
     * @return -1表示小于 0等于 1大于
     */
    public static int equalsDate(Date startDate, Date endDate){
        if(startDate.getTime() > endDate.getTime())
            return 1;
        else if(startDate.getTime() == endDate.getTime())
            return 0;
        return -1;
    }

    /**
     * 比较两个日期
     * @param startDate
     * @param endDate
     * @param pattern 格式
     * @return -1表示小于 0等于 1大于
     */
    public static int equalsDate(String startDate, String endDate, String pattern) throws ParseException{
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        return equalsDate(dateFormat.parse(startDate), dateFormat.parse(endDate));
    }

    /**
     * 比较两个日期
     * @param startDate
     * @param endDate
     * @return -1表示小于 0等于 1大于
     */
    public static int equalsDate(String startDate, String endDate) throws ParseException{
        return equalsDate(sdf.parse(startDate), sdf.parse(endDate));
    }

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
     * 验证两个日期的月数差距是否在gapMonth范围内
     * @param startDate 开始日期
     * @param endDate   结束日期
     * @param gapMonth  相差月数
     * @param pattern   日期格式化模式
     * @return
     */
    public static boolean isCorrectGapMonth(String startDate, String endDate, int gapMonth, String pattern) throws ParseException{
        SimpleDateFormat simpleFormat = new SimpleDateFormat(pattern);
        return isCorrectGapMonth(simpleFormat.parse(startDate), simpleFormat.parse(endDate), gapMonth);
    }

    public static void main(String[] args) throws ParseException {
        String str = "2011-02-24";
        String fmt = "yyyyMMdd";
        SimpleDateFormat sdf = new SimpleDateFormat(fmt);
        Date date = sdf.parse(str);//转换成功的Date对象
        System.out.println(date);
    }
}
