<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật Môn sinh' : 'Thêm Môn sinh'} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            color: #e0e0e0;
            /* Hình nền tối màu */
            background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
            url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        /* --- CẤU HÌNH SIDEBAR (BÊN TRÁI) --- */
        .sidebar {
            width: 280px;
            background-color: rgba(20, 20, 20, 0.95);
            border-right: 1px solid #333;
            display: flex;
            flex-direction: column;
            padding: 20px;
            height: 100vh; /* Chiều cao full màn hình */
            position: fixed; /* Cố định vị trí */
            top: 0;
            left: 0;
            z-index: 1000; /* Đảm bảo nằm trên cùng */
        }

        /* Style cho link trong sidebar */
        .nav-link {
            color: #bbb;
            font-size: 1.1rem;
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: all 0.3s;
            text-decoration: none;
        }
        .nav-link:hover, .nav-link.active {
            background-color: #ff6600;
            color: white;
        }
        .nav-link i {
            width: 25px;
            margin-right: 10px;
        }
        .brand-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            font-size: 1.8rem;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
        }

        /* --- CẤU HÌNH NỘI DUNG CHÍNH (BÊN PHẢI) --- */
        .main-content {
            margin-left: 280px; /* Đẩy nội dung sang phải bằng chiều rộng sidebar */
            padding: 30px;
            min-height: 100vh;
        }

        /* Card form trong suốt */
        .card.bg-dark {
            background-color: rgba(33, 37, 41, 0.9) !important;
        }

        /* Placeholder màu sáng để dễ đọc trên nền tối */
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
                    ${isEdit ? 'CẬP NHẬT MÔN SINH' : 'ĐĂNG KÝ MÔN SINH MỚI'}
                </h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/student/${isEdit ? 'update' : 'create'}" method="post">

                    <div class="mb-3">
                        <label class="form-label">Mã Môn Sinh (StudentId)</label>
                        <input type="text" name="studentId" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.studentId}"
                               placeholder="Ví dụ: MS001"
                        ${isEdit ? 'readonly' : ''} required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Họ và Tên</label>
                        <input type="text" name="fullName" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.fullName}"
                               placeholder="Ví dụ: Nguyễn Văn A"
                               required>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" name="birthday" class="form-control bg-secondary text-white border-0"
                                   value="${studentForm.birthday}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Giới tính</label>
                            <select name="gender" class="form-select bg-secondary text-white border-0">
                                <option value="true" ${studentForm.gender ? 'selected' : ''}>Nam</option>
                                <option value="false" ${!studentForm.gender ? 'selected' : ''}>Nữ</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Cấp đai (Rank)</label>
                        <input type="text" name="rank" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.rank}"
                               placeholder="Ví dụ: Lam đai nhất, Đai vàng...">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.phone}"
                               placeholder="Ví dụ: 0901234567">
                    </div>

                    <div class="d-flex justify-content-end">
                        <%-- Cập nhật link hủy về trang danh sách Admin --%>
                        <a href="${pageContext.request.contextPath}/students" class="btn btn-secondary me-2">Hủy</a>
                        <button type="submit" class="btn btn-warning fw-bold">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>