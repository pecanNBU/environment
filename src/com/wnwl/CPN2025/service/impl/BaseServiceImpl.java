package com.wnwl.CPN2025.service.impl;

import com.wnwl.CPN2025.hdao.BaseDAO;
import com.wnwl.CPN2025.service.BaseService;
import com.wnwl.CPN2025.util.PageBean;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class BaseServiceImpl<T, ID extends Serializable> implements BaseService<T, ID> {
    private BaseDAO<T, ID> baseDAO;

    public void setBaseDAO(BaseDAO<T, ID> baseDAO) {
        this.baseDAO = baseDAO;
    }

    @Override
    public ID save(T entity) {
        return baseDAO.save(entity);
    }

    @Override
    public void save(String sql) {
        baseDAO.save(sql);
    }

    @Override
    public void saveBatch(int arg0, String[] strs, String sql) {
        baseDAO.saveBatch(arg0, strs, sql);
    }

    @Override
    public void saveBatch(int arg0, int arg1, String sql, String[] strs) {
        baseDAO.saveBatch(arg0, arg1, sql, strs);
    }

    @Override
    public void saveBatch(int arg0, List ids, String sql) {
        baseDAO.saveBatch(arg0, ids, sql);
    }

    @Override
    public void saveOrUpdate(T entity) {
        baseDAO.saveOrUpdate(entity);
    }

    @Override
    public void updateBatch(String hsql) {
        baseDAO.updateBatch(hsql);
    }

    @Override
    public void updateBatch(List<String> hsqls) {
        baseDAO.updateBatch(hsqls);
    }

    @Override
    public void entityBatchs(List<Object> entitys) {
        baseDAO.entityBatchs(entitys);
    }

    @Override
    public void remove(T entity) {
        baseDAO.remove(entity);
    }

    @Override
    public void removeAll(Collection<T> entities) {
        baseDAO.removeAll(entities);
    }

    @Override
    public void remove(int id) {
        baseDAO.remove(id);
    }

    @Override
    public void removes(String[] ts) {
        baseDAO.removes(ts);
    }

    @Override
    public void removes(String sql) {
        baseDAO.removes(sql);
    }

    @Override
    public T findById(Integer id) {
        return baseDAO.findById(id);
    }

    @Override
    public T findFirstObject(String hql) {
        return baseDAO.findFirstObject(hql);
    }

    public T findFirstObject(String hql, String sql) {
        return baseDAO.findFirstObject(hql, sql);
    }

    @Override
    public List<T> findSelfObjects(String cond) {
        return baseDAO.findSelfObjects(cond);
    }

    @Override
    public List<T> findAnyObjects(String hql) {
        return baseDAO.findAnyObjects(hql);
    }

    @Override
    public List findUnknowCombine(String hql) {
        return baseDAO.findUnknowCombine(hql);
    }

    @Override
    public List findSql(String sql) {
        return baseDAO.findSql(sql);
    }

    @Override
    public List findSqlByPage(Integer pageSize, Integer jumpSize, String sql) {
        return baseDAO.findSqlByPage(pageSize, jumpSize, sql);
    }

    @Override
    public Long getTotalCount(PageBean p, String[] str, Object[] ob2)
            throws Exception {
        return baseDAO.getTotalCount(p, str, ob2);
    }

    @Override
    public Long getTotalCount() {
        return baseDAO.getTotalCount();
    }

    @Override
    public Long getCountbyCond(String cond) {
        return baseDAO.getCountbyCond(cond);
    }

    public Long getCountbyHql(String hql) {
        return baseDAO.getCountbyHql(hql);
    }

    public Long getCountbySql(String sql) {
        return baseDAO.getCountbySql(sql);
    }

    @Override
    public List<T> findAll() {
        return baseDAO.findAll();
    }

    @Override
    public List<T> getList(int page, int rows) {
        return baseDAO.getList(page, rows);
    }

    @Override
    public List<T> getList(int page, int rows, String cond) {
        return baseDAO.getList(page == 0 ? 1 : page, rows == 0 ? 50 : rows, cond);
    }

    public List<T> getListByHql(final int page, final int rows, final String hql) {
        return baseDAO.getListByHql(page == 0 ? 1 : page, rows == 0 ? 50 : rows, hql);
    }

    @Override
    public List getList(PageBean page) {
        return baseDAO.getList(page);
    }

    @Override
    public List<T> getList(PageBean p, String cond) {
        return baseDAO.getList(p, cond);
    }

    public List<T> getAnyList(final PageBean p, final String hsql) {
        return baseDAO.getAnyList(p, hsql);
    }

    @Override
    public List getList(PageBean page, String[] str, Object[] ob2)
            throws Exception {
        return baseDAO.getList(page, str, ob2);
    }

    @Override
    public List getByQuery(String sql) {
        return baseDAO.getByQuery(sql);
    }

    /* (non-Javadoc)
     * <P> Title: getEntityId</P>
     * <P> Description: </P>
     * @param hql
     * @return
     * @see com.tds.service.TDSService#getEntityId(java.lang.String)
     */
    @Override
    public Integer getEntityId(String hql) {
        return baseDAO.getEntityId(hql);
    }

    /* (non-Javadoc)
     * <P> Title: getEntityIdL</P>
     * <P> Description: </P>
     * @param hql
     * @return
     * @see com.tds.service.TDSService#getEntityIdL(java.lang.String)
     */
    @Override
    public Long getEntityIdL(String hql) {
        return baseDAO.getEntityIdL(hql);
    }

    /* (non-Javadoc)
     * <P> Title: getPropertyBySql</P>
     * <P> Description: </P>
     * @param page
     * @param rows
     * @param sql
     * @return
     * @see com.tds.service.TDSService#getPropertyBySql(java.lang.String, java.lang.String, java.lang.String)
     */
    @Override
    public List getListBySql(int page, int rows, String sql) {
        // TODO Auto-generated method stub
        return baseDAO.getListBySql(page == 0 ? 1 : page, rows == 0 ? 50 : rows, sql);
    }

    /* (non-Javadoc)
     * <P> Title: insertEntityBySql</P>
     * <P> Description: </P>
     * @param sql
     * @return
     * @see com.tds.service.TDSService#insertEntityBySql(java.lang.String)
     */
    @Override
    public long insertEntityBySql(String sql) {
        // TODO Auto-generated method stub
        return baseDAO.insertEntityBySql(sql);
    }

    /* (non-Javadoc)
     * <P> Title: removeWLH</P>
     * <P> Description: </P>
     * @param sql
     * @return
     * @see com.tds.service.TDSService#removeWLH(java.lang.String)
     */
    @Override
    public int removeWLH(String sql) {
        return baseDAO.removeswlh(sql);
    }

    /* (non-Javadoc)
     * <P> Title: updateBySql</P>
     * <P> Description: </P>
     * @param sql
     * @return
     * @see com.tds.service.TDSService#updateBySql(java.lang.String)
     */
    @Override
    public int updateBySql(String sql) {
        return baseDAO.updateBySql(sql);
    }

    public byte findNodeStatebyUrl(Integer actorId, String url) {
        return baseDAO.findNodeStatebyUrl(actorId, url);
    }

    public T findLastObject() {
        return baseDAO.findLastObject();
    }

    public Integer findLastId() {
        return baseDAO.findLastId();
    }

    public List<T> findAllbyDep(Integer depId) {
        return baseDAO.findAllbyDep(depId);
    }

    public List<T> castQueryBySql(final String sql, final T t) {
        return baseDAO.castQueryBySql(sql, t);
    }
}
