package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Question;
import model.QuestionDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/startExam")
public class ExamStartServlet extends HttpServlet {

	QuestionDAO questionDAO = new QuestionDAO();

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		try {

			int examId = Integer.parseInt(req.getParameter("examId"));

			List<Question> questions = questionDAO.getQuestionsByExamId(examId);

			req.setAttribute("questions", questions);
			req.setAttribute("examId", examId);

			req.getRequestDispatcher("/student/take_exam.jsp").forward(req, resp);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}