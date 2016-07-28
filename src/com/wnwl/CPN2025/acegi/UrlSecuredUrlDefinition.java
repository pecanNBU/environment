package com.wnwl.CPN2025.acegi;

import com.wnwl.CPN2025.service.SystemService;
import org.acegisecurity.ConfigAttributeDefinition;
import org.acegisecurity.SecurityConfig;

import java.util.LinkedList;
import java.util.List;

/**
 * @author sunjie
 * @since 2009-6-9
 */
public class UrlSecuredUrlDefinition {

    private static List<UrlEntryHolder> urlEHs;
    private SystemService systemService;

    /**
     * 得到所有URL资源保护配置。
     *
     * @return
     */
    public List<UrlEntryHolder> getAllUrlEntryHolder() {
        if (urlEHs == null || urlEHs.size() == 0) {
            reload();
        }
        return urlEHs;
    }

    public synchronized void reload() {            //角色添加用户、更新角色-模块：更新此列表
        urlEHs = new LinkedList<UrlEntryHolder>();
        String sql = "SELECT a.id,a.url,c.name FROM (SELECT id,url FROM tree_node WHERE url<>'' ORDER BY id) a " +
                "JOIN priv_actor_node b ON b.node_id=a.id JOIN priv_actor c ON c.id=b.actor_id";
        List list = systemService.findSql(sql);        //获取登录用户对应的模块以及对应的权限
        Object[] values;
        int id1, id2 = 0;
        String roleName, roleUrl;
        ConfigAttributeDefinition cad = new ConfigAttributeDefinition();
        UrlEntryHolder urlEH = new UrlEntryHolder();
        for (int i = 0; i < list.size(); i++) {
            values = (Object[]) (list.get(i));
            if (values[2] == null || values[2].toString().length() < 6 || !"ROLE_".equals(values[2].toString().substring(0, 5)))
                continue;
            else {
                id1 = Integer.parseInt(values[0].toString());
                roleUrl = values[1] != null ? values[1].toString() : "";
                roleUrl = roleUrl.substring(0, 2).equals("..") ? roleUrl.substring(2, roleUrl.length()) : roleUrl;
                roleName = values[2] != null ? values[2].toString() : "";
                if (id1 != id2)
                    cad = new ConfigAttributeDefinition();
                cad.addConfigAttribute(new SecurityConfig(roleName));
                id2 = id1;
                urlEH = new UrlEntryHolder();
                urlEH.setCad(cad);
                urlEH.setUrl(roleUrl);
                urlEHs.add(urlEH);
            }
        }
    }

    public SystemService getSystemService() {
        return systemService;
    }

    public void setSystemService(SystemService systemService) {
        this.systemService = systemService;
    }
}