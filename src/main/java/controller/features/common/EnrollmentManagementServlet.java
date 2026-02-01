package controller.features.common;

import dao.DojoDAO;
import dao.EnrollmentDAO;
import dao.StudentDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.EnrollmentDAOImpl;
import dao.daoimpl.StudentDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Dojo;
import model.Enrollment;
import model.Student;
import model.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

// Map cho cả 3 role để tái sử dụng logic
@WebServlet({
        "/enrollments", "/admin/enrollments", "/admin/enrollments/create", "/admin/enrollments/update", "/admin/enrollments/delete", "/admin/enrollments/save",
        "/master/enrollments", "/master/enrollments/create", "/master/enrollments/update", "/master/enrollments/delete", "/master/enrollments/save",
        "/staff/enrollments", "/staff/enrollments/create", "/staff/enrollments/update", "/staff/enrollments/delete", "/staff/enrollments/save"
})
public class EnrollmentManagementServlet extends HttpServlet {

    private EnrollmentDAO enrollmentDAO = new EnrollmentDAOImpl();
    private StudentDAO studentDAO = new StudentDAOImpl();
    private DojoDAO dojoDAO = new DojoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        // Xác định role dựa trên URL để trả về đúng folder view (admin/master/staff)
        String rolePath = "admin"; // mặc định
        if (uri.contains("/master/")) rolePath = "master";
        else if (uri.contains("/staff/")) rolePath = "staff";

        req.setAttribute("rolePath", rolePath); // Để dùng trong JSP cho các thẻ <a href>

        if (uri.contains("create")) {
            showForm(req, resp, rolePath);
        } else if (uri.contains("update") || uri.contains("edit")) { // Hỗ trợ cả /edit và /update
            showForm(req, resp, rolePath);
        } else if (uri.contains("delete")) {
            deleteEnrollment(req, resp, rolePath);
        } else {
            listEnrollments(req, resp, rolePath);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        // Xác định role để redirect sau khi post
        String rolePath = "admin";
        if (uri.contains("/master/")) rolePath = "master";
        else if (uri.contains("/staff/")) rolePath = "staff";

        if (uri.contains("save") || uri.contains("create") || uri.contains("update")) {
            saveEnrollment(req, resp, rolePath);
        }
    }

    private void listEnrollments(HttpServletRequest req, HttpServletResponse resp, String rolePath) throws ServletException, IOException {
        // Lấy tất cả danh sách enrollment
        // Lưu ý: Nếu là Master/Staff, bạn có thể muốn lọc danh sách này chỉ hiển thị Dojo của họ
        // Ví dụ: if (rolePath.equals("master")) items = enrollmentDAO.findByMaster(userId);
        // Ở đây mình lấy tất cả cho đơn giản:
        List<Enrollment> items = enrollmentDAO.findAll();

        req.setAttribute("enrollments", items);

        // Forward về file jsp list tương ứng, ví dụ: /views/admin/enrollment/enrollment-list.jsp
        // Giả sử bạn để chung view hoặc copy ra từng folder
        // Ở đây mình giả định cấu trúc views/admin/enrollment-list.jsp (như bạn cung cấp trước đó)
        // Nếu file nằm trong thư mục con, hãy sửa đường dẫn bên dưới
        req.getRequestDispatcher("/views/" + rolePath + "/enrollment/enrollment-list.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, String rolePath) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Enrollment enrollment = new Enrollment();

        if (idStr != null && !idStr.isEmpty()) {
            // Chế độ Edit
            try {
                // DAO của bạn dùng String làm key trong interface CrudDAO<Enrollment, String>
                // Nhưng Model Enrollment dùng Integer id.
                // Tùy implementation của findById, bạn có thể cần parse hoặc truyền chuỗi.
                // Giả sử findById nhận String:
                enrollment = enrollmentDAO.findById(idStr);
                req.setAttribute("isEdit", true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            req.setAttribute("isEdit", false);
        }

        req.setAttribute("enrollment", enrollment);

        // Chuẩn bị dữ liệu cho Dropdown
        List<Student> students = studentDAO.findAll();
        List<Dojo> dojos = dojoDAO.findAll();

        // Truyền enum Status ra view nếu cần (hoặc hardcode trong JSP như bài trước)
        req.setAttribute("enrollmentStatuses", Enrollment.EnrollmentStatus.values());
        req.setAttribute("students", students);
        req.setAttribute("dojos", dojos);

        req.getRequestDispatcher("/views/" + rolePath + "/enrollment/enrollment-form.jsp").forward(req, resp);
    }

    private void saveEnrollment(HttpServletRequest req, HttpServletResponse resp, String rolePath) throws IOException {
        try {
            // 1. Lấy dữ liệu từ form
            String idStr = req.getParameter("id");
            String studentId = req.getParameter("studentId");
            String dojoId = req.getParameter("dojoId");
            String dateStr = req.getParameter("enrollmentDate");
            String statusStr = req.getParameter("status"); // Giá trị: ACTIVE, DROPPED...

            Enrollment enrollment = new Enrollment();

            // Xử lý ID (Update)
            if (idStr != null && !idStr.isEmpty()) {
                enrollment.setId(Integer.parseInt(idStr));
            }

            // Xử lý Student (Foreign Key)
            Student student = studentDAO.findById(studentId);
            enrollment.setStudent(student);

            // Xử lý Dojo (Foreign Key)
            Dojo dojo = dojoDAO.findById(dojoId);
            enrollment.setDojo(dojo);

            // Xử lý Date
            if (dateStr != null && !dateStr.isEmpty()) {
                enrollment.setEnrollDate(LocalDate.parse(dateStr));
            } else {
                enrollment.setEnrollDate(LocalDate.now());
            }

            // Xử lý Enum Status
            // Form gửi lên String "ACTIVE", "DROPPED" -> convert sang Enum
            if (statusStr != null && !statusStr.isEmpty()) {
                enrollment.setStatus(Enrollment.EnrollmentStatus.valueOf(statusStr));
            } else {
                enrollment.setStatus(Enrollment.EnrollmentStatus.ACTIVE); // Default
            }

            // 2. Gọi DAO lưu
            if (enrollment.getId() != null && enrollment.getId() > 0) {
                enrollmentDAO.update(enrollment);
                req.getSession().setAttribute("message", "Cập nhật ghi danh thành công!");
            } else {
                enrollmentDAO.create(enrollment);
                req.getSession().setAttribute("message", "Tạo ghi danh mới thành công!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        // Redirect về trang danh sách
        resp.sendRedirect(req.getContextPath() + "/" + rolePath + "/enrollments");
    }

    private void deleteEnrollment(HttpServletRequest req, HttpServletResponse resp, String rolePath) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                // Giả sử delete nhận String ID theo interface CrudDAO
                enrollmentDAO.deleteById(idStr);
                req.getSession().setAttribute("message", "Đã xóa bản ghi danh!");
            } catch (Exception e) {
                req.getSession().setAttribute("error", "Xóa thất bại: " + e.getMessage());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/" + rolePath + "/enrollments");
    }
}