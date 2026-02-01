<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật Võ đường' : 'Thêm Võ đường'} - Admin</title>
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
        /* Style cho placeholder nhạt hơn trên nền tối */
        ::placeholder {
            color: #adb5bd !important;
            opacity: 0.6;
        }
    </style>
</head>
<body>

<jsp:include page="/views/admin/layout/sidebar.jsp" />


<div class="main-content">
    <div class="container">
        <div class="card bg-dark border-secondary" style="max-width: 600px; margin: 0 auto;">
            <div class="card-header border-secondary">
                <h3 class="text-warning mb-0" style="font-family: 'Oswald', sans-serif;">
                    ${isEdit ? 'CẬP NHẬT VÕ ĐƯỜNG' : 'THÊM VÕ ĐƯỜNG MỚI'}
                </h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/dojo/${isEdit ? 'update' : 'create'}" method="post">
                    <div class="mb-3">
                        <label class="form-label">Mã Võ Đường (ID)</label>
                        <input type="text" name="dojoId" class="form-control bg-secondary text-white border-0"
                               value="${dojoForm.dojoId}"
                               placeholder="Ví dụ: DJ001"
                        ${isEdit ? 'readonly' : ''} required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên Võ Đường</label>
                        <input type="text" name="name" class="form-control bg-secondary text-white border-0"
                               value="${dojoForm.name}"
                               placeholder="Ví dụ: Võ đường Quận 7"
                               required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" name="address" class="form-control bg-secondary text-white border-0"
                               value="${dojoForm.address}"
                               placeholder="Ví dụ: 123 Nguyễn Văn Linh, TP.HCM">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Võ sư phụ trách</label>
                        <select name="masterId" class="form-select bg-secondary text-white border-0">
                            <c:forEach var="m" items="${masters}">
                                <option value="${m.userId}" ${dojoForm.master.userId == m.userId ? 'selected' : ''}>${m.fullname}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-check mb-4">
                        <input type="checkbox" name="active" value="true" class="form-check-input" id="activeCheck" ${dojoForm.active ? 'checked' : ''}>
                        <label class="form-check-label text-white" for="activeCheck">Đang hoạt động</label>
                    </div>
                    <div class="d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/dojo" class="btn btn-secondary me-2">Hủy</a>
                        <button type="submit" class="btn btn-warning fw-bold">${isEdit ? 'Cập nhật' : 'Tạo mới'}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>