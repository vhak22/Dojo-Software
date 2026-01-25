package model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "RoleName", nullable = false, length = 50, unique = true)
    private String roleName;

    @Column(name = "Description", length = 255)
    private String description;

    // Một Role có thể được gán cho nhiều User
    @OneToMany(mappedBy = "role")
    private List<User> users;

    public Role() {
    }
    public Role(String roleName, String description) {
        this.roleName = roleName;
        this.description = description;
    }


    // Getters và Setters

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}