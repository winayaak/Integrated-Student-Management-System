package model;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlacementDAO {

	public List<Company> getCompanies() {

		String sql = "SELECT * FROM companies ORDER BY name";
		List<Company> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Company c = new Company();

				c.setId(rs.getInt("id"));
				c.setName(rs.getString("name"));
				c.setPackageAmt(rs.getDouble("package_amt"));
				c.setRequirements(rs.getString("requirements"));

				list.add(c);
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch companies", e);
		}

		return list;
	}

	public void addCompany(String name, Double packageAmt, String requirements) {

		String sql = "INSERT INTO companies (name, package_amt, requirements) VALUES (?, ?, ?)";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, name);
			ps.setObject(2, packageAmt);
			ps.setString(3, requirements);

			ps.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException("Failed to add company", e);
		}
	}

	public void apply(int studentId, int companyId) {

		String sql = "INSERT INTO placement (student_id, company_id, applied_date) VALUES (?, ?, CURDATE())";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, companyId);

			ps.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException("Failed to apply for placement", e);
		}
	}

	public List<PlacementRecord> getAll() {

		String sql = "SELECT p.*, s.name AS student_name, s.roll_no, c.name AS company_name, c.package_amt "
				+ "FROM placement p " + "JOIN students s ON p.student_id = s.id "
				+ "JOIN companies c ON p.company_id = c.id";

		List<PlacementRecord> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				PlacementRecord pr = new PlacementRecord();

				pr.setId(rs.getInt("id"));
				pr.setStudentId(rs.getInt("student_id"));
				pr.setStudentName(rs.getString("student_name"));
				pr.setRollNo(rs.getString("roll_no"));

				pr.setCompanyId(rs.getInt("company_id"));
				pr.setCompanyName(rs.getString("company_name"));

				pr.setStatus(rs.getString("status"));
				pr.setPackageAmt(rs.getDouble("package_amt"));
				pr.setAppliedDate(rs.getDate("applied_date"));

				list.add(pr);
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch placements", e);
		}

		return list;
	}

	public List<PlacementRecord> getByStudent(int studentId) {

		String sql = "SELECT p.*, c.name AS company_name, c.package_amt " + "FROM placement p "
				+ "JOIN companies c ON p.company_id = c.id " + "WHERE p.student_id = ? ORDER BY p.applied_date DESC";

		List<PlacementRecord> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {

					PlacementRecord pr = new PlacementRecord();

					pr.setId(rs.getInt("id"));
					pr.setStudentId(rs.getInt("student_id"));
					pr.setCompanyId(rs.getInt("company_id"));
					pr.setCompanyName(rs.getString("company_name"));

					pr.setStatus(rs.getString("status"));
					pr.setPackageAmt(rs.getDouble("package_amt"));
					pr.setAppliedDate(rs.getDate("applied_date"));

					list.add(pr);
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to fetch student placements", e);
		}

		return list;
	}

	// ⭐ NEW METHOD FOR ADMIN
	public void updateStatus(int id, String status) {

		String sql = "UPDATE placement SET status=? WHERE id=?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, status);
			ps.setInt(2, id);

			ps.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException("Failed to update placement status", e);
		}
	}

	/* ========================= INNER CLASSES ========================= */

	public static class Company {

		private int id;
		private String name;
		private double packageAmt;
		private String requirements;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public double getPackageAmt() {
			return packageAmt;
		}

		public void setPackageAmt(double packageAmt) {
			this.packageAmt = packageAmt;
		}

		public String getRequirements() {
			return requirements;
		}

		public void setRequirements(String requirements) {
			this.requirements = requirements;
		}
	}

	public static class PlacementRecord {

		private int id;
		private int studentId;
		private int companyId;

		private String studentName;
		private String rollNo;
		private String companyName;

		private String status;
		private double packageAmt;

		private Date appliedDate;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public int getStudentId() {
			return studentId;
		}

		public void setStudentId(int studentId) {
			this.studentId = studentId;
		}

		public int getCompanyId() {
			return companyId;
		}

		public void setCompanyId(int companyId) {
			this.companyId = companyId;
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

		public String getCompanyName() {
			return companyName;
		}

		public void setCompanyName(String companyName) {
			this.companyName = companyName;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		public double getPackageAmt() {
			return packageAmt;
		}

		public void setPackageAmt(double packageAmt) {
			this.packageAmt = packageAmt;
		}

		public Date getAppliedDate() {
			return appliedDate;
		}

		public void setAppliedDate(Date appliedDate) {
			this.appliedDate = appliedDate;
		}
	}
}