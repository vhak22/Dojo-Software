package controller.features.admin;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;
import org.apache.commons.beanutils.BeanUtils;

import java.io.IOException;
import java.util.List;

// 1. ĐỊNH NGHĨA CÁC ĐƯỜNG DẪN URL MÀ SERVLET NÀY SẼ XỬ LÝ
@WebServlet({
        "/admin/users",          // Trang danh sách (Trang chủ của module User)
        "/admin/user/create",    // Xử lý thêm mới
        "/admin/user/update",    // Xử lý cập nhật
        "/admin/user/delete",    // Xử lý xóa
        "/admin/user/edit"       // Load form để sửa
})
public class UserManagementServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath(); // Lấy phần đuôi của URL

        // 2. ĐIỀU HƯỚNG DỰA TRÊN URL
        if (path.contains("edit")) {
            // URL: /admin/user/edit?id=...
            String id = req.getParameter("id");
            User user = userDAO.findById(id);
            req.setAttribute("userForm", user);
            req.setAttribute("isEdit", true);
            // Trỏ về file JSP trong thư mục views/admin
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
        else if (path.contains("create")) {
            // URL: /admin/user/create (Khi bấm nút Thêm mới)
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
        else if (path.contains("delete")) {
            // URL: /admin/user/delete?id=...
            deleteUser(req, resp);
        }
        else {
            // URL: /admin/users (Mặc định vào danh sách)
            List<User> list = userDAO.findAll();
            req.setAttribute("items", list);
            req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Xử lý dữ liệu từ Form gửi lên (Create hoặc Update)
        String path = req.getServletPath();
        req.setCharacterEncoding("UTF-8");

        try {
            String userId = req.getParameter("userId");
            User user;

            if (path.contains("create")) {
                // Logic tạo mới
                if (userDAO.findById(userId) != null) {
                    req.setAttribute("error", "User ID " + userId + " đã tồn tại!");
                    User formUser = new User();
                    BeanUtils.populate(formUser, req.getParameterMap());
                    req.setAttribute("userForm", formUser);
                    req.setAttribute("isEdit", false);
                    req.getRequestDispatcher("/views/admin/user/user-form.jsp").forward(req, resp);
                    return;
                }
                user = new User();
                BeanUtils.populate(user, req.getParameterMap());
            } else {
                // Logic cập nhật
                user = userDAO.findById(userId);
                if (user == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?error=not_found");
                    return;
                }
                user.setFullname(req.getParameter("fullname"));
                user.setEmail(req.getParameter("email"));
            }

            // Xử lý mật khẩu (Giữ cũ nếu không nhập mới)
            String formPass = req.getParameter("password");
            if (formPass != null && !formPass.trim().isEmpty()) {
                user.setPassword(formPass);
            }

            // Xử lý Role (Dropdown)
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            Role role = new Role();
            role.setId(roleId);
            user.setRole(role);

            // Xử lý Active (Checkbox)
            boolean isActive = req.getParameter("active") != null;
            user.setActive(isActive);

            // Lưu và Redirect về trang danh sách
            if (path.contains("create")) {
                userDAO.create(user);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=create_success");
            } else {
                userDAO.update(user);
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
            User user = userDAO.findById(id);
            if (user != null) {
                user.setActive(false); // Soft Delete
                userDAO.update(user);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=delete_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=delete_fail");
        }
    }
}