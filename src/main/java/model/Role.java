package model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    public enum RoleName {
        ADMIN,
        MASTER,
        STAFF
    }

    @Column(name = "RoleName", nullable = false, length = 50, unique = true)
    @Enumerated(EnumType.ORDINAL)
    private RoleName roleName;

    @Column(name = "Description", length = 255)
    private String description;

    // Một Role có thể được gán cho nhiều User
    @OneToMany(mappedBy = "role")
    private List<User> users;

    public Role() {
    }

    public Role(Integer id, List<User> users, String description, RoleName roleName) {
        this.id = id;
        this.users = users;
        this.description = description;
        this.roleName = roleName;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public RoleName getRoleName() {
        return roleName;
    }

    public void setRoleName(RoleName roleName) {
        this.roleName = roleName;
    }
}