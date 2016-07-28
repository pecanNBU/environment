package com.wnwl.CPN2025.dwr;

import org.directwebremoting.ScriptSession;
import org.directwebremoting.WebContextFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class ChatService implements ApplicationContextAware {
    private ApplicationContext ctx;

    public void setApplicationContext(ApplicationContext ctx) throws BeansException {
        this.ctx = ctx;
    }

    /**
     * <b>function:</b> 向服务器发送信息，服务器端监听ChatMessageEvent事件，当有事件触发就向所有客户端发送信息
     *
     * @param msg
     * @author hoojo
     * @createDate 2011-6-8 下午12:37:24
     */
    public void sendMessage(String msg) {
        //发布事件
        /*if(!msg.equals("0")){
            System.err.println(msg);
        	try {
    			msg = new String(msg.getBytes("iso-8859-1"),"UTF-8");
    		} catch (UnsupportedEncodingException e) {
    			e.printStackTrace();
    		}
    		System.err.println(msg);
    	}*/
        ctx.publishEvent(new ChatMessageEvent(msg));
    }

    public void test() {
        ScriptSession scriptSession = WebContextFactory.get().getScriptSession();
        System.out.println(scriptSession.getPage());
    }
}
