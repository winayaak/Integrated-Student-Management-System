package model;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

	// -----------------------
	// Add Book (Admin)
	// -----------------------
	public boolean add(String title, String author, String isbn, int copies) {
		String sql = "INSERT INTO books (title, author, isbn, copies_available, total_copies) VALUES (?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, title);
			ps.setString(2, author);
			ps.setString(3, isbn);
			ps.setInt(4, copies);
			ps.setInt(5, copies);

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			throw new RuntimeException("Failed to add book", e);
		}
	}

	// -----------------------
	// List All Books
	// -----------------------
	public List<Book> findAll() {
		String sql = "SELECT * FROM books ORDER BY title";
		List<Book> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(mapBook(rs));
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch books", e);
		}

		return list;
	}

	// -----------------------
	// Issue Book
	// -----------------------
	public boolean issue(int studentId, int bookId) {
		String insert = "INSERT INTO library (student_id, book_id, issue_date) VALUES (?, ?, CURRENT_DATE)";
		String update = "UPDATE books SET copies_available = copies_available - 1 WHERE id = ? AND copies_available > 0";

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false);

			try (PreparedStatement ps1 = conn.prepareStatement(insert);
					PreparedStatement ps2 = conn.prepareStatement(update)) {

				ps1.setInt(1, studentId);
				ps1.setInt(2, bookId);
				ps1.executeUpdate();

				ps2.setInt(1, bookId);
				int updated = ps2.executeUpdate();

				if (updated == 0) {
					conn.rollback();
					return false;
				}

				conn.commit();
				return true;

			} catch (Exception e) {
				conn.rollback();
				throw e;
			}

		} catch (Exception e) {
			throw new RuntimeException("Failed to issue book", e);
		}
	}

	// -----------------------
	// Return Book
	// -----------------------
	public boolean returnBook(int libraryId) {
		String updateLibrary = "UPDATE library SET returned = TRUE, return_date = CURRENT_DATE WHERE id = ?";
		String updateBook = "UPDATE books b JOIN library l ON b.id = l.book_id "
				+ "SET b.copies_available = b.copies_available + 1 " + "WHERE l.id = ?";

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false);

			try (PreparedStatement ps1 = conn.prepareStatement(updateLibrary);
					PreparedStatement ps2 = conn.prepareStatement(updateBook)) {

				ps1.setInt(1, libraryId);
				ps1.executeUpdate();

				ps2.setInt(1, libraryId);
				ps2.executeUpdate();

				conn.commit();
				return true;

			} catch (Exception e) {
				conn.rollback();
				throw e;
			}

		} catch (Exception e) {
			throw new RuntimeException("Failed to return book", e);
		}
	}

	// -----------------------
	// Get All Issued (Admin)
	// -----------------------
	public List<LibraryRecord> getAllIssued() {
		String sql = "SELECT l.*, s.name, s.roll_no, b.title " + "FROM library l "
				+ "JOIN students s ON l.student_id = s.id " + "JOIN books b ON l.book_id = b.id "
				+ "WHERE l.returned = FALSE";

		List<LibraryRecord> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(mapLibrary(rs));
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch issued books", e);
		}

		return list;
	}

	// -----------------------
	// Get Issued By Student
	// -----------------------
	public List<LibraryRecord> getIssuedByStudent(int studentId) {
		String sql = "SELECT l.*, b.title " + "FROM library l " + "JOIN books b ON l.book_id = b.id "
				+ "WHERE l.student_id = ? AND l.returned = FALSE";

		List<LibraryRecord> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(mapLibrary(rs));
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch student books", e);
		}

		return list;
	}

	private Book mapBook(ResultSet rs) throws SQLException {
		Book b = new Book();
		b.setId(rs.getInt("id"));
		b.setTitle(rs.getString("title"));
		b.setAuthor(rs.getString("author"));
		b.setIsbn(rs.getString("isbn"));
		b.setCopiesAvailable(rs.getInt("copies_available"));
		b.setTotalCopies(rs.getInt("total_copies"));
		return b;
	}

	private LibraryRecord mapLibrary(ResultSet rs) throws SQLException {
		LibraryRecord r = new LibraryRecord();
		r.setId(rs.getInt("id"));
		r.setStudentName(rs.getString("name"));
		r.setRollNo(rs.getString("roll_no"));
		r.setTitle(rs.getString("title"));
		r.setIssueDate(rs.getDate("issue_date"));
		return r;
	}

	// -----------------------
	// Inner Classes
	// -----------------------
	public static class Book {
		private int id;
		private String title;
		private String author;
		private String isbn;
		private int copiesAvailable;
		private int totalCopies;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public String getTitle() {
			return title;
		}

		public void setTitle(String title) {
			this.title = title;
		}

		public String getAuthor() {
			return author;
		}

		public void setAuthor(String author) {
			this.author = author;
		}

		public String getIsbn() {
			return isbn;
		}

		public void setIsbn(String isbn) {
			this.isbn = isbn;
		}

		public int getCopiesAvailable() {
			return copiesAvailable;
		}

		public void setCopiesAvailable(int copiesAvailable) {
			this.copiesAvailable = copiesAvailable;
		}

		public int getTotalCopies() {
			return totalCopies;
		}

		public void setTotalCopies(int totalCopies) {
			this.totalCopies = totalCopies;
		}
	}

	public static class LibraryRecord {
		private int id;
		private String studentName;
		private String rollNo;
		private String title;
		private Date issueDate;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public String getStudentName() {
			return studentName;
		}

		public void setStudentName(String studentName) {
			this.studentName = studentName;
		}

		public String getRollNo() {
			return rollNo;
		}

		public void setRollNo(String rollNo) {
			this.rollNo = rollNo;
		}

		public String getTitle() {
			return title;
		}

		public void setTitle(String title) {
			this.title = title;
		}

		public Date getIssueDate() {
			return issueDate;
		}

		public void setIssueDate(Date issueDate) {
			this.issueDate = issueDate;
		}
	}
}