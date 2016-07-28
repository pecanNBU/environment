package com.wnwl.CPN2025.action;

import com.wnwl.CPN2025.bhh.PrivActor;
import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.service.LogService;
import com.wnwl.CPN2025.service.UserService;
import com.wnwl.CPN2025.util.Encyptions;
import com.wnwl.CPN2025.util.Page;
import org.apache.struts2.ServletActionContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @ClassName: LoginAction
 * @Description: login user self manage
 * @author: Jenny
 * @date 2016-7-18
 */
public class LoginAction extends BaseAction {
    private static final long serialVersionUID = 2696363985077090985L;
    private UserService userService;
    private LogService logService;
    private UserInfo userInfo;                  //用户信息对象变量，需注入spring
    private Encyptions ens = new Encyptions();    //加密类对象
    private String loginName;                   //用户名
    private String psw;                         //密码
    private ArrayList<Object> rows;
    private Map<String, Object> map;
    private long total;
    private Page pages;
    private byte flag;

    public String hide() {
        return SUCCESS;
    }

    public String main() {
        userInfo = userService.findloginUser();
        if (null == userInfo)
            return ERROR;
        return SUCCESS;
    }

    public String checkLogin() {
        try {
            String psws = ens.encryptSHA(psw);
            userInfo = userService.checkLogin(loginName, psws);
            if (userInfo == null)
                flag = 0;
            else {
                flag = 1;
                String ip = ServletActionContext.getRequest().getHeader("x-forwarded-for");
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = ServletActionContext.getRequest().getHeader("Proxy-Client-IP");
                }
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = ServletActionContext.getRequest().getHeader("WL-Proxy-Client-IP");
                }
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = ServletActionContext.getRequest().getRemoteAddr();
                }
                //logService.login(userInfo, ip);
            }
        } catch (Exception e) {
            flag = 2;
            e.printStackTrace();
        }
        return SUCCESS;
    }

    /* (non-Javadoc)
     * <P> Title:logins()</P>
     * <P> Description: 登陆判定，根据是否成功转入相应页面</P>
     * @throws Exception
     */
    public String logins() {
        try {
            userInfo = userService.findloginUser();
            List<PrivActor> privActors = userService.getPrivActor(userInfo.getId());
            if (privActors != null && privActors.size() > 0) {
                for (PrivActor privActor : privActors) {
                    session.put("actorId", privActor.getId());
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    /* (non-Javadoc)
     * <P> Title:exitLogin()</P>
     * <P> Description: 退出登陆</P>
     * @throws Exception
     */
    public String exitLogin() {
        try {
            HttpServletRequest request = ServletActionContext.getRequest();
            HttpSession session = request.getSession();
            session.invalidate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    /* (non-Javadoc)
     * <P> Title:updatepassword()</P>
     * <P> Description: 获取用户密码</P>
     * @throws
     */
    public String password() {
        try {
            userInfo = userService.findloginUser();
            String j = userInfo.getLoginPwd();
            HttpServletRequest request = ServletActionContext.getRequest();
            request.setAttribute("j", j);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SUCCESS;
    }

    /* (non-Javadoc)
     * <P> Title:updatepassword()</P>
     * <P> Description: 修改用户密码</P>
     * @throws
     */
    public String updatepassword() {
        try {
            String newPwdId = ServletActionContext.getRequest().getParameter("newPwdId");
            String userpwd = ServletActionContext.getRequest().getParameter("userpwd");
            String newPwdId1 = ens.encryptSHA(newPwdId);
            String userpwd1 = ens.encryptSHA(userpwd);
            UserInfo userInfo = userService.findloginUser();
            if (userpwd1.equals(userInfo.getLoginPwd())) {
                userInfo.setLoginPwd(newPwdId1);
                userService.getUserInfoDAO().saveOrUpdate(userInfo);
                return SUCCESS;
            } else
                addFieldError("userpwd", "原始密码不正确，请重新输入");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ERROR;
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public LogService getLogService() {
        return logService;
    }

    public void setLogService(LogService logService) {
        this.logService = logService;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public void setPsw(String psw) {
        this.psw = psw;
    }

    public byte getFlag() {
        return flag;
    }
}
