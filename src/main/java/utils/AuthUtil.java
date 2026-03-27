package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.Role;
import model.User;

import java.util.Arrays;
import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;

public final class AuthUtil {

    public static final String SESSION_CURRENT_USER = "currentUser";

    private AuthUtil() {
    }

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object obj = session.getAttribute(SESSION_CURRENT_USER);
        return (obj instanceof User) ? (User) obj : null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public static void login(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(SESSION_CURRENT_USER, user);
    }

    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static boolean hasRole(HttpServletRequest request, Role.RoleName requiredRole) {
        User user = getCurrentUser(request);
        if (user == null || user.getRole() == null || user.getRole().getRoleName() == null) {
            return false;
        }
        return user.getRole().getRoleName() == requiredRole;
    }

    public static boolean hasAnyRole(HttpServletRequest request, Role.RoleName... roles) {
        Set<Role.RoleName> roleSet = Arrays.stream(roles).collect(Collectors.toSet());
        User user = getCurrentUser(request);
        if (user == null || user.getRole() == null || user.getRole().getRoleName() == null) {
            return false;
        }
        return roleSet.contains(user.getRole().getRoleName());
    }

    public static Set<Role.RoleName> toRoleSet(String csvRoles) {
        if (csvRoles == null || csvRoles.isBlank()) return Collections.emptySet();
        return Arrays.stream(csvRoles.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(String::toUpperCase)
                .map(Role.RoleName::valueOf)
                .collect(Collectors.toSet());
    }
}