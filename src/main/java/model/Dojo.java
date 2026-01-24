package model;


import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "Dojos")
public class Dojo {
    @Id
    @Column(name = "DojoId", length = 20)
    private String dojoId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 255)
    private String address;

    @ManyToOne
    @JoinColumn(name = "MasterId")
    private User master;

    private Boolean active = true;

    @OneToMany(mappedBy = "dojo")
    private List<Enrollment> enrollments;

    public Dojo() {
    }

    public Dojo(User master, List<Enrollment> enrollments, Boolean active, String address, String name, String dojoId) {
        this.master = master;
        this.enrollments = enrollments;
        this.active = active;
        this.address = address;
        this.name = name;
        this.dojoId = dojoId;
    }

    public String getDojoId() {
        return dojoId;
    }

    public void setDojoId(String dojoId) {
        this.dojoId = dojoId;
    }

    public List<Enrollment> getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(List<Enrollment> enrollments) {
        this.enrollments = enrollments;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public User getMaster() {
        return master;
    }

    public void setMaster(User master) {
        this.master = master;
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
// Getters và Setters
}