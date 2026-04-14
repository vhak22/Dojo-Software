package dao;

import model.Enrollment;

import java.util.List;

public interface EnrollmentDAO extends CrudDAO<Enrollment, Integer> {
    long count();

    java.util.List<Enrollment> findLatest(int limit);

    List<Enrollment> searchAndPaginate(String keyword, int page, int pageSize);

    long getTotalCount(String keyword);
}
