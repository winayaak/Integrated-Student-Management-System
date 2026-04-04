package model;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

	public boolean createStudent(int userId, String name, String email, Integer courseId, String rollNo) {
		String sql = "INSERT INTO students (user_id, name, email, course_id, roll_no, semester) VALUES (?, ?, ?, ?, ?, 1)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setString(2, name);
			ps.setString(3, email);
			ps.setObject(4, courseId);
			ps.setString(5, rollNo);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new RuntimeException("Failed to create student", e);
		}
	}

	public Student findById(int id) {
		String sql = "SELECT s.*, c.name as course_name FROM students s LEFT JOIN courses c ON s.course_id = c.id WHERE s.id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? mapStudent(rs) : null;
			}
		} catch (SQLException e) {
			throw new RuntimeException("Failed to find student", e);
		}
	}

	public Student findByUserId(int userId) {
		String sql = "SELECT s.*, c.name as course_name FROM students s LEFT JOIN courses c ON s.course_id = c.id WHERE s.user_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? mapStudent(rs) : null;
			}
		} catch (SQLException e) {
			throw new RuntimeException("Failed to find student", e);
		}
	}

	public List<Student> findAll() {
		String sql = "SELECT s.*, c.name as course_name FROM students s LEFT JOIN courses c ON s.course_id = c.id ORDER BY s.roll_no";
		List<Student> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				list.add(mapStudent(rs));
			}
		} catch (SQLException e) {
			throw new RuntimeException("Failed to list students", e);
		}
		return list;
	}

	public boolean update(int id, String name, String email, Integer courseId, String rollNo, Integer semester) {
		String sql = "UPDATE students SET name=?, email=?, course_id=?, roll_no=?, semester=? WHERE id=?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, name);
			ps.setString(2, email);
			ps.setObject(3, courseId);
			ps.setString(4, rollNo);
			ps.setInt(5, semester != null ? semester : 1);
			ps.setInt(6, id);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new RuntimeException("Failed to update student", e);
		}
	}

	public boolean delete(int id) {
		String sql = "DELETE FROM students WHERE id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			throw new RuntimeException("Failed to delete student", e);
		}
	}

	public List<Student> findByCourseId(int courseId) {
		String sql = "SELECT s.*, c.name as course_name FROM students s LEFT JOIN courses c ON s.course_id = c.id WHERE s.course_id = ? ORDER BY s.roll_no";
		List<Student> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, courseId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapStudent(rs));
				}
			}
		} catch (SQLException e) {
			throw new RuntimeException("Failed to list students", e);
		}
		return list;
	}

	private Student mapStudent(ResultSet rs) throws SQLException {
		Student s = new Student();
		s.setId(rs.getInt("id"));
		s.setUserId(rs.getInt("user_id"));
		s.setName(rs.getString("name"));
		s.setEmail(rs.getString("email"));
		s.setCourseId(rs.getInt("course_id"));
		s.setCourseName(rs.getString("course_name"));
		s.setRollNo(rs.getString("roll_no"));
		s.setSemester(rs.getInt("semester"));
		s.setPhone(rs.getString("phone"));
		return s;
	}
}