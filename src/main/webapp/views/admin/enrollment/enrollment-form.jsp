<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${isEdit ? 'Cập nhật Ghi danh' : 'Ghi danh mới'} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            color: #e0e0e0;
            background: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
            url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center fixed;
            background-size: cover;
            /* Reset margin để sidebar không bị lệch */
            margin: 0;
            padding: 0;
        }

        /* --- CẤU HÌNH KHUNG SIDEBAR (WRAPPER) --- */
        .admin-sidebar-wrapper {
            width: 280px;
            height: 100vh;
            position: fixed !important; /* Cố định vị trí bên trái */
            top: 0;
            left: 0;
            z-index: 1000;
            background-color: rgba(20, 20, 20, 0.95);
            border-right: 1px solid #333;
            overflow-y: auto;
        }

        /* Style cho link bên trong Wrapper để đảm bảo hiển thị đúng */
        .admin-sidebar-wrapper .nav-link {
            color: #bbb;
            font-size: 1.1rem;
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
        }
        .admin-sidebar-wrapper .nav-link:hover,
        .admin-sidebar-wrapper .nav-link.active {
            background-color: #ff6600;
            color: white;
        }
        .admin-sidebar-wrapper .nav-link i {
            width: 25px;
            margin-right: 10px;
        }
        .admin-sidebar-wrapper .brand-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            font-size: 1.8rem;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
            padding-top: 20px;
        }
        .admin-sidebar-wrapper .mt-auto {
            padding: 20px;
        }

        /* --- CẤU HÌNH NỘI DUNG CHÍNH (BÊN PHẢI) --- */
        .main-content {
            margin-left: 280px; /* Đẩy nội dung sang phải */
            padding: 30px;
            min-height: 100vh;
            position: relative;
        }

        .card.bg-dark {
            background-color: rgba(33, 37, 41, 0.9) !important;
        }

        ::placeholder {
            color: #adb5bd !important;
            opacity: 0.6;
        }
    </style>
</head>
<body>

<div class="admin-sidebar-wrapper">
    <jsp:include page="/views/admin/layout/sidebar.jsp" />
</div>

<div class="main-content">
    <div class="container mt-5">
        <div class="card bg-dark border-secondary shadow-lg" style="max-width: 700px; margin: auto;">
            <div class="card-header border-secondary bg-black">
                <h3 class="text-warning mb-0" style="font-family: 'Oswald', sans-serif;">GHI DANH MÔN SINH VÀO LỚP</h3>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/${rolePath}/enrollments/save" method="post">

                    <%-- Logic ID đã sửa --%>
                    <input type="hidden" name="id" value="${enrollment.id}">

                    <div class="mb-3">
                        <label class="form-label text-white-50">Chọn Môn Sinh</label>
                        <select name="studentId" class="form-select bg-secondary text-white border-0" required>
                            <option value="">-- Chọn môn sinh --</option>
                            <c:forEach var="st" items="${students}">
                                <option value="${st.studentId}" ${enrollment.student.studentId == st.studentId ? 'selected' : ''}>
                                        ${st.studentId} - ${st.fullName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-white-50">Chọn Võ Đường</label>
                        <select name="dojoId" class="form-select bg-secondary text-white border-0" required>
                            <option value="">-- Chọn võ đường --</option>
                            <c:forEach var="dj" items="${dojos}">
                                <option value="${dj.dojoId}" ${enrollment.dojo.dojoId == dj.dojoId ? 'selected' : ''}>
                                        ${dj.name} (${dj.address})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-white-50">Ngày ghi danh</label>
                            <%-- Logic Date đã sửa --%>
                            <input type="date" name="enrollmentDate" class="form-control bg-secondary text-white border-0"
                                   value="${enrollment.enrollDate}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-white-50">Trạng thái</label>
                            <select name="status" class="form-select bg-secondary text-white border-0">
                                <%-- Logic Status Enum đã sửa --%>
                                <option value="ACTIVE" ${enrollment.status == 'ACTIVE' ? 'selected' : ''}>Đang học (ACTIVE)</option>
                                <option value="TRIAL" ${enrollment.status == 'TRIAL' ? 'selected' : ''}>Học thử (TRIAL)</option>
                                <option value="DROPPED" ${enrollment.status == 'DROPPED' ? 'selected' : ''}>Đã nghỉ (DROPPED)</option>
                                <option value="RESERVED" ${enrollment.status == 'RESERVED' ? 'selected' : ''}>Bảo lưu (RESERVED)</option>
                                <option value="SUSPENDED" ${enrollment.status == 'SUSPENDED' ? 'selected' : ''}>Đình chỉ (SUSPENDED)</option>
                            </select>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end mt-4">
                        <a href="${pageContext.request.contextPath}/${rolePath}/enrollments" class="btn btn-outline-light me-2">Quay lại</a>
                        <button type="submit" class="btn btn-warning px-4 fw-bold">XÁC NHẬN GHI DANH</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>