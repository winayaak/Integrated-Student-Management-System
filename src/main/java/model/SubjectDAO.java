package model;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubjectDAO {

	// 🔹 Get all subjects
	public List<Subject> findAll() {
		String sql = "SELECT * FROM subjects ORDER BY name";
		List<Subject> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(mapSubject(rs));
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to list subjects", e);
		}

		return list;
	}

	// 🔹 Get subjects by course
	public List<Subject> findByCourseId(int courseId) {
		String sql = "SELECT * FROM subjects WHERE course_id = ? ORDER BY name";
		List<Subject> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, courseId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapSubject(rs));
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to list subjects", e);
		}

		return list;
	}

	// 🔹 Get subject by ID
	public Subject findById(int id) {
		String sql = "SELECT * FROM subjects WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);

			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? mapSubject(rs) : null;
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to find subject", e);
		}
	}

	// 🔹 Create subject
	public boolean create(int courseId, String name, String code, int maxMarks) {
		String sql = "INSERT INTO subjects (course_id, name, code, max_marks) VALUES (?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, courseId);
			ps.setString(2, name);
			ps.setString(3, code);
			ps.setInt(4, maxMarks);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			throw new RuntimeException("Failed to create subject", e);
		}
	}

	// 🔹 Delete subject
	public boolean delete(int id) {
		String sql = "DELETE FROM subjects WHERE id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, id);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			throw new RuntimeException("Failed to delete subject", e);
		}
	}

	// 🔹 Mapper
	private Subject mapSubject(ResultSet rs) throws SQLException {
		Subject s = new Subject();
		s.setId(rs.getInt("id"));
		s.setCourseId(rs.getInt("course_id"));
		s.setName(rs.getString("name"));
		s.setCode(rs.getString("code"));
		s.setMaxMarks(rs.getInt("max_marks"));
		return s;
	}
}