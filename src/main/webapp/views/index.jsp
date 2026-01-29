<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vovinam Thu Duc</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@700&display=swap" rel="stylesheet">
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
            background: linear-gradient(90deg, rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0.5) 50%, rgba(0, 0, 0, 0.5) 100%);
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
            background: url('${pageContext.request.contextPath}/views/images/backgroundIndex.jpg') no-repeat center center/cover;
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

        /* --- HISTORY SECTION STYLE --- */
        .history-section {
            background-color: #000000;
            /* Nền đen tuyền */
            padding: 80px 0;
            color: white;
            min-height: 80vh;
            /* Chiều cao tối thiểu */
        }

        /* Tiêu đề lớn bên trái */
        .history-title {
            font-family: 'Oswald', sans-serif;
            font-size: 4rem;
            /* Chữ to */
            font-weight: 700;
            text-transform: uppercase;
            color: #ff6600;
            /* Màu cam giống hình mẫu */
            line-height: 1;
            margin-bottom: 30px;
        }

        /* Khu vực hiển thị năm và mô tả bên trái */
        .display-year {
            font-family: 'Oswald', sans-serif;
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .display-desc {
            font-family: 'Roboto', sans-serif;
            font-size: 1.1rem;
            line-height: 1.6;
            max-width: 500px;
            /* Giới hạn chiều rộng đoạn văn cho dễ đọc */
        }

        /* Danh sách năm bên phải */
        .years-list-container {
            max-height: 400px;
            /* Chiều cao cố định */
            overflow-y: auto;
            /* Cho phép cuộn chuột nếu danh sách dài */
            padding-right: 20px;
        }

        /* Tùy chỉnh thanh cuộn (Scrollbar) cho đẹp */
        .years-list-container::-webkit-scrollbar {
            width: 5px;
        }

        .years-list-container::-webkit-scrollbar-thumb {
            background: #333;
            border-radius: 5px;
        }

        .year-item {
            font-family: 'Oswald', sans-serif;
            font-size: 4rem;
            /* Kích thước số năm trong danh sách */
            font-weight: 700;
            color: #333;
            /* Màu xám tối mặc định (khi chưa chọn) */
            cursor: pointer;
            transition: all 0.3s ease;
            line-height: 1;
            margin-bottom: 10px;
        }

        .year-item:hover {
            color: #666;
            /* Sáng hơn chút khi hover */
            transform: translateX(-10px);
            /* Di chuyển nhẹ sang trái */
        }

        /* Trạng thái khi được chọn (Active) */
        .year-item.active {
            color: #ff6600;
            /* Màu cam nổi bật */
            font-size: 5rem;
            /* Phóng to lên */
        }

        /* Hiệu ứng Fade in khi đổi nội dung */
        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .history-title {
                font-size: 2.5rem;
            }

            .display-year {
                font-size: 2rem;
            }

            .year-item {
                font-size: 3rem;
            }

            .year-item.active {
                font-size: 4rem;
            }

            .years-list-container {
                margin-top: 40px;
                max-height: 300px;
            }
        }

        /* ... (Các CSS cũ giữ nguyên) ... */

        /* Style cho hình ảnh lịch sử */
        .history-image {
            max-height: 400px;
            /* Giới hạn chiều cao để không bị quá khổ */
            width: 100%;
            /* Chiều rộng tự động theo khung */
            object-fit: cover;
            /* Cắt ảnh cho vừa khung mà không bị méo */
            border: 2px solid #333;
            /* Viền nhẹ cho ảnh */
            transition: all 0.5s ease;
            /* Hiệu ứng mượt mà khi đổi ảnh */
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {

            /* ... (Các CSS cũ) ... */
            .history-image {
                max-height: 250px;
                /* Hình nhỏ hơn trên điện thoại */
                margin-bottom: 30px;
            }
        }

        /* --- FAQ SECTION STYLE --- */
        .faq-section {
            background-color: #000;
            color: white;
        }

        /* Ảnh bên trái full chiều cao */
        .faq-image-container {
            height: 100%;
            min-height: 500px;
            /* Chiều cao tối thiểu trên mobile */
            /* Thay đường dẫn ảnh của bạn vào đây */
            background: url('${pageContext.request.contextPath}/views/images/FAQ.jpg') no-repeat center center/cover;
            /* Hiệu ứng đen trắng cho ảnh giống hình mẫu */
            filter: grayscale(100%);
        }

        /* Padding cho phần nội dung bên phải */
        .faq-content-wrapper {
            padding: 80px 60px;
            width: 100%;
        }

        .faq-title {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: #fff;
            opacity: 0.2;
            /* Làm mờ tiêu đề giống hình mẫu */
            text-transform: uppercase;
        }

        /* Tùy chỉnh Bootstrap Accordion */
        .accordion-item {
            background-color: transparent !important;
            /* Xuyên thấu */
            border: none;
            border-bottom: 1px solid #333 !important;
            /* Đường kẻ mờ ngăn cách */
        }

        /* Nút bấm (Câu hỏi) */
        .accordion-button {
            background-color: transparent !important;
            color: #888 !important;
            /* Màu xám khi chưa chọn */
            font-family: 'Roboto', sans-serif;
            font-size: 1.2rem;
            font-weight: 500;
            padding: 25px 0;
            /* Tăng khoảng cách trên dưới */
        }

        /* Ẩn icon mặc định của Bootstrap (cái mũi tên bên phải) */
        .accordion-button::after {
            display: none;
        }

        /* Xử lý khi nút được bấm (Active) */
        .accordion-button:not(.collapsed) {
            color: #ff6600 !important;
            /* Đổi màu chữ sang CAM */
            box-shadow: none;
            /* Bỏ viền xanh mặc định khi click */
        }

        /* Nội dung trả lời */
        .accordion-body {
            font-family: 'Roboto', sans-serif;
            line-height: 1.6;
            padding-bottom: 30px;
        }

        /* Xử lý dấu + và dấu x bằng Javascript hoặc CSS thủ công */
        /* Ở đây tôi dùng Javascript inline trong thẻ HTML để đổi dấu + thành x cho đơn giản */
        /* Nhưng để chuyên nghiệp, ta dùng CSS selector dưới đây: */

        .icon-indicator {
            display: inline-block;
            width: 20px;
            font-weight: 300;
            transition: transform 0.3s;
        }

        /* Khi mở ra thì đổi dấu + thành dấu x bằng css content? */
        /* Cách đơn giản nhất trong CSS thuần mà không cần JS phức tạp: */
        .accordion-button:not(.collapsed) .icon-indicator {
            content: "x";
            /* Không đổi được content text trực tiếp dễ dàng, nên ta dùng mẹo xoay */
            transform: rotate(45deg);
            /* Xoay dấu + 45 độ thành dấu x */
            font-size: 1.5rem;
            font-weight: bold;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .faq-content-wrapper {
                padding: 40px 20px;
            }

            .faq-title {
                font-size: 2rem;
            }

            .accordion-button {
                font-size: 1rem;
            }
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
                        <a class="nav-link" href="#">HLV</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Địa Điểm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#faq">Hỏi Đáp</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Đăng nhập</a>
                    </li>
                    <li class="nav-item ms-lg-3 mt-3 mt-lg-0">
                        <span class="text-white-50 small" style="cursor: pointer;">🌐 Vietnamese ▼</span>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <section class="hero-section">
        <div class="overlay"></div>
        <div class="container hero-content">
            <h1 class="hero-title">ĐÁNH THỨC NHÀ VÔ ĐỊCH<br>
                TRONG BẠN</h1>
            <p class="lead mb-4">Trải nghiệm tập luyện cùng các Võ sĩ Vovinam chuyên nghiệp.</p>
            <a href="#" class="btn btn-custom">Trải nghiệm ngay</a>
        </div>
    </section>
    <section id="history" class="history-section">
        <div class="container">
            <div class="row">

                <div class="col-lg-8 col-md-12 d-flex flex-column justify-content-between">

                    <h2 class="history-title mb-5">
                        KHÁM PHÁ<br>
                        <span class="text-white">HÀNH TRÌNH CỦA CHÚNG TÔI</span>
                    </h2>

                    <div class="history-content-display fade-in" id="contentDisplay">

                        <div class="row align-items-center">

                            <div class="col-md-6 mb-4 mb-md-0">
                                <h3 class="display-year text-white" id="displayYear">2025</h3>
                                <p class="display-desc text-secondary" id="displayDesc">
                                    Đang tải dữ liệu...
                                </p>
                            </div>

                            <div class="col-md-6">
                                <img src="" alt="Lịch sử hình thành" id="displayImage"
                                    class="img-fluid rounded shadow history-image w-100">
                            </div>

                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-12">
                    <div class="years-list-container mt-4 mt-lg-0">
                        <ul class="list-unstyled text-end" id="yearList">
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section id="locations" class="py-5" style="background-color: #050505;">
        <div class="container">

            <div class="row mb-5 align-items-end">
                <div class="col-lg-6 col-md-12 mb-3 mb-lg-0">
                    <h2 class="text-uppercase fw-bold text-white mb-2" style="font-family: 'Oswald', sans-serif;">
                        Hệ Thống <span style="color: #ff6600;">Câu Lạc Bộ</span>
                    </h2>
                    <p class="text-white-50 m-0">Tìm câu lạc bộ gần bạn nhất để bắt đầu tập luyện.</p>
                </div>


            </div>

            <div class="row g-4">
                <div class="row g-4">
                    <c:forEach items="${listDojo}" var="dojo">
                        <div class="col-lg-4 col-md-6">
                            <div class="card h-100 bg-dark text-white border-secondary shadow-sm">
                                <div style="height: 200px; overflow: hidden;">
                                    <c:choose>
                                        <c:when test="${not empty dojo.image}">
                                            <img src="${pageContext.request.contextPath}/image/${dojo.image}"
                                                 class="card-img-top w-100 h-100 object-fit-cover"
                                                 alt="${dojo.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/400x250/333/fff?text=No+Image"
                                                 class="card-img-top w-100 h-100 object-fit-cover"
                                                 alt="Default Image">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body d-flex flex-column">
                                    <div class="mb-2">
                                        <c:choose>
                                            <c:when test="${dojo.active}">
                                                <span class="badge bg-success">Đang hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Tạm ngưng</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <span class="badge border border-secondary text-white-50 ms-1">${dojo.dojoId}</span>
                                    </div>

                                    <h4 class="card-title text-uppercase fw-bold mt-2"
                                        style="font-family: 'Oswald', sans-serif;">
                                            ${dojo.name}
                                    </h4>

                                    <p class="card-text text-white-50 small flex-grow-1">
                                        <i class="me-2">📍</i> ${dojo.address}
                                        <br>
                                        <i class="me-2">📞</i> Liên hệ: Admin
                                    </p>

                                    <hr class="border-secondary">

                                    <div class="d-grid gap-2">
                                        <a href="LocationDetailServlet?id=${dojo.dojoId}" class="btn btn-outline-light btn-sm">
                                            Xem lịch tập
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <br><br>
    </section>

    <section id="faq" class="faq-section">
        <div class="container-fluid p-0">
            <div class="row g-0">
                <div class="col-lg-6 col-md-12">
                    <div class="faq-image-container"></div>
                </div>

                <div class="col-lg-6 col-md-12 d-flex align-items-center bg-black">
                    <div class="faq-content-wrapper">

                        <h2 class="faq-title mb-5">CÂU HỎI THƯỜNG GẶP</h2>

                        <div class="accordion accordion-flush" id="faqAccordion">

                            <div class="accordion-item bg-black border-bottom border-secondary">
                                <h2 class="accordion-header" id="headingOne">
                                    <button class="accordion-button collapsed bg-black text-secondary shadow-none ps-0"
                                        type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne"
                                        aria-expanded="false" aria-controls="collapseOne">
                                        <span class="icon-indicator me-3">+</span> Vovinam có phù hợp cho trẻ em không?
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne"
                                    data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-white-50 ps-5 pt-0">
                                        Chúng tôi có giáo trình thiết kế riêng cho từng độ tuổi. Vovinam không chỉ giúp
                                        trẻ rèn luyện sức khỏe mà còn dạy về đạo đức, kỷ luật và sự tự tin. Các lớp học
                                        luôn đảm bảo an toàn tuyệt đối.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item bg-black border-bottom border-secondary">
                                <h2 class="accordion-header" id="headingTwo">
                                    <button class="accordion-button bg-black text-warning shadow-none ps-0"
                                        type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo"
                                        aria-expanded="true" aria-controls="collapseTwo">
                                        <span class="icon-indicator me-3">×</span> Tập võ có giúp giảm cân không?
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse show"
                                    aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-white-50 ps-5 pt-0">
                                        Chắc chắn rồi! Một giờ tập Vovinam có thể đốt cháy từ 600-800 calo. Các bài tập
                                        vận động toàn thân giúp săn chắc cơ bắp và giảm mỡ thừa hiệu quả.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item bg-black border-bottom border-secondary">
                                <h2 class="accordion-header" id="headingThree">
                                    <button class="accordion-button collapsed bg-black text-secondary shadow-none ps-0"
                                        type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree"
                                        aria-expanded="false" aria-controls="collapseThree">
                                        <span class="icon-indicator me-3">+</span> Người làm văn phòng cứng người có tập
                                        được không?
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse"
                                    aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-white-50 ps-5 pt-0">
                                        Hoàn toàn được. Vovinam rất chú trọng vào các bài khởi động và giãn cơ. Tập
                                        luyện thường xuyên sẽ giúp giải tỏa căng thẳng và giảm đau lưng, mỏi vai gáy cho
                                        dân văn phòng.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item bg-black border-bottom border-secondary">
                                <h2 class="accordion-header" id="headingFour">
                                    <button class="accordion-button collapsed bg-black text-secondary shadow-none ps-0"
                                        type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour"
                                        aria-expanded="false" aria-controls="collapseFour">
                                        <span class="icon-indicator me-3">+</span> Tôi cần chuẩn bị gì cho buổi tập đầu
                                        tiên?
                                    </button>
                                </h2>
                                <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour"
                                    data-bs-parent="#faqAccordion">
                                    <div class="accordion-body text-white-50 ps-5 pt-0">
                                        Bạn chỉ cần mang theo quần áo thể thao thoải mái và nước uống. Găng tay và dụng
                                        cụ tập luyện sẽ được trung tâm hỗ trợ trong các buổi trải nghiệm đầu tiên.
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br><br><br>
    </section>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {

            // ============================================================
            // PHẦN 1: XỬ LÝ LỊCH SỬ HÌNH THÀNH (HISTORY TIMELINE)
            // ============================================================

            const yearListEl = document.getElementById('yearList');
            const displayYearEl = document.getElementById('displayYear');
            const displayDescEl = document.getElementById('displayDesc');
            const displayImageEl = document.getElementById('displayImage');
            const contentContainer = document.getElementById('contentDisplay');

            // Chỉ chạy code nếu tìm thấy phần tử yearList (tránh lỗi ở trang khác)
            if (yearListEl) {

                // DỮ LIỆU LỊCH SỬ
                const historyData = [
                    {
                        year: 2025,
                        desc: "Năm hiện tại: Mở rộng thêm 2 chi nhánh mới tại Quận 9 và Bình Thạnh. Đưa chương trình đào tạo Vovinam tự vệ thực chiến vào giảng dạy.",
                        image: "${pageContext.request.contextPath}/views/images/history-2025.jpg"
                    },
                    {
                        year: 2024,
                        desc: "We expanded to the vibrant heart of District 1, unveiling Vietnam's finest facility - a state-of-the-art space designed to inspire.",
                        image: "https://via.placeholder.com/600x400/333333/ffffff?text=Anh+Lich+Su+2024"
                    },
                    {
                        year: 2023,
                        desc: "Đạt mốc 500 học viên thường xuyên. Tổ chức giải đấu giao hữu Vovinam mở rộng lần đầu tiên.",
                        image: "https://i.imgur.com/wO8J4qN.jpeg"
                    },
                    {
                        year: 2022,
                        desc: "Trở lại mạnh mẽ sau đại dịch. Nâng cấp toàn bộ trang thiết bị tập luyện và sàn đấu tiêu chuẩn quốc tế.",
                        image: "https://via.placeholder.com/600x400/222222/ffffff?text=Anh+Lich+Su+2022"
                    },
                    {
                        year: 2020,
                        desc: "Chuyển đổi sang mô hình tập luyện trực tuyến (Online) để duy trì phong độ cho các võ sinh trong mùa dịch.",
                        image: "https://via.placeholder.com/600x400/555555/ffffff?text=Anh+Lich+Su+2020"
                    },
                    {
                        year: 2018,
                        desc: "Thành lập CLB Vovinam Thủ Đức với vỏn vẹn 10 thành viên ban đầu tại một sân kho nhỏ.",
                        image: "https://via.placeholder.com/600x400/777777/ffffff?text=Anh+Lich+Su+2018"
                    },
                    {
                        year: 2015,
                        desc: "Ý tưởng nhen nhóm. Những người sáng lập bắt đầu hành trình tìm kiếm phương pháp huấn luyện Vovinam hiện đại.",
                        image: "https://via.placeholder.com/600x400/999999/ffffff?text=Anh+Lich+Su+2015"
                    }
                ];

                // Hàm vẽ danh sách năm
                function renderYears() {
                    yearListEl.innerHTML = '';
                    historyData.forEach((item, index) => {
                        const li = document.createElement('li');
                        li.classList.add('year-item');
                        li.innerText = item.year;

                        // Active năm đầu tiên
                        if (index === 0) li.classList.add('active');

                        // Bắt sự kiện click
                        li.onclick = () => selectYear(index);
                        yearListEl.appendChild(li);
                    });

                    // Load nội dung đầu tiên
                    updateContent(0);
                }

                // Hàm xử lý khi chọn năm
                function selectYear(index) {
                    const allYears = document.querySelectorAll('.year-item');
                    allYears.forEach(y => y.classList.remove('active'));
                    allYears[index].classList.add('active');
                    updateContent(index);
                }

                // Hàm cập nhật nội dung và hình ảnh
                function updateContent(index) {
                    // Reset hiệu ứng fade-in
                    contentContainer.classList.remove('fade-in');
                    void contentContainer.offsetWidth; // Trigger reflow (reset CSS animation)
                    contentContainer.classList.add('fade-in');

                    // Cập nhật text
                    displayYearEl.innerText = historyData[index].year;
                    displayDescEl.innerText = historyData[index].desc;

                    // Cập nhật ảnh
                    if (displayImageEl) {
                        displayImageEl.src = historyData[index].image;
                        displayImageEl.alt = "Lịch sử năm " + historyData[index].year;
                    }
                }

                // Chạy hàm khởi tạo History
                renderYears();
            }


            // ============================================================
            // PHẦN 2: XỬ LÝ FAQ (ĐỔI DẤU + THÀNH ×)
            // ============================================================

            const accordionButtons = document.querySelectorAll('.accordion-button');

            if (accordionButtons.length > 0) {

                // Hàm helper để cập nhật icon dựa trên trạng thái nút
                function updateIcon(button) {
                    const icon = button.querySelector('.icon-indicator');
                    if (icon) {
                        // Nếu có class 'collapsed' nghĩa là đang ĐÓNG -> hiện dấu +
                        // Nếu KHÔNG có class 'collapsed' nghĩa là đang MỞ -> hiện dấu ×
                        if (button.classList.contains('collapsed')) {
                            icon.innerText = '+';
                        } else {
                            icon.innerText = '×';
                        }
                    }
                }

                // 1. Khởi tạo trạng thái ban đầu (cho cái nào đang mở sẵn)
                accordionButtons.forEach(btn => updateIcon(btn));

                // 2. Bắt sự kiện click
                accordionButtons.forEach(button => {
                    button.addEventListener('click', function () {

                        // Reset tất cả các nút khác về dấu + (vì accordion flush chỉ mở 1 cái 1 lúc)
                        accordionButtons.forEach(otherBtn => {
                            if (otherBtn !== button) {
                                const otherIcon = otherBtn.querySelector('.icon-indicator');
                                if (otherIcon) otherIcon.innerText = '+';
                            }
                        });

                        // Cập nhật nút hiện tại (Dùng setTimeout nhẹ để chờ Bootstrap đổi class xong)
                        setTimeout(() => {
                            updateIcon(this);
                        }, 50);
                    });
                });
            }

        });
    </script>
</body>

</html>