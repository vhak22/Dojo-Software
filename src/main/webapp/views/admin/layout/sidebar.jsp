<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="sidebar">
    <div class="brand-title"><i class="fa-solid fa-dragon"></i>Vovinam Thu Duc</div>

    <nav class="nav flex-column">
        <%-- PHÂN QUYỀN: ADMIN HIỂN THỊ TẤT CẢ --%>
        <c:if test="${sessionScope.currentUser.role.roleName == 'ADMIN'}">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fa-solid fa-chart-line"></i> Dashboard Admin
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                <i class="fa-solid fa-users-gear"></i> Manage Users
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/dojos">
                <i class="fa-solid fa-torii-gate"></i> Manage All Dojos
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/students">
                <i class="fa-solid fa-user-graduate"></i> Manage All Students
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/enrollments">
                <i class="fa-solid fa-clipboard-list"></i> Manage All Enrollments
            </a>
        </c:if>

        <%-- PHÂN QUYỀN: MASTER CHỈ HIỂN THỊ 3 CHỨC NĂNG THEO YÊU CẦU --%>
        <c:if test="${sessionScope.currentUser.role.roleName == 'MASTER'}">
            <a class="nav-link" href="${pageContext.request.contextPath}/master/dashboard">
                <i class="fa-solid fa-chart-line"></i> Master Dashboard
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/dojos">
                <i class="fa-solid fa-torii-gate"></i> My Dojos
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/students">
                <i class="fa-solid fa-user-graduate"></i> My Students
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/enrollments">
                <i class="fa-solid fa-clipboard-list"></i> Enrollment Manage
            </a>
        </c:if>

        <%-- PHÂN QUYỀN: STAFF --%>
        <c:if test="${sessionScope.currentUser.role.roleName == 'STAFF'}">
            <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="fa-solid fa-chart-line"></i> Staff Dashboard
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/students">
                <i class="fa-solid fa-torii-gate"></i> View Dojos
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/enrollments">
                <i class="fa-solid fa-user-graduate"></i> Student Support
            </a>
        </c:if>

        <div class="mt-auto">
            <hr class="text-white">
            <div class="d-flex align-items-center text-white mb-3">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.fullname}&background=ff6600&color=fff"
                     class="rounded-circle me-2" width="40">
                <div>
                    <div class="fw-bold">${sessionScope.currentUser.fullname}</div>
                    <small class="text-muted">
                        <%-- Hiển thị tên Role động --%>
                        ${sessionScope.currentUser.role.roleName}
                    </small>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100">Đăng xuất</a>
        </div>
    </nav>
</div>