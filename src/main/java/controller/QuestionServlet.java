package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.Question;
import model.QuestionDAO;

@WebServlet("/faculty/addQuestion")
public class QuestionServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int examId = Integer.parseInt(request.getParameter("exam_id"));
		String question = request.getParameter("question");
		String optionA = request.getParameter("option_a");
		String optionB = request.getParameter("option_b");
		String optionC = request.getParameter("option_c");
		String optionD = request.getParameter("option_d");
		String correctAnswer = request.getParameter("correct_answer");

		Question q = new Question();

		q.setExamId(examId);
		q.setQuestion(question);
		q.setOptionA(optionA);
		q.setOptionB(optionB);
		q.setOptionC(optionC);
		q.setOptionD(optionD);
		q.setCorrectAnswer(correctAnswer);

		QuestionDAO dao = new QuestionDAO();
		dao.addQuestion(q);

		response.sendRedirect("add_questions.jsp");
	}
}