package com.wnwl.CPN2025.acegi;

import com.wnwl.CPN2025.bhh.UserInfo;
import com.wnwl.CPN2025.service.UserService;
import org.acegisecurity.Authentication;
import org.acegisecurity.context.SecurityContext;
import org.acegisecurity.context.SecurityContextHolder;
import org.acegisecurity.userdetails.UserDetails;

public class CurrentUser {
    private static UserService userService;

    public static UserInfo getUser() {

        //if not in unit test environment, get the current user using acegi
        if ((SecurityContextHolder.getContext() == null)
                || !(SecurityContextHolder.getContext() instanceof SecurityContext)

                || (SecurityContextHolder.getContext()

                .getAuthentication() == null)) {

            return null;

        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth.getPrincipal() == null) {

            return null;

        }

        UserInfo user = null;

        UserDetails ud = (UserDetails) auth.getPrincipal();
        String loginName = ud.getUsername();
        if (null != loginName) {

            user = userService.findUserByLogin(loginName);

        }

        return user;

    }

    public static UserService getUserService() {
        return userService;
    }

    public static void setUserService(UserService userService) {
        CurrentUser.userService = userService;
    }
}
