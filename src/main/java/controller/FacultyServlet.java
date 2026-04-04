package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/faculty")
public class FacultyServlet extends HttpServlet {

	private FacultyDAO facultyDAO = new FacultyDAO();
	private UserDAO userDAO = new UserDAO();

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<Faculty> faculty = facultyDAO.findAll();

		req.setAttribute("faculty", faculty);

		req.getRequestDispatcher("/admin/faculty.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");

		if ("add".equals(action)) {

			String username = req.getParameter("username");
			String name = req.getParameter("name");
			String email = req.getParameter("email");
			String department = req.getParameter("department");
			String phone = req.getParameter("phone");

			String password = "123";

			userDAO.register(username, password, "FACULTY");

			User user = userDAO.login(username, password);

			if (user != null) {

				facultyDAO.add(user.getId(), name, email, department, phone);

			}

		}

		if ("delete".equals(action)) {

			int id = Integer.parseInt(req.getParameter("id"));

			facultyDAO.delete(id);
		}

		resp.sendRedirect(req.getContextPath() + "/admin/faculty");

	}
}