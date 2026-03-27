package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import model.Role;
import model.User;
import utils.XJPA;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang đăng ký
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cài đặt encoding để nhận tiếng Việt có dấu
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ form
        String userId = request.getParameter("userId");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. Validate cơ bản phía Server
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // 3. Xử lý Database thông qua JPA
        EntityManager em = XJPA.getEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            // 3.1 Kiểm tra UserId hoặc Email đã tồn tại chưa
            String jpql = "SELECT u FROM User u WHERE u.userId = :userId OR u.email = :email";
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("userId", userId);
            query.setParameter("email", email);

            List<User> existingUsers = query.getResultList();

            if (!existingUsers.isEmpty()) {
                request.setAttribute("errorMessage", "Tài khoản (User ID) hoặc Email đã được sử dụng!");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
                return;
            }

            // 3.2 Khởi tạo đối tượng User mới (Entity)
            User newUser = new User();
            newUser.setUserId(userId);
            newUser.setFullname(fullname);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setActive(true);
            newUser.setCreatedAt(LocalDateTime.now());
            newUser.setAuthProvider("LOCAL");

            // Set Role: Lấy Role từ DB lên để gán cho User (Giả sử ID Role học viên là 2)
            // Lưu ý: Thay đổi kiểu dữ liệu của số 2 tùy thuộc vào Khóa chính của bảng Role là Integer hay String
            Role defaultRole = em.find(Role.class, 2);
            if (defaultRole != null) {
                newUser.setRole(defaultRole);
            }

            // 3.3 Lưu vào Database
            trans.begin();
            em.persist(newUser);
            trans.commit();

            // 4. Đăng ký thành công -> Lưu thông báo và chuyển hướng
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập hệ thống.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Exception e) {
            // Rollback nếu có lỗi xảy ra trong quá trình persist
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        } finally {
            // Đảm bảo luôn đóng EntityManager để giải phóng tài nguyên
            em.close();
        }
    }
}