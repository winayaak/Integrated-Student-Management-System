package model;

import util.DBConnection;
import java.sql.*;
import java.security.MessageDigest;

public class UserDAO {

	// ================= HASH PASSWORD =================
	private String hashPassword(String password) {

		try {

			if (password == null)
				password = "default123";

			MessageDigest md = MessageDigest.getInstance("SHA-256");

			byte[] hash = md.digest(password.getBytes("UTF-8"));

			StringBuilder hex = new StringBuilder();

			for (byte b : hash) {
				hex.append(String.format("%02x", b));
			}

			return hex.toString();

		} catch (Exception e) {
			throw new RuntimeException("Error hashing password", e);
		}
	}

	// ================= REGISTER USER =================
	public boolean register(String username, String password, String role) {

		String sql = "INSERT INTO users(username,password_hash,role) VALUES(?,?,?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ps.setString(2, hashPassword(password));
			ps.setString(3, role);

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	// ================= LOGIN =================
	public User login(String username, String password) {

		String sql = "SELECT * FROM users WHERE username=? AND password_hash=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ps.setString(2, hashPassword(password));

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {

				User user = new User();

				user.setId(rs.getInt("id"));
				user.setUsername(rs.getString("username"));
				user.setRole(rs.getString("role"));

				return user;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	// ================= CHECK USERNAME =================
	public boolean usernameExists(String username) {

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE username=?")) {

			ps.setString(1, username);

			ResultSet rs = ps.executeQuery();

			return rs.next();

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	// ================= GET USER ID =================
	public int getUserIdByUsername(String username) {

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE username=?")) {

			ps.setString(1, username);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("id");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return -1;
	}

}