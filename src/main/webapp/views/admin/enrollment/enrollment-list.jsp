<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> --%>
<%-- Bỏ fmt vì LocalDate Java 8 không dùng được với fmt:formatDate mặc định --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Ghi danh - Vovinam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            color: #e0e0e0;
            background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
            url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed;
            background-size: cover;
            /* Reset margin để sidebar không bị lệch */
            margin: 0;
            padding: 0;
        }

        /* --- CẤU HÌNH KHUNG SIDEBAR (WRAPPER) --- */
        .admin-sidebar-wrapper {
            width: 280px;
            height: 100vh;
            position: fixed !important; /* Cố định vị trí bên trái */
            top: 0;
            left: 0;
            z-index: 1000;
            background-color: rgba(20, 20, 20, 0.95);
            border-right: 1px solid #333;
            overflow-y: auto;
        }

        /* Style cho link bên trong Wrapper để đảm bảo hiển thị đúng */
        .admin-sidebar-wrapper .nav-link {
            color: #bbb;
            font-size: 1.1rem;
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
        }
        .admin-sidebar-wrapper .nav-link:hover,
        .admin-sidebar-wrapper .nav-link.active {
            background-color: #ff6600;
            color: white;
        }
        .admin-sidebar-wrapper .nav-link i {
            width: 25px;
            margin-right: 10px;
        }
        .admin-sidebar-wrapper .brand-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            font-size: 1.8rem;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
            padding-top: 20px;
        }
        .admin-sidebar-wrapper .mt-auto {
            padding: 20px;
        }

        /* --- CẤU HÌNH NỘI DUNG CHÍNH (BÊN PHẢI) --- */
        .main-content {
            margin-left: 280px; /* Đẩy nội dung sang phải */
            padding: 30px;
            min-height: 100vh;
            position: relative;
        }

        /* CSS cho Table */
        .table-dark {
            --bs-table-bg: rgba(30, 30, 30, 0.8);
        }

        /* Làm cho Card form hơi trong suốt (nếu dùng card ở trang này) */
        .card.bg-dark {
            background-color: rgba(33, 37, 41, 0.9) !important;
        }
    </style>
</head>
<body>

<div class="admin-sidebar-wrapper">
    <jsp:include page="/views/admin/layout/sidebar.jsp" />
</div>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-white" style="font-family: 'Oswald', sans-serif;">DANH SÁCH GHI DANH (ENROLLMENTS)</h2>
        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments/create" class="btn btn-warning fw-bold">
            <i class="fa-solid fa-user-plus"></i> Ghi danh mới
        </a>
    </div>

    <div class="table-responsive">
        <table class="table table-dark table-hover border border-secondary">

            <thead class="table-light text-dark">
            <tr>
                <th>ID</th>
                <th>Môn sinh</th>
                <th>Võ đường</th>
                <th>Ngày ghi danh</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="en" items="${enrollments}">
                <tr>
                    <td>${en.id}</td>

                    <td>
                        <div class="fw-bold text-info">${en.student.fullName}</div>
                        <small class="text-muted">ID: ${en.student.studentId}</small>
                    </td>

                    <td>${en.dojo.name}</td>

                    <td>${en.enrollDate}</td>

                    <td>
                        <c:choose>
                            <c:when test="${en.status == 'ACTIVE'}">
                                <span class="badge bg-success">Đang học</span>
                            </c:when>
                            <c:when test="${en.status == 'TRIAL'}">
                                <span class="badge bg-warning text-dark">Học thử</span>
                            </c:when>
                            <c:when test="${en.status == 'DROPPED'}">
                                <span class="badge bg-danger">Đã nghỉ</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${en.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments/edit?id=${en.id}" class="btn btn-sm btn-outline-primary">
                            <i class="fa-solid fa-pen"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments/delete?id=${en.id}"
                           class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa bản ghi danh này?')">
                            <i class="fa-solid fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>