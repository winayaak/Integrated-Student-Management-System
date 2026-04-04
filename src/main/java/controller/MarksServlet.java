package controller;

import model.MarksDAO;
import model.Student;
import model.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/marks")
public class MarksServlet extends HttpServlet {

	private final MarksDAO marksDAO = new MarksDAO();
	private final StudentDAO studentDAO = new StudentDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// Open marks page
		req.getRequestDispatcher("/faculty/marks.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		try {

			int subjectId = Integer.parseInt(req.getParameter("subjectId"));
			int semester = Integer.parseInt(req.getParameter("semester"));

			List<Student> students = studentDAO.findAll();

			for (Student s : students) {

				String marksStr = req.getParameter("marks_" + s.getId());

				if (marksStr != null && !marksStr.isEmpty()) {

					double marks = Double.parseDouble(marksStr);

					marksDAO.addOrUpdate(s.getId(), subjectId, semester, marks);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			throw new ServletException("Error saving marks", e);
		}

		// Redirect after saving
		resp.sendRedirect(req.getContextPath() + "/faculty/marks");
	}
}