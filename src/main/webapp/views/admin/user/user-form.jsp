<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="container text-white mt-5">
  <div class="card bg-dark border-secondary">
    <div class="card-header border-secondary">
      <h3 class="text-warning" style="font-family: 'Oswald', sans-serif;">
        ${isEdit ? 'CẬP NHẬT THÔNG TIN' : 'THÊM NGƯỜI DÙNG MỚI'}
      </h3>
    </div>
    <div class="card-body">
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/admin/user/${isEdit ? 'update' : 'create'}" method="post">

        <div class="mb-3">
          <label class="form-label">Mã User (ID)</label>
          <input type="text" name="userId" class="form-control bg-secondary text-white border-0"
                 value="${userForm.userId}" ${isEdit ? 'readonly' : ''} required>
        </div>

        <div class="mb-3">
          <label class="form-label">Mật khẩu</label>
          <input type="password" name="password" class="form-control bg-secondary text-white border-0"
                 placeholder="${isEdit ? 'Để trống nếu không đổi pass' : 'Nhập mật khẩu...'}"
          ${isEdit ? '' : 'required'}>
        </div>

        <div class="mb-3">
          <label class="form-label">Họ và Tên</label>
          <input type="text" name="fullname" class="form-control bg-secondary text-white border-0"
                 value="${userForm.fullname}" required>
        </div>

        <div class="mb-3">
          <label class="form-label">Email</label>
          <input type="email" name="email" class="form-control bg-secondary text-white border-0"
                 value="${userForm.email}" required>
        </div>

        <div class="mb-3">
          <label class="form-label">Vai Trò</label>
          <select name="roleId" class="form-select bg-secondary text-white border-0">
            <option value="1" ${userForm.role.roleId == 1 ? 'selected' : ''}>ADMIN - Quản trị viên</option>
            <option value="2" ${userForm.role.roleId == 2 ? 'selected' : ''}>MASTER - Võ sư chủ nhiệm</option>
            <option value="3" ${userForm.role.roleId == 3 ? 'selected' : ''}>STAFF - Nhân viên</option>
          </select>
        </div>

        <div class="form-check mb-4">
          <input type="checkbox" name="active" value="true" class="form-check-input" id="activeCheck"
          ${userForm.active ? 'checked' : ''}>
          <label class="form-check-label" for="activeCheck">Kích hoạt tài khoản</label>
        </div>

        <div class="d-flex justify-content-end">
          <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-2">Hủy bỏ</a>
          <button type="submit" class="btn btn-warning fw-bold">
            <i class="fa-solid fa-save"></i> Lưu dữ liệu
          </button>
        </div>
      </form>
    </div>
  </div>
</div>