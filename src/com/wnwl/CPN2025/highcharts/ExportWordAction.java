package com.wnwl.CPN2025.highcharts;

import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;
import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletContext;

public class ExportWordAction {
    public static void openAnExistsFileTest() {
        System.out.println(System.getProperty("java.library.path"));
        WordBean wordBean = new WordBean();
        wordBean.setVisible(false); // 是否前台打开word 程序，或者后台运行
        ServletContext ctx = ServletActionContext.getServletContext();
        String WebRoot = ctx.getRealPath("files") + "/charts/charts.docx";
        wordBean.openFile(WebRoot);
        wordBean.insertJpeg(ctx.getRealPath("files") + "/charts/11.jpg"); // 插入图片(注意刚打开的word
        // ，光标处于开头，故，图片在最前方插入)
        wordBean.insertJpeg(ctx.getRealPath("files") + "/charts/22.jpg");
        wordBean.save();
        wordBean.closeDocument();
        wordBean.closeWord();
    }

    public static void main(String[] args) {
        openAnExistsFileTest();// 打开一个存在 的文件
        System.out.println("插入成功");
    }
}

class WordBean {
    // 代表一个word 程序
    private ActiveXComponent MsWordApp = null;
    // 代表进行处理的word 文档
    private Dispatch document = null;
    // 选定的范围或插入点
    private Dispatch selection;

    public WordBean() {
        if (MsWordApp == null) {
            MsWordApp = new ActiveXComponent("Word.Application");
        }
    }

    // 设置是否在前台打开 word 程序 ，
    public void setVisible(boolean visible) {
        MsWordApp.setProperty("Visible", new Variant(visible));
    }

    // 创建一个新文档
    public void createNewDocument() {
        Dispatch documents = Dispatch.get(MsWordApp, "Documents").toDispatch();
        document = Dispatch.call(documents, "Add").toDispatch();
    }

    // 打开一个存在的word文档,并用document 引用 引用它
    public void openFile(String wordFilePath) {
        Dispatch documents = Dispatch.get(MsWordApp, "Documents").toDispatch();
        document = Dispatch.call(documents, "Open", wordFilePath,
                new Variant(true)/* 是否进行转换ConfirmConversions */,
                new Variant(false)/* 是否只读 */).toDispatch();
    }

    // 向文档中添加 一个图片，
    public void insertJpeg(String jpegFilePath) {
        Dispatch selection = Dispatch.get(MsWordApp, "Selection").toDispatch();
        Dispatch image = Dispatch.get(selection, "InLineShapes").toDispatch();
        Dispatch.call(image, "AddPicture", jpegFilePath);
    }

    public void printFile() {
        Dispatch.call(document, "PrintOut");
    }

    // 保存文档的更改
    public void save() {
        Dispatch.call(document, "Save");
    }

    public void saveFileAs(String filename) {
        Dispatch.call(document, "SaveAs", filename);
    }

    public void closeDocument() {
        Dispatch.call(document, "Close", new Variant(0));
        document = null;
    }

    public void closeWord() {
        Dispatch.call(MsWordApp, "Quit");
        MsWordApp = null;
        document = null;
    }

    // 设置wordApp打开后窗口的位置
    public void setLocation() {
        Dispatch activeWindow = Dispatch.get(MsWordApp, "Application")
                .toDispatch();
        Dispatch.put(activeWindow, "WindowState", new Variant(1)); // 0=default
        Dispatch.put(activeWindow, "Top", new Variant(0));
        Dispatch.put(activeWindow, "Left", new Variant(0));
        Dispatch.put(activeWindow, "Height", new Variant(600));
        Dispatch.put(activeWindow, "width", new Variant(800));
        //Dispatch.put(activeWindow, "bottom", new Variant(0));
    }
    /** */
    /**
     * 把插入点移动到文件首位置
     */
    public void moveStart() {
        if (selection == null)
            selection = Dispatch.get(MsWordApp, "Selection").toDispatch();
        Dispatch.call(selection, "HomeKey", new Variant(6));
    }

    public void moveEnd() {
        if (selection == null)
            selection = Dispatch.get(MsWordApp, "Selection").toDispatch();
        Dispatch.call(selection, "EndKey", new Variant(6));
    }

    // word 中在对表格进行遍历的时候 ，是先列后行 先column 后cell
    // 另外下标从1开始
    public void insertTable(String tableTitle, int row, int column) {
        Dispatch selection = Dispatch.get(MsWordApp, "Selection").toDispatch(); // 输入内容需要的对象
        Dispatch.call(selection, "TypeText", tableTitle); // 写入标题内容 // 标题格行
        Dispatch.call(selection, "TypeParagraph"); // 空一行段落
        Dispatch.call(selection, "TypeParagraph"); // 空一行段落
        Dispatch.call(selection, "MoveDown"); // 游标往下一行
        // 建立表格
        Dispatch tables = Dispatch.get(document, "Tables").toDispatch();
        // int count = Dispatch.get(tables,
        // "Count").changeType(Variant.VariantInt).getInt(); // document中的表格数量
        // Dispatch table = Dispatch.call(tables, "Item", new Variant(
        // 1)).toDispatch();//文档中第一个表格
        Dispatch range = Dispatch.get(selection, "Range").toDispatch();// /当前光标位置或者选中的区域
        Dispatch newTable = Dispatch.call(tables, "Add", range,
                new Variant(row), new Variant(column), new Variant(1))
                .toDispatch(); // 设置row,column,表格外框宽度
        Dispatch cols = Dispatch.get(newTable, "Columns").toDispatch(); // 此表的所有列，
        int colCount = Dispatch.get(cols, "Count").changeType(
                Variant.VariantInt).getInt();// 一共有多少列 实际上这个数==column
        System.out.println(colCount + "列");
        for (int i = 1; i <= colCount; i++) { // 循环取出每一列
            Dispatch col = Dispatch.call(cols, "Item", new Variant(i))
                    .toDispatch();
            Dispatch cells = Dispatch.get(col, "Cells").toDispatch();// 当前列中单元格
            int cellCount = Dispatch.get(cells, "Count").changeType(
                    Variant.VariantInt).getInt();// 当前列中单元格数 实际上这个数等于row
            for (int j = 1; j <= cellCount; j++) {// 每一列中的单元格数
                // Dispatch cell = Dispatch.call(cells, "Item", new
                // Variant(j)).toDispatch(); //当前单元格
                // Dispatch cell = Dispatch.call(newTable, "Cell", new
                // Variant(j) , new Variant(i) ).toDispatch(); //取单元格的另一种方法
                // Dispatch.call(cell, "Select");//选中当前单元格
                // Dispatch.put(selection, "Text",
                // "第"+j+"行，第"+i+"列");//往选中的区域中填值，也就是往当前单元格填值
                putTxtToCell(newTable, j, i, "第" + j + "行，第" + i + "列");// 与上面四句的作用相同
            }
        }
    }
    /** */
    /**
     * 在指定的单元格里填写数据
     *
     * @param cellRowIdx
     * @param cellColIdx
     * @param txt
     */
    public void putTxtToCell(Dispatch table, int cellRowIdx, int cellColIdx,
                             String txt) {
        Dispatch cell = Dispatch.call(table, "Cell", new Variant(cellRowIdx),
                new Variant(cellColIdx)).toDispatch();
        Dispatch.call(cell, "Select");
        Dispatch selection = Dispatch.get(MsWordApp, "Selection").toDispatch(); // 输入内容需要的对象
        Dispatch.put(selection, "Text", txt);
    }
    /** */
    /**
     * 在指定的单元格里填写数据
     *
     * @param tableIndex
     * @param cellRowIdx
     * @param cellColIdx
     * @param txt
     */
    public void putTxtToCell(int tableIndex, int cellRowIdx, int cellColIdx,
                             String txt) {
        // 所有表格
        Dispatch tables = Dispatch.get(document, "Tables").toDispatch();
        // 要填充的表格
        Dispatch table = Dispatch.call(tables, "Item", new Variant(tableIndex))
                .toDispatch();
        Dispatch cell = Dispatch.call(table, "Cell", new Variant(cellRowIdx),
                new Variant(cellColIdx)).toDispatch();
        Dispatch.call(cell, "Select");
        Dispatch selection = Dispatch.get(MsWordApp, "Selection").toDispatch(); // 输入内容需要的对象
        Dispatch.put(selection, "Text", txt);
    }

    // 合并两个单元格
    public void mergeCell(Dispatch cell1, Dispatch cell2) {
        Dispatch.call(cell1, "Merge", cell2);
    }

    public void mergeCell(Dispatch table, int row1, int col1, int row2, int col2) {
        Dispatch cell1 = Dispatch.call(table, "Cell", new Variant(row1),
                new Variant(col1)).toDispatch();
        Dispatch cell2 = Dispatch.call(table, "Cell", new Variant(row2),
                new Variant(col2)).toDispatch();
        mergeCell(cell1, cell2);
    }

    public void mergeCellTest() {
        Dispatch tables = Dispatch.get(document, "Tables").toDispatch();
        int tableCount = Dispatch.get(tables, "Count").changeType(
                Variant.VariantInt).getInt(); // document中的表格数量
        Dispatch table = Dispatch.call(tables, "Item", new Variant(tableCount))
                .toDispatch();// 文档中最后一个table
        mergeCell(table, 1, 1, 1, 2);// 将table 中x=1,y=1 与x=1,y=2的两个单元格合并
    }
}