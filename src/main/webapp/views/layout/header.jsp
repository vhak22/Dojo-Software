<!-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %> -->
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vovinam Thu Duc</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;700&family=Roboto:wght@400;500&display=swap"
        rel="stylesheet">

    <style>
        /* --- TÙY CHỈNH RIÊNG (CUSTOM CSS) --- */

        body {
            font-family: 'Roboto', sans-serif;
        }

        /* 1. HEADER STYLE */
        .navbar-custom {
            /* Hiệu ứng xuyên thấu Gradient: Đen đậm ở trên -> Trong suốt ở dưới */
            background: linear-gradient(180deg, rgba(0, 0, 0, 0.9) 0%, rgba(0, 0, 0, 0.5) 50%, rgba(0, 0, 0, 0) 100%);
            padding: 20px 0;
            transition: all 0.3s ease;
        }

        /* Logo */
        .navbar-brand {
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
            font-size: 1.8rem;
            color: white !important;
            letter-spacing: 1px;
        }

        .navbar-brand span {
            color: #467df4;
            /* Màu cam điểm nhấn */
            font-style: italic;
        }

        /* Menu Links */
        .nav-link {
            color: #e0e0e0 !important;
            text-transform: uppercase;
            font-size: 0.9rem;
            font-weight: 500;
            margin-left: 15px;
            position: relative;
        }

        .nav-link:hover {
            color: #fff !important;
        }

        /* Hiệu ứng gạch chân hover */
        .nav-link::after {
            content: '';
            display: block;
            width: 0;
            height: 2px;
            background: #467df4;
            transition: width .3s;
        }

        .nav-link:hover::after {
            width: 100%;
        }

        /* Dropdown Menu (Mobile) */
        /* Khi mở menu trên mobile, ta cần nền tối để dễ đọc chữ */
        @media (max-width: 991px) {
            .navbar-collapse {
                background-color: rgba(0, 0, 0, 0.95);
                padding: 20px;
                border-radius: 0 0 10px 10px;
                margin-top: 10px;
            }
        }

        /* 2. HERO SECTION (Để test hiệu ứng xuyên thấu) */
        .hero-section {
            height: 100vh;
            /* Ảnh nền võ thuật */
            background: url('./images/backgroundIndex.jpg') no-repeat center center/cover;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Lớp phủ đen mờ lên ảnh */
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
        }

        .hero-title {
            font-family: 'Oswald', sans-serif;
            font-size: 4rem;
            font-weight: 700;
            text-transform: uppercase;
            line-height: 1;
            margin-bottom: 20px;
        }

        .btn-custom {
            background-color: #467df4;
            color: white;
            font-weight: 700;
            text-transform: uppercase;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
        }

        .btn-custom:hover {
            background-color: rgb(99, 160, 252);
            color: white;
        }
    </style>
</head>

<body>
    <nav class="navbar navbar-expand-lg fixed-top navbar-custom">
        <div class="container-fluid px-md-5">

            <a class="navbar-brand" href="#">
                <span>Vovinam</span> Thu Duc
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon" style="filter: invert(1);"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="#">Hoạt Động</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Phương Pháp</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">HLV</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Địa Điểm & Lịch Trình</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Hỏi Đáp</a>
                    </li>
                    <li class="nav-item ms-lg-3 mt-3 mt-lg-0">
                        <span class="text-white-50 small" style="cursor: pointer;">🌐 Vietnamese ▼</span>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>