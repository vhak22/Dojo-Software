<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Vovinam Thu Duc</title>
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
            transition: all 0.3s ease;
        }

        .btn-custom:hover {
            background-color: #3b6ccf;
            color: white;
        }

        .error-msg {
            color: #ff4d4d;
            text-align: center;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }

        .success-msg {
            color: #28a745;
            text-align: center;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
<div class="overlay"></div>
<%-- Copy phần CSS và HTML từ forgot-password.jsp và thay thế phần form --%>
<div class="login-card">
    <h2 class="login-title">Đặt Mật Khẩu Mới</h2>

    <c:if test="${not empty error}">
        <div class="error-msg">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/reset-password" method="post">
        <div class="mb-4">
            <label for="newPassword" class="form-label text-white-50">Mật khẩu mới</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
        </div>
        <button type="submit" class="btn btn-custom">Đổi Mật Khẩu</button>
    </form>
</div>
</body>

</html>