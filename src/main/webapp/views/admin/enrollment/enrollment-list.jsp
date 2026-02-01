<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Ghi danh - Vovinam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Roboto', sans-serif; color: #e0e0e0; background: linear-gradient(rgba(0, 0, 0, 0.9), rgba(0, 0, 0, 0.9)), url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg'); background-size: cover; }
        .sidebar { width: 280px; background-color: rgba(20, 20, 20, 0.95); height: 100vh; position: fixed; padding: 20px; border-right: 1px solid #333; }
        .main-content { margin-left: 280px; padding: 30px; }
        .nav-link { color: #aaa; padding: 12px 15px; border-radius: 8px; margin-bottom: 5px; transition: 0.3s; }
        .nav-link:hover, .nav-link.active { background: #ff6600; color: white; }
        .table-dark { --bs-table-bg: rgba(30, 30, 30, 0.8); }
    </style>
</head>
<body>

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
                    <td>${en.enrollmentId}</td>
                    <td>
                        <div class="fw-bold text-info">${en.student.fullName}</div>
                        <small class="text-muted">ID: ${en.student.studentId}</small>
                    </td>
                    <td>${en.dojo.name}</td>
                    <td><fmt:formatDate value="${en.enrollmentDate}" pattern="dd/MM/yyyy"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${en.status == 'Active'}">
                                <span class="badge bg-success">Đang học</span>
                            </c:when>
                            <c:when test="${en.status == 'Completed'}">
                                <span class="badge bg-primary">Hoàn thành</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">Đã nghỉ</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments/edit?id=${en.enrollmentId}" class="btn btn-sm btn-outline-primary">
                            <i class="fa-solid fa-pen"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments/delete?id=${en.enrollmentId}"
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