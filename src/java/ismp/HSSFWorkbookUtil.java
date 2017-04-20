package ismp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;

public class HSSFWorkbookUtil {
    private static HSSFWorkbook wb = new HSSFWorkbook();
    private static HSSFSheet sheet;
    private static HSSFFont font;
    private static HSSFCellStyle cellStyle;
    private static String name;
    private static String customerNo;
    private static String startDate;
    private static String endDate;
    public static int maxExportNum = 50000;
    public static boolean isDefault = false;

    public static HSSFWorkbook createDefaultHSSFWorkbook(List<Map<String,String>> list,Map<String, String> titleMap,String _name,String _customerNo,String _startDate,String _endDate){
        name = _name;
        customerNo = _customerNo;
        startDate = _startDate;
        endDate = _endDate;
        isDefault = true;
        return fillHSSFWorkbook(wb, list, titleMap);
    }

    /**
     *
     * @param wb
     * @param list
     * @param titleMap
     * @return
     */
    public static HSSFWorkbook fillHSSFWorkbook(HSSFWorkbook workBook,List<Map<String,String>> list,Map<String, String> titleMap){
        if(list==null || list.size()==0)
            return workBook;
        wb = workBook;
        Map<String, Integer>  colMap = new HashMap<String, Integer>();
        List<String> titleList = new ArrayList<String>();
        Integer count = 0;
        for(String key:titleMap.keySet()){
            colMap.put(key, count);
            titleList.add(titleMap.get(key));
            count++;
        }
        for(int i=0;i<list.size();i++){
            if(i%maxExportNum==0){
                sheet = wb.createSheet();
                if(isDefault){
                    createDefaultHead();
                }
                createTitleRow(sheet,titleList);
                sheet.setDefaultColumnWidth(20);
                fillDataStyle();
            }
            fillColumnValue(sheet,list.get(i),colMap);
        }

        return wb;
    }
    /**
     *
     * @param map
     * @param colMap
     */
    protected static void fillColumnValue(HSSFSheet sheet, Map<String, String> map,Map<String, Integer> colMap) {
        int rowNum = sheet.getLastRowNum();
        HSSFRow row = sheet.createRow(rowNum+1);
        HSSFCell cell = null;
        for(String key:map.keySet()){
            int colNum = colMap.get(key)==null ? -1 : colMap.get(key);
            if(colNum==-1)
                continue;
            String value = map.get(key);
            cell = row.createCell((short)colNum);
            cell.setCellValue(value);
            cell.setCellStyle(cellStyle);
        }
        cellStyle.setFont(font);
        row.setRowStyle(cellStyle);
    }
    /**
     *
     * @param wb
     * @param titleList
     */
    protected static void createTitleRow(HSSFSheet sheet,List<String> titleList) {
        int rowNum = sheet.getLastRowNum();
        HSSFRow row = sheet.createRow(rowNum+1);
        HSSFCell cell = null;
        fillTitleRowStyle();
        for(int i=0;i<titleList.size(); i++){
            String name = titleList.get(i);
            cell = row.createCell(i);
            cell.setCellValue(name);
            cell.setCellStyle(cellStyle);
        }
        cellStyle.setFont(font);
        row.setRowStyle(cellStyle);
    }
    /**
     *
     * @param list
     * @param titleMap
     * @param name
     * @param customerNo
     * @param startDate
     * @param endDate
     * @return
     */
    public static void createDefaultHead(){
        HSSFRow  row = sheet.createRow(0);
        row.createCell(0).setCellValue(name);
        row.createCell(2).setCellValue("账号：["+customerNo+"]");
        row.createCell(4).setCellValue("起始日期：["+startDate+"] 终止日期: ["+endDate+"]");
        sheet.addMergedRegion(new CellRangeAddress(0,0,0,1));
        sheet.addMergedRegion(new CellRangeAddress(0,0,2,3));
        sheet.addMergedRegion(new CellRangeAddress(0,0,4,6));
        defaultHeadStyle();
        HSSFCell cell = null;
        for(int i=0;i<5;i+=2){
            cell = row.getCell(i);
            cell.setCellStyle(cellStyle);
        }
        row.setRowStyle(cellStyle);
        HSSFRow row1 = sheet.createRow(1);
        row1.setRowStyle(cellStyle);

    }

    private static void defaultHeadStyle(){
        font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short)11);
        font.setColor(HSSFColor.BLACK.index);
        cellStyle = wb.createCellStyle();
        cellStyle.setFont(font);
        cellStyle.setBorderTop(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        cellStyle.setTopBorderColor(HSSFColor.WHITE.index);
        cellStyle.setLeftBorderColor(HSSFColor.WHITE.index);
        cellStyle.setRightBorderColor(HSSFColor.WHITE.index);
    }
    private static void fillTitleRowStyle(){
        cellStyle = wb.createCellStyle();
        cellStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        cellStyle.setBorderTop(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setTopBorderColor(HSSFColor.BLACK.index);
        cellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
        cellStyle.setRightBorderColor(HSSFColor.BLACK.index);
        cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
        cellStyle.setAlignment(HorizontalAlignment.CENTER);
        font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short)11);
        font.setColor(HSSFColor.WHITE.index);
    }
    private static void fillDataStyle(){
        cellStyle = wb.createCellStyle();
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
        cellStyle.setRightBorderColor(HSSFColor.BLACK.index);
        cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
        font = wb.createFont();
        font.setFontName("宋体");
        font.setFontHeightInPoints((short)11);
    }

}
