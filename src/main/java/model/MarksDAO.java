package model;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MarksDAO {

	// ✅ ADD OR UPDATE MARKS (IMPORTANT FIX)
	public boolean addOrUpdate(int studentId, int subjectId, int semester, double marks) {

		String sql = "INSERT INTO marks (student_id, subject_id, semester, marks_obtained) " + "VALUES (?, ?, ?, ?) "
				+ "ON DUPLICATE KEY UPDATE marks_obtained = VALUES(marks_obtained)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, subjectId);
			ps.setInt(3, semester);
			ps.setDouble(4, marks);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			throw new RuntimeException("Failed to save marks", e);
		}
	}

	// ✅ CALCULATE CGPA
	public double getOverallCGPA(int studentId) {

		String sql = "SELECT AVG(marks_obtained) AS avg_marks FROM marks WHERE student_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					double avg = rs.getDouble("avg_marks");

					// Convert marks to CGPA (simple logic)
					return avg / 10.0;
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to calculate CGPA", e);
		}

		return 0;
	}
}