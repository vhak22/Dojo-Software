package controller.features.common;

import dao.StudentDAO;
import dao.daoimpl.StudentDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Student;
import model.User;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.converters.DateTimeConverter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({
        "/students",          // Trang danh sách
        "/student/create",          // Action tạo (giữ nguyên hoặc thêm /admin/ tùy bạn)
        "/student/edit",            // Action load form sửa
        "/student/update",          // Action cập nhật
        "/student/delete"           // Action xóa
})
public class StudentManagementServlet extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String roleName = String.valueOf(currentUser.getRole().getRoleName());

        if (path.contains("edit")) {
            String id = req.getParameter("id");
            Student student = studentDAO.findById(id);
            req.setAttribute("studentForm", student);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
        } else if (path.contains("create")) {
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
        } else if (path.contains("delete")) {
            deleteStudent(req, resp);
        } else {
            List<Student> list;
            if ("ADMIN".equals(roleName)) {
                list = studentDAO.findAll();
            } else if ("MASTER".equals(roleName)) {
                // Cần viết thêm hàm findByMasterId trong DAO
                // Logic: Tìm student có Enrollment thuộc Dojo mà Master này quản lý
                list = studentDAO.findByMasterId(currentUser.getUserId());
            } else {
                list = new ArrayList<>(); // Staff logic tùy chỉnh
            }
            req.setAttribute("items", list);
            req.getRequestDispatcher("/views/admin/students/student-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        try {
            org.apache.commons.beanutils.converters.DateConverter dtConverter = new org.apache.commons.beanutils.converters.DateConverter(null);
            dtConverter.setPattern("yyyy-MM-dd");
            org.apache.commons.beanutils.ConvertUtils.register(dtConverter, java.util.Date.class);
            Student formStudent = new Student();
            // Đăng ký converter cho ngày tháng nếu cần (Java 8 LocalDate)
            BeanUtils.populate(formStudent, req.getParameterMap());

            if (path.contains("create")) {
                if (studentDAO.findById(formStudent.getStudentId()) != null) {
                    req.setAttribute("error", "Mã học viên đã tồn tại!");
                    req.setAttribute("isEdit", false);
                    req.getRequestDispatcher("/views/admin/student/student-form.jsp").forward(req, resp);
                    return;
                }
                studentDAO.create(formStudent);
                resp.sendRedirect(req.getContextPath() + "/admin/students?message=create_success");
            } else if (path.contains("update")) {
                studentDAO.update(formStudent);
                resp.sendRedirect(req.getContextPath() + "/admin/students?message=update_success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/student/student-form.jsp").forward(req, resp);
        }
    }

    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            Student student = studentDAO.findById(id);
            if (student != null) {
                student.setActive(false);
                studentDAO.update(student);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/students?message=delete_success");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/students?error=delete_fail");
        }
    }
}