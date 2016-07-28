package com.wnwl.CPN2025.dwr;

import org.directwebremoting.ScriptBuffer;
import org.directwebremoting.ScriptSession;
import org.directwebremoting.ServerContext;
import org.directwebremoting.ServerContextFactory;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.web.context.ServletConfigAware;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import java.util.Collection;


/**
 * 创建人：kjk
 * 创建时间：Jul 15, 2011 12:17:30 PM
 * 修改人：
 * 修改时间：Jul 15, 2011 12:17:30 PM
 * 修改备注：
 * 版本信息：v4
 * <p>
 * 类描述：
 */

public class ChatMessageClient implements ApplicationListener,
        ServletConfigAware {
    private ServletContext ctx;

	/* (non-Javadoc)
     * @see org.springframework.context.ApplicationListener#onApplicationEvent(org.springframework.context.ApplicationEvent)
	 */

    /**
     * ctx
     *
     * @return the ctx
     */

    public ServletContext getCtx() {
        return ctx;
    }

    /**
     * @param ctx the ctx to set
     */

    public void setCtx(ServletContext ctx) {
        this.ctx = ctx;
    }

    @Override
    public void onApplicationEvent(ApplicationEvent event) {
        //如果事件类型是ChatMessageEvent就执行下面操作
        if (event instanceof ChatMessageEvent) {
            try {
                String msg = event.getSource().toString();
                ServerContext context = ServerContextFactory.get();
                //获得客户端所有chat页面script session连接数
                Collection<ScriptSession> sessions = context.getScriptSessionsByPage("/CPN2025/main/hide");
                ScriptBuffer sb;
                for (ScriptSession session : sessions) {
                    sb = new ScriptBuffer();
                    //执行setMessage方法
                    if (msg.equals("mote"))
                        sb.appendScript("moteData()");    //推送开关柜温度的数据
                    else if (msg.equals("0"))
                        sb.appendScript("showAlerts('" + msg + "')");    //推送警报
                    else if (msg.equals("switchSynch"))    //推送完成初始化开关量
                        sb.appendScript("switchSynch()");
                    else if (msg.split("_")[0].equals("switch"))    //推送控制开关量的结果
                        sb.appendScript("showSwitchs('" + msg + "')");
                    //System.out.println(sb.toString());
                    //执行客户端script session方法，相当于浏览器执行JavaScript代码
                    //上面就会执行客户端浏览器中的showMessage方法，并且传递一个对象过去
                    session.addScript(sb);
                }
            } catch (Exception e) {
                System.err.println("暂无");
            }
        }
    }

	/* (non-Javadoc)
     * @see org.springframework.web.context.ServletConfigAware#setServletConfig(javax.servlet.ServletConfig)
	 */

    @Override
    public void setServletConfig(ServletConfig arg0) {
        // TODO Auto-generated method stub

    }

}
