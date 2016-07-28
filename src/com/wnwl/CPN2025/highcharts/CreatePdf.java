package com.wnwl.CPN2025.highcharts;

import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;
import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletContext;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.List;

public class CreatePdf {
    //自己做的一个简单例子，中间有图片之类的
    //先建立Document对象：相对应的 这个版本的jar引入的是com.lowagie.text.Document
    Document document = new Document(PageSize.A4, 36.0F, 36.0F, 36.0F, 36.0F);

    public static void main(String[] args) throws DocumentException, IOException {
        CreatePdf pdf = new CreatePdf();
        pdf.getPDFdemo();
    }

    public void getPDFdemo() throws DocumentException, IOException {
        //这个导出用的是 iTextAsian.jar 和iText-2.1.3.jar 属于比较老的方法。 具体下在地址见：
        //首先
        //字体的定义：这里用的是自带的jar里面的字体
        BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", false);
        // 当然你也可以用你电脑里面带的字体库
        //BaseFont bfChinese = BaseFont.createFont("C:/WINDOWS/Fonts/SIMSUN.TTC,1",BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        //定义字体 注意在最新的包里面 颜色是封装的
        Font fontChinese8 = new Font(bfChinese, 10.0F, 0, new Color(59, 54, 54));
        //生成pdf的第一个步骤：
        //保存本地指定路径
        saveLocal();
        document.open();
        ByteArrayOutputStream ba = new ByteArrayOutputStream();
        //   PdfWriter writer = PdfWriter.getInstance(document, ba);
        document.open();
        //获取此编译的文件路径
        ServletContext ctx = ServletActionContext.getServletContext();
        String WebRoot = ctx.getRealPath("files");
        //获取根路径
        //String filePath  = path.substring(1, path.length()-15);
        //获取图片路径 找到你需要往pdf上生成的图片
        //这里根据自己的获取的路径写 只要找到图片位置就可以
        String picPath = WebRoot + "/dep/";
        //往PDF中添加段落
        Paragraph pHeader = new Paragraph();
        pHeader.add(new Paragraph(" 你要生成文字写这里", new Font(bfChinese, 8.0F, 1)));
        //pHeader.add(new Paragraph("文字", 字体 可以自己写 也可以用fontChinese8 之前定义好的 );
        document.add(pHeader);//在文档中加入你写的内容
        //获取图片
        Image img2 = Image.getInstance(picPath + "wnwlLogo.png");
        //定义图片在文档中显示的绝对位置
        img2.scaleAbsolute(137.0F, 140.0F);
        img2.setAbsolutePosition(330.0F, 37.0F);
        //将图片添加到文档中
        document.add(img2);
        //关闭文档
        document.close();
        /*//设置文档保存的文件名
         response.setHeader("Content-disposition", "attachment;filename=\""+ new String(("CCF会员资格确认函.pdf").getBytes("GBK"),"ISO-8859-1") + "\"");
        //设置类型
         response.setContentType("application/pdf");
         response.setContentLength(ba.size());
         ServletOutputStream out = response.getOutputStream();
         ba.writeTo(out);
         out.flush();*/
    }

    public void addImg(List<String> listImgs) {  //往PDF添加图片,每张图片占一半空间
        try {
            saveLocal();
            document.open();
            document.open();
            Image img2;
            Phrase pHeader = new Phrase();
            pHeader.add(new Phrase(" "));
            //pHeader.add(new Paragraph("文字", 字体 可以自己写 也可以用fontChinese8 之前定义好的 );
            for (int i = 0; i < listImgs.size(); i++) {
                img2 = Image.getInstance(listImgs.get(i));
                img2.scalePercent(48, 42);
                document.add(pHeader);//在文档中加入你写的内容
                document.add(img2);
                //if(i%2==1) {
                //}
            }
            document.close();
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void test11() {
        try {
            CreatePdf pdf = new CreatePdf();
            pdf.getPDFdemo();
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //指定一个文件进行保存 这里吧文件保存到D盘的text.pdf
    public void saveLocal() throws IOException, DocumentException {
        //直接生成PDF 制定生成到D盘test.pdf
        ServletContext ctx = ServletActionContext.getServletContext();
        String WebRoot = ctx.getRealPath("files");
        File file = new File(WebRoot + "/charts/charts.pdf");
        file.createNewFile();
        PdfWriter.getInstance(document, new FileOutputStream(file));

    }
}