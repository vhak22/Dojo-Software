<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Hệ thống Võ đường</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #000 url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center/cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0; /* Thêm padding để trên mobile không bị dính sát mép */
        }

        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1;
        }

        .login-card {
            position: relative;
            z-index: 2;
            background-color: rgba(20, 20, 20, 0.9);
            border: 1px solid #333;
            border-radius: 8px;
            width: 100%;
            max-width: 450px; /* Tăng chiều rộng lên một chút cho form đăng ký */
            padding: 40px;
            color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
        }

        .login-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            text-transform: uppercase;
            font-size: 2rem;
            margin-bottom: 20px;
            text-align: center;
        }

        .form-control {
            background-color: #333;
            border: 1px solid #444;
            color: white;
        }

        .form-control:focus {
            background-color: #444;
            color: white;
            border-color: #ff6600;
            box-shadow: none;
        }

        .btn-custom {
            background-color: #467df4;
            color: white;
            font-weight: 700;
            text-transform: uppercase;
            width: 100%;
            padding: 10px;
            border: none;
            margin-top: 10px;
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            background-color: #3b6ccf;
            color: white;
        }

        /* Nút Đăng ký/Đăng nhập bằng Google */
        .btn-google {
            background-color: #ffffff;
            color: #333;
            font-weight: 600;
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 4px;
            margin-top: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: background-color 0.3s ease;
            text-decoration: none;
        }

        .btn-google:hover {
            background-color: #f1f1f1;
            color: #000;
        }

        .btn-google i {
            color: #ea4335; /* Màu đỏ đặc trưng của icon Google */
            font-size: 1.2rem;
        }

        .error-msg {
            color: #ff4d4d;
            text-align: center;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }

        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin-top: 20px;
            color: #aaa;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #444;
        }

        .divider:not(:empty)::before {
            margin-right: .5em;
        }

        .divider:not(:empty)::after {
            margin-left: .5em;
        }
    </style>
</head>

<body>
<div class="overlay"></div>
<div class="login-card">
    <h2 class="login-title">Đăng Ký</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="mb-3">
            <label for="fullname" class="form-label text-white-50">Họ và tên</label>
            <input type="text" class="form-control" id="fullname" name="fullname"
                   placeholder="Nhập họ và tên" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label text-white-50">Email</label>
            <input type="email" class="form-control" id="email" name="email"
                   placeholder="Nhập địa chỉ email" required>
        </div>

        <div class="mb-3">
            <label for="userId" class="form-label text-white-50">Tài khoản (User ID)</label>
            <input type="text" class="form-control" id="userId" name="userId"
                   placeholder="Nhập ID (VD: KHANH001)" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label text-white-50">Mật khẩu</label>
            <input type="password" class="form-control" id="password" name="password"
                   placeholder="Nhập mật khẩu" required>
        </div>

        <div class="mb-4">
            <label for="confirmPassword" class="form-label text-white-50">Xác nhận mật khẩu</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                   placeholder="Nhập lại mật khẩu" required>
        </div>

        <button type="submit" class="btn btn-custom">Tạo tài khoản</button>
    </form>

    <div class="divider small">hoặc</div>

    <a href="${pageContext.request.contextPath}/auth/google" class="btn btn-google">
        <i class="fa-brands fa-google"></i> Đăng ký bằng Google
    </a>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-white-50 small">Đã có tài khoản? Đăng nhập ngay</a>
        <br>
        <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-white-50 small mt-2 d-inline-block">Quay về trang chủ</a>
    </div>
</div>
</body>

</html>