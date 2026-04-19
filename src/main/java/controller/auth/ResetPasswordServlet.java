package controller.auth;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        // Kiểm tra xem người dùng đã qua bước xác thực OTP chưa
        Boolean isVerified = (Boolean) session.getAttribute("isOtpVerified");
        if (isVerified == null || !isVerified) {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String newPassword = req.getParameter("newPassword");
        String email = (String) session.getAttribute("resetEmail");

        if (email != null && newPassword != null) {
            User user = userDAO.findByEmail(email);
            if (user != null) {
                user.setPassword(newPassword);
                userDAO.update(user); // Cập nhật mật khẩu mới

                // Dọn dẹp session
                session.removeAttribute("otpCode");
                session.removeAttribute("otpCreationTime");
                session.removeAttribute("resetEmail");
                session.removeAttribute("isOtpVerified");

                // Báo thành công và điều hướng về login
                session.setAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }
        req.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại.");
        req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
    }
}