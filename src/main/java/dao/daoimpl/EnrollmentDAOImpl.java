package dao.daoimpl;

import dao.AbstractDAO;
import dao.EnrollmentDAO;
import model.Enrollment;

public class EnrollmentDAOImpl extends AbstractDAO<Enrollment, String> implements EnrollmentDAO {
    public EnrollmentDAOImpl() {
        super(Enrollment.class);
    }
}
