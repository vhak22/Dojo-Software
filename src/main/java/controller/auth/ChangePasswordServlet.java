package controller.auth;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy user từ session
        User sessionUser = (User) req.getSession().getAttribute("currentUser");
        if (sessionUser == null) {
            resp.sendRedirect("login");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        // Validate
        if (!sessionUser.getPassword().equals(oldPass)) {
            req.setAttribute("error", "Mật khẩu cũ không đúng!");
            req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
            return;
        }
        if (!newPass.equals(confirmPass)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
            return;
        }

        // Update
        sessionUser.setPassword(newPass);
        try {
            userDAO.update(sessionUser); // Update vào DB
            req.setAttribute("message", "Đổi mật khẩu thành công!");
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi hệ thống!");
        }

        req.getRequestDispatcher("/views/change-password.jsp").forward(req, resp);
    }
}