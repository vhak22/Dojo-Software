package dao.daoimpl;

import dao.AbstractDAO;
import dao.StudentDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Student;
import utils.XJPA;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
    @Override
    public List<Student> findByMasterId(String masterId) {
        EntityManager em = XJPA.getEntityManager();
        try {
            // Logic JPQL:
            // 1. Từ Student (s) JOIN sang danh sách Enrollments (e)
            // 2. Từ Enrollment (e) JOIN sang Dojo (d)
            // 3. Kiểm tra Master của Dojo (d.master.userId) có trùng với masterId truyền vào không
            // Dùng DISTINCT để tránh học viên xuất hiện nhiều lần nếu họ đăng ký nhiều lớp

            String jpql = "SELECT DISTINCT s FROM Student s " +
                    "JOIN s.enrollments e " +
                    "JOIN e.dojo d " +
                    "WHERE d.master.userId = :mid";

            TypedQuery<Student> query = em.createQuery(jpql, Student.class);
            query.setParameter("mid", masterId);

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>(); // Trả về list rỗng nếu có lỗi để tránh NullPointerException
        } finally {
            em.close();
        }
    }
}
