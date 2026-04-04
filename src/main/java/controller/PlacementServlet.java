package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBConnection;

import model.PlacementDAO;
import model.User;

import java.io.IOException;

@WebServlet({ "/admin/placement", "/faculty/placement", "/student/placement" })
public class PlacementServlet extends HttpServlet {

	private final PlacementDAO placementDAO = new PlacementDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String path = req.getServletPath();

		// ADMIN / FACULTY VIEW
		if (path.equals("/admin/placement") || path.equals("/faculty/placement")) {

			req.setAttribute("companies", placementDAO.getCompanies());
			req.setAttribute("placements", placementDAO.getAll());

			req.getRequestDispatcher("/admin/placement.jsp").forward(req, resp);
			return;
		}

		// STUDENT VIEW
		if (path.equals("/student/placement")) {

			HttpSession session = req.getSession();
			User user = (User) session.getAttribute("user");

			int studentId = 0;

			try {

				Connection conn = DBConnection.getConnection();

				PreparedStatement ps = conn.prepareStatement("SELECT id FROM students WHERE user_id=?");

				ps.setInt(1, user.getId());

				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					studentId = rs.getInt("id");
				}

				rs.close();
				ps.close();
				conn.close();

			} catch (Exception e) {
				e.printStackTrace();
			}

			req.setAttribute("companies", placementDAO.getCompanies());
			req.setAttribute("applications", placementDAO.getByStudent(studentId));

			req.getRequestDispatcher("/student/placement.jsp").forward(req, resp);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");

		// ADMIN ADD COMPANY
		if ("addCompany".equals(action)) {

			String name = req.getParameter("name");

			Double packageAmt = null;
			String packageStr = req.getParameter("packageAmt");

			if (packageStr != null && !packageStr.isEmpty()) {
				packageAmt = Double.parseDouble(packageStr);
			}

			String requirements = req.getParameter("requirements");

			placementDAO.addCompany(name, packageAmt, requirements);

			resp.sendRedirect(req.getContextPath() + "/admin/placement");
			return;
		}

		// ADMIN UPDATE PLACEMENT STATUS
		if ("updateStatus".equals(action)) {

			int id = Integer.parseInt(req.getParameter("id"));
			String status = req.getParameter("status");

			placementDAO.updateStatus(id, status);

			resp.sendRedirect(req.getContextPath() + "/admin/placement");
			return;
		}

		// STUDENT APPLY FOR COMPANY
		if ("apply".equals(action)) {

			int companyId = Integer.parseInt(req.getParameter("companyId"));

			HttpSession session = req.getSession();
			User user = (User) session.getAttribute("user");

			int studentId = 0;

			try {

				Connection conn = DBConnection.getConnection();

				PreparedStatement ps = conn.prepareStatement("SELECT id FROM students WHERE user_id=?");

				ps.setInt(1, user.getId());

				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					studentId = rs.getInt("id");
				}

				rs.close();
				ps.close();
				conn.close();

			} catch (Exception e) {
				e.printStackTrace();
			}

			placementDAO.apply(studentId, companyId);

			resp.sendRedirect(req.getContextPath() + "/student/placement");
		}
	}
}