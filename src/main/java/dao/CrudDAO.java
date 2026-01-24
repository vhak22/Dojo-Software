package dao;
import java.util.List;



/**
 * Interface chung định nghĩa các hoạt động CRUD cơ bản (Create, Read, Update, Delete).
 *
 * @param <T> Loại đối tượng Entity mà DAO này xử lý (ví dụ: News, User, Category).
 * @param <K> Loại của khóa chính (Primary Key) của Entity (ví dụ: String).
 */
public interface CrudDAO<T, K> {
    List<T> findAll();

    T findById(K id);

    void create(T entity);

    void update(T entity);

    void deleteById(K id);

}