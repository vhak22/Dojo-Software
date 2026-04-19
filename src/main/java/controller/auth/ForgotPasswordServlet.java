package controller.auth;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import model.User;
import utils.EmailUtil;
import utils.RandomStringUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        User user = userDAO.findByEmail(email);

        if (user != null) {
            // 1. Tạo mã OTP 6 số
            String otpCode = RandomStringUtil.generateOTP(6);

            // 2. Lưu OTP, thời gian tạo và email vào Session
            HttpSession session = req.getSession();
            session.setAttribute("otpCode", otpCode);
            session.setAttribute("otpCreationTime", System.currentTimeMillis());
            session.setAttribute("resetEmail", email); // Lưu lại email để đổi pass sau này

            // 3. Gửi email
            String subject = "Hệ thống Dojo - Mã xác thực quên mật khẩu";
            String body = "Xin chào " + user.getFullname() + ",\n\n"
                    + "Mã xác thực (OTP) của bạn là: " + otpCode + "\n"
                    + "Mã này có hiệu lực trong vòng 1 phút.\n\n"
                    + "Trân trọng,\nDojo Software.";

            EmailUtil.sendEmail(email, subject, body);

            // 4. Chuyển hướng sang trang xác thực mã
            resp.sendRedirect(req.getContextPath() + "/verify-otp");
        } else {
            req.setAttribute("error", "Email không tồn tại trong hệ thống.");
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
        }
    }
}