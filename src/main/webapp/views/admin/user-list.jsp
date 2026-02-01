<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
...
<div class="main-content">
    <h2 class="text-white">QUẢN LÝ NGƯỜI DÙNG</h2>
    <a href="${pageContext.request.contextPath}/admin/user/create" class="btn btn-success mb-3">+ Thêm mới</a>

    <table class="table table-dark table-striped">
        <thead>
        <tr>
            <th>ID</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>Vai trò</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${items}">
            <tr>
                <td>${item.userId}</td>
                <td>${item.fullname}</td>
                <td>${item.email}</td>
                <td>${item.role.description}</td>
                <td>${item.active ? 'Hoạt động' : 'Đã khóa'}</td>
                <td>
                    <a href="user/edit?id=${item.userId}" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="user/delete?id=${item.userId}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn chắc chắn muốn khóa user này?')">Khóa</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
...