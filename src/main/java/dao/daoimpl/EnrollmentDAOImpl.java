package dao.daoimpl;

import dao.AbstractDAO;
import dao.EnrollmentDAO;
import model.Enrollment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.XJPA;

import java.util.List;

public class EnrollmentDAOImpl extends AbstractDAO<Enrollment, Integer> implements EnrollmentDAO {
    public EnrollmentDAOImpl() {
        super(Enrollment.class);
    }

    @Override
    public long count() {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT COUNT(e) FROM Enrollment e";
            return em.createQuery(jpql, Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Enrollment> findLatest(int limit) {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT e FROM Enrollment e ORDER BY e.enrollDate DESC";
            TypedQuery<Enrollment> query = em.createQuery(jpql, Enrollment.class);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Enrollment> searchAndPaginate(String keyword, int page, int pageSize) {
        return super.searchWithFields(keyword, page, pageSize, "id", "student", "dojo", "status");
    }

    @Override
    public long getTotalCount(String keyword) {
        return super.countWithFields(keyword, "id", "student", "dojo", "status");
    }
}
