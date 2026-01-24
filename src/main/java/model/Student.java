package model;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "Students")
public class Student {
    @Id
    @Column(name = "StudentId", length = 20)
    private String studentId;

    @Column(nullable = false, length = 100)
    private String fullName;

    private LocalDate birthday;

    private Boolean gender; // 1: Nam, 0: Nữ

    @Column(length = 15)
    private String phone;

    @Column(length = 50)
    private String rank;

    @OneToMany(mappedBy = "student")
    private List<Enrollment> enrollments;

    public Student(String studentId, List<Enrollment> enrollments, String rank, String phone, Boolean gender, LocalDate birthday, String fullName) {
        this.studentId = studentId;
        this.enrollments = enrollments;
        this.rank = rank;
        this.phone = phone;
        this.gender = gender;
        this.birthday = birthday;
        this.fullName = fullName;
    }

    public Student() {
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }

    public String getRank() {
        return rank;
    }

    public void setRank(String rank) {
        this.rank = rank;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
// Getters và Setters
}
