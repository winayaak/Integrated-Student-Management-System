package model;

import java.sql.*;
import java.util.*;

import util.DBConnection;

public class QuestionDAO {

	Connection con;

	public QuestionDAO() {
		try {
			con = DBConnection.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void addQuestion(Question q) {

		try {

			String sql = "INSERT INTO questions(exam_id,question,option_a,option_b,option_c,option_d,correct_answer) VALUES(?,?,?,?,?,?,?)";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, q.getExamId());
			ps.setString(2, q.getQuestion());
			ps.setString(3, q.getOptionA());
			ps.setString(4, q.getOptionB());
			ps.setString(5, q.getOptionC());
			ps.setString(6, q.getOptionD());
			ps.setString(7, q.getCorrectAnswer());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public List<Question> getQuestionsByExamId(int examId) {

		List<Question> list = new ArrayList<>();

		try {

			String sql = "SELECT * FROM questions WHERE exam_id=?";

			PreparedStatement ps = con.prepareStatement(sql);

			ps.setInt(1, examId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				Question q = new Question();

				q.setId(rs.getInt("id"));
				q.setExamId(rs.getInt("exam_id"));
				q.setQuestion(rs.getString("question"));
				q.setOptionA(rs.getString("option_a"));
				q.setOptionB(rs.getString("option_b"));
				q.setOptionC(rs.getString("option_c"));
				q.setOptionD(rs.getString("option_d"));
				q.setCorrectAnswer(rs.getString("correct_answer"));

				list.add(q);

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;

	}

}