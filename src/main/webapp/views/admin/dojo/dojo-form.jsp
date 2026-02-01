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
                               value="${dojoForm.dojoId}" ${isEdit ? 'readonly' : ''} required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên Võ Đường</label>
                        <input type="text" name="name" class="form-control bg-secondary text-white border-0"
                               value="${dojoForm.name}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" name="address" class="form-control bg-secondary text-white border-0"
                               value="${dojoForm.address}">
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
                        <label class="form-check-label" for="activeCheck">Đang hoạt động</label>
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