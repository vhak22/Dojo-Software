package dao.daoimpl;

import dao.AbstractDAO;
import dao.UserDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import model.Role;
import model.User;
import utils.XJPA;

import java.util.List;

public class UserDAOImpl extends AbstractDAO<User, String> implements UserDAO {
    public UserDAOImpl() {
        super(User.class);
    }

    @Override
    public List<User> findByRole(Role.RoleName roleName) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.role.roleName = :roleParam";

            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("roleParam", roleName);

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> searchAndPaginate(String keyword, int page, int pageSize) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.id LIKE :kw OR u.fullname LIKE :kw OR u.email LIKE :kw";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("kw", "%" + keyword + "%");

            // Thiết lập phân trang
            query.setFirstResult((page - 1) * pageSize); // Vị trí bắt đầu
            query.setMaxResults(pageSize);               // Số lượng bản ghi mỗi trang

            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long getTotalCount(String keyword) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT COUNT(u) FROM User u WHERE u.id LIKE :kw OR u.fullname LIKE :kw OR u.email LIKE :kw";
            Query query = em.createQuery(jpql);
            query.setParameter("kw", "%" + keyword + "%");
            return (long) query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
