package dao.daoimpl;

import dao.AbstractDAO;
import dao.StudentDAO;
import model.Student;

public class StudentDAOImpl extends AbstractDAO<Student, String> implements StudentDAO {
    public StudentDAOImpl() {
        super(Student.class);
    }
}
