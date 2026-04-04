package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import util.DBConnection;

public class ExamDAO {

	// CREATE EXAM
	public void createExam(Exam exam) {

		try {

			Connection conn = DBConnection.getConnection();

			String sql = "INSERT INTO exams(title, exam_date, duration, faculty_id) VALUES (?, ?, ?, ?)";

			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, exam.getTitle());
			ps.setString(2, exam.getExamDate());
			ps.setInt(3, exam.getDuration());
			ps.setInt(4, exam.getFacultyId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// GET ALL EXAMS (for students)
	public List<Exam> getAllExams() {

		List<Exam> exams = new ArrayList<>();

		try {

			Connection conn = DBConnection.getConnection();

			String sql = "SELECT * FROM exams";

			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Exam e = new Exam();

				e.setId(rs.getInt("id"));
				e.setTitle(rs.getString("title"));
				e.setExamDate(rs.getString("exam_date"));
				e.setDuration(rs.getInt("duration"));
				e.setFacultyId(rs.getInt("faculty_id"));

				exams.add(e);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return exams;
	}

	// GET EXAMS BY FACULTY
	public List<Exam> getExamsByFaculty(int facultyId) {

		List<Exam> exams = new ArrayList<>();

		try {

			Connection conn = DBConnection.getConnection();

			String sql = "SELECT * FROM exams WHERE faculty_id=?";

			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, facultyId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Exam e = new Exam();

				e.setId(rs.getInt("id"));
				e.setTitle(rs.getString("title"));
				e.setExamDate(rs.getString("exam_date"));
				e.setDuration(rs.getInt("duration"));
				e.setFacultyId(rs.getInt("faculty_id"));

				exams.add(e);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return exams;
	}

}