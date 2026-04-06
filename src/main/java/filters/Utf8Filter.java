package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class Utf8Filter implements Filter {

    private static final String UTF_8 = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(UTF_8);
        response.setCharacterEncoding(UTF_8);
        if (response instanceof HttpServletResponse httpResp) {
            httpResp.setContentType("text/html; charset=UTF-8");
        }
        chain.doFilter(request, response);
    }
}