package model;

import java.sql.*;
import java.util.*;
import util.DBConnection;

public class FacultyDAO {

	public List<Faculty> findAll() {

		List<Faculty> list = new ArrayList<>();

		String sql = "SELECT * FROM faculty";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Faculty f = new Faculty();

				f.setId(rs.getInt("id"));
				f.setUserId(rs.getInt("user_id"));
				f.setName(rs.getString("name"));
				f.setEmail(rs.getString("email"));
				f.setDepartment(rs.getString("department"));
				f.setPhone(rs.getString("phone"));

				list.add(f);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public void add(int userId, String name, String email, String dept, String phone) {

		String sql = "INSERT INTO faculty(user_id,name,email,department,phone) VALUES(?,?,?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ps.setString(2, name);
			ps.setString(3, email);
			ps.setString(4, dept);
			ps.setString(5, phone);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void delete(int id) {

		String sql = "DELETE FROM faculty WHERE id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}