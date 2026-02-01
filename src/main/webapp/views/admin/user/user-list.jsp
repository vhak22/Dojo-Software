<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
                <th>Họ tên</th>
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
                            <c:when test="${item.role.roleId == 1}"><span class="badge bg-danger">ADMIN</span></c:when>
                            <c:when test="${item.role.roleId == 2}"><span class="badge bg-primary">MASTER</span></c:when>
                            <c:otherwise><span class="badge bg-secondary">STAFF</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>${item.active ? 'Hoạt động' : 'Đã khóa'}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${item.userId}"
                           class="btn btn-sm btn-primary">
                            <i class="fa-solid fa-pen"></i> Sửa
                        </a>

                        <c:if test="${item.active}">
                            <a href="${pageContext.request.contextPath}/admin/user/delete?id=${item.userId}"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Bạn chắc chắn muốn khóa tài khoản này?')">
                                <i class="fa-solid fa-lock"></i> Khóa
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>