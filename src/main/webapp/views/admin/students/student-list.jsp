<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật User' : 'Thêm User'} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            color: #e0e0e0;
            /* --- CẬP NHẬT BACKGROUND --- */
            background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
            url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed;
            background-size: cover;
            /* --------------------------- */
        }
        .sidebar {
            width: 280px; background-color: rgba(20, 20, 20, 0.95); border-right: 1px solid #333;
            display: flex; flex-direction: column; padding: 20px; height: 100vh; position: fixed; top: 0; left: 0;
        }
        .brand-title { font-family: 'Oswald', sans-serif; color: #ff6600; font-size: 1.8rem; text-transform: uppercase; margin-bottom: 30px; text-align: center; }
        .nav-link { color: #bbb; font-size: 1.1rem; padding: 12px 15px; border-radius: 5px; margin-bottom: 5px; transition: all 0.3s; }
        .nav-link:hover, .nav-link.active { background-color: #ff6600; color: white; }
        .nav-link i { width: 25px; margin-right: 10px; }

        .main-content { margin-left: 280px; padding: 30px; min-height: 100vh; }

        /* Làm cho Card form hơi trong suốt */
        .card.bg-dark {
            background-color: rgba(33, 37, 41, 0.9) !important;
        }
    </style>
</head>
<body>

<jsp:include page="/views/admin/layout/sidebar.jsp" />

<div class="main-content">
    <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ MÔN SINH</h2>
    <a href="${pageContext.request.contextPath}/student/create" class="btn btn-success mb-3">
        <i class="fa-solid fa-plus"></i> Thêm Môn Sinh Mới
    </a>

    <div class="table-responsive">
        <table class="table table-dark table-striped table-hover border border-secondary">
            <thead>
            <tr>
                <th>Mã môn sinh</th>
                <th>Họ và Tên</th>
                <th>Cấp đai</th>
                <th>Số điện thoại</th>
                <th>Giới tính</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
                <tr>
                    <td>${item.studentId}</td>
                    <td>${item.fullName}</td>
                    <td><span class="badge bg-info text-dark">${item.rank}</span></td>
                    <td>${item.phone}</td>
                    <td>${item.gender ? 'Nam' : 'Nữ'}</td> <td>
                    <a href="${pageContext.request.contextPath}/student/edit?id=${item.studentId}" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/student/delete?id=${item.studentId}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa môn sinh này?')">Xóa</a>
                </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>