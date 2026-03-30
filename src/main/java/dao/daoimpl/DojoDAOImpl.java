package dao.daoimpl;

import dao.AbstractDAO;
import dao.DojoDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.Dojo;
import utils.XJPA;

import java.util.List;

public class DojoDAOImpl extends AbstractDAO<Dojo, String> implements DojoDAO {
    public DojoDAOImpl() {
        super(Dojo.class);
    }
    @Override
    public long count() {
        EntityManager em = XJPA.getEntityManager();
        try {
            String jpql = "SELECT COUNT(d) FROM Dojo d";
            return em.createQuery(jpql, Long.class).getSingleResult(); // total Dojo records
        } finally {
            em.close();
        }
    }
    @Override
    public List<Dojo> findByMasterId(String masterId) {
        EntityManager em = XJPA.getEntityManager();
        try {
            // Truy vấn Dojo dựa trên khóa ngoại master
            String jpql = "SELECT d FROM Dojo d WHERE d.master.userId = :mid";
            TypedQuery<Dojo> query = em.createQuery(jpql, Dojo.class);
            query.setParameter("mid", masterId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
