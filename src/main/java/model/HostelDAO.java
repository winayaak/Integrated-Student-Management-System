package model;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HostelDAO {

	public List<HostelRoom> getAllRooms() {

		String sql = "SELECT * FROM hostel_rooms ORDER BY block, room_no";
		List<HostelRoom> rooms = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				HostelRoom r = new HostelRoom();

				r.setId(rs.getInt("id"));
				r.setRoomNo(rs.getString("room_no"));
				r.setBlock(rs.getString("block"));
				r.setCapacity(rs.getInt("capacity"));

				rooms.add(r);
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to get hostel rooms", e);
		}

		return rooms;
	}

	public List<HostelAllocation> getAllAllocations() {

		String sql = "SELECT h.*, s.name AS student_name, s.roll_no, r.room_no, r.block " + "FROM hostel h "
				+ "JOIN students s ON h.student_id = s.id " + "JOIN hostel_rooms r ON h.room_id = r.id";

		List<HostelAllocation> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				HostelAllocation a = new HostelAllocation();

				a.setStudentId(rs.getInt("student_id"));
				a.setStudentName(rs.getString("student_name"));
				a.setRollNo(rs.getString("roll_no"));

				a.setRoomId(rs.getInt("room_id"));
				a.setRoomNo(rs.getString("room_no"));
				a.setBlock(rs.getString("block"));

				a.setAllocatedDate(rs.getDate("allocated_date"));

				list.add(a);
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to list allocations", e);
		}

		return list;
	}

	public void allocate(int studentId, int roomId) {

		String sql = "INSERT INTO hostel (student_id, room_id, allocated_date) VALUES (?, ?, CURDATE())";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);
			ps.setInt(2, roomId);

			ps.executeUpdate();

		} catch (SQLException e) {
			throw new RuntimeException("Failed to allocate hostel", e);
		}
	}

	public List<HostelAllocation> getByStudent(int studentId) {

		String sql = "SELECT h.*, r.room_no, r.block " + "FROM hostel h " + "JOIN hostel_rooms r ON h.room_id = r.id "
				+ "WHERE h.student_id = ?";

		List<HostelAllocation> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, studentId);

			try (ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {

					HostelAllocation a = new HostelAllocation();

					a.setStudentId(rs.getInt("student_id"));
					a.setRoomId(rs.getInt("room_id"));
					a.setRoomNo(rs.getString("room_no"));
					a.setBlock(rs.getString("block"));
					a.setAllocatedDate(rs.getDate("allocated_date"));

					list.add(a);
				}
			}

		} catch (SQLException e) {
			throw new RuntimeException("Failed to get hostel allocation", e);
		}

		return list;
	}

	/*
	 * ========================= INNER CLASSES =========================
	 */

	public static class HostelRoom {

		private int id;
		private String roomNo;
		private String block;
		private int capacity;

		public int getId() {
			return id;
		}

		public void setId(int id) {
			this.id = id;
		}

		public String getRoomNo() {
			return roomNo;
		}

		public void setRoomNo(String roomNo) {
			this.roomNo = roomNo;
		}

		public String getBlock() {
			return block;
		}

		public void setBlock(String block) {
			this.block = block;
		}

		public int getCapacity() {
			return capacity;
		}

		public void setCapacity(int capacity) {
			this.capacity = capacity;
		}
	}

	public static class HostelAllocation {

		private int studentId;
		private int roomId;

		private String studentName;
		private String rollNo;

		private String roomNo;
		private String block;

		private Date allocatedDate;

		public int getStudentId() {
			return studentId;
		}

		public void setStudentId(int studentId) {
			this.studentId = studentId;
		}

		public int getRoomId() {
			return roomId;
		}

		public void setRoomId(int roomId) {
			this.roomId = roomId;
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

		public String getRoomNo() {
			return roomNo;
		}

		public void setRoomNo(String roomNo) {
			this.roomNo = roomNo;
		}

		public String getBlock() {
			return block;
		}

		public void setBlock(String block) {
			this.block = block;
		}

		public Date getAllocatedDate() {
			return allocatedDate;
		}

		public void setAllocatedDate(Date allocatedDate) {
			this.allocatedDate = allocatedDate;
		}
	}
}