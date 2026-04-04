package model;

import util.DBConnection;
import java.sql.*;
import java.util.*;

public class StudentAnswerDAO {

	public void saveAnswer(int studentId, int questionId, String answer) {

		String sql = "INSERT INTO student_answers(student_id,question_id,answer) VALUES(?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, questionId);
			ps.setString(3, answer);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}