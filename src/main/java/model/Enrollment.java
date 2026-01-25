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

    @Column(name = "Status", length = 50)
    private String status;

    public Enrollment(Integer id, String status, LocalDate enrollDate, Dojo dojo, Student student) {
        this.id = id;
        this.status = status;
        this.enrollDate = enrollDate;
        this.dojo = dojo;
        this.student = student;
    }

    public Enrollment() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
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
}