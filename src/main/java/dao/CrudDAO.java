package dao;
import java.util.List;

public interface CrudDAO<T, K> {
    List<T> findAll();
    T findById(K id);
    void create(T entity);
    void update(T entity);
    void deleteById(K id);

    // Bổ sung 2 hàm này
    List<T> searchAndPaginate(String keyword, int page, int pageSize);
    long getTotalCount(String keyword);
}