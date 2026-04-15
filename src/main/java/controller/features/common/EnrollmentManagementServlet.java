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
import utils.ParamUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

// Map cho cả 3 role để tái sử dụng logic
@WebServlet({
        "/enrollments", "/enrollments/create", "/enrollments/edit", "/enrollments/update", "/enrollments/delete", "/enrollments/save",
        "/admin/enrollments", "/admin/enrollments/create", "/admin/enrollments/edit", "/admin/enrollments/update", "/admin/enrollments/delete", "/admin/enrollments/save",
        "/master/enrollments", "/master/enrollments/create", "/master/enrollments/edit", "/master/enrollments/update", "/master/enrollments/delete", "/master/enrollments/save",
        "/staff/enrollments", "/staff/enrollments/create", "/staff/enrollments/edit", "/staff/enrollments/update", "/staff/enrollments/delete", "/staff/enrollments/save"
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
        // Lưu ý: Nếu là Master/Staff, lọc danh sách này chỉ hiển thị Dojo của họ
        // Ví dụ: if (rolePath.equals("master")) items = enrollmentDAO.findByMaster(userId);
        // Ở đây lấy tất cả cho đơn giản:
        List<Enrollment> items = enrollmentDAO.findAll();

        req.setAttribute("enrollments", items);

        // Forward về file jsp list tương ứng, ví dụ: /views/admin/enrollment/enrollment-list.jsp
        // Giả sử bạn để chung view hoặc copy ra từng folder
        // Ở đây mình giả định cấu trúc views/admin/enrollment-list.jsp (như bạn cung cấp trước đó)
        // Nếu file nằm trong thư mục con, hãy sửa đường dẫn bên dưới
        req.getRequestDispatcher("/views/" + rolePath + "/enrollment/enrollment-list.jsp").forward(req, resp);
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, String rolePath) throws ServletException, IOException {
        Integer id = ParamUtil.getInt(req, "id", null);
        Enrollment enrollment = new Enrollment();

        if (id != null) {
            // Chế độ Edit
            try {
                enrollment = enrollmentDAO.findById(id);
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
            Integer id = ParamUtil.getInt(req, "id", null);
            String studentId = ParamUtil.getString(req, "studentId", null);
            String dojoId = ParamUtil.getString(req, "dojoId", null);
            LocalDate enrollDate = ParamUtil.getLocalDate(req, "enrollmentDate", "yyyy-MM-dd", LocalDate.now());
            Enrollment.EnrollmentStatus status = ParamUtil.getEnum(
                    req,
                    "status",
                    Enrollment.EnrollmentStatus.class,
                    Enrollment.EnrollmentStatus.ACTIVE
            );

            Enrollment enrollment = new Enrollment();

            // Xử lý ID (Update)
            if (id != null) {
                enrollment.setId(id);
            }

            // Xử lý Student (Foreign Key)
            Student student = studentDAO.findById(studentId);
            enrollment.setStudent(student);

            // Xử lý Dojo (Foreign Key)
            Dojo dojo = dojoDAO.findById(dojoId);
            enrollment.setDojo(dojo);

            // Xử lý Date
            enrollment.setEnrollDate(enrollDate);
            enrollment.setStatus(status);

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
        Integer id = ParamUtil.getInt(req, "id", null);
        if (id != null) {
            try {
                enrollmentDAO.deleteById(id);
                req.getSession().setAttribute("message", "Đã xóa bản ghi danh!");
            } catch (Exception e) {
                req.getSession().setAttribute("error", "Xóa thất bại: " + e.getMessage());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/" + rolePath + "/enrollments");
    }
}