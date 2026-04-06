package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Role;
import utils.AuthUtil;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/master/*", "/staff/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // 1) Not logged in -> login page
        if (!AuthUtil.isLoggedIn(req)) {
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // 2) Role-based checks
        boolean authorized =
                (uri.startsWith(contextPath + "/admin/") && AuthUtil.hasRole(req, Role.RoleName.ADMIN)) ||
                (uri.startsWith(contextPath + "/master/") && AuthUtil.hasAnyRole(req, Role.RoleName.ADMIN, Role.RoleName.MASTER)) ||
                (uri.startsWith(contextPath + "/staff/") && AuthUtil.hasAnyRole(req, Role.RoleName.ADMIN, Role.RoleName.MASTER, Role.RoleName.STAFF));

        if (!authorized) {
            // Option A: redirect to a 403 JSP
            resp.sendRedirect(contextPath + "/views/errors/403.jsp");
            // Option B: resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}