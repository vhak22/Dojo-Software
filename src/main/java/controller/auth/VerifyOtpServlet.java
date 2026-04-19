package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userOtp = req.getParameter("otp");
        HttpSession session = req.getSession();

        String sessionOtp = (String) session.getAttribute("otpCode");
        Long creationTime = (Long) session.getAttribute("otpCreationTime");

        if (sessionOtp != null && creationTime != null) {
            long currentTime = System.currentTimeMillis();
            long elapsedTime = currentTime - creationTime;

            // Kiểm tra nếu quá 1 phút (60,000 milliseconds)
            if (elapsedTime > 60000) {
                session.removeAttribute("otpCode"); // Xóa mã hết hạn
                session.removeAttribute("otpCreationTime");
                req.setAttribute("error", "Mã xác thực đã hết hạn. Vui lòng gửi lại.");
                req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
            }
            // Kiểm tra mã có khớp không
            else if (sessionOtp.equals(userOtp)) {
                // Đánh dấu session là đã xác thực thành công để cho phép đổi pass
                session.setAttribute("isOtpVerified", true);
                resp.sendRedirect(req.getContextPath() + "/reset-password");
            } else {
                req.setAttribute("error", "Mã xác thực không chính xác.");
                req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("error", "Không tìm thấy yêu cầu cấp lại mật khẩu. Vui lòng thử lại từ đầu.");
            req.getRequestDispatcher("/views/auth/verify-otp.jsp").forward(req, resp);
        }
    }
}