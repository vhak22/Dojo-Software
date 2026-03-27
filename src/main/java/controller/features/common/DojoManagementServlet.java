package controller.features.common;

import dao.DojoDAO;
import dao.UserDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Dojo;
import model.Role;
import model.User;
import org.apache.commons.beanutils.BeanUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

// [SỬA LỖI 4] Cập nhật đường dẫn có /admin để khớp với Redirect và cấu trúc chung
@WebServlet({
        "/dojos",
        "/dojo/create",
        "/dojo/edit",
        "/dojo/update",
        "/dojo/delete"
})
public class DojoManagementServlet extends HttpServlet {

    private DojoDAO dojoDAO = new DojoDAOImpl();
    private UserDAO userDAO = new UserDAOImpl(); // Thêm DAO User để lấy danh sách Võ sư

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        User currentUser = (User) req.getSession().getAttribute("currentUser");

        if (path.contains("edit")) {
            String id = req.getParameter("id");
            Dojo dojo = dojoDAO.findById(id);

            // [SỬA LỖI 2] Đổi tên attribute thành "dojoForm" cho khớp với JSP
            req.setAttribute("dojoForm", dojo);
            req.setAttribute("isEdit", true);

            // [SỬA LỖI 3] Chuẩn bị danh sách Võ sư (Master) cho dropdown
            prepareMasterList(req);

            req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
        }
        else if (path.contains("create")) {
            req.setAttribute("isEdit", false);

            // [SỬA LỖI 3] Cũng cần danh sách Võ sư khi tạo mới
            prepareMasterList(req);

            req.getRequestDispatcher("/views/admin/dojo/dojo-form.jsp").forward(req, resp);
        }
        else if (path.contains("delete")) {
            deleteDojo(req, resp);
        }
        else {
            // --- SỬA ĐOẠN HIỂN THỊ DANH SÁCH ---
            List<Dojo> list;
            String roleName =String.valueOf(currentUser.getRole().getRoleName());//getRole() == 1 (nhows 1 là admin)

            if ("ADMIN".equalsIgnoreCase(roleName)) {
                list = dojoDAO.findAll();
            } else if ("MASTER".equalsIgnoreCase(roleName)) {
                // [QUAN TRỌNG] Gọi hàm DAO mới thay vì currentUser.getManagedDojos()
                // Điều này giúp lấy dữ liệu tươi mới và tránh lỗi LazyInitializationException
                list = dojoDAO.findByMasterId(currentUser.getUserId());
            } else {
                list = new ArrayList<>();
            }

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

            // Xử lý Master (Do BeanUtils chỉ map được ID, ta cần set Object User hoàn chỉnh)
            String masterId = req.getParameter("masterId");
            if (masterId != null && !masterId.isEmpty()) {
                User master = new User();
                master.setUserId(masterId); // Chỉ cần set ID để Hibernate/JPA hiểu khóa ngoại
                formDojo.setMaster(master);
            }

            // Xử lý Checkbox Active
            boolean isActive = req.getParameter("active") != null;
            formDojo.setActive(isActive);

            if (path.contains("create")) {
                if (dojoDAO.findById(formDojo.getDojoId()) != null) {
                    req.setAttribute("error", "Mã Dojo đã tồn tại!");
                    req.setAttribute("isEdit", false);
                    prepareMasterList(req); // Load lại list master nếu lỗi
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
            try {
                prepareMasterList(req); // Load lại list master để tránh lỗi view
            } catch (Exception ex) {}
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

    // Hàm phụ trợ để lấy danh sách User có role là MASTER
    private void prepareMasterList(HttpServletRequest req) {
        UserDAO userDAO = new UserDAOImpl();
        List<User> allUsers = userDAO.findAll();
        List<User> masters = new ArrayList<>();
        for (User u : allUsers) {
            // Kiểm tra Role ID = 2 hoặc Role Name = MASTER (tùy DB của bạn)
            if (u.getRole().getId() == 2 || "MASTER".equalsIgnoreCase(String.valueOf(u.getRole().getRoleName()))) {
                masters.add(u);
            }
        }
        req.setAttribute("masters", masters);
    }
}

