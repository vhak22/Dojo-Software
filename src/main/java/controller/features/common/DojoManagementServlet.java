package controller.admin;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;
import org.apache.commons.beanutils.BeanUtils; // Cần thư viện commons-beanutils

import java.io.IOException;
import java.util.List;

@WebServlet({
        "/admin/users",           // Xem danh sách
        "/admin/user/create",     // Tạo mới
        "/admin/user/update",     // Cập nhật
        "/admin/user/delete",     // Xóa
        "/admin/user/edit"        // Load form sửa
})
public class DojoManagementServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.contains("edit")) {
            // Load thông tin user lên form để sửa
            String id = req.getParameter("id");
            User user = userDAO.findById(id);
            req.setAttribute("userForm", user);
            req.setAttribute("isEdit", true); // Đánh dấu là đang sửa
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        } else if (path.contains("create")) {
            // Mở form trống để tạo mới
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        } else if (path.contains("delete")) {
            // Xóa user
            deleteUser(req, resp);
        } else {
            // Mặc định: Xem danh sách
            List<User> list = userDAO.findAll();
            req.setAttribute("items", list);
            req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Xử lý tiếng Việt
        req.setCharacterEncoding("UTF-8");

        try {
            User formUser = new User();
            BeanUtils.populate(formUser, req.getParameterMap()); // Mapping dữ liệu từ form vào object

            // Xử lý Role (Vì BeanUtils khó map object lồng nhau, ta làm thủ công ID role)
            // Giả sử form gửi về roleId (1, 2, 3)
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            // Lưu ý: Bạn cần method getRoleById hoặc tạo object Role giả
            Role role = new Role();
            role.setId(roleId);
            formUser.setRole(role);

            if (path.contains("create")) {
                if (userDAO.findById(formUser.getUserId()) != null) {
                    req.setAttribute("message", "User ID đã tồn tại!");
                    req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
                    return;
                }
                userDAO.create(formUser);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=create_success");

            } else if (path.contains("update")) {
                userDAO.update(formUser);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=update_success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            //Soft delete
            User user = userDAO.findById(id);
            user.setActive(false);
            userDAO.update(user);

            resp.sendRedirect(req.getContextPath() + "/admin/users?message=delete_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=delete_fail");
        }
    }
}