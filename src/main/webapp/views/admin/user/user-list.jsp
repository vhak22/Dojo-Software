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

<jsp:include page="/views/admin/layout/sidebar.jsp" />


<div class="main-content">
    <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ NGƯỜI DÙNG</h2>

    <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="form-inline mb-3">
        <div class="input-group">
            <input type="text" name="keyword" class="form-control" value="${keyword}" placeholder="Tìm mã, tên, email...">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </div>
    </form>

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
            <c:forEach var="u" items="${items}">
                <tr class="${!u.active ? 'opacity-50' : ''}">
                    <td>${u.userId}</td>
                    <td>${u.fullname}</td>
                    <td>${u.email}</td>
                    <td>
                        <c:choose>
                            <c:when test="${u.role.roleName == 'ADMIN'}"><span class="badge bg-danger">ADMIN</span></c:when>
                            <c:when test="${u.role.roleName == 'MASTER'}"><span class="badge bg-primary">MASTER</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">STAFF</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${u.active}"><span class="badge bg-success">Hoạt động</span></c:if>
                        <c:if test="${!u.active}"><span class="badge bg-secondary">Đã khóa</span></c:if>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${u.userId}" class="btn btn-sm btn-primary">Sửa</a>
                        <c:if test="${u.active}">
                            <a href="${pageContext.request.contextPath}/admin/user/delete?id=${u.userId}" class="btn btn-sm btn-danger" onclick="return confirm('Khóa tài khoản này?')">Khóa</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty items}">
                <tr>
                    <td colspan="5" class="text-center">Không tìm thấy kết quả nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">

                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?keyword=${keyword}&page=${currentPage - 1}">Previous</a>
                </li>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?keyword=${keyword}&page=${i}">${i}</a>
                    </li>
                </c:forEach>

                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?keyword=${keyword}&page=${currentPage + 1}">Next</a>
                </li>

            </ul>
        </nav>
    </c:if>
</div>

</body>
</html>