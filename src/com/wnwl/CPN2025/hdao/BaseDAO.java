package com.wnwl.CPN2025.hdao;

import com.wnwl.CPN2025.util.PageBean;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.List;

/**
 * @param <T>:  generalized entity class
 * @param <ID>: data type of primary key
 * @ClassName: BaseDao
 * @Description: interface of all required methods for other dao interfaces
 * @author: 198910310@qq.com
 * @date 2011-7-9上午8:07:32
 */
public interface BaseDAO<T, ID extends Serializable> {
    /**
     * @return HQL
     */
    String getHql();

    /**
     * @param HQL the HQL to set
     */
    void setHql(String hql);

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

    void saveBatch(final int arg0, final Timestamp stdt, final List ids, final String sql);

    void saveBatch(final String sql, final float strs[], final List<Integer> list, final int start, final int len);

    void saveBatch(final int arg11, final String query, final String sql, final boolean strs[], final int start, int len);

    void saveBatch(final int arg1, final String query, final String sql, final short strs[], final int start, final int len);

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

    void updateBatch(final List<String> sqls);

    void entityBatchs(final List<Object> entitys);

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
     * @param ts: primary keys' array
     * @return int
     * @throws
     * @Title: removesWLHArr
     * @Description: bulk delete entities with id is in ts
     */
    int removesWLHArr(String ts, Class cla);

    /**
     * @param sql:delete sql
     * @return void
     * @throws
     * @Title: removes
     * @Description: delete a or some record(s) with sql
     */
    void removes(String sql);

    /**
     * @param sql:delete sql
     * @return void
     * @throws
     * @Title: removesWLH
     * @Description: delete a or some record(s) with sql
     */
    int removeWLH(String sql);

    /**
     * @param sql:delete sql
     * @return int
     * @throws
     * @Title: removeswlh
     * @Description: delete a or some record(s) with sql
     */
    int removeswlh(String sql);

    //update通过sql语句
    int updateBySql(String sql);

    /**
     * @param id
     * @return T
     * @throws
     * @Title: TDSDao
     * @Description: find a entity by key
     */
    T findById(Integer id);

    /**
     * @param hql
     * @return T
     * @throws
     * @Title: TDSDao
     * @Description: find a entity by HQL
     */
    T findFirstObject(String hql);

    T findFirstObject(String hql, String sql);

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
     * @param hql
     * @return List
     * @throws
     * @Title: finSqlByPage
     * @Description: find records's num with hql
     */
    List findSqlByPage(Integer pageSize, Integer jump, String sql);

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

    List<T> getListByHql(final int i, final int j, final String hql);

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

    List<T> getBySqlQuery(final String sql);

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
     * @return int
     * @throws
     * @Title: getEntityId
     * @Description: pages show style
     */
    //public int getEntityByCriteria(Class cla,String sql);
    Integer getEntityId(String hql);

    Long getEntityIdL(String hql);

    /**
     * 插入相应的属性值 sql语句
     */
    long insertEntityBySql(String sql);

    List getListBySql(int page, int rows, String sql);

    byte findNodeStatebyUrl(Integer actorId, String url);

    T findLastObject();

    Integer findLastId();

    List<T> findAllbyDep(Integer depId);

    List<T> castQueryBySql(final String sql, final T t);
}