package controller.features.common;

import dao.DojoDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dojo;
import model.Role;
import model.User;
import org.apache.commons.beanutils.BeanUtils; // Cần thư viện commons-beanutils

import java.io.IOException;
import java.util.List;

@WebServlet({
        "/Dojos",           // Xem danh sách
        "/Dojo/create",     // Tạo mới
        "/Dojo/delete",     // Xóa
        "/Dojo/edit"        // Load form sửa
})
public class DojoManagementServlet extends HttpServlet {

    private DojoDAO dojoDAO = new DojoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.contains("edit")) {
            // Load thông tin user lên form để sửa
            String id = req.getParameter("id");
            Dojo dojo = dojoDAO.findById(id);
            req.setAttribute("dojoForm", dojo);
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
            deleteDojo(req, resp);
        } else {
            // Mặc định: Xem danh sách
            List<Dojo> list = dojoDAO.findAll();
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
            Dojo formDojo = new Dojo();
            BeanUtils.populate(formDojo, req.getParameterMap()); // Mapping dữ liệu từ form vào object

            if (path.contains("create")) {
                if (dojoDAO.findById(formDojo.getDojoId()) != null) {
                    req.setAttribute("message", "Dojo ID đã tồn tại!");
                    req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
                    return;
                }
                dojoDAO.create(formDojo);
                resp.sendRedirect(req.getContextPath() + "/Dojos?message=create_success");

            } else if (path.contains("update")) {
                dojoDAO.update(formDojo);
                resp.sendRedirect(req.getContextPath() + "/Dojos?message=update_success");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/user-form.jsp").forward(req, resp);
        }
    }

    private void deleteDojo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            //Soft delete
            Dojo dojo = dojoDAO.findById(id);
            dojo.setActive(false);
            dojoDAO.update(dojo);

            resp.sendRedirect(req.getContextPath() + "/Dojos?message=delete_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/Dojos?error=delete_fail");
        }
    }
}