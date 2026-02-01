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
                               value="${studentForm.studentId}" ${isEdit ? 'readonly' : ''} required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và Tên</label>
                        <input type="text" name="fullName" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.fullName}" required>
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
                               value="${studentForm.rank}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control bg-secondary text-white border-0"
                               value="${studentForm.phone}">
                    </div>
                    <div class="d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/student" class="btn btn-secondary me-2">Hủy</a>
                        <button type="submit" class="btn btn-warning fw-bold">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>