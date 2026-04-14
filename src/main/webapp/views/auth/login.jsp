<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Vovinam Thu Duc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link
            href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap"
            rel="stylesheet">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #000 url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center/cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
            max-width: 400px;
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
        }

        .btn-custom:hover {
            background-color: #3b6ccf;
            color: white;
        }

        /* Thêm style cho nút Đăng ký */
        .btn-register {
            background-color: transparent;
            color: #ff6600;
            font-weight: 700;
            text-transform: uppercase;
            width: 100%;
            padding: 10px;
            border: 1px solid #ff6600;
            margin-top: 15px;
            transition: all 0.3s ease;
        }

        .btn-register:hover {
            background-color: #ff6600;
            color: white;
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
    <h2 class="login-title">Đăng Nhập</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-msg">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="mb-3">
            <label for="userId" class="form-label text-white-50">Tài khoản (User ID)</label>
            <input type="text" class="form-control" id="userId" name="userId"
                   placeholder="Nhập ID (VD: AD001)" required>
        </div>
        <div class="mb-4">
            <label for="password" class="form-label text-white-50">Mật khẩu</label>
            <input type="password" class="form-control" id="password" name="password"
                   placeholder="Nhập mật khẩu" required>
            <div class="text-end mt-1">
                <a href="${pageContext.request.contextPath}/forgot-password" class="small text-decoration-none">Quên mật khẩu?</a>
            </div>
        </div>

        <button type="submit" class="btn btn-custom">Truy cập hệ thống</button>

        <div class="divider small">hoặc</div>
        <a href="${pageContext.request.contextPath}/auth/google" class="btn btn-custom text-decoration-none d-block text-center">Đăng nhập với Google</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-register text-decoration-none d-block text-center mt-2">Đăng ký tài khoản</a>

        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/home"
               class="text-decoration-none text-white-50 small">Quay về trang chủ</a>
        </div>
    </form>
</div>
</body>

</html>