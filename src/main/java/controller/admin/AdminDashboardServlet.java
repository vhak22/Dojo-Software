package controller.admin;

import dao.DojoDAO;
import dao.StudentDAO;
import dao.UserDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.StudentDAOImpl;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Role;
import model.User;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    // Khai báo các DAO
    private UserDAO userDAO = new UserDAOImpl();
    private DojoDAO dojoDAO = new DojoDAOImpl();
    private StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null || user.getRole().getRoleName() != Role.RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }

        // 1. Lấy thống kê
        try {
            long totalUsers = userDAO.count(); // Đảm bảo bạn đã thêm hàm count() vào DAO
            long totalDojos = dojoDAO.count();
            long totalStudents = studentDAO.count();

            // 2. Đẩy ra view
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalDojos", totalDojos);
            req.setAttribute("totalStudents", totalStudents);

        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi nếu chưa implement hàm count
        }

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}