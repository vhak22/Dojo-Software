package dao.daoimpl;

import dao.AbstractDAO;
import dao.DojoDAO;
import jakarta.persistence.EntityManager;
import model.Dojo;
import utils.XJPA;

public class DojoDAOImpl extends AbstractDAO<Dojo, String> implements DojoDAO {
    public DojoDAOImpl() {
        super(Dojo.class);
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
