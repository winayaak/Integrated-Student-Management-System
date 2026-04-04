package controller;

import ai.AcademicRiskDetector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Student;
import model.StudentDAO;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/ai-insights")
public class AIInsightsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		List<Student> students = new StudentDAO().findAll();
		List<Object[]> atRisk = new ArrayList<>();

		for (Student s : students) {

			AcademicRiskDetector.RiskResult result = AcademicRiskDetector.assess(s.getId());

			if (!"SAFE".equals(result.getRiskLevel())) {
				atRisk.add(new Object[] { s, result });
			}
		}

		req.setAttribute("atRisk", atRisk);
		req.getRequestDispatcher("/admin/ai-insights.jsp").forward(req, resp);
	}
}