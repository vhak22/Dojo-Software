package utils;

import dao.CrudDAO;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

public class PaginationUtil {
    public static <T, K> void paginate(HttpServletRequest request, CrudDAO<T, K> dao, int pageSize) {
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        try {
            if (pageStr != null && !pageStr.isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        List<T> list = dao.searchAndPaginate(keyword, currentPage, pageSize);
        long totalCount = dao.getTotalCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        request.setAttribute("items", list);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
    }
}