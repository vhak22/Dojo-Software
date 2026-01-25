package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "Users")
public class User {
    @Id
    @Column(name = "UserId", length = 20)
    private String userId;

    @Column(name = "Password", nullable = false, length = 100)
    private String password;

    @Column(name = "Fullname", length = 100)
    private String fullname;

    @Column(name = "Email", unique = true, length = 100)
    private String email;

    // QUAN TRỌNG: Mapping khóa ngoại RoleId sang Object Role
    @ManyToOne
    @JoinColumn(name = "RoleId")
    private Role role;

    @Column(name = "Active")
    private Boolean active = true;

    @Column(name = "Created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    // Một Master (User) có thể quản lý nhiều Dojo
    @OneToMany(mappedBy = "master")
    private List<Dojo> managedDojos;

    public User(List<Dojo> managedDojos, LocalDateTime createdAt, Role role, Boolean active, String email, String fullname, String password, String userId) {
        this.managedDojos = managedDojos;
        this.createdAt = createdAt;
        this.role = role;
        this.active = active;
        this.email = email;
        this.fullname = fullname;
        this.password = password;
        this.userId = userId;
    }

    public User() {
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<Dojo> getManagedDojos() {
        return managedDojos;
    }

    public void setManagedDojos(List<Dojo> managedDojos) {
        this.managedDojos = managedDojos;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}