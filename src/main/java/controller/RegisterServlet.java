package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.StudentDAO;
import model.UserDAO;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	private final UserDAO userDAO = new UserDAO();
	private final StudentDAO studentDAO = new StudentDAO();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String username = req.getParameter("username");
		String password = req.getParameter("password");
		String role = req.getParameter("role");

		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String rollNo = req.getParameter("rollNo");

		// Register user
		userDAO.register(username, password, role);
		boolean success = true;

		if (!success) {
			req.setAttribute("error", "Username already exists");
			req.getRequestDispatcher("/register.jsp").forward(req, resp);
			return;
		}

		// If student, create student profile
		if ("STUDENT".equals(role)) {
			int userId = userDAO.login(username, password).getId();
			studentDAO.createStudent(userId, name, email, null, rollNo);
		}

		resp.sendRedirect(req.getContextPath() + "/login.jsp");
	}
}