package dao.daoimpl;

import dao.AbstractDAO;
import dao.DojoDAO;
import model.Dojo;

public class DojoDAOImpl extends AbstractDAO<Dojo, String> implements DojoDAO {
    public DojoDAOImpl() {
        super(Dojo.class);
    }
}
