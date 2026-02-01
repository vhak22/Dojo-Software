<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Master Dashboard - Vovinam Management</title>
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
        .sub-menu { margin-left: 20px; border-left: 2px solid #444; padding-left: 10px; }
        .main-content { margin-left: 280px; flex: 1; padding: 30px; }
        .card-dashboard { background-color: rgba(40, 40, 40, 0.8); border: 1px solid #444; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
        .card-title { font-family: 'Oswald', sans-serif; color: #ff6600; text-transform: uppercase; }
    </style>
</head>
<body>
<div class="overlay">
    <div class="sidebar">
        <div class="brand-title"><i class="fa-solid fa-medal"></i> Master Panel</div>
        <nav class="nav flex-column">
            <a class="nav-link active" href="#"><i class="fa-solid fa-house"></i> Overview</a>

            <a class="nav-link" href="#"><i class="fa-solid fa-torii-gate"></i> Manage Dojos (Võ đường)</a>

            <div class="mt-2">
                <a class="nav-link" href="#"><i class="fa-solid fa-clipboard-list"></i> Enrollments</a>
                <div class="sub-menu">
                    <a class="nav-link text-white-50" href="#" style="font-size: 0.95rem;">
                        <i class="fa-solid fa-graduation-cap"></i> Manage Students
                    </a>
                </div>
            </div>

            <div class="mt-auto">
                <hr class="text-white">
                <div class="d-flex align-items-center text-white mb-3">
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.fullname}&background=0d6efd&color=fff" class="rounded-circle me-2" width="40">
                    <div>
                        <div class="fw-bold">${sessionScope.currentUser.fullname}</div>
                        <small class="text-muted">Master (Võ sư)</small>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light w-100">Đăng xuất</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ VÕ ĐƯỜNG</h2>

        <div class="row">
            <div class="col-md-6">
                <div class="card-dashboard">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title">Danh sách Võ Đường</h4>
                            <p>Quản lý các địa điểm tập luyện và lịch tập.</p>
                        </div>
                        <i class="fa-solid fa-map-location-dot fa-3x text-secondary"></i>
                    </div>
                    <hr class="border-secondary">
                    <button class="btn btn-outline-warning">Xem chi tiết</button>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card-dashboard">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="card-title">Hồ sơ Võ sinh</h4>
                            <p>Quản lý thông tin, cấp đai và quá trình thăng cấp.</p>
                        </div>
                        <i class="fa-solid fa-users fa-3x text-secondary"></i>
                    </div>
                    <hr class="border-secondary">
                    <button class="btn btn-outline-warning">Tra cứu</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>