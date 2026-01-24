CREATE DATABASE Dojo;
GO
USE Dojo;
GO

-- 1. Bảng Người dùng (Gồm Admin, Nhân viên và Võ sư/Master)
CREATE TABLE Users (
    UserId NVARCHAR(20) PRIMARY KEY, -- Đã đổi từ Username thành UserId
    Password NVARCHAR(20) NOT NULL,
    Fullname NVARCHAR(100),
    Email NVARCHAR(100),
    Role NVARCHAR(20) DEFAULT 'Staff', -- Phân quyền: 'Admin', 'Master', 'Staff'
    Active BIT DEFAULT 1
);

-- 2. Bảng Võ đường (Kết nối trực tiếp với bảng Users qua UserId của Master)
CREATE TABLE Dojos (
    DojoId NVARCHAR(20) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    MasterId NVARCHAR(20), -- Khóa ngoại trỏ đến UserId trong bảng Users
    Active BIT DEFAULT 1,
    CONSTRAINT FK_Dojo_Master FOREIGN KEY (MasterId) REFERENCES Users(UserId)
);

-- 3. Bảng Võ sinh
CREATE TABLE Students (
    StudentId NVARCHAR(20) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Birthday DATE,
    Gender BIT, -- 1: Nam, 0: Nữ
    Phone NVARCHAR(15),
    Rank NVARCHAR(50) -- Cấp đai
);

-- 4. Bảng Quản lý tham gia (Kết nối Võ sinh và Võ đường)
CREATE TABLE Enrollments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    StudentId NVARCHAR(20),
    DojoId NVARCHAR(20),
    EnrollDate DATE DEFAULT GETDATE(),
    Status NVARCHAR(50), -- Đang tập, Đã nghỉ
    CONSTRAINT FK_Enroll_Student FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_Enroll_Dojo FOREIGN KEY (DojoId) REFERENCES Dojos(DojoId)
);
GO