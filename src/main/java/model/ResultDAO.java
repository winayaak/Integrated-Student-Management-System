package model;

import util.DBConnection;
import java.sql.*;

public class ResultDAO {

	public int calculateScore(int studentId, int examId) {

		int score = 0;

		String sql = "SELECT q.correct_answer, sa.answer " + "FROM student_answers sa "
				+ "JOIN questions q ON sa.question_id=q.id " + "WHERE sa.student_id=? AND q.exam_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, examId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				String correct = rs.getString("correct_answer");
				String answer = rs.getString("answer");

				if (correct.equalsIgnoreCase(answer)) {
					score++;
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return score;
	}

}