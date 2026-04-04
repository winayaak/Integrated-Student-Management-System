package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.Exam;
import model.ExamDAO;

@WebServlet("/faculty/createExam")
public class ExamServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String title = request.getParameter("title");
		String examDate = request.getParameter("examDate");
		int duration = Integer.parseInt(request.getParameter("duration"));

		HttpSession session = request.getSession();

		Integer facultyId = (Integer) session.getAttribute("userId");

		if (facultyId == null) {
			response.sendRedirect("../login.jsp");
			return;
		}

		Exam exam = new Exam();
		exam.setTitle(title);
		exam.setExamDate(examDate);
		exam.setDuration(duration);
		exam.setFacultyId(facultyId);

		ExamDAO dao = new ExamDAO();
		dao.createExam(exam);

		response.sendRedirect("dashboard.jsp");
	}
}