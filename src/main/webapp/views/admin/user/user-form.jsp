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



<div class="main-content">
  <div class="container">
    <div class="card bg-dark border-secondary" style="max-width: 600px; margin: 0 auto;">
      <div class="card-header border-secondary">
        <h3 class="text-warning mb-0" style="font-family: 'Oswald', sans-serif;">
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
                   placeholder="Ví dụ: US001, khanhv..."
                   value="${userForm.userId}" ${isEdit ? 'readonly' : ''} required>
          </div>

          <div class="mb-3">
            <label class="form-label">Mật khẩu</label>
            <input type="password" name="password" class="form-control bg-secondary text-white border-0"
                   placeholder="${isEdit ? 'Để trống nếu không muốn thay đổi' : 'Nhập mật khẩu ít nhất 6 ký tự'}"
            ${isEdit ? '' : 'required'}>
          </div>

          <div class="mb-3">
            <label class="form-label">Họ và Tên</label>
            <input type="text" name="fullname" class="form-control bg-secondary text-white border-0"
                   placeholder="Nhập tên đầy đủ (ví dụ: Nguyễn Vĩnh Khánh)"
                   value="${userForm.fullname}" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control bg-secondary text-white border-0"
                   placeholder="ten@example.com"
                   value="${userForm.email}" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Vai Trò</label>
            <select name="roleId" class="form-select bg-secondary text-white border-0">
              <option value="" disabled ${empty userForm.role ? 'selected' : ''}>-- Chọn vai trò người dùng --</option>
              <option value="1" ${userForm.role.id == 1 ? 'selected' : ''}>ADMIN - Quản trị viên</option>
              <option value="2" ${userForm.role.id == 2 ? 'selected' : ''}>MASTER - Võ sư</option>
              <option value="3" ${userForm.role.id == 3 ? 'selected' : ''}>STAFF - Nhân viên</option>
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
              <i class="fa-solid fa-floppy-disk"></i> ${isEdit ? 'Cập nhật' : 'Tạo mới'}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

</body>
</html>