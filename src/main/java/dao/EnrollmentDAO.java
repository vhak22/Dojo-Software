package dao;

import model.Enrollment;

public interface EnrollmentDAO extends CrudDAO<Enrollment, Integer> {
    long count();

    // Returns the most recent enrollments by enrollDate (descending).
    java.util.List<Enrollment> findLatest(int limit);
}
