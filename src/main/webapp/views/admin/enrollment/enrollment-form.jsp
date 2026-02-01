<div class="main-content">
    <div class="container mt-5">
        <div class="card bg-dark border-secondary shadow-lg" style="max-width: 700px; margin: auto;">
            <div class="card-header border-secondary bg-black">
                <h3 class="text-warning mb-0" style="font-family: 'Oswald', sans-serif;">GHI DANH MÔN SINH VÀO LỚP</h3>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/${rolePath}/enrollments/save" method="post">
                    <input type="hidden" name="id" value="${enrollment.enrollmentId}">

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
                            <input type="date" name="enrollmentDate" class="form-control bg-secondary text-white border-0"
                                   value="${enrollment.enrollmentDate}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-white-50">Trạng thái</label>
                            <select name="status" class="form-select bg-secondary text-white border-0">
                                <option value="Active" ${enrollment.status == 'Active' ? 'selected' : ''}>Đang học</option>
                                <option value="Completed" ${enrollment.status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="Dropped" ${enrollment.status == 'Dropped' ? 'selected' : ''}>Đã nghỉ</option>
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