package dao.daoimpl;

import dao.AbstractDAO;
import dao.StudentDAO;
import jakarta.persistence.EntityManager;
import model.Student;
import utils.XJPA;

public class StudentDAOImpl extends AbstractDAO<Student, String> implements StudentDAO {
    public StudentDAOImpl() {
        super(Student.class);
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
}
