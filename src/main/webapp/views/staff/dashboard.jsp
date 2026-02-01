<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard - Ghi danh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #121212 url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center/cover;
            background-attachment: fixed; color: #e0e0e0;
        }
        .overlay { background-color: rgba(0, 0, 0, 0.85); min-height: 100vh; display: flex; }
        .sidebar { width: 280px; background-color: rgba(20, 20, 20, 0.95); border-right: 1px solid #333; padding: 20px; height: 100vh; position: fixed; display: flex; flex-direction: column;}
        .brand-title { font-family: 'Oswald', sans-serif; color: #ff6600; font-size: 1.8rem; text-transform: uppercase; margin-bottom: 30px; text-align: center; }
        .nav-link { color: #bbb; font-size: 1.1rem; padding: 12px 15px; border-radius: 5px; margin-bottom: 5px; transition: all 0.3s; }
        .nav-link:hover, .nav-link.active { background-color: #ff6600; color: white; transform: translateX(5px); }
        .nav-link i { width: 25px; margin-right: 10px; }

        /* Highlight phần Enrollments vì Staff tập trung vào đây */
        .enroll-section { background-color: rgba(255, 102, 0, 0.1); border-radius: 8px; padding: 10px; margin-bottom: 15px; border: 1px solid #ff6600; }
        .sub-menu-link { display: block; padding: 8px 0 8px 35px; color: #999; text-decoration: none; transition: 0.2s; }
        .sub-menu-link:hover { color: white; padding-left: 40px; }

        .main-content { margin-left: 280px; flex: 1; padding: 30px; }
        .card-dashboard { background-color: rgba(40, 40, 40, 0.8); border: 1px solid #444; border-radius: 8px; padding: 20px; }
    </style>
</head>
<body>
<div class="overlay">
    <div class="sidebar">
        <div class="brand-title"><i class="fa-solid fa-id-card"></i> Staff Portal</div>

        <nav class="nav flex-column">
            <a class="nav-link active" href="#"><i class="fa-solid fa-gauge-high"></i> Dashboard</a>

            <div class="enroll-section mt-3">
                <a class="nav-link text-white fw-bold" href="#">
                    <i class="fa-solid fa-file-signature"></i> Enrollments
                </a>
                <a class="sub-menu-link" href="#">
                    <i class="fa-solid fa-caret-right"></i> Manage Students
                </a>
                <a class="sub-menu-link" href="#">
                    <i class="fa-solid fa-caret-right"></i> Pending Requests
                </a>
            </div>

            <div class="mt-auto">
                <hr class="text-white">
                <div class="d-flex align-items-center text-white mb-3">
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.fullname}&background=20c997&color=fff" class="rounded-circle me-2" width="40">
                    <div>
                        <div class="fw-bold">${sessionScope.currentUser.fullname}</div>
                        <small class="text-muted">Staff</small>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light w-100">Đăng xuất</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">CÔNG TÁC GHI DANH</h2>

        <div class="row g-4">
            <div class="col-md-8">
                <div class="card-dashboard h-100">
                    <h4 style="color: #ff6600;">Ghi danh mới (New Enrollment)</h4>
                    <p class="text-white-50">Tạo hồ sơ đăng ký cho học viên mới tham gia vào các võ đường.</p>
                    <form class="mt-3">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <input type="text" class="form-control bg-dark text-white border-secondary" placeholder="Tên học viên">
                            </div>
                            <div class="col-md-6 mb-3">
                                <input type="tel" class="form-control bg-dark text-white border-secondary" placeholder="Số điện thoại">
                            </div>
                        </div>
                        <button class="btn btn-danger w-100">Tiếp tục đăng ký <i class="fa-solid fa-arrow-right"></i></button>
                    </form>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card-dashboard h-100 text-center">
                    <i class="fa-solid fa-user-clock fa-3x text-warning mb-3"></i>
                    <h5>Hồ sơ chờ duyệt</h5>
                    <h2 class="fw-bold">08</h2>
                    <button class="btn btn-sm btn-outline-secondary mt-2">Xem danh sách</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>