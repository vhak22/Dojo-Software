package controller.features.common;


import dao.StudentDAO;
import dao.daoimpl.StudentDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Student;
import org.apache.commons.beanutils.BeanUtils; // Cần thư viện commons-beanutils

import java.io.IOException;
import java.util.List;

@WebServlet({
        "/student",
        "/student/create",
        "/student/update",
        "/student/enroll"
})
public class StudentManagementServlet extends HttpServlet {

    private StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.contains("edit")) {
            // Load thông tin user lên form để sửa
            String id = req.getParameter("id");
            Student student = studentDAO.findById(id);
            req.setAttribute("studentForm", student);
            req.setAttribute("isEdit", true); // Đánh dấu là đang sửa
            //sửa đường dẫn lại
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        } else if (path.contains("create")) {
            // Mở form trống để tạo mới
            req.setAttribute("isEdit", false);
            //sửa đường dẫn lại
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        } else if (path.contains("delete")) {
            // Xóa user
            deleteStudent(req, resp);
        } else {
            // Mặc định: Xem danh sách
            List<Student> list = studentDAO.findAll();
            req.setAttribute("items", list);
            req.getRequestDispatcher("/views/admin/user-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        // Xử lý tiếng Việt
        req.setCharacterEncoding("UTF-8");

        try {
            Student formStudent = new Student();
            BeanUtils.populate(formStudent, req.getParameterMap()); // Mapping dữ liệu từ form vào object

            if (path.contains("create")) {
                if (studentDAO.findById(formStudent.getStudentId()) != null) {
                    req.setAttribute("message", "Student ID đã tồn tại!");
                    //sửa đường dẫn
                    req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
                    return;
                }
                studentDAO.create(formStudent);
                resp.sendRedirect(req.getContextPath() + "/Students?message=create_success");

            } else if (path.contains("update")) {
                studentDAO.update(formStudent);
                resp.sendRedirect(req.getContextPath() + "/Students?message=update_success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
    }

    private void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            //Soft delete
            Student student = studentDAO.findById(id);
            student.setActive(false);
            studentDAO.update(student);

            resp.sendRedirect(req.getContextPath() + "/Students?message=delete_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/Students?error=delete_fail");
        }
    }
}