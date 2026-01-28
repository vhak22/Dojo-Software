package controller;

import dao.DojoDAO;
import dao.UserDAO;
import dao.daoimpl.DojoDAOImpl;
import dao.daoimpl.UserDAOImpl;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Role;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet({
        "/home"
})
public class HomeServlet extends HttpServlet {
    DojoDAO dojoDAO = new DojoDAOImpl();
    private UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setAttribute("trainers",userDAO.findByRole(Role.RoleName.MASTER) );
        req.setAttribute("listDojo", dojoDAO.findAll());
        req.getRequestDispatcher("/views/index.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Code xử lý gửi dữ liệu vào Hibernate DAO ở đây
    }
}