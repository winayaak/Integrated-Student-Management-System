package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/hostel")
public class HostelServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		try {
			Connection conn = DBConnection.getConnection();

			PreparedStatement ps = conn.prepareStatement("SELECT s.id, s.name FROM students s");

			ResultSet rs = ps.executeQuery();

			req.setAttribute("students", rs);

			PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM hostel_rooms");

			ResultSet rs2 = ps2.executeQuery();

			req.setAttribute("rooms", rs2);

			req.getRequestDispatcher("/admin/hostel.jsp").forward(req, resp);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		try {

			int studentId = Integer.parseInt(req.getParameter("studentId"));
			int roomId = Integer.parseInt(req.getParameter("roomId"));

			Connection conn = DBConnection.getConnection();

			PreparedStatement ps = conn.prepareStatement(
					"INSERT INTO hostel(student_id, room_id, allocated_date) VALUES (?, ?, CURDATE())");

			ps.setInt(1, studentId);
			ps.setInt(2, roomId);

			ps.executeUpdate();

			resp.sendRedirect("hostel");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}