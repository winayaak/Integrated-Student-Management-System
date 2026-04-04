package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import model.Question;
import model.QuestionDAO;
import util.DBConnection;

@WebServlet("/student/submitExam")
public class ExamSubmitServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int examId = Integer.parseInt(request.getParameter("examId"));

		HttpSession session = request.getSession();
		Integer studentId = (Integer) session.getAttribute("userId");

		if (studentId == null) {
			studentId = 1;
		}

		try {

			Connection conn = DBConnection.getConnection();

			// 🔹 Check if student already attempted
			PreparedStatement check = conn
					.prepareStatement("SELECT * FROM exam_results WHERE student_id=? AND exam_id=?");

			check.setInt(1, studentId);
			check.setInt(2, examId);

			ResultSet rs = check.executeQuery();

			if (rs.next()) {

				// Already attempted
				response.sendRedirect("dashboard.jsp");
				return;

			}

			QuestionDAO questionDAO = new QuestionDAO();
			List<Question> questions = questionDAO.getQuestionsByExamId(examId);

			int score = 0;

			for (Question q : questions) {

				String answer = request.getParameter("q" + q.getId());

				if (answer != null && answer.equalsIgnoreCase(q.getCorrectAnswer())) {
					score++;
				}

			}

			int totalQuestions = questions.size();

			// 🔹 Save result
			PreparedStatement ps = conn
					.prepareStatement("INSERT INTO exam_results (student_id, exam_id, score) VALUES (?, ?, ?)");

			ps.setInt(1, studentId);
			ps.setInt(2, examId);
			ps.setInt(3, score);

			ps.executeUpdate();

			request.setAttribute("score", score);
			request.setAttribute("total", totalQuestions);

			request.getRequestDispatcher("result.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}