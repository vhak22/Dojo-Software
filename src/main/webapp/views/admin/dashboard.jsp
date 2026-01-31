<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-5">
    <h1>Xin chào Admin: ${sessionScope.currentUser.fullname}</h1>
    <p>Email: ${sessionScope.currentUser.email}</p>
    <hr>
    <div class="row">
        <div class="col-md-4">
            <div class="card bg-secondary text-white">
                <div class="card-body">
                    <h3>Quản lý Users</h3>
                    <p>Thêm, xóa, sửa người dùng</p>
                    <a href="#" class="btn btn-light">Truy cập</a>
                </div>
            </div>
        </div>
    </div>
    <br>
    <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Đăng xuất</a>
</div>
</body>
</html>