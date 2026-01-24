package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;
import java.util.List;

public abstract class AbstractDAO<T, K> implements CrudDAO<T, K> {
    private Class<T> entityClass;

    public AbstractDAO(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    @Override
    public List<T> findAll() {
        // Sử dụng khối try-with-resources hoặc đảm bảo đóng em nếu lấy mới
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT obj FROM " + entityClass.getSimpleName() + " obj";
            TypedQuery<T> query = em.createQuery(jpql, entityClass);
            return query.getResultList();
        } finally {
            em.close(); // Giải phóng kết nối sau khi dùng xong
        }
    }

    @Override
    public T findById(K id) {
        EntityManager em = XJPA.getEntityManager();
        try {
            return em.find(entityClass, id);
        } finally {
            em.close();
        }
    }

    @Override
    public void create(T entity) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(entity);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Lỗi khi thêm mới: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void update(T entity) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            Object id = em.getEntityManagerFactory().getPersistenceUnitUtil().getIdentifier(entity);
            T managedEntity = em.find(entityClass, id);
            if (managedEntity != null) {
                em.merge(entity);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Lỗi khi cập nhật: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteById(K id) {
        EntityManager em = XJPA.getEntityManager();
        try {
            em.getTransaction().begin();
            T entity = em.find(entityClass, id);
            if (entity != null) {
                em.remove(entity);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Lỗi khi xóa: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}