package model;

import java.sql.*;
import java.util.*;
import util.DBConnection;

public class CourseDAO {

	// GET ALL COURSES
	public List<Course> findAll() {

		List<Course> list = new ArrayList<>();

		String sql = "SELECT * FROM courses";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Course c = new Course();

				c.setId(rs.getInt("id"));
				c.setName(rs.getString("name"));
				c.setCode(rs.getString("code"));
				c.setCredits(rs.getInt("credits"));
				c.setDepartment(rs.getString("department"));

				list.add(c);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// ADD COURSE
	public void add(String name, String code, int credits, String department) {

		String sql = "INSERT INTO courses(name,code,credits,department) VALUES(?,?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, name);
			ps.setString(2, code);
			ps.setInt(3, credits);
			ps.setString(4, department);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// DELETE COURSE
	public void delete(int id) {

		String sql = "DELETE FROM courses WHERE id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, id);

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}