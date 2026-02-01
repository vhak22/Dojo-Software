package controller.admin;

import dao.UserDAO;
import dao.daoimpl.UserDAOImpl;
import model.User;
import utils.XImg;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/update-profile")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String userId = req.getParameter("userId");
            Part filePart = req.getPart("avatarFile");

            // 1. Lưu file vào ổ cứng
            String savedFileName = XImg.saveFile(filePart);

            // 2. Cập nhật vào Database
            User user = userDAO.findById(userId);
            if (user != null && savedFileName != null) {
                user.setAvatar(savedFileName);
                userDAO.update(user);
            }

            resp.sendRedirect("home");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi upload ảnh");
        }
    }
}