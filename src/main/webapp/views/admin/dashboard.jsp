<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Dojo-Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: #121212 url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center/cover;
            background-attachment: fixed;
            color: #e0e0e0;
            overflow-x: hidden;
        }
        .overlay {
            background-color: rgba(0, 0, 0, 0.85); /* Tối hơn index để dễ làm việc */
            min-height: 100vh;
            display: flex;
        }
        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background-color: rgba(20, 20, 20, 0.95);
            border-right: 1px solid #333;
            display: flex;
            flex-direction: column;
            padding: 20px;
            height: 100vh;
            position: fixed;
        }
        .brand-title {
            font-family: 'Oswald', sans-serif;
            color: #ff6600;
            font-size: 1.8rem;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-align: center;
        }
        .nav-link {
            color: #bbb;
            font-size: 1.1rem;
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: all 0.3s;
        }
        .nav-link:hover, .nav-link.active {
            background-color: #ff6600;
            color: white;
            transform: translateX(5px);
        }
        .nav-link i { width: 25px; text-align: center; margin-right: 10px; }

        /* Sub-menu cho Enrollments -> Manage Students */
        .sub-menu {
            margin-left: 20px;
            border-left: 2px solid #444;
            padding-left: 10px;
            display: none; /* Ẩn mặc định */
        }
        .has-submenu:hover .sub-menu { display: block; } /* Hiện khi hover */

        /* Main Content */
        .main-content {
            margin-left: 280px;
            flex: 1;
            padding: 30px;
        }
        .card-dashboard {
            background-color: rgba(40, 40, 40, 0.8);
            border: 1px solid #444;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .card-dashboard:hover {
            transform: translateY(-5px);
            border-color: #ff6600;
        }
        .card-title { font-family: 'Oswald', sans-serif; color: #ff6600; text-transform: uppercase; }
        .stat-number { font-size: 2.5rem; font-weight: bold; color: white; }
    </style>
</head>
<body>
<div class="overlay">
    <div class="sidebar">
        <div class="brand-title"><i class="fa-solid fa-dragon"></i>Vovinam Thu Duc</div>

        <nav class="nav flex-column">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>

            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                <i class="fa-solid fa-users-gear"></i> Manage Users
            </a>

            <a class="nav-link" href="${pageContext.request.contextPath}/dojos">
                <i class="fa-solid fa-torii-gate"></i> Manage Dojos
            </a>

            <div class="has-submenu">
                <a class="nav-link" href="#"><i class="fa-solid fa-clipboard-list"></i> Enrollments (Đăng kí nhập học)</a>
                <div class="sub-menu">
                    <a class="nav-link text-sm" href="#" style="font-size: 0.9rem;">
                        <i class="fa-solid fa-arrow-turn-up fa-rotate-90"></i> Manage Students
                    </a>
                </div>
            </div>

            <div class="mt-auto">
                <hr class="text-white">
                <div class="d-flex align-items-center text-white mb-3">
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.currentUser.fullname}&background=ff6600&color=fff" class="rounded-circle me-2" width="40">
                    <div>
                        <div class="fw-bold">${sessionScope.currentUser.fullname}</div>
                        <small class="text-muted">Administrator</small>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger w-100">Đăng xuất</a>
            </div>
        </nav>
    </div>

    <div class="main-content">
        <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">TỔNG QUAN HỆ THỐNG</h2>

        <div class="row">
            <div class="col-md-3">
                <div class="card-dashboard text-center">
                    <div class="card-title">Total Users</div>
                    <div class="stat-number">150</div>
                    <p class="text-white-50">Active accounts</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-dashboard text-center">
                    <div class="card-title">Total Dojos</div>
                    <div class="stat-number">12</div>
                    <p class="text-white-50">Operating locations</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-dashboard text-center">
                    <div class="card-title">New Enrollments</div>
                    <div class="stat-number">45</div>
                    <p class="text-white-50">This month</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-dashboard text-center">
                    <div class="card-title">System Health</div>
                    <div class="stat-number text-success">Good</div>
                    <p class="text-white-50">All services running</p>
                </div>
            </div>
        </div>

        <h4 class="mt-4 mb-3" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ NHANH</h4>
        <div class="row">
            <div class="col-md-4">
                <div class="card-dashboard">
                    <h5 class="card-title"><i class="fa-solid fa-user-plus"></i> Duyệt User Mới</h5>
                    <p>Kiểm tra và kích hoạt tài khoản nhân viên hoặc võ sư mới.</p>
                    <button class="btn btn-primary w-100">Truy cập</button>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>