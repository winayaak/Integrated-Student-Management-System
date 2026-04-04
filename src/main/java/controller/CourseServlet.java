package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/courses")
public class CourseServlet extends HttpServlet {

	private CourseDAO courseDAO = new CourseDAO();

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<Course> courses = courseDAO.findAll();

		req.setAttribute("courses", courses);

		req.getRequestDispatcher("/admin/courses.jsp").forward(req, resp);
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");

		if ("add".equals(action)) {

			String name = req.getParameter("name");
			String code = req.getParameter("code");
			int credits = Integer.parseInt(req.getParameter("credits"));
			String department = req.getParameter("department");

			courseDAO.add(name, code, credits, department);
		}

		if ("delete".equals(action)) {

			int id = Integer.parseInt(req.getParameter("id"));

			courseDAO.delete(id);
		}

		resp.sendRedirect(req.getContextPath() + "/admin/courses");
	}
}