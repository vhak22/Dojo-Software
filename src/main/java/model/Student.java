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

    @Column(name = "FullName", nullable = false, length = 100)
    private String fullName;

    @Column(name = "Birthday")
    private LocalDate birthday;

    @Column(name = "Gender")
    private Boolean gender; // true: Nam, false: Nữ

    @Column(name = "Phone", length = 15)
    private String phone;

    @Column(name = "Rank", length = 50)
    private String rank;

    // Một Student có thể có nhiều Enrollment
    @OneToMany(mappedBy = "student")
    private List<Enrollment> enrollments;

    @Column(name = "Active")
    private Boolean active = true;

    public Student() {
    }

    public Student(List<Enrollment> enrollments, Boolean active, String rank, String phone, Boolean gender, LocalDate birthday, String fullName, String studentId) {
        this.enrollments = enrollments;
        this.rank = rank;
        this.phone = phone;
        this.gender = gender;
        this.birthday = birthday;
        this.fullName = fullName;
        this.studentId = studentId;
        this.active = active;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
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

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }
}