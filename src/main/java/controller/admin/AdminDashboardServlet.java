package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        // Bảo mật: Kiểm tra user có tồn tại và đúng quyền ADMIN không
        if (user == null || user.getRole().getRoleName() != Role.RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }

        // Chuyển tới trang JSP Dashboard của Admin
        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}