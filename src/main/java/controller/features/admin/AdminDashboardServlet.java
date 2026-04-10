package controller.features.admin;

import dao.DojoDAO;
import dao.EnrollmentDAO;
import dao.StudentDAO;
import dao.UserDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.EnrollmentDAOImpl;
import dao.daoimpl.StudentDAOImpl;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Enrollment;
import model.Role;
import model.User;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    // Khai báo các DAO
    private UserDAO userDAO = new UserDAOImpl();
    private DojoDAO dojoDAO = new DojoDAOImpl();
    private StudentDAO studentDAO = new StudentDAOImpl();
    private EnrollmentDAO enrollmentDAO = new EnrollmentDAOImpl();

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
            long totalEnrollments = enrollmentDAO.count();

            List<User> allUsers = userDAO.findAll();
            long activeUsers = allUsers.stream().filter(u -> Boolean.TRUE.equals(u.getActive())).count();
            long inactiveUsers = totalUsers - activeUsers;

            List<User> recentUsers = allUsers.stream()
                    .sorted(Comparator.comparing(User::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed())
                    .limit(5)
                    .collect(Collectors.toList());

            List<Enrollment> recentEnrollments = enrollmentDAO.findLatest(5);

            // 2. Đẩy ra view
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalDojos", totalDojos);
            req.setAttribute("totalStudents", totalStudents);
            req.setAttribute("totalEnrollments", totalEnrollments);
            req.setAttribute("activeUsers", activeUsers);
            req.setAttribute("inactiveUsers", inactiveUsers);
            req.setAttribute("recentUsers", recentUsers);
            req.setAttribute("recentEnrollments", recentEnrollments);

        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi nếu chưa implement hàm count
        }

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }
}