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
import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Hiển thị form quên mật khẩu
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        // 1. Kiểm tra User trong database
        User user = userDAO.findByEmail(email);

        if (user != null) {
            // 2. Tạo mật khẩu ngẫu nhiên (ví dụ 8 ký tự)
            String newPassword = RandomStringUtil.generateRandomPassword(8);

            // 3. Cập nhật mật khẩu mới vào Entity và lưu xuống Database
            user.setPassword(newPassword);
            try {
                // Sử dụng hàm update kế thừa từ AbstractDAO/CrudDAO
                userDAO.update(user);

                // 4. Sử dụng EmailUtil đã cấu hình để gửi mật khẩu
                String subject = "Hệ thống Dojo - Cấp lại mật khẩu";
                String body = "Xin chào " + user.getFullname() + ",\n\n"
                        + "Mật khẩu mới của bạn là: " + newPassword + "\n"
                        + "Vui lòng đăng nhập và đổi mật khẩu ngay lập tức để bảo mật tài khoản.\n\n"
                        + "Trân trọng,\nDojo Software.";

                EmailUtil.sendEmail(email, subject, body);

                req.setAttribute("message", "Mật khẩu mới đã được gửi tới email của bạn!");
            } catch (Exception e) {
                req.setAttribute("error", "Lỗi hệ thống khi cập nhật mật khẩu. Vui lòng thử lại.");
                e.printStackTrace();
            }
        } else {
            req.setAttribute("error", "Email không tồn tại trong hệ thống.");
        }

        // Trả lại kết quả về giao diện
        req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
    }
}