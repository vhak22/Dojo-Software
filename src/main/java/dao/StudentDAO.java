package dao;

import model.Student;

import java.util.List;

public interface StudentDAO extends CrudDAO<Student, String>{
    long count();
    List<Student> findByMasterId(String masterId);
}
