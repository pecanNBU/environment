/**
 * @Title: AuthenticationManager.java
 * @Package: com.tds.yz
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2012-4-7下午4:04:49
 * @version V1.0
 */
package com.wnwl.CPN2025.yz;

import org.acegisecurity.Authentication;
import org.acegisecurity.AuthenticationException;

/**
 * @ClassName: AuthenticationManager
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2012-4-7下午4:04:49
 */
public interface AuthenticationManager {
    Authentication authenticate(Authentication authentication)
            throws AuthenticationException;
}
