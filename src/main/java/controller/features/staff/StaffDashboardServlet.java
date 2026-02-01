package controller.features.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;
import java.io.IOException;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null || user.getRole().getRoleName() != Role.RoleName.STAFF) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }

        req.getRequestDispatcher("/views/staff/dashboard.jsp").forward(req, resp);
    }
}