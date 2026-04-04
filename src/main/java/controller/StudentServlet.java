package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.StudentDAO;
import model.UserDAO;

import java.io.IOException;

@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {

	private final StudentDAO studentDAO = new StudentDAO();
	private final UserDAO userDAO = new UserDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setAttribute("students", studentDAO.findAll());
		req.getRequestDispatcher("/admin/students.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");

		try {

			// ================= ADD =================
			if ("add".equals(action)) {

				String username = req.getParameter("username");
				String password = req.getParameter("password");

				userDAO.register(username, password, "STUDENT");
				boolean created = true;

				if (created) {
					int userId = userDAO.getUserIdByUsername(username);

					studentDAO.createStudent(userId, req.getParameter("name"), req.getParameter("email"),
							Integer.parseInt(req.getParameter("courseId")), req.getParameter("rollNo"));
				}
			}

			// ================= DELETE =================
			else if ("delete".equals(action)) {
				studentDAO.delete(Integer.parseInt(req.getParameter("id")));
			}

			// ================= UPDATE =================
			else if ("update".equals(action)) {
				studentDAO.update(Integer.parseInt(req.getParameter("id")), req.getParameter("name"),
						req.getParameter("email"), Integer.parseInt(req.getParameter("courseId")),
						req.getParameter("rollNo"), Integer.parseInt(req.getParameter("semester")));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		resp.sendRedirect(req.getContextPath() + "/admin/students");
	}
}