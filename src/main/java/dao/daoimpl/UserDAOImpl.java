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
        return super.searchWithFields(keyword, page, pageSize, "userId", "fullname", "email");
    }

    @Override
    public long getTotalCount(String keyword) {
        return super.countWithFields(keyword, "userId", "fullname", "email");
    }
}
