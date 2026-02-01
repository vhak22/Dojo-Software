package controller.features.common;

import dao.DojoDAO;
import dao.daoimpl.DojoDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dojo;
import org.apache.commons.beanutils.BeanUtils;

import java.io.IOException;
import java.util.List;

@WebServlet({
        "/dojos",           // Xem danh sách
        "/dojo/create",     // Form tạo mới & Xử lý tạo
        "/dojo/edit",       // Load form sửa
        "/dojo/update",     // Xử lý cập nhật
        "/dojo/delete"      // Xóa (Soft delete)
})
public class DojoManagementServlet extends HttpServlet {

    private DojoDAO dojoDAO = new DojoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.contains("edit")) {
            String id = req.getParameter("id");
            Dojo dojo = dojoDAO.findById(id);
            req.setAttribute("dojo", dojo);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
        } else if (path.contains("create")) {
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
        } else if (path.contains("delete")) {
            deleteDojo(req, resp);
        } else {
            // Mặc định xem danh sách
            List<Dojo> list = dojoDAO.findAll();
            req.setAttribute("items", list);
            req.getRequestDispatcher("/views/admin/dojo/dojo-list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        try {
            Dojo formDojo = new Dojo();
            BeanUtils.populate(formDojo, req.getParameterMap());

            if (path.contains("create")) {
                if (dojoDAO.findById(formDojo.getDojoId()) != null) {
                    req.setAttribute("error", "Mã Dojo đã tồn tại!");
                    req.setAttribute("isEdit", false);
                    req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
                    return;
                }
                dojoDAO.create(formDojo);
                resp.sendRedirect(req.getContextPath() + "/admin/dojos?message=create_success");
            } else if (path.contains("update")) {
                dojoDAO.update(formDojo);
                resp.sendRedirect(req.getContextPath() + "/admin/dojos?message=update_success");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
        }
    }

    private void deleteDojo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String id = req.getParameter("id");
            Dojo dojo = dojoDAO.findById(id);
            if (dojo != null) {
                dojo.setActive(false); // Soft delete
                dojoDAO.update(dojo);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/dojos?message=delete_success");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/dojos?error=delete_fail");
        }
    }
}