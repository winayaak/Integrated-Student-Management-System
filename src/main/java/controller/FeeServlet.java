package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.FeeDAO;
import model.StudentDAO;

import java.io.IOException;

@WebServlet("/admin/fees")
public class FeeServlet extends HttpServlet {

	private final FeeDAO feeDAO = new FeeDAO();
	private final StudentDAO studentDAO = new StudentDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		// Load fees
		req.setAttribute("fees", feeDAO.findAll());

		// 🔥 Load students for dropdown
		req.setAttribute("students", studentDAO.findAll());

		req.getRequestDispatcher("/admin/fees.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");

		try {

			if ("add".equals(action)) {

				int studentId = Integer.parseInt(req.getParameter("studentId"));
				double amount = Double.parseDouble(req.getParameter("amount"));
				String feeType = req.getParameter("feeType");
				String dueDate = req.getParameter("dueDate");

				feeDAO.add(studentId, amount, feeType, dueDate);

			} else if ("markPaid".equals(action)) {

				int id = Integer.parseInt(req.getParameter("id"));
				feeDAO.markPaid(id);

			} else if ("delete".equals(action)) {

				int id = Integer.parseInt(req.getParameter("id"));
				feeDAO.delete(id);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		resp.sendRedirect(req.getContextPath() + "/admin/fees");
	}
}