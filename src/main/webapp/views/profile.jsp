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
<form action="${pageContext.request.contextPath}/update-profile" method="post" enctype="multipart/form-data">
    <input type="hidden" name="userId" value="${sessionScope.currentUser.userId}">

    <label>Chọn ảnh đại diện:</label>
    <input type="file" name="avatarFile" accept="image/*" class="form-control">

    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
</form>

<hr>

<c:if test="${not empty sessionScope.currentUser.avatar}">
    <img src="${pageContext.request.contextPath}/image/${sessionScope.currentUser.avatar}"
         alt="Avatar" style="width: 150px; height: 150px; object-fit: cover; border-radius: 50%;">
</c:if>

<c:if test="${empty sessionScope.currentUser.avatar}">
    <img src="https://via.placeholder.com/150" alt="Default Avatar">
</c:if>
</body>

</html>