package model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "Users")
public class User {
    @Id
    @Column(name = "UserId", length = 20)
    private String userId;

    @Column(nullable = false, length = 20)
    private String password;

    @Column(length = 100)
    private String fullname;

    @Column(length = 100)
    private String email;

    @Column(length = 20)
    private String role = "Staff";

    private Boolean active = true;

    @OneToMany(mappedBy = "master")
    private List<Dojo> managedDojos;

    public User() {
    }

    public User(String userId, String password, String fullname, String email, String role, Boolean active, List<Dojo> managedDojos) {
        this.userId = userId;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
        this.role = role;
        this.active = active;
        this.managedDojos = managedDojos;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public List<Dojo> getManagedDojos() {
        return managedDojos;
    }

    public void setManagedDojos(List<Dojo> managedDojos) {
        this.managedDojos = managedDojos;
    }
// Getters và Setters
}
