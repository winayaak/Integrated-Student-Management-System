package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

import model.Library;
import model.LibraryDAO;

@WebServlet("/admin/library")
public class LibraryServlet extends HttpServlet {

    private LibraryDAO dao = new LibraryDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Library> list = dao.findAll();
        req.setAttribute("list", list);

        req.getRequestDispatcher("/admin/library.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {

            int studentId = Integer.parseInt(req.getParameter("student_id"));
            int bookId = Integer.parseInt(req.getParameter("book_id"));

            dao.add(studentId, bookId,
                    new java.sql.Date(System.currentTimeMillis())); // ✅ FIXED
        }

        if ("return".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            dao.returnBook(id);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/library");
    }
}