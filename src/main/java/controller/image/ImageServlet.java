package controller.image;

import utils.XImg;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/image/*") // URL sẽ là /image/ten_file.jpg
public class ImageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // Lấy tên file từ URL (phần sau /image/)
        String filename = req.getPathInfo().substring(1);

        File file = new File(XImg.getUploadDir(), filename);

        if (file.exists()) {
            resp.setContentType(getServletContext().getMimeType(filename));
            resp.setContentLength((int) file.length());
            Files.copy(file.toPath(), resp.getOutputStream());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND); // 404 nếu không thấy ảnh
        }
    }
}