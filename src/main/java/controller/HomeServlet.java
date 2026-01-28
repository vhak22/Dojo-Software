package controller;

import dao.DojoDAO;
import dao.daoimpl.DojoDAOImpl;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet({
        "/home"
})
public class HomeServlet extends HttpServlet {
    DojoDAO dojoDAO = new DojoDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listDojo", dojoDAO.findAll());
        req.getRequestDispatcher("/views/index.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Code xử lý gửi dữ liệu vào Hibernate DAO ở đây
    }
}