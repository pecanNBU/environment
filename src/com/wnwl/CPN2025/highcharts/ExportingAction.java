package com.wnwl.CPN2025.highcharts;

import com.opensymphony.xwork2.ActionSupport;
import com.wnwl.CPN2025.service.RegService;
import org.apache.struts2.ServletActionContext;
import sun.misc.BASE64Decoder;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * SVG 转换类，实现将SVG文件转换为常见图片格式文件
 *
 * @author Zhy
 *         <p>
 *         publish on Highcharts中文网  http://www.hcharts.cn
 *         <p>
 *         导出步骤：
 *         1、接受页面提交的参数   （ 可以将参数打印出来以确保页面提交过来的代码不会乱码）
 *         2、将svg代码保存为.svg文件 （保存文件时注意编码）
 *         3、执行转换函数，将.svg文件转换成目标文件
 *         4、读取目标文件，并调用 浏览器下载
 */
@SuppressWarnings("serial")
public class ExportingAction extends ActionSupport {
    /**
     * 第一步：获取页面提交的参数，这里由Struts2帮我们来处理
     */

    // 宽度
    private float width;

    // 缩放比例，这里并没有用到该参数详见API，http://www.hcharts.cn/api/index.php#exporting.scale
    private float scale;

    // 导出类型
    private String type;

    // 文件名
    private String filename;

    // SVG代码，官方默认是以文件形式上传，用jsp/servlet 的request.getParameter(arg0)是无法获取该值的，所以这里利用Struts2来帮我们处理。更多详情我将在Highcharts中文论坛上详细说明
    private String svg;
    private byte state;
    private int index;
    private String tabFlag;
    private Integer reportId;
    private String[] svgs;
    private HttpServletResponse response;
    private InputStream input;
    private String downloadFileName;
    private String stDt;
    private String endDt;
    private RegService regService;
    private int regId;
    private String imgUrl;

    public ExportingAction() {
        response = ServletActionContext.getResponse();
    }

    //导出实时曲线图-生成图片
    public String exportNowChart() {
        /*String type = "jpg";
        try {
			ServletContext ctx = ServletActionContext.getServletContext();
			String WebRoot= ctx.getRealPath("files")+"/temp/";
			deleteFile(WebRoot);	//清空文件夹-图片路径
			String tempName = WebRoot+System.currentTimeMillis()+(int)(Math.random()*1000);
			String temp,filename;
			File svgTempFile,resultFile;
			OutputStreamWriter svgFileOsw;
			MyConverter mc;
			FileInputStream resultFileFi;
			long l;
			int k,j;
			byte[] abyte0;
			WordBean wordBean = new WordBean();
			wordBean.setVisible(false); // 是否前台打开word 程序，或者后台运行
			String wordPath = ctx.getRealPath("files")+"/charts/";
			deleteFile(wordPath);	//清空文件夹-导出的word路径
			wordBean.createNewDocument();
			//wordBean.openFile(wordPath);
			// ，光标处于开头，故，图片在最前方插入)
			for(int i=0;i<svgs.length;i++){
				svg = svgs[i];
				temp = tempName+i+".svg";
				svgTempFile = new File(temp);
				svgFileOsw = new OutputStreamWriter(new FileOutputStream(svgTempFile),"UTF-8");
				svgFileOsw.write(svg);
				svgFileOsw.flush();
				svgFileOsw.close();
				mc = new MyConverter();
				filename = mc.convers(temp,WebRoot, type, 1100,900,i);
				resultFile = new File(WebRoot+filename);
				resultFileFi = new FileInputStream(resultFile);
				l = resultFile.length();
				k = 0;
				abyte0 = new byte[65000];
				while ((long) k < l) {
					j = resultFileFi.read(abyte0, 0, 65000);
					k += j;
				}
				resultFileFi.close();
				svgTempFile.delete();
				//resultFile.delete();
				wordBean.insertJpeg(WebRoot+"/chart"+i+".jpg"); // 插入图片(注意刚打开的word
			}
			wordBean.saveFileAs(wordPath+"charts.docx");
			wordBean.closeDocument();
			wordBean.closeWord();

		} catch (Exception e) {
			e.printStackTrace();
		}*/
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String WebRoot = ctx.getRealPath("files") + "/temp/";
            deleteFile(WebRoot);    //清空文件夹-图片路径
            String tempName = WebRoot + System.currentTimeMillis() + (int) (Math.random() * 1000);
            String temp, filename;
            File svgTempFile, resultFile;
            OutputStreamWriter svgFileOsw;
            MyConverter mc;
            FileInputStream resultFileFi;
            long l;
            int k, j;
            byte[] abyte0;
            CreatePdf cp = new CreatePdf();
            // ，光标处于开头，故，图片在最前方插入)
            List<String> listImgs = new ArrayList<String>();
            type = "jpg";
            for (int i = 0; i < svgs.length; i++) {
                svg = svgs[i];
                temp = tempName + i + ".svg";
                svgTempFile = new File(temp);
                svgFileOsw = new OutputStreamWriter(new FileOutputStream(svgTempFile), "UTF-8");
                svgFileOsw.write(svg);
                svgFileOsw.flush();
                svgFileOsw.close();
                mc = new MyConverter();
                filename = mc.convers(temp, WebRoot, type, 1100, 900, i);
                resultFile = new File(WebRoot + filename);
                resultFileFi = new FileInputStream(resultFile);
                l = resultFile.length();
                k = 0;
                abyte0 = new byte[65000];
                while ((long) k < l) {
                    j = resultFileFi.read(abyte0, 0, 65000);
                    k += j;
                }
                resultFileFi.close();
                svgTempFile.delete();
                //resultFile.delete();
                listImgs.add(WebRoot + "/chart" + i + ".jpg");
            }
            cp.addImg(listImgs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadChartWord() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/charts/charts.pdf";
            input = new FileInputStream(wordPath);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH小时mm分钟ss秒");
            downloadFileName = "CPN2025-电缆沟在线监测系统【实时趋势图：" + sdf.format(new Date()) + "】.pdf";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadNowContr() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/charts/charts.pdf";
            input = new FileInputStream(wordPath);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH小时mm分钟ss秒");
            downloadFileName = "CPN2025-电缆沟在线监测系统【实时同比图：" + sdf.format(new Date()) + "】.pdf";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String exportHisCharts() {    //批量导出图片到word内
        /*String type = "jpg";
        try {
			ServletContext ctx = ServletActionContext.getServletContext();
			String WebRoot= ctx.getRealPath("files")+"/temp/";
			deleteFile(WebRoot);	//清空文件夹-图片路径
			String tempName = WebRoot+System.currentTimeMillis()+(int)(Math.random()*1000);
			String temp,filename;
			File svgTempFile,resultFile;
			OutputStreamWriter svgFileOsw;
			MyConverter mc;
			FileInputStream resultFileFi;
			long l;
			int k,j;
			byte[] abyte0;
			WordBean wordBean = new WordBean();
			wordBean.setVisible(false); // 是否前台打开word 程序，或者后台运行
			String wordPath = ctx.getRealPath("files")+"/charts/";
			deleteFile(wordPath);	//清空文件夹-导出的word路径
			wordBean.createNewDocument();
			// wordBean.openFile(wordPath);
			// 光标处于开头，故，图片在最前方插入)
			for(int i=0;i<svgs.length;i++){
				svg = svgs[i];
				temp = tempName+i+".svg";
				svgTempFile = new File(temp);
				svgFileOsw = new OutputStreamWriter(new FileOutputStream(svgTempFile),"UTF-8");
				svgFileOsw.write(svg);
				svgFileOsw.flush();
				svgFileOsw.close();
				mc = new MyConverter();
				filename = mc.convers(temp,WebRoot, type, 1100,900,i);
				resultFile = new File(WebRoot+filename);
				resultFileFi = new FileInputStream(resultFile);
				l = resultFile.length();
				k = 0;
				abyte0 = new byte[65000];
				while ((long) k < l) {
					j = resultFileFi.read(abyte0, 0, 65000);
					k += j;
				}
				resultFileFi.close();
				svgTempFile.delete();
				//resultFile.delete();
				wordBean.insertJpeg(WebRoot+"/chart"+i+".jpg"); // 插入图片(注意刚打开的word
			}
			wordBean.saveFileAs(wordPath+"charts.docx");
			wordBean.closeDocument();
			wordBean.closeWord();

		} catch (Exception e) {
			e.printStackTrace();
		}*/
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String WebRoot = ctx.getRealPath("files") + "/temp/";
            deleteFile(WebRoot);    //清空文件夹-图片路径
            String tempName = WebRoot + System.currentTimeMillis() + (int) (Math.random() * 1000);
            String temp, filename;
            File svgTempFile, resultFile;
            OutputStreamWriter svgFileOsw;
            MyConverter mc;
            FileInputStream resultFileFi;
            long l;
            int k, j;
            byte[] abyte0;
            CreatePdf cp = new CreatePdf();
            // ，光标处于开头，故，图片在最前方插入)
            List<String> listImgs = new ArrayList<String>();
            type = "jpg";
            for (int i = 0; i < svgs.length; i++) {
                svg = svgs[i];
                temp = tempName + i + ".svg";
                svgTempFile = new File(temp);
                svgFileOsw = new OutputStreamWriter(new FileOutputStream(svgTempFile), "UTF-8");
                svgFileOsw.write(svg);
                svgFileOsw.flush();
                svgFileOsw.close();
                mc = new MyConverter();
                filename = mc.convers(temp, WebRoot, type, 1100, 900, i);
                resultFile = new File(WebRoot + filename);
                resultFileFi = new FileInputStream(resultFile);
                l = resultFile.length();
                k = 0;
                abyte0 = new byte[65000];
                while ((long) k < l) {
                    j = resultFileFi.read(abyte0, 0, 65000);
                    k += j;
                }
                resultFileFi.close();
                svgTempFile.delete();
                //resultFile.delete();
                listImgs.add(WebRoot + "/chart" + i + ".jpg");
            }
            cp.addImg(listImgs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadHisLine() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/charts/charts.pdf";
            input = new FileInputStream(wordPath);
            /*RegInfo regInfo = regInfoService.findById(regId);
            //String pName = regInfo.getParent().getRegName()+regInfo.getRegName();
            String pName = "";
			pName = URLencoude(pName);
			downloadFileName = "CPN2025-电缆沟在线监测系统【历史趋势图："+pName+"："+stDt+"至"+endDt+"】.pdf";*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadHisColumn() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/charts/charts.pdf";
            input = new FileInputStream(wordPath);
            /*RegInfo regInfo = regService.findById(regId);
            //String pName = regInfo.getParent().getRegName()+regInfo.getRegName();
            String pName = "";
            pName = URLencoude(pName);
            downloadFileName = "CPN2025-电缆沟在线监测系统【历史柱状图："+pName+"："+stDt+"至"+endDt+"】.pdf";*/
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadHisContr() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/charts/charts.pdf";
            input = new FileInputStream(wordPath);
            downloadFileName = "CPN2025-电缆沟在线监测系统【历史图表：" + stDt + "至" + endDt + "】.pdf";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String exportNowState() { //导出图片 - 实时状态图
        //对字节数组字符串进行Base64解码并生成图片
        if (imgUrl == null) //图像数据为空
            return SUCCESS;
        BASE64Decoder decoder = new BASE64Decoder();
        try {
            String[] url = imgUrl.split(",");
            String u = url[1];
            //Base64解码
            byte[] buffer = new BASE64Decoder().decodeBuffer(u);
            //生成图片
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/pic/chart.png";
            OutputStream out = new FileOutputStream(new File(wordPath));
            out.write(buffer);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    public String downloadNowState() {
        try {
            ServletContext ctx = ServletActionContext.getServletContext();
            String wordPath = ctx.getRealPath("files") + "/pic/chart.png";
            input = new FileInputStream(wordPath);
            /*RegInfo regInfo = regInfoService.findById(regId);
            //String pName = regInfo.getParent().getRegName()+regInfo.getRegName();
            String pName = "";
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH小时mm分钟ss秒");
            downloadFileName = "CPN2025-电缆沟在线监测系统【实时状态图-"+pName+"："+sdf.format(new Date())+"】.png";*/
            //downloadFileName = new String(downloadFileName.getBytes(), "ISO8859-1");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    private String URLencoude(String name) {
        return name.replaceAll("#", "号");
    }

    /**
     * 删除单个文件
     *
     * @param sPath 被删除文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    public boolean deleteFile(String sPath) {
        boolean flag = false;
        File file = new File(sPath);
        // 路径为文件且不为空则进行删除
        if (file.isFile() && file.exists()) {
            file.delete();
            flag = true;
        }
        return flag;
    }

    public float getWidth() {
        return width;
    }

    public void setWidth(float width) {
        this.width = width;
    }

    public float getScale() {
        return scale;
    }

    public void setScale(float scale) {
        this.scale = scale;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public void setSvgs(String[] svgs) {
        this.svgs = svgs;
    }

    public InputStream getInput() {
        return input;
    }

    public String getDownloadFileName() {
        String name = "";
        HttpServletRequest request = ServletActionContext.getRequest();
        String Agent = request.getHeader("User-Agent");
        try {// 解决下载文件中文文件名问题
            if (null != Agent) {
                Agent = Agent.toLowerCase();
                if (Agent.indexOf("firefox") != -1) {
                    name = new String(downloadFileName.getBytes(), "iso8859-1");
                } else if (Agent.indexOf("msie") != -1) {
                    name = java.net.URLEncoder.encode(downloadFileName, "UTF-8");
                } else {
                    name = java.net.URLEncoder.encode(downloadFileName, "UTF-8");
                }
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return name;
    }

    public void setState(byte state) {
        this.state = state;
    }

    public void setTabFlag(String tabFlag) {
        this.tabFlag = tabFlag;
    }

    public void setReportId(Integer reportId) {
        this.reportId = reportId;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public void setStDt(String stDt) {
        this.stDt = stDt;
    }

    public void setEndDt(String endDt) {
        this.endDt = endDt;
    }

    public RegService getRegService() {
        return regService;
    }

    public void setRegService(RegService regService) {
        this.regService = regService;
    }

    public void setRegId(int regId) {
        this.regId = regId;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }
}