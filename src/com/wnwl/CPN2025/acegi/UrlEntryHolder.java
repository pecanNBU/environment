package com.wnwl.CPN2025.acegi;

import org.acegisecurity.ConfigAttributeDefinition;

import java.io.Serializable;

/**
 * 存放URL与对应角色集合的实体类
 *
 * @author sunjie
 * @since 2009-6-9
 */
public class UrlEntryHolder implements Serializable {

    private static final long serialVersionUID = 2317309106087370323L;

    /**
     * 保护的URL模式
     */
    private String url;

    /**
     * 要求的角色集合
     */
    private ConfigAttributeDefinition cad;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public ConfigAttributeDefinition getCad() {
        return cad;
    }

    public void setCad(ConfigAttributeDefinition cad) {
        this.cad = cad;
    }

}
