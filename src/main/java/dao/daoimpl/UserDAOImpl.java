package dao.daoimpl;

import dao.AbstractDAO;
import dao.UserDAO;
import model.User;

public class UserDAOImpl extends AbstractDAO<User, String> implements UserDAO {
    public UserDAOImpl() {
        super(User.class);
    }
}
