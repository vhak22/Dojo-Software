package model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Dojos")
public class Dojo {
    @Id
    @Column(name = "DojoId", length = 20)
    private String dojoId;

    @Column(name = "Name", nullable = false, length = 100)
    private String name;

    @Column(name = "Address", length = 255)
    private String address;

    // QUAN TRỌNG: Mapping khóa ngoại MasterId sang Object User
    @ManyToOne
    @JoinColumn(name = "MasterId")
    private User master;

    @Column(name = "Active")
    private Boolean active = true;

    // Một Dojo có nhiều lượt Enrollment
    @OneToMany(mappedBy = "dojo")
    private List<Enrollment> enrollments;

    public Dojo() {
    }

    public Dojo(String dojoId, List<Enrollment> enrollments, Boolean active, User master, String address, String name) {
        this.dojoId = dojoId;
        this.enrollments = enrollments;
        this.active = active;
        this.master = master;
        this.address = address;
        this.name = name;
    }

    public String getDojoId() {
        return dojoId;
    }

    public void setDojoId(String dojoId) {
        this.dojoId = dojoId;
    }

    public User getMaster() {
        return master;
    }

    public void setMaster(User master) {
        this.master = master;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }
}