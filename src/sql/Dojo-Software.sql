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
    Status NVARCHAR(50), 
    CONSTRAINT FK_Enroll_Student FOREIGN KEY (StudentId) REFERENCES Students(StudentId),
    CONSTRAINT FK_Enroll_Dojo FOREIGN KEY (DojoId) REFERENCES Dojos(DojoId)
);
GO

-- Chèn dữ liệu mẫu cho Roles
INSERT INTO Roles (RoleName, Description) VALUES 
(N'Admin', N'Quản trị viên hệ thống'),
(N'Master', N'Võ sư quản lý võ đường'),
(N'Staff', N'Nhân viên hỗ trợ');