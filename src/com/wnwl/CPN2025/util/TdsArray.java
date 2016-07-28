package com.wnwl.CPN2025.util;
/**
 * @Title: TdsArray.java
 * @Package: com.tds.util
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2011-8-26上午8:16:22
 * @version V1.0
 */

import java.util.ArrayList;
import java.util.List;
import java.util.Set;


/**
 * @ClassName: TdsArray
 * @Description: TODO
 * @author: 198910310@qq.com
 * @date 2011-8-26上午8:16:22
 */
public class TdsArray implements java.io.Serializable {
    private static final long serialVersionUID = -7262812145217951352L;
    private Integer id;
    private String tname;
    private Byte isLeaf;

    public TdsArray() {

    }

    public List seriallist(int pages, int pagesize, Set setlist) {
        List list1 = new ArrayList();
        List list2 = new ArrayList();
        list1.addAll(setlist);
        int total = list1.size();
        int j = (pages - 1) * pagesize;
        pagesize = total - pages * pagesize < 0 ? total - (pages - 1) * pagesize : pagesize;
        for (int i = j; i < j + pagesize; i++)
            list2.add(list1.get(i));
        return list2;
    }

    public List seriallist(int pages, int pagesize, List setlist) {
        List list1 = setlist;
        List list2 = new ArrayList();
        //list1.addAll(setlist);
        int total = list1.size();
        int j = (pages - 1) * pagesize;
        pagesize = total - pages * pagesize < 0 ? total - (pages - 1) * pagesize : pagesize;
        for (int i = j; i < j + pagesize; i++)
            list2.add(list1.get(i));
        return list2;
    }

    /**
     * @return the id
     */
    public Integer getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * @return the tname
     */
    public String getTname() {
        return tname;
    }

    /**
     * @param tname the tname to set
     */
    public void setTname(String tname) {
        this.tname = tname;
    }

    /**
     * @return the isLeaf
     */
    public Byte getIsLeaf() {
        return isLeaf;
    }

    /**
     * @param isLeaf the isLeaf to set
     */
    public void setIsLeaf(Byte isLeaf) {
        this.isLeaf = isLeaf;
    }
}
