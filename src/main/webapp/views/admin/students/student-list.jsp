<div class="main-content">
    <h2 class="text-white mb-4" style="font-family: 'Oswald', sans-serif;">QUẢN LÝ MÔN SINH</h2>
    <a href="${pageContext.request.contextPath}/student/create" class="btn btn-success mb-3">
        <i class="fa-solid fa-plus"></i> Thêm Môn Sinh Mới
    </a>

    <div class="table-responsive">
        <table class="table table-dark table-striped table-hover border border-secondary">
            <thead>
            <tr>
                <th>Mã môn sinh</th>
                <th>Họ và Tên</th>
                <th>Cấp đai</th>
                <th>Số điện thoại</th>
                <th>Giới tính</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
                <tr>
                    <td>${item.studentId}</td>
                    <td>${item.fullName}</td>
                    <td><span class="badge bg-info text-dark">${item.rank}</span></td>
                    <td>${item.phone}</td>
                    <td>${item.gender ? 'Nam' : 'Nữ'}</td> <td>
                    <a href="${pageContext.request.contextPath}/student/edit?id=${item.studentId}" class="btn btn-sm btn-primary">Sửa</a>
                    <a href="${pageContext.request.contextPath}/student/delete?id=${item.studentId}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa môn sinh này?')">Xóa</a>
                </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>