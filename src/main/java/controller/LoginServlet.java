package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.User;
import model.UserDAO;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	private final UserDAO userDAO = new UserDAO();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String username = req.getParameter("username");
		String password = req.getParameter("password");

		User user = userDAO.login(username, password);

		if (user != null) {

			HttpSession session = req.getSession();

			// Store full user object
			session.setAttribute("user", user);

			// Store common values
			session.setAttribute("userId", user.getId());
			session.setAttribute("role", user.getRole());

			if ("ADMIN".equals(user.getRole())) {

				resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");

			} else if ("FACULTY".equals(user.getRole())) {

				// Store faculty id
				session.setAttribute("facultyId", user.getId());

				resp.sendRedirect(req.getContextPath() + "/faculty/dashboard.jsp");

			} else if ("STUDENT".equals(user.getRole())) {

				// Store student id
				session.setAttribute("studentId", user.getId());

				resp.sendRedirect(req.getContextPath() + "/student/dashboard.jsp");

			}

		} else {

			req.setAttribute("error", "Invalid username or password");
			req.getRequestDispatcher("/login.jsp").forward(req, resp);

		}
	}

}