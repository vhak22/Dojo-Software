<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Võ đường - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Style giữ nguyên như user-list.jsp để đồng bộ UI */
        body { font-family: 'Roboto', sans-serif; color: #e0e0e0; background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)), url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed; background-size: cover; }
        .sidebar { width: 280px; background-color: rgba(20, 20, 20, 0.95); border-right: 1px solid #333; display: flex; flex-direction: column; padding: 20px; height: 100vh; position: fixed; top: 0; left: 0; z-index: 1000; }
        .main-content { margin-left: 280px; padding: 30px; min-height: 100vh; }
        .table-dark { --bs-table-bg: rgba(33, 37, 41, 0.9); }
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background-color: rgba(20, 20, 20, 0.95);
            border-right: 1px solid #333;
            display: flex;
            flex-direction: column;
            padding: 20px;
            height: 100vh;
            position: fixed;
        }
        .brand-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            font-size: 1.8rem;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
        }
        .nav-link {
            color: #bbb;
            font-size: 1.1rem;
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: all 0.3s;
        }
        .nav-link:hover, .nav-link.active {
            background-color: #ff6600;
            color: white;
            transform: translateX(5px);
        }
        .nav-link i { width: 25px; text-align: center; margin-right: 10px; }

        /* Sub-menu cho Enrollments -> Manage Students */
        .sub-menu {
            margin-left: 20px;
            border-left: 2px solid #444;
            padding-left: 10px;
            display: none; /* Ẩn mặc định */
        }
        .has-submenu:hover .sub-menu { display: block; } /* Hiện khi hover */

    </style>
</head>
<body>
<jsp:include page="/views/admin/layout/sidebar.jsp" />
<div class="main-content">
    <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ VÕ ĐƯỜNG</h2>
    <a href="${pageContext.request.contextPath}/dojo/create" class="btn btn-success mb-3">
        <i class="fa-solid fa-plus"></i> Thêm Võ Đường Mới
    </a>

    <div class="table-responsive">
        <table class="table table-dark table-striped table-hover border border-secondary">
            <thead>
            <tr>
                <th>ID</th>
                <th>Tên Võ Đường</th>
                <th>Địa chỉ</th>
                <th>Võ sư quản lý</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
                <tr class="${!item.active ? 'opacity-50' : ''}">
                    <td>${item.dojoId}</td>
                    <td>${item.name}</td>
                    <td>${item.address}</td>
                    <td>${item.master.fullname}</td> <td>
                        <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}">
                                ${item.active ? 'Hoạt động' : 'Tạm ngưng'}
                        </span>
                </td>
                    <c:if test="${sessionScope.currentUser.role.roleName == 'ADMIN' || sessionScope.currentUser.role.roleName == 'MASTER'}">
                    <td>
                        <a href="${pageContext.request.contextPath}/dojo/edit?id=${item.dojoId}" class="btn btn-sm btn-primary">Sửa</a>
                        <c:if test="${item.active}">
                            <a href="${pageContext.request.contextPath}/dojo/delete?id=${item.dojoId}" class="btn btn-sm btn-danger" onclick="return confirm('Ngưng hoạt động võ đường này?')">Khóa</a>
                        </c:if>
                    </td>
                    </c:if>
                    <c:if test="${sessionScope.currentUser.role.roleName == 'STAFF'}">
                    <td>
                        <div class="btn btn-sm btn-danger"> STAFF </div>
                    </td>
                    </c:if>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>