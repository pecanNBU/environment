package com.wnwl.CPN2025.acegi;

import com.wnwl.CPN2025.bhh.PrivActor;
import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.service.UserService;
import org.acegisecurity.GrantedAuthority;
import org.acegisecurity.GrantedAuthorityImpl;
import org.acegisecurity.userdetails.UserDetails;
import org.acegisecurity.userdetails.UserDetailsService;
import org.acegisecurity.userdetails.UsernameNotFoundException;
import org.springframework.dao.DataAccessException;

import java.util.ArrayList;
import java.util.List;

public class AcegiUserDeitailsService implements UserDetailsService {

    /* 依赖注入 */
    private UserService userService;
    private String loginName;

    /* 用户所有的权限 */
//private final List<GrantedAuthority> grantedAuthList = new ArrayList<GrantedAuthority>(6); 
    private GrantedAuthority[] grantedAuthArray;

    /**
     * 实现接口UserDetailsService的函数，根据用户名获取UserDetails对象
     */
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException, DataAccessException {

    /* 取得用户 */
        UserInfo user = userService.findUserByLogin(userName);
        if (user == null)
            throw new UsernameNotFoundException("User name is not found.");

    /* 取得所有用户权限 */
        List<PrivActor> userRoleList = userService.getPrivActor(user.getId());
        List<PrivActor> roles = new ArrayList<PrivActor>(0);
        if (userRoleList == null || userRoleList.size() == 0) {
            PrivActor e = new PrivActor();
            e.setName("ROLE_A");
            roles.add(e);
        } else
            roles.addAll(userRoleList);
    /* 取得用户的所有角色 */
        int size = userRoleList.size();
        grantedAuthArray = new GrantedAuthority[size];
        int j = 0;
        for (int i = 0; i < size; i++) {
            PrivActor userRole = roles.get(i);
            if (userRole != null) {
                this.grantedAuthArray[j++] = new GrantedAuthorityImpl(userRole.getName().toUpperCase());
            }
        }

        return new org.acegisecurity.userdetails.User(userName, user.getLoginPwd(),
                true, true, true, true, this.grantedAuthArray);
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }
}