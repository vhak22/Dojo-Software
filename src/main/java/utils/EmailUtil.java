package utils;

// Khai báo đúng chuẩn jakarta
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    public static void sendEmail(String toEmail, String subject, String body) {
        // 1. Tài khoản email của bạn
        final String fromEmail = "khanhnguyeen2208@gmail.com";
        // BẮT BUỘC dùng "Mật khẩu ứng dụng" (16 ký tự) của Google, KHÔNG dùng mật khẩu đăng nhập
        final String password = "qugckvelwhppcvzy";

        // 2. Cấu hình SMTP của Google
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // Máy chủ SMTP
        props.put("mail.smtp.port", "587"); // Cổng TLS
        props.put("mail.smtp.auth", "true"); // Phải xác thực
        props.put("mail.smtp.starttls.enable", "true"); // Bật TLS

        // 3. Khởi tạo Session với Authenticator
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // 4. Soạn tin nhắn
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(body, "text/plain; charset=UTF-8");
            // 5. Gửi
            Transport.send(message);
            System.out.println("Gửi email thành công tới: " + toEmail);

        } catch (Exception e) {
            System.out.println("Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
        }
    }
}