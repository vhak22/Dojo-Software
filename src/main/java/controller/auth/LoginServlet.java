package controller.auth;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu đã đăng nhập rồi thì chuyển hướng vào dashboard luôn
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            redirectBasedOnRole(resp, (User) session.getAttribute("currentUser"));
            return;
        }
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("userId");
        String password = req.getParameter("password");

        try {
            // 1. Tìm user trong DB
            User user = userDAO.findById(userId);

            // 2. Kiểm tra thông tin đăng nhập
            // Lưu ý: Thực tế bạn nên mã hóa mật khẩu (BCrypt).
            // Ở đây tôi so sánh trực tiếp chuỗi vì trong file SQL bạn đang lưu plain text/giả lập hash.
            if (user != null && user.getPassword().equals(password)) {

                // 3. Kiểm tra tài khoản có bị khóa không
                if (!user.getActive()) {
                    req.setAttribute("errorMessage", "Tài khoản của bạn đã bị khóa!");
                    req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
                    return;
                }

                // 4. Đăng nhập thành công -> Lưu vào Session
                HttpSession session = req.getSession();
                session.setAttribute("currentUser", user);

                // 5. Phân quyền và chuyển hướng
                redirectBasedOnRole(resp, user);

            } else {
                // Đăng nhập thất bại
                req.setAttribute("errorMessage", "Sai tên đăng nhập hoặc mật khẩu!");
                req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }

    // Hàm phụ trợ để điều hướng user
    private void redirectBasedOnRole(HttpServletResponse resp, User user) throws IOException {
        Role.RoleName roleName = user.getRole().getRoleName();
        //admin = ADMIN,
        if (roleName == Role.RoleName.ADMIN) {
            resp.sendRedirect("admin/dashboard");
        } else if (roleName == Role.RoleName.MASTER) {
            resp.sendRedirect("master/dashboard");
        } else if (roleName == Role.RoleName.STAFF) {
            resp.sendRedirect("staff/dashboard");
        } else {
            // Trường hợp không có quyền cụ thể, về trang chủ
            resp.sendRedirect("home");
        }
    }
}