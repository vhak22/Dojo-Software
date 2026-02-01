package dao;

import model.Student;

public interface StudentDAO extends CrudDAO<Student, String>{
    long count();
}
