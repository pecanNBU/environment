package com.wnwl.CPN2025.hdao.impl;

import com.wnwl.CPN2025.bhh.DType;
import com.wnwl.CPN2025.hdao.BaseDAO;
import com.wnwl.CPN2025.util.PageBean;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;

import java.io.Serializable;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

/**
 * @param <T>
 * @param <ID>
 * @ClassName: BaseDaoImpl
 * @Description: Implements BaseDao for other dao implement class
 * @author: 198910310@qq.com
 * @date 2011-7-9上午8:33:42
 */
public class BaseDAOImpl<T, ID extends Serializable> implements BaseDAO<T, ID> {
    public HibernateTemplate hibernateTemplate;
    private Class<T> type;
    private String hql;
    private Log log = LogFactory.getLog(this.getClass());

    public BaseDAOImpl(Class<T> type) {
        this.type = type;
        this.hql = "from " + type.getName();
    }

    public HibernateTemplate getHibernateTemplate() {
        return hibernateTemplate;
    }

    public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
        this.hibernateTemplate = hibernateTemplate;
    }

    @Override
    public String getHql() {
        return hql;
    }

    @Override
    public void setHql(String hql) {
        this.hql = hql;
    }

    @SuppressWarnings("unchecked")
    @Override
    public ID save(T entity) {
        ID id = null;
        try {
            id = (ID) hibernateTemplate.save(entity);
            hibernateTemplate.flush();
        } catch (Exception e) {
            log.error("出错");//System.err.println(e);
        }
        return id;
    }

    public void saves(Set entities) {
        hibernateTemplate.saveOrUpdateAll(entities);
        hibernateTemplate.flush();
    }

    @Override
    @SuppressWarnings({"unchecked", "rawtypes"})
    public void save(final String sql) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    preparedStatement.addBatch();
                    preparedStatement.executeBatch();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }

    public List findSql(final String sql) {
        List list = getHibernateTemplate().executeFind(new HibernateCallback() {
            @Override
            public Object doInHibernate(Session session)
                    throws HibernateException, SQLException {
                List catNameList = session.createSQLQuery(sql).list();
                return catNameList;
            }
        });
        return list;
    }

    public List findSqlByPage(final Integer pageSize, final Integer jump, final String sql) {
        List list = getHibernateTemplate().executeFind(new HibernateCallback() {
            @Override
            public Object doInHibernate(Session session)
                    throws HibernateException, SQLException {
                List catNameList = session.createSQLQuery(sql)
                        .setFirstResult((jump - 1) * pageSize).setMaxResults(pageSize).list();
                return catNameList;
            }

        });
        return list;
    }

    @Override
    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg0, final String strs[], final String sql) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    for (int i = 0; i < strs.length; i++) {
                        preparedStatement.setInt(1, arg0);
                        preparedStatement.setInt(2, Integer.parseInt(strs[i]));
                        preparedStatement.addBatch();
                    }
                    preparedStatement.executeBatch();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }

    @Override
    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg0, final int arg1, final String sql, final String strs[]) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    for (String s : strs) {
                        preparedStatement.setInt(1, arg0);
                        preparedStatement.setInt(2, arg1);
                        preparedStatement.setInt(3, Integer.parseInt(s.trim()));
                        preparedStatement.addBatch();
                    }
                    preparedStatement.executeBatch();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }

    @Override
    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg0, final List ids, final String sql) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    for (int i = 0; i < ids.size(); i++) {
                        preparedStatement.setInt(1, arg0);
                        preparedStatement.setInt(2, (Integer) ids.get(i));
                        preparedStatement.addBatch();
                    }
                    preparedStatement.executeBatch();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }

    @Override
    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg0, final Timestamp stdt, final List ids, final String sql) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    for (int i = 0; i < ids.size(); i++) {
                        preparedStatement.setInt(1, arg0);
                        preparedStatement.setInt(2, (Integer) ids.get(i));
                        preparedStatement.setTimestamp(3, stdt);
                        preparedStatement.addBatch();
                    }
                    preparedStatement.executeBatch();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final String sql, final float strs[], final List<Integer> list, final int start, final int len) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                @SuppressWarnings("deprecation")
                Connection connection = session.connection();
                try {
                    int i = start;
                    PreparedStatement preparedStatement2 = connection.prepareStatement(sql);
                    Date date = new Date();
                    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Timestamp ts = Timestamp.valueOf(sdf2.format(date));
                    int j;
                    for (j = 0; j < len; j++) {
                        preparedStatement2.setInt(1, i);
                        preparedStatement2.setInt(2, list.get(j).intValue());
                        preparedStatement2.setString(3, Float.toString(strs[j]).trim());
                        preparedStatement2.setTimestamp(4, ts);
                        preparedStatement2.addBatch();
                        i++;
                    }
                    preparedStatement2.executeBatch();
                    preparedStatement2.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    System.out.println(e);
                }
                return null;
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg1, final String query, final String sql, final boolean strs[], final int start, final int len) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                @SuppressWarnings("deprecation")
                Connection connection = session.connection();
                try {
                    int i = start;
                    PreparedStatement preparedStatement1 = connection.prepareStatement(query);
                    PreparedStatement preparedStatement2 = connection.prepareStatement(sql);
                    ResultSet rs = null;
                    int j;
                    for (j = 0; j < len; j++) {
                        rs = null;
                        preparedStatement1.setInt(1, i);
                        //preparedStatement1.setString(2, Short.toString(strs[j]).trim());
                        rs = preparedStatement1.executeQuery();
                        if (!rs.next() || !rs.getString(3).equals(translate(strs[j]).trim())) {
                            preparedStatement2.setInt(1, i);
                            preparedStatement2.setInt(2, arg1);
                            preparedStatement2.setString(3, translate(strs[j]).trim());
                            preparedStatement2.addBatch();
                        }
                        i++;
                    }
                    rs.close();
                    preparedStatement1.close();
                    preparedStatement2.executeBatch();
                    preparedStatement2.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    System.out.println(e);
                }
                return null;
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public void saveBatch(final int arg1, final String query, final String sql, final short strs[], final int start, final int len) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                @SuppressWarnings("deprecation")
                Connection connection = session.connection();
                try {
                    int i = start;
                    PreparedStatement preparedStatement1 = connection.prepareStatement(query);
                    PreparedStatement preparedStatement2 = connection.prepareStatement(sql);
                    ResultSet rs = null;
                    int j;
                    for (j = 0; j < len; j++) {
                        rs = null;
                        preparedStatement1.setInt(1, i);
                        //preparedStatement1.setString(2, Short.toString(strs[j]).trim());
                        rs = preparedStatement1.executeQuery();
                        if (!rs.next() || !rs.getString(3).equals(Short.toString(strs[j]).trim())) {
                            preparedStatement2.setInt(1, i);
                            preparedStatement2.setInt(2, arg1);
                            preparedStatement2.setString(3, Short.toString(strs[j]).trim());
                            preparedStatement2.addBatch();
                        }
                        i++;
                    }
                    rs.close();
                    preparedStatement1.close();
                    preparedStatement2.executeBatch();
                    preparedStatement2.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    System.out.println(e);
                }
                return null;
            }
        });
    }

    private String translate(boolean x) {
        if (x == true)
            return "1";
        else
            return "0";
    }

    @Override
    public void saveOrUpdate(T entity) {
        hibernateTemplate.saveOrUpdate(entity);
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public void updateBatch(final String sql) {
        hibernateTemplate.execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    preparedStatement.executeUpdate();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    System.out.println(e);
                    //log.error("出错");//System.out.println(e);
                }
                return null;
            }
        });
    }


    @SuppressWarnings("unchecked")
    public List<T> castQueryBySql(final String sql, final T t) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                Query q = session.createSQLQuery(sql).addEntity(t.getClass());
                return q.list();
            }
        });
    }

    public void updateBatch(final List<String> sqls) {//批量处理sql insert、update、delete
        Session session = hibernateTemplate.getSessionFactory().openSession();
        session.beginTransaction();
        Transaction tx = session.beginTransaction();
        try {
            Statement state = session.connection().createStatement();
            for (int i = 0; i < sqls.size(); i++) {
                //list里add()多个你要新增的数据库对象，这样多个对象1次commit操作，有一个对象出错，之前的操作都会回滚
                //session.saveOrUpdate(sqls.get(i));
                // state.execute(sqls.get(i));
                state.executeUpdate(sqls.get(i));
            }
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            log.error("出错");// e.printStackTrace();
        } finally {
            session.flush();
            session.close();
        }
    }


    public void entityBatchs(final List<Object> entitys) {//批量处理实体
        Session session = hibernateTemplate.getSessionFactory().openSession();
        //session.evict(arg0);
        //session.beginTransaction();
        Transaction tx = session.beginTransaction();
        try {
            for (int i = 0; i < entitys.size(); i++) {
                //list里add()多个你要新增的数据库对象，这样多个对象1次commit操作，有一个对象出错，之前的操作都会回滚
                session.merge(entitys.get(i));
            }
            session.beginTransaction().commit();
            session.flush();
        } catch (Exception e) {
            tx.rollback();
            log.error("出错");// e.printStackTrace();
        } finally {
            session.close();
        }
    }

    @Override
    public void remove(T entity) {
        hibernateTemplate.delete(entity);
    }

    @Override
    public void removeAll(Collection<T> entities) {
        try {
            hibernateTemplate.deleteAll(entities);
            hibernateTemplate.flush();
        } catch (Exception e) {
            log.error("出错");//System.out.println(e);
        }
    }

    @Override
    public void remove(int id) {
        hibernateTemplate.delete(this.findById(id));
        hibernateTemplate.flush();
    }

    @Override
    public void removes(String[] ts) {
        Collection<T> rs = new HashSet<T>();
        for (String t : ts) {
            rs.add(this.findById(Integer.parseInt(t.trim())));
        }
        this.removeAll(rs);
    }

    public int removesWLHArr(String ts, Class cla) {
        Session session = hibernateTemplate.getSessionFactory().openSession();
        session.beginTransaction();
        int flag = session.createQuery("delete from " + cla.getName() + " where id in (" + ts + ")").executeUpdate();
        session.flush();
        session.getTransaction().commit();
        session.close();
        return flag;
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public void removes(final String sql) {
        this.getHibernateTemplate().execute(new HibernateCallback() {
            public Object doInHibernate(Session session) throws HibernateException {
                Connection connection = session.connection();
                try {
                    PreparedStatement preparedStatement = connection.prepareStatement(sql);
                    preparedStatement.executeUpdate();
                    preparedStatement.close();
                    session.flush();
                    session.close();
                    connection.close();
                } catch (SQLException e) {
                    log.error("出错");//System.out.println(e);
                }
                return null;
            }

        });
    }

    public int removeswlh(String sql) {
        Session session = hibernateTemplate.getSessionFactory().openSession();
        session.beginTransaction();
        int flag = session.createQuery(sql).executeUpdate();
        session.flush();
        session.getTransaction().commit();
        session.close();
        return flag;
    }

    @Override
    public T findById(Integer id) {
        return hibernateTemplate.get(type, id);
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> findAll() {
        String hql = "from " + type.getName();
        return (List<T>) hibernateTemplate.find(hql);
    }

    @SuppressWarnings("unchecked")
    @Override
    public T findFirstObject(String hql) {
        List<T> lt = hibernateTemplate.find(hql);
        if (null == lt || lt.size() == 0)
            return null;
        else
            return lt.get(0);
    }

    public T findFirstObject(final String hql, final String sql1) {
        List list = getHibernateTemplate().executeFind(new HibernateCallback() {
            @Override
            public Object doInHibernate(Session session)
                    throws HibernateException, SQLException {
                String hql1 = hql + ":typeName ";
                DType cus = new DType();
                cus.setTypeName(sql1);
                List<T> returnList = session.createQuery(hql1).setProperties(cus).list();
                return returnList;
            }
        });
        return (T) list.get(0);
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    @Override
    public List<T> findSelfObjects(final String cond) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                try {
                    String hqls = "from " + type.getName() + " where " + cond;
                    return (List<T>) hibernateTemplate.find(hqls);
                } catch (Exception e) {
                    log.error("出错");//e.printStackTrace();
                    return null;
                }
            }
        });
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<T> findAnyObjects(final String hql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                try {
                    return (List<T>) hibernateTemplate.find(hql);
                } catch (Exception e) {
                    log.error("出错");//e.printStackTrace();
                    return null;
                }
            }
        });
        /*List<T> listt=hibernateTemplate.find(hql);
        if(listt.size()==0 || null==listt)
			return null;
		else
			return listt;*/
    }

    @SuppressWarnings({"rawtypes"})
    @Override
    public List findUnknowCombine(final String hql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                try {
                    return hibernateTemplate.find(hql);
                } catch (Exception e) {
                    log.error("出错");//e.printStackTrace();
                    return null;
                }
            }
        });
        //return (List) hibernateTemplate.find(hql);
    }

    @Override
    public Long getTotalCount() {
        String hsql = "select count(*) from " + type.getName();
        List list = getHibernateTemplate().find(hsql);
        Long count = new Long(0L);
        if (list.size() > 0) {
            count = new Long(list.get(0) + "");
        }
        return count;
    }

    @Override
    public Long getCountbyCond(String cond) {
        String hsql = "select count(*) from " + type.getName() + " where " + cond;
        List list = getHibernateTemplate().find(hsql);
        Long count = new Long(0L);
        if (list.size() > 0) {
            count = new Long(list.get(0) + "");
        }
        return count;
    }

    @SuppressWarnings("rawtypes")
    @Override
    public Long getCountbyHql(String hsql) {
        String hql = "select count(*) " + hsql;
        List list = getHibernateTemplate().find(hql);
        Long count = new Long(0L);
        if (list.size() > 0) {
            count = new Long(list.get(0) + "");
        }
        return count;
    }

    public Long getCountbySql(final String sql) {
        List list = getHibernateTemplate().executeFind(new HibernateCallback() {
            @Override
            public Object doInHibernate(Session session)
                    throws HibernateException, SQLException {
                List catNameList = session.createSQLQuery(sql).list();
                return catNameList;
            }
        });
        Long count = new Long(0L);
        if (list != null && list.size() > 0) {
            count = new Long(list.size());
        }
        return count;
    }

    @Override
    public Long getTotalCount(PageBean p, String str[], Object ob2[]) throws Exception {
        @SuppressWarnings("rawtypes")
        List list = new ArrayList();
        String hsql = "select count(*) from " + type.getName();
        if (str != null && str.length > 0) {
            list = getHibernateTemplate().findByNamedParam(hsql, str, ob2);
        } else {
            list = this.getHibernateTemplate().find(hsql);
        }
        Long count = new Long(0L);
        if (list.size() > 0) {
            count = new Long(list.get(0) + "");
        }
        return count;
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    @Override
    public List<T> getList(final int page, final int rows) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                String hsql = "from " + type.getName();
                Query q = session.createQuery(hsql);
                q.setFirstResult((page - 1) * rows);
                q.setMaxResults(rows);
                return q.list();
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public List<T> getList(final int page, final int rows, final String cond) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                String hsql = "from " + type.getName() + " where " + cond;
                Query q = session.createQuery(hsql);
                q.setFirstResult((page - 1) * rows);
                q.setMaxResults(rows);
                return q.list();
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    public List<T> getListByHql(final int page, final int rows, final String hql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                Query q = session.createQuery(hql);
                q.setFirstResult((page - 1) * rows);
                q.setMaxResults(rows);
                return q.list();
            }
        });
    }

    @Override
    public List getListBySql(final int page, final int rows, final String sql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                Query q = session.createSQLQuery(sql);
                q.setFirstResult((page - 1) * rows);
                q.setMaxResults(rows);
                return q.list();
            }
        });
    }

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    public List<T> getList(final PageBean p) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                String hsql = "from " + type.getName() + " order by " + p.getOrderitem() + " " + p.getUord();
                Query q = session.createQuery(hsql);
                q.setFirstResult((p.getPage() - 1) * p.getPageSize());
                q.setMaxResults(p.getPageSize());
                return q.list();
            }
        });
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    public List<T> getList(final PageBean p, final String cond) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                String hsql = "from " + type.getName() + " where " + cond;
                Query q = session.createQuery(hsql);
                q.setFirstResult((p.getPage() - 1) * p.getPageSize());
                q.setMaxResults(p.getPageSize());
                return q.list();
            }
        });
    }

    @Override
    @SuppressWarnings({"rawtypes", "unchecked"})
    public List<T> getAnyList(final PageBean p, final String hsql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                if (hsql == "") {
                    return new ArrayList();
                }
                Query q = session.createQuery(hsql);
                q.setFirstResult((p.getPage() - 1) * p.getPageSize());
                q.setMaxResults(p.getPageSize());
                return q.list();
            }
        });
    }

    @SuppressWarnings({"rawtypes", "unchecked"})
    public List<T> getList(final PageBean p, final String str[], final Object ob2[]) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                String hsql = "from " + type.getName() + " order by " + p.getOrderitem() + " " + p.getUord();
                Query q = session.createQuery(hsql);
                if (str != null) {
                    for (int i = 0; i < str.length; i++) {
                        q.setParameter(str[i], ob2[i]);
                    }
                }
                q.setFirstResult((p.getPage() - 1) * p.getPageSize());
                q.setMaxResults(p.getPageSize());
                return q.list();
            }
        });
    }

    @SuppressWarnings({"unchecked", "rawtypes"})
    @Override
    public List<T> getByQuery(final String hql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                Query q = session.createQuery(hql);
                return q.list();
            }
        });
    }

    @SuppressWarnings("unchecked")
    public List<T> getBySqlQuery(final String sql) {
        return this.getHibernateTemplate().executeFind(new HibernateCallback() {
            public Object doInHibernate(Session session) {
                Query q = session.createSQLQuery(sql);
                return q.list();
            }
        });
    }

	/*@Override
    public int getEntityByCriteria(Class entity,String sql ) {
		Session session = hibernateTemplate.getSessionFactory().openSession();
		session.beginTransaction();
		int entityId = (Integer) session.createCriteria(entity).add(Restrictions.sqlRestriction(sql)).setProjection(Projections.projectionList()
				.add(Projections.id())).uniqueResult();
		session.getTransaction().commit();
		session.close();
		return entityId;
	}*/

    @Override
    public Integer getEntityId(String hql) {
        List lt = hibernateTemplate.find(hql);
        if (null == lt || lt.size() == 0)
            return null;
        else
            return (Integer) lt.get(0);
    }

    /* (non-Javadoc)
     * <P> Title: getEntityIdL</P>
     * <P> Description: </P>
     * @param hql
     * @return
     * @see com.tds.hdao.TDSDao#getEntityIdL(java.lang.String)
     */
    @Override
    public Long getEntityIdL(String hql) {
        List lt = hibernateTemplate.find(hql);
        if (lt.size() == 0 || null == lt)
            return null;
        else
            return (Long) lt.get(0);
    }

    public int removeWLH(String sql) {
        int flag = -1;
        try {
            Session session = hibernateTemplate.getSessionFactory().openSession();
            session.beginTransaction();
            flag = session.createQuery(sql).executeUpdate();
            session.flush();
            session.getTransaction().commit();
            session.close();
        } catch (HibernateException e) {
            log.error("出错");//e.printStackTrace();
        }
        return flag;
    }

    /* (non-Javadoc)
     * <P> Title: insertEntity</P>
     * <P> Description: </P>
     * @return
     * @see com.tds.hdao.TDSDao#insertEntity()
     */
    @Override
    public long insertEntityBySql(String sql) {
        int flag = -1;
        try {
            Session session = hibernateTemplate.getSessionFactory().openSession();
            session.beginTransaction();
            flag = session.createSQLQuery(sql).executeUpdate();
            session.flush();
            session.getTransaction().commit();
            session.close();
        } catch (NumberFormatException e) {
            log.error("出错");//e.printStackTrace();
        } catch (Exception e) {
            log.error("出错");//e.printStackTrace();
        }
        return flag;
    }

    /* (non-Javadoc)
     * <P> Title: updateBySql</P>
     * <P> Description: </P>
     * @param sql
     * @return
     * @see com.tds.hdao.TDSDao#updateBySql(java.lang.String)
     */
    @Override
    public int updateBySql(String sql) {
        int flag = -1;
        try {
            Session session = hibernateTemplate.getSessionFactory().openSession();
            session.beginTransaction();
            flag = session.createSQLQuery(sql).executeUpdate();
            session.flush();
            session.getTransaction().commit();
            session.close();
        } catch (Exception e) {
            log.error("出错");//e.printStackTrace();
        }
        return flag;
    }

    public byte findNodeStatebyUrl(Integer actorId, String url) {
        url = url.replace("/CTM2025/", "");
        String sql = "SELECT nodeState FROM priv_actor_nodes WHERE actorId = " + actorId + " AND nodeId in (SELECT id FROM tree_nodes WHERE url = '" + url + "')";
        List list = this.findSql(sql);
        if (list != null && list.size() > 0)
            return Byte.valueOf(list.get(0).toString());
        else
            return -1;
    }

    public T findLastObject() {
        List<T> lt = hibernateTemplate.find("from " + type.getName() + " order by id desc ");
        if (null == lt || lt.size() == 0)
            return null;
        else
            return lt.get(0);
    }

    public Integer findLastId() {
        String hql = "select id from " + type.getName() + " order by id desc";
        List<T> lt = this.findUnknowCombine(hql);
        if (lt != null && lt.size() > 0)
            return Integer.parseInt(lt.get(0).toString());
        else
            return -1;
    }

    public List<T> findAllbyDep(Integer depId) {
        String cond = "userDep.id=" + depId;
        return this.findSelfObjects(cond);
    }
}
