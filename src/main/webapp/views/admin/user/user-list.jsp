<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            color: #e0e0e0;
            /* --- CẬP NHẬT BACKGROUND --- */
            /* Sử dụng lớp phủ đen mờ (0.85) lên trên hình nền */
            background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
            url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed;
            background-size: cover;
            /* --------------------------- */
        }
        .sidebar {
            width: 280px;
            background-color: rgba(20, 20, 20, 0.95); /* Giữ nền sidebar hơi trong suốt */
            border-right: 1px solid #333;
            display: flex;
            flex-direction: column;
            padding: 20px;
            height: 100vh;
            position: fixed;
            top: 0; left: 0;
            z-index: 1000;
        }
        .brand-title {
            font-family: 'Oswald', sans-serif; color: #ff6600; font-size: 1.8rem;
            text-transform: uppercase; margin-bottom: 30px; text-align: center;
        }
        .nav-link {
            color: #bbb; font-size: 1.1rem; padding: 12px 15px;
            border-radius: 5px; margin-bottom: 5px; transition: all 0.3s;
        }
        .nav-link:hover, .nav-link.active {
            background-color: #ff6600; color: white;
        }
        .nav-link i { width: 25px; margin-right: 10px; }

        .main-content {
            margin-left: 280px;
            padding: 30px;
            min-height: 100vh;
        }
        /* Làm cho bảng hơi trong suốt để lộ nền một chút */
        .table-dark {
            --bs-table-bg: rgba(33, 37, 41, 0.9);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand-title"><i class="fa-solid fa-dragon"></i>Vovinam Thu Duc</div>

    <nav class="nav flex-column">
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-chart-line"></i> Dashboard
        </a>

        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
            <i class="fa-solid fa-users-gear"></i> Manage Users
        </a>

        <a class="nav-link" href="${pageContext.request.contextPath}/dojo">
            <i class="fa-solid fa-torii-gate"></i> Manage Dojos
        </a>

        <div class="has-submenu">
            <a class="nav-link" href="#"><i class="fa-solid fa-clipboard-list"></i> Enrollments (Đăng kí nhập học)</a>
            <div class="sub-menu">
                <a class="nav-link text-sm" href="#" style="font-size: 0.9rem;">
                    <i class="fa-solid fa-arrow-turn-up fa-rotate-90"></i> Manage Students
                </a>
            </div>
        </div>

        <div class="mt-auto">
            <hr class="text-white">
            <div class="d-flex align-items-center text-white mb-3">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.fullname}&background=ff6600&color=fff" class="rounded-circle me-2" width="40">
                <div>
                    <div class="fw-bold">${sessionScope.currentUser.fullname}</div>
                    <small class="text-muted">Administrator</small>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100">Đăng xuất</a>
        </div>
    </nav>
</div>

<div class="main-content">
    <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ NGƯỜI DÙNG</h2>

    <a href="${pageContext.request.contextPath}/admin/user/create" class="btn btn-success mb-3">
        <i class="fa-solid fa-plus"></i> Thêm User Mới
    </a>

    <c:if test="${not empty param.message}">
        <div class="alert alert-success">Thao tác thành công!</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">Có lỗi xảy ra!</div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-dark table-striped table-hover border border-secondary">
            <thead>
            <tr>
                <th>ID</th>
                <th>Họ và Tên</th>
                <th>Email</th>
                <th>Vai trò</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
                <tr class="${!item.active ? 'opacity-50' : ''}">
                    <td>${item.userId}</td>
                    <td>${item.fullname}</td>
                    <td>${item.email}</td>
                    <td>
                        <c:choose>
                            <c:when test="${item.role.roleName == 'ADMIN'}"><span class="badge bg-danger">ADMIN</span></c:when>
                            <c:when test="${item.role.roleName == 'MASTER'}"><span class="badge bg-primary">MASTER</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">STAFF</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${item.active}"><span class="badge bg-success">Hoạt động</span></c:if>
                        <c:if test="${!item.active}"><span class="badge bg-secondary">Đã khóa</span></c:if>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${item.userId}" class="btn btn-sm btn-primary">Sửa</a>
                        <c:if test="${item.active}">
                            <a href="${pageContext.request.contextPath}/admin/user/delete?id=${item.userId}" class="btn btn-sm btn-danger" onclick="return confirm('Khóa tài khoản này?')">Khóa</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>