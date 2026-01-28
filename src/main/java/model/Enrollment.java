package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Enrollments")
public class Enrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // QUAN TRỌNG: Khóa ngoại StudentId
    @ManyToOne
    @JoinColumn(name = "StudentId")
    private Student student;

    // QUAN TRỌNG: Khóa ngoại DojoId
    @ManyToOne
    @JoinColumn(name = "DojoId")
    private Dojo dojo;

    @Column(name = "EnrollDate")
    private LocalDate enrollDate = LocalDate.now();

    public enum EnrollmentStatus {
        DROPPED,    // 0: Nghỉ hẳn
        ACTIVE,     // 1: Đang tập
        TRIAL,      // 2: Học thử
        RESERVED,   // 3: Bảo lưu
        SUSPENDED   // 4: Đình chỉ
    }

    @Column(name = "Status", nullable = false)
    @Enumerated(EnumType.ORDINAL)
    private EnrollmentStatus status;

    public Enrollment() {
    }

    public Enrollment(Integer id, EnrollmentStatus status, LocalDate enrollDate, Dojo dojo, Student student) {
        this.id = id;
        this.status = status;
        this.enrollDate = enrollDate;
        this.dojo = dojo;
        this.student = student;
    }

    public EnrollmentStatus getStatus() {
        return status;
    }

    public void setStatus(EnrollmentStatus status) {
        this.status = status;
    }

    public LocalDate getEnrollDate() {
        return enrollDate;
    }

    public void setEnrollDate(LocalDate enrollDate) {
        this.enrollDate = enrollDate;
    }

    public Dojo getDojo() {
        return dojo;
    }

    public void setDojo(Dojo dojo) {
        this.dojo = dojo;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}