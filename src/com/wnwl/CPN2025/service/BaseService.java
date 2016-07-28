package com.wnwl.CPN2025.service;

import com.wnwl.CPN2025.util.PageBean;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

/**
 * Simple to Introduction
 *
 * @ProjectName: 建设工程颗粒物与噪声在线监测系统
 * @Package: com.wnwl.CPN2025.service
 * @ClassName: 数据库操作接口
 * @Description: 增删改查
 * @Author: Jenny
 * @CreateDate: 2016.7.18
 * @UpdateUser:
 * @UpdateDate:
 * @UpdateRemark:
 * @Version: V1.0
 */
public interface BaseService<T, ID extends Serializable> {

    /**
     * @param entity: a object of T
     * @return ID:primary key of entity
     * @throws
     * @Title: save
     * @Description: save entity
     */
    ID save(T entity);

    /**
     * @param hsql:sql statement for save
     * @return hsql: a insert sql statement
     * @throws
     * @Title: save
     * @Description: save entity with
     */
    void save(final String sql);

    /**
     * @param arg0: first arg in sql
     * @param strs: second args in sql which in a  String array
     * @param sql:  insert sql for batch save
     * @throws
     * @Title: saveBatch
     * @Description: batch save entity with insert sql
     */
    void saveBatch(final int arg0, final String[] strs, final String sql);

    /**
     * @param arg0:first arg in sql
     * @param strs:      third args in sql which in a  String array
     * @param sql:       insert sql for batch save
     * @return arg1:second arg in sql
     * @throws
     * @Title: saveBatch
     * @Description: batch save entity with insert sql
     */
    void saveBatch(final int arg0, final int arg1, final String sql, final String strs[]);

    /**
     * @param arg0:first arg in sql
     * @param ids:       primary keys' in a list
     * @param sql:       insert sql for batch save
     * @throws
     * @Title: saveBatch
     * @Description: batch save entity with insert sql
     */
    void saveBatch(final int arg0, final List ids, final String sql);

    /**
     * @param entity: a object of T
     * @return void
     * @throws
     * @Title: saveOrUpdate
     * @Description: save entity if entity not exists or update entity
     */
    void saveOrUpdate(T entity);

    /**
     * @param entity
     * @return sql: update information for upate
     * @throws
     * @Title: updateBatch
     * @Description: update with a sql
     */
    void updateBatch(final String sql);

    void updateBatch(List<String> hsql);

    void entityBatchs(List<Object> entitys);

    void remove(T entity);

    /**
     * @param entities: a entity set
     * @return void
     * @throws
     * @Title: removeAll
     * @Description: bulk delete entities which belong to a collection
     */
    void removeAll(Collection<T> entities);

    /**
     * @param id: primary key
     * @return void
     * @throws
     * @Title: remove
     * @Description: delete entity with id
     */
    void remove(int id);

    /**
     * @param ts: primary keys' array
     * @return void
     * @throws
     * @Title: removes
     * @Description: bulk delete entities with id is in ts
     */
    void removes(String[] ts);

    /**
     * @param sql:delete sql
     * @return void
     * @throws
     * @Title: removes
     * @Description: delete a or some record(s) with sql
     */
    void removes(String sql);

    /**
     * @param id
     * @return T
     * @throws
     * @Title: TDSDao
     * @Description: find a entity by key
     */
    T findById(Integer addr);

    /**
     * @param hql
     * @return T
     * @throws
     * @Title: TDSDao
     * @Description: find a entity by HQL
     */
    T findFirstObject(String hql, String sql);

    T findFirstObject(String hql);

    /**
     * @param cond: where condition for hql
     * @return List<T>
     * @throws
     * @Title: findSelfObjects
     * @Description: find list self entities by HQL which use self dao
     */
    List<T> findSelfObjects(String cond);

    /**
     * @param hql
     * @return List<T>
     * @throws
     * @Title: findAnyObjects
     * @Description: find list entities by HQL which use any dao
     */
    List<T> findAnyObjects(String hql);

    /**
     * @param hql
     * @return List
     * @throws
     * @Title: findUnknowCombine
     * @Description: find any properties combine
     */
    @SuppressWarnings("rawtypes")
    List findUnknowCombine(String hql);

    List findSql(String sql);

    /**
     * @param p
     * @param str
     * @param ob2
     * @return Long
     * @throws Exception
     * @Title: getTotalCount
     * @Description: get total count with parameters for calculating page number
     */
    Long getTotalCount(PageBean p, String str[], Object ob2[])
            throws Exception;

    /**
     * @param page
     * @return Long
     * @throws Exception
     * @Title: getTotalCount
     * @Description: get total count with no parameters for calculating page number
     */
    Long getTotalCount();

    Long getCountbyCond(String cond);

    Long getCountbyHql(String hql);

    Long getCountbySql(String sql);

    /**
     * @return List<T>
     * @throws
     * @Title: findAll
     * @Description: find all self objects
     */
    List<T> findAll();

    /**
     * @param page
     * @return List
     * @throws
     * @Title: getList
     * @Description: find list pagebeans with no parameters which have entities info
     */
    List<T> getList(final int page, final int rows);

    /**
     * @param page
     * @return List
     * @throws
     * @Title: getList
     * @Description: find list T with no parameters which have entities info
     */
    List<T> getList(final int page, final int rows, final String cond);

    List<T> getListByHql(final int page, final int rows, final String hql);

    List getListBySql(final int page, final int rows, final String sql);

    /**
     * @param page
     * @return List
     * @throws
     * @Title: getList
     * @Description: find list pagebeans with no parameters which have entities info
     */
    @SuppressWarnings("rawtypes")
    List<T> getList(PageBean page);

    /**
     * @param page
     * @return List
     * @throws
     * @Title: getList
     * @Description: find list pagebeans with no parameters which have entities info
     */
    List<T> getList(final PageBean p, final String cond);

    /**
     * @param page
     * @return List
     * @throws
     * @Title: getList
     * @Description: find list pagebeans with no parameters which have entities info
     */
    List<T> getAnyList(final PageBean p, final String hsql);

    /**
     * @param page
     * @param str
     * @param ob2
     * @return List
     * @throws Exception
     * @Title: getList
     * @Description: find list pagebeans with  parameters which have entities info
     */
    @SuppressWarnings("rawtypes")
    List<T> getList(PageBean page, String str[], Object ob2[]) throws Exception;

    /**
     * @param entity
     * @return ID
     * @throws
     * @Title: TDSDao
     * @Description: save entity with
     */
    List<T> getByQuery(final String sql);

    /**
     * @param page
     * @return Integer
     * @throws
     * @Title: getEntityId
     * @Description: pages show style
     */
    Integer getEntityId(String hql);

    Long getEntityIdL(String hql);

    long insertEntityBySql(String sql);

    int removeWLH(String sql);

    /**
     * @param jumpPage
     * @param pageSize
     * @param purl
     * @return Page
     * @throws Exception
     * @Title: TDSService
     * @Description: get basic info of pages
     */
    List findSqlByPage(Integer pageSize, Integer jumpSize, String sql);

    int updateBySql(String sql);

    byte findNodeStatebyUrl(Integer actorId, String url);

    T findLastObject();        //获取最后条数据

    Integer findLastId();    //获取最后条数据的id

    List<T> findAllbyDep(Integer depId);    //获取该单位的所有数据

    List<T> castQueryBySql(final String sql, final T t);
}
