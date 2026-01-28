package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class XImg {
    // Đường dẫn lưu ảnh trên máy tính (Nên để ngoài project để không bị mất khi redeploy)
    // Ví dụ trên Windows: C:/DojoUploads/
    private static final String UPLOAD_DIR = "C:" + File.separator + "DojoUploads";

    public static String saveFile(Part filePart) throws IOException {
        // Tạo thư mục nếu chưa tồn tại
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        // Lấy tên file gốc
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        // Kiểm tra nếu người dùng không chọn file
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Tạo tên file ngẫu nhiên để tránh trùng lặp (vd: avatar.jpg -> 123e4567-e89b...jpg)
        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

        // Lưu file vào ổ cứng
        Path filePath = Paths.get(UPLOAD_DIR, uniqueFileName);
        Files.copy(filePart.getInputStream(), filePath);

        return uniqueFileName; // Trả về tên file để lưu vào DB
    }

    public static String getUploadDir() {
        return UPLOAD_DIR;
    }
}