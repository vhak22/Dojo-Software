...
<div class="container text-white mt-5">
  <h3>${isEdit ? 'CẬP NHẬT USER' : 'THÊM USER MỚI'}</h3>

  <form action="${pageContext.request.contextPath}/admin/user/${isEdit ? 'update' : 'create'}" method="post">
    <div class="mb-3">
      <label>User ID</label>
      <input type="text" name="userId" class="form-control" value="${userForm.userId}" ${isEdit ? 'readonly' : ''} required>
    </div>
    <div class="mb-3">
      <label>Mật khẩu</label>
      <input type="password" name="password" class="form-control" value="${userForm.password}" required>
    </div>
    <div class="mb-3">
      <label>Họ và tên</label>
      <input type="text" name="fullname" class="form-control" value="${userForm.fullname}" required>
    </div>
    <div class="mb-3">
      <label>Email</label>
      <input type="email" name="email" class="form-control" value="${userForm.email}" required>
    </div>
    <div class="mb-3">
      <label>Vai trò</label>
      <select name="roleId" class="form-select">
        <option value="1" ${userForm.role.roleId == 1 ? 'selected' : ''}>ADMIN</option>
        <option value="2" ${userForm.role.roleId == 2 ? 'selected' : ''}>MASTER</option>
        <option value="3" ${userForm.role.roleId == 3 ? 'selected' : ''}>STAFF</option>
      </select>
    </div>
    <div class="form-check mb-3">
      <input type="checkbox" name="active" value="true" class="form-check-input" ${userForm.active ? 'checked' : ''}>
      <label class="form-check-label">Kích hoạt</label>
    </div>

    <button type="submit" class="btn btn-warning">Lưu dữ liệu</button>
    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Hủy</a>
  </form>
</div>
...