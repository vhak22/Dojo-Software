package controller.features.common;

import dao.StudentDAO;
import dao.UserDAO;
import dao.daoimpl.StudentDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Student;
import model.User;
import utils.ParamUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet({
        "/students",               // Trang danh sách
        "/admin/students",         // Hỗ trợ link admin sidebar/redirect
        "/student/create",         // Action tạo
        "/student/edit",           // Action load form sửa
        "/student/update",         // Action cập nhật
        "/student/delete"          // Action xóa
})
public class StudentManagementServlet extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String roleName = String.valueOf(currentUser.getRole().getRoleName());

        if (path.contains("edit")) {
            String id = ParamUtil.getString(req, "id", null);
            Student student = studentDAO.findById(id);
            req.setAttribute("studentForm", student);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
        }
        else if (path.contains("create")) {
            req.setAttribute("studentForm", new Student());
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
        }
        else if (path.contains("delete")) {
            deleteStudent(req, resp);
        }
        else {
            List<Student> list;
            if ("ADMIN".equals(roleName)) {
                utils.PaginationUtil.paginate(req, studentDAO, 20);
            }
            else if ("MASTER".equals(roleName)) {
                // Cần viết thêm hàm findByMasterId trong DAO
                // Logic: Tìm student có Enrollment thuộc Dojo mà Master này quản lý
//                list = studentDAO.findByMasterId(currentUser.getUserId());
                utils.PaginationUtil.paginate(req, studentDAO, 10);
            }
            else {
                utils.PaginationUtil.paginate(req, studentDAO, 5);
            }

            req.getRequestDispatcher("/views/admin/students/student-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        boolean isUpdate = path.contains("update");
        Student formStudent = isUpdate
                ? studentDAO.findById(ParamUtil.getString(req, "studentId", null))
                : new Student();

        try {
            if (formStudent == null) {
                formStudent = new Student();
            }
            formStudent.setStudentId(ParamUtil.getString(req, "studentId", null));
            formStudent.setFullName(ParamUtil.getString(req, "fullName", ""));
            formStudent.setBirthday(ParamUtil.getLocalDate(req, "birthday", "yyyy-MM-dd", null));
            formStudent.setGender(ParamUtil.getBoolean(req, "gender", null));
            formStudent.setRank(ParamUtil.getString(req, "rank", null));
            formStudent.setPhone(ParamUtil.getString(req, "phone", null));
            if (!isUpdate) {
                formStudent.setActive(true);
            }

            if (path.contains("create")) {
                if (studentDAO.findById(formStudent.getStudentId()) != null) {
                    req.setAttribute("error", "Mã học viên đã tồn tại!");
                    req.setAttribute("studentForm", formStudent);
                    req.setAttribute("isEdit", false);
                    req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
                    return;
                }
                studentDAO.create(formStudent);
                resp.sendRedirect(req.getContextPath() + "/students?message=create_success");
            } else if (path.contains("update")) {
                if (studentDAO.findById(formStudent.getStudentId()) == null) {
                    req.setAttribute("error", "Không tìm thấy môn sinh để cập nhật!");
                    req.setAttribute("studentForm", formStudent);
                    req.setAttribute("isEdit", true);
                    req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
                    return;
                }
                studentDAO.update(formStudent);
                resp.sendRedirect(req.getContextPath() + "/students?message=update_success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("studentForm", formStudent);
            req.setAttribute("isEdit", path.contains("update"));
            req.getRequestDispatcher("/views/admin/students/student-form.jsp").forward(req, resp);
        }
    }

    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = ParamUtil.getString(req, "id", null);
            Student student = studentDAO.findById(id);
            if (student != null) {
                student.setActive(false);
                studentDAO.update(student);
            }
            resp.sendRedirect(req.getContextPath() + "/students?message=delete_success");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/students?error=delete_fail");
        }
    }

}