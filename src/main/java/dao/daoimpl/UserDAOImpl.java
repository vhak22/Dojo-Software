package dao.daoimpl;

import dao.AbstractDAO;
import dao.UserDAO;
import jakarta.persistence.EntityManager;
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
}
