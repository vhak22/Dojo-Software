CREATE DATABASE Dojo;
GO
USE Dojo;
GO

-- 1. Tạo bảng Roles riêng biệt (Giống cấu trúc BEDSIT)
CREATE TABLE Roles (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) UNIQUE NOT NULL, -- 'Admin', 'Master', 'Staff'
    Description NVARCHAR(255)
);

-- 2. Bảng Người dùng (Sử dụng RoleId thay vì Role string)
CREATE TABLE Users (
    UserId NVARCHAR(20) PRIMARY KEY,
    Password NVARCHAR(100) NOT NULL, -- Tăng độ dài để lưu hash password
    Fullname NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    RoleId INT, -- Khóa ngoại trỏ đến bảng Roles
    Active BIT DEFAULT 1,
    Created_at DATETIME DEFAULT GETDATE(),
    
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleId) REFERENCES Roles(Id) 
        ON DELETE SET NULL
);

-- 3. Bảng Võ đường (Giữ nguyên quan hệ với Master)
CREATE TABLE Dojos (
    DojoId NVARCHAR(20) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    MasterId NVARCHAR(20), 
    Active BIT DEFAULT 1,
    CONSTRAINT FK_Dojo_Master FOREIGN KEY (MasterId) REFERENCES Users(UserId)
);

-- 4. Bảng Võ sinh
CREATE TABLE Students (
    StudentId NVARCHAR(20) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Birthday DATE,
    Gender BIT, 
    Phone NVARCHAR(15),
    Rank NVARCHAR(50) 
);

-- 5. Bảng Quản lý tham gia
CREATE TABLE Enrollments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    StudentId NVARCHAR(20),
    DojoId NVARCHAR(20),
    EnrollDate DATE DEFAULT GETDATE(),
    status TINYINT NOT NULL, --0: Dropped (Nghỉ hẳn), 1: Active (Đang tập), 2: Trial (Học thử), 3: Reserved (Bảo lưu/Chấn thương), 4: Suspended (Đình chỉ/Kỷ luật)
    CONSTRAINT FK_Enroll_Student FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_Enroll_Dojo FOREIGN KEY (DojoId) REFERENCES Dojos(DojoId)
);
GO


-- =============================================
-- 1. INSERT DATA: ROLES
-- =============================================
-- Tạo 3 vai trò cơ bản cho hệ thống quản lý võ đường
INSERT INTO Roles (RoleName, Description) VALUES 
(N'Admin', N'Quản trị viên hệ thống - Toàn quyền truy cập'),
(N'Master', N'Võ sư chủ nhiệm - Quản lý võ đường và nhân sự'),
(N'Staff', N'Nhân viên văn phòng/Lễ tân - Quản lý ghi danh và thu phí');
GO

-- =============================================
-- 2. INSERT DATA: USERS
-- =============================================
-- Giả định ID của Roles: 1=Admin, 2=Master, 3=Staff (do Identity tự tăng)
-- Password ở đây để dạng text minh họa, thực tế nên là chuỗi Hash (BCrypt/MD5)

INSERT INTO Users (UserId, Password, Fullname, Email, RoleId, Active) VALUES
-- 1 Admin hệ thống
('AD001', 'hash_password_admin', N'Nguyễn Đài Vĩnh Khánh', 'admin@dojo.vn', 1, 1),

-- 2 Võ sư chủ nhiệm (Master)
('MS001', 'hash_password_hung', N'VS. Lê Văn Hùng', 'hung.le@dojo.vn', 2, 1),   -- Quản lý Thủ Đức
('MS002', 'hash_password_lan', N'VS. Trần Thị Lan', 'lan.tran@dojo.vn', 2, 1),  -- Quản lý Quận 9
('MS003', 'hash_password_duc', N'VS. Phạm Minh Đức', 'duc.pham@dojo.vn', 2, 1), -- Quản lý Bình Thạnh
('MS004', 'hash_password_hieu', N'VS. Mã Thanh Hiếu', 'hieu.ma@dojo.vn', 2, 1), -- Quản lý Bình Thạnh

-- 2 Nhân viên hỗ trợ (Staff)
('ST003', 'hash_password_nhan', N'Nguyễn Thành Nhân', 'nhan.nguyen@dojo.vn', 3, 1),
('ST004', 'hash_password_huu', N'Phạm Hữu', 'huu.pham@dojo.vn', 3, 1);
GO

-- =============================================
-- 3. INSERT DATA: DOJOS
-- =============================================
-- Tạo các địa điểm tập luyện thực tế, gắn liền với các Master ở trên
INSERT INTO Dojos (DojoId, Name, Address, MasterId, Active) VALUES
('DJ_TDUC', N'CLB Vovinam Thủ Đức', N'119 Võ Văn Ngân, TP. Thủ Đức', 'MS001', 1),
('DJ_Q009', N'CLB Vovinam Quận 9', N'Lê Văn Việt, TP. Thủ Đức', 'MS002', 1),
('DJ_BTHANH', N'Vovinam Bình Thạnh', N'8 Phan Đăng Lưu, Bình Thạnh', 'MS003', 1),
('DJ_OLD', N'CLB Vovinam Cũ', N'Khu giải tỏa', 'MS001', 0),
-- Tích hợp thêm CLB Năng Khiếu (Giao cho MS001 quản lý kiêm nhiệm)
INSERT INTO Dojos (DojoId, Name, Address, MasterId, Active) VALUES
('DJ_NK', N'CLB Năng Khiếu', N'Chung cư SunviewTown Gò Dưa', 'MS004', 1);
GO

-- =============================================
-- 4. INSERT DATA: STUDENTS
-- =============================================
-- Tạo danh sách võ sinh đa dạng độ tuổi, giới tính và cấp đai Vovinam
-- Cấp đai: Tự vệ nhập môn -> Lam đai -> Hoàng đai -> Chuẩn hồng đai

INSERT INTO Students (StudentId, FullName, Birthday, Gender, Phone, Rank) VALUES
-- Nhóm cao thủ (Hoàng đai)
('SV001', N'Trần Văn An', '1998-05-15', 1, '0909123456', N'Hoàng Đai Nhất'),
('SV002', N'Lê Thị Bích', '2000-10-20', 0, '0909123457', N'Hoàng Đai'),

-- Nhóm trung cấp (Lam đai)
('SV003', N'Nguyễn Tấn Dũng', '2005-01-12', 1, '0909123458', N'Lam Đai III'),
('SV004', N'Phạm Thu Hà', '2006-03-08', 0, '0909123459', N'Lam Đai II'),
('SV005', N'Hoàng Văn Nam', '2004-07-22', 1, '0909123460', N'Lam Đai I'),

-- Nhóm nhập môn (Mới tập)
('SV006', N'Đỗ Minh Khôi', '2010-09-05', 1, '0909123461', N'Tự Vệ Nhập Môn'), -- Học sinh nhỏ tuổi
('SV007', N'Ngô Bảo Châu', '2012-12-12', 0, '0909123462', N'Tự Vệ Nhập Môn'),
('SV008', N'Bùi Văn Long', '1995-02-28', 1, '0909123463', N'Tự Vệ Nhập Môn'), -- Người đi làm tập tối

-- Nhóm đã nghỉ hoặc bị kỷ luật
('SV009', N'Vũ Văn Xấu', '2002-04-30', 1, '0909123464', N'Lam Đai I'),
('SV010', N'Trương Thị Lười', '2003-11-11', 0, '0909123465', N'Tự Vệ Nhập Môn');
GO
INSERT INTO Students (StudentId, FullName, Birthday, Gender, Phone, Rank) VALUES
('NK01', N'Trần Quốc Toản', '2010-05-01', 1, '0981111101', N'Hoàng Đai'),
('NK02', N'Nguyễn Thị Ánh', '2011-02-14', 0, '0981111102', N'Hoàng Đai Nhất'),
('NK03', N'Lê Văn Luyện', '2009-08-20', 1, '0981111103', N'Hoàng Đai'),
('NK04', N'Phạm Hồng Nhung', '2010-11-11', 0, '0981111104', N'Hoàng Đai Nhị'),
('NK05', N'Đỗ Hùng Dũng', '2008-09-09', 1, '0981111105', N'Chuẩn Hồng Đai'),
('NK06', N'Bùi Tiến Dũng', '2009-01-23', 1, '0981111106', N'Hoàng Đai'),
('NK07', N'Vũ Thị Hoa', '2012-12-05', 0, '0981111107', N'Lam Đai III'),
('NK08', N'Đặng Văn Lâm', '2008-07-30', 1, '0981111108', N'Hoàng Đai Nhất'),
('NK09', N'Trịnh Công Sơn', '2010-03-15', 1, '0981111109', N'Hoàng Đai'),
('NK10', N'Lý Tiểu Long', '2011-06-01', 1, '0981111110', N'Lam Đai III'),
('NK11', N'Mai Phương Thúy', '2009-04-20', 0, '0981111111', N'Hoàng Đai'),
('NK12', N'Hồ Ngọc Hà', '2010-10-10', 0, '0981111112', N'Lam Đai II'),
('NK13', N'Dương Quá', '2008-11-25', 1, '0981111113', N'Chuẩn Hồng Đai'),
('NK14', N'Tiểu Long Nữ', '2009-09-09', 0, '0981111114', N'Hoàng Đai Nhị'),
('NK15', N'Quách Tĩnh', '2010-01-01', 1, '0981111115', N'Hoàng Đai'),
('NK16', N'Hoàng Dung', '2011-05-05', 0, '0981111116', N'Lam Đai III'),
('NK17', N'Âu Dương Phong', '2008-08-08', 1, '0981111117', N'Hoàng Đai Nhất'),
('NK18', N'Chu Bá Thông', '2009-12-12', 1, '0981111118', N'Hoàng Đai'),
('NK19', N'Mạc Đăng Khoa', '2010-02-28', 1, '0981111119', N'Lam Đai II'),
('NK20', N'Trấn Thành', '2008-06-15', 1, '0981111120', N'Chuẩn Hồng Đai');
-- =============================================
-- 5. INSERT DATA: ENROLLMENTS
-- =============================================
-- Gắn kết Võ sinh vào Võ đường với các Status khác nhau (Active, Trial, Suspended...)
-- Status: 0: Dropped, 1: Active, 2: Trial, 3: Reserved, 4: Suspended

INSERT INTO Enrollments (StudentId, DojoId, EnrollDate, status) VALUES
-- CLB Thủ Đức (DJ_TDUC)
('SV001', 'DJ_TDUC', '2023-01-10', 1), -- Trần Văn An: Đang tập (Active)
('SV003', 'DJ_TDUC', '2023-06-15', 1), -- Nguyễn Tấn Dũng: Đang tập (Active)
('SV006', 'DJ_TDUC', '2024-02-01', 2), -- Đỗ Minh Khôi: Học thử (Trial)
('SV009', 'DJ_TDUC', '2023-05-20', 4), -- Vũ Văn Xấu: Bị kỷ luật (Suspended) do đánh nhau

-- CLB Quận 9 (DJ_Q009)
('SV002', 'DJ_Q009', '2022-08-05', 3), -- Lê Thị Bích: Bảo lưu (Reserved) do chấn thương
('SV004', 'DJ_Q009', '2023-09-10', 1), -- Phạm Thu Hà: Đang tập (Active)
('SV010', 'DJ_Q009', '2023-01-01', 0), -- Trương Thị Lười: Nghỉ hẳn (Dropped)

-- CLB Bình Thạnh (DJ_BTHANH)
('SV005', 'DJ_BTHANH', '2023-11-20', 1), -- Hoàng Văn Nam: Đang tập (Active)
('SV007', 'DJ_BTHANH', '2024-01-15', 2), -- Ngô Bảo Châu: Học thử (Trial)
('SV008', 'DJ_BTHANH', '2024-02-10', 1); -- Bùi Văn Long: Đang tập (Active)

-- Một trường hợp đặc biệt: SV001 từng học ở CLB Cũ trước khi chuyển sang Thủ Đức
INSERT INTO Enrollments (StudentId, DojoId, EnrollDate, status) VALUES
('SV001', 'DJ_OLD', '2020-01-01', 0); -- Đã nghỉ ở CLB cũ (Dropped)
-- Đội năng khiếu (DJ_NangKhieu)
INSERT INTO Enrollments (StudentId, DojoId, EnrollDate, status) VALUES
('NK01', 'DJ_NK', '2023-01-01', 1),
('NK02', 'DJ_NK', '2023-02-01', 1),
('NK03', 'DJ_NK', '2023-01-15', 1),
('NK04', 'DJ_NK', '2023-03-01', 1),
('NK05', 'DJ_NK', '2022-12-01', 1),
('NK06', 'DJ_NK', '2023-04-10', 1),
('NK07', 'DJ_NK', '2023-05-05', 1),
('NK08', 'DJ_NK', '2023-01-20', 1),
('NK09', 'DJ_NK', '2023-06-01', 1),
('NK10', 'DJ_NK', '2023-07-15', 1),
('NK11', 'DJ_NK', '2023-02-14', 1),
('NK12', 'DJ_NK', '2023-03-08', 1),
('NK13', 'DJ_NK', '2022-11-20', 1),
('NK14', 'DJ_NK', '2023-08-01', 1),
('NK15', 'DJ_NK', '2023-01-10', 1),
('NK16', 'DJ_NK', '2023-09-05', 1),
('NK17', 'DJ_NK', '2023-05-20', 1),
('NK18', 'DJ_NK', '2023-10-01', 1),
('NK19', 'DJ_NK', '2023-04-30', 1),
('NK20', 'DJ_NK', '2022-12-25', 1);
GO
GO

USE master;
GO
-- Kiểm tra xem database có tồn tại hay không trước khi xóa
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Dojo')
BEGIN
    -- Chuyển database về chế độ SINGLE_USER để ngắt tất cả kết nối hiện tại
    ALTER DATABASE Dojo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Xóa database
    DROP DATABASE Dojo;
    
    PRINT 'Da xoa database Dojo thanh cong.';
END
ELSE
BEGIN
    PRINT 'Database Dojo khong ton tai.';
END
GO

Select * from Roles
GO
SELECT * FROM Users
GO
SELECT * FROM Enrollments
GO
SELECT * FROM Students
GO 
SELECT * FROM Dojos