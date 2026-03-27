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

    @Column(name = "Avatar")
    private String avatar;

    @Column(name = "Auth_provider", length = 20)
    private String authProvider = "LOCAL";

    public User(String userId, String avatar, List<Dojo> managedDojos, LocalDateTime createdAt, Boolean active, Role role, String email, String fullname, String password, String authProvider) {
        this.userId = userId;
        this.avatar = avatar;
        this.managedDojos = managedDojos;
        this.createdAt = createdAt;
        this.active = active;
        this.role = role;
        this.email = email;
        this.fullname = fullname;
        this.password = password;
        this.authProvider = authProvider;
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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(String authProvider) {
        this.authProvider = authProvider;
    }

    public boolean hasRole(Role.RoleName roleNameToCheck) {
        if (this.role == null || this.role.getRoleName() == null) {
            return false;
        }
        return this.role.getRoleName() == roleNameToCheck;
    }
}