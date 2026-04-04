package model;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AttendanceDAO {

	public boolean markAttendance(int studentId, int courseId, String date, String status) {
		String sql = "INSERT INTO attendance (student_id, course_id, attendance_date, status) " + "VALUES (?, ?, ?, ?) "
				+ "ON DUPLICATE KEY UPDATE status = VALUES(status)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, courseId);
			ps.setString(3, date);
			ps.setString(4, status);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			throw new RuntimeException("Failed to mark attendance", e);
		}
	}

	public double getAttendancePercentage(int studentId) {
		String sql = "SELECT " + "SUM(CASE WHEN status = 'PRESENT' THEN 1 ELSE 0 END) AS present_count, "
				+ "COUNT(*) AS total_count " + "FROM attendance WHERE student_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					int present = rs.getInt("present_count");
					int total = rs.getInt("total_count");
					if (total == 0)
						return 0;
					return (present * 100.0) / total;
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to calculate attendance", e);
		}

		return 0;
	}
}