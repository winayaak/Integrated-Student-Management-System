package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.AttendanceDAO;
import model.MarksDAO;
import model.Student;
import model.StudentDAO;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/student/ml-prediction")
public class MLPredictionServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		resp.setContentType("application/json");
		resp.setCharacterEncoding("UTF-8");

		User user = (User) req.getSession().getAttribute("user");

		Student student = user != null ? new StudentDAO().findByUserId(user.getId()) : null;

		if (student == null) {
			resp.getWriter().print("{\"likelihood\":\"N/A\",\"message\":\"Student not found\"}");
			return;
		}

		double attPct = new AttendanceDAO().getAttendancePercentage(student.getId());

		double cgpa = new MarksDAO().getOverallCGPA(student.getId());

		String likelihood;

		if (attPct >= 75 && cgpa >= 7.5)
			likelihood = "HIGH";
		else if (attPct >= 75 && cgpa >= 6.0)
			likelihood = "MEDIUM";
		else if (attPct >= 60 && cgpa >= 5.0)
			likelihood = "LOW";
		else
			likelihood = "VERY_LOW";

		PrintWriter out = resp.getWriter();
		out.print("{\"likelihood\":\"" + likelihood + "\",\"attendance\":" + attPct + ",\"cgpa\":" + cgpa + "}");
	}
}