package model;

import java.sql.*;
import java.util.*;
import util.DBConnection;

public class LibraryDAO {

	public List<Library> findAll() {

		List<Library> list = new ArrayList<>();

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT * FROM library");
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Library l = new Library();

				l.setId(rs.getInt("id"));
				l.setStudentId(rs.getInt("student_id"));
				l.setBookId(rs.getInt("book_id"));
				l.setIssueDate(rs.getDate("issue_date"));
				l.setReturnDate(rs.getDate("return_date"));
				l.setStatus(rs.getString("status"));

				list.add(l);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void add(int studentId, int bookId, java.sql.Date issueDate) {

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(
						"INSERT INTO library(student_id, book_id, issue_date, status) VALUES (?, ?, ?, 'ISSUED')")) {

			ps.setInt(1, studentId);
			ps.setInt(2, bookId);
			ps.setDate(3, issueDate);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void returnBook(int id) {

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con
						.prepareStatement("UPDATE library SET return_date = NOW(), status='RETURNED' WHERE id=?")) {

			ps.setInt(1, id);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}