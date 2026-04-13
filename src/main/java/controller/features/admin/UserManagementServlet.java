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

@WebServlet({
        "/admin/users",          // Trang danh sách
        "/admin/user/create",    // Xử lý tạo mới
        "/admin/user/update",    // Xử lý cập nhật
        "/admin/user/delete",    // Xử lý xóa
        "/admin/user/edit",       // Form sửa
        "/admin/user/reset-password" //resetPassword
})
public class UserManagementServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.contains("edit")) {
            String id = req.getParameter("id");
            User user = userDAO.findById(id);
            req.setAttribute("userForm", user);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/user/user-form.jsp").forward(req, resp);
        }
        else if (path.contains("create")) {
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/user/user-form.jsp").forward(req, resp);
        }
        else if (path.contains("delete")) {
            deleteUser(req, resp);
        }
        else if (path.contains("reset-password")) {
            resetPassword(req, resp);
        }
        else {
            utils.PaginationUtil.paginate(req, userDAO, 10);
            req.getRequestDispatcher("/views/admin/user/user-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        req.setCharacterEncoding("UTF-8");

        try {
            User user = new User();
            // Lấy dữ liệu cơ bản từ form
            BeanUtils.populate(user, req.getParameterMap());

            // 1. Xử lý Role (Dropdown trả về roleId)
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            Role role = new Role();
            role.setId(roleId);
            user.setRole(role);

            // 2. Xử lý Checkbox Active (Quan trọng)
            // HTML Checkbox: Tick -> "true", Không tick -> null
            boolean isActive = req.getParameter("active") != null;
            user.setActive(isActive);

            if (path.contains("create")) {
                // --- LOGIC TẠO MỚI ---
                if (userDAO.findById(user.getUserId()) != null) {
                    req.setAttribute("error", "Mã User đã tồn tại!");
                    req.setAttribute("userForm", user);
                    req.setAttribute("isEdit", false);
                    req.getRequestDispatcher("/views/admin/user/user-form.jsp").forward(req, resp);
                    return;
                }
                userDAO.create(user);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=create_success");
            }
            else {
                // --- LOGIC CẬP NHẬT ---
                User oldUser = userDAO.findById(user.getUserId());

                // Giữ lại password cũ nếu không nhập mới
                String newPass = req.getParameter("password");
                if (newPass == null || newPass.trim().isEmpty()) {
                    user.setPassword(oldUser.getPassword());
                }

                userDAO.update(user);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=update_success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/user/user-form.jsp").forward(req, resp);
        }
    }

    private void resetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        try {
            User user = userDAO.findById(id);
            if (user != null && user.getEmail() != null) {

                // 1. Random mật khẩu mới (Lấy 8 ký tự đầu)
                String newPass = java.util.UUID.randomUUID().toString().substring(0, 8);

                // 2. Lưu vào CSDL
                user.setPassword(newPass);
                userDAO.update(user);

                // 3. Gửi Email
                String subject = "Cap lai mat khau phan mem Dojo";
                String body = "Xin chao " + user.getFullname() + ",\n\n"
                        + "Mat khau moi cua ban la: " + newPass + "\n"
                        + "Vui long dang nhap va doi mat khau ngay!";

                utils.EmailUtil.sendEmail(user.getEmail(), subject, body);

                // 4. Báo thành công
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=Da gui email mat khau moi!");
            }
            //            } else {
//
//                resp.sendRedirect(req.getContextPath() + "/admin/users?error=User khong ton tai hoac khong co email");
//            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Loi gui email");
        }
    }
    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            User user = userDAO.findById(id);
            if (user != null) {
                // Soft Delete: Chỉ set Active = false
                user.setActive(false);
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