package dao;

import model.Role;
import model.User;

import java.util.List;

public interface UserDAO extends CrudDAO<User, String>{
    List<User> findByRole(Role.RoleName roleName);
}
