package model;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeeDAO {

    // ================= DTO =================
    public static class FeeRecord {
        private int id;
        private int studentId;
        private String studentName;
        private double amount;
        private String feeType;
        private Date dueDate;
        private boolean paid;

        public int getId() { return id; }
        public int getStudentId() { return studentId; }
        public String getStudentName() { return studentName; }
        public double getAmount() { return amount; }
        public String getFeeType() { return feeType; }
        public Date getDueDate() { return dueDate; }
        public boolean isPaid() { return paid; }

        public void setId(int id) { this.id = id; }
        public void setStudentId(int studentId) { this.studentId = studentId; }
        public void setStudentName(String studentName) { this.studentName = studentName; }
        public void setAmount(double amount) { this.amount = amount; }
        public void setFeeType(String feeType) { this.feeType = feeType; }
        public void setDueDate(Date dueDate) { this.dueDate = dueDate; }
        public void setPaid(boolean paid) { this.paid = paid; }
    }

    // ================= COMMON MAPPER =================
    private FeeRecord map(ResultSet rs) throws SQLException {
        FeeRecord f = new FeeRecord();

        f.setId(rs.getInt("id"));
        f.setStudentId(rs.getInt("student_id"));
        f.setStudentName(rs.getString("student_name"));
        f.setAmount(rs.getDouble("amount"));
        f.setFeeType(rs.getString("fee_type"));
        f.setDueDate(rs.getDate("due_date"));
        f.setPaid(rs.getBoolean("paid"));

        return f;
    }

    // ================= ADMIN: GET ALL =================
    public List<FeeRecord> findAll() {

        List<FeeRecord> list = new ArrayList<>();

        String sql = "SELECT f.id, f.student_id, s.name AS student_name, " +
                     "f.amount, f.fee_type, f.due_date, f.paid " +
                     "FROM fees f JOIN students s ON f.student_id = s.id " +
                     "ORDER BY f.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch fees", e);
        }

        return list;
    }

    // ================= STUDENT: GET BY STUDENT =================
    public List<FeeRecord> getByStudent(int studentId) {

        List<FeeRecord> list = new ArrayList<>();

        String sql = "SELECT f.id, f.student_id, s.name AS student_name, " +
                     "f.amount, f.fee_type, f.due_date, f.paid " +
                     "FROM fees f JOIN students s ON f.student_id = s.id " +
                     "WHERE f.student_id = ? ORDER BY f.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Failed to fetch student fees", e);
        }

        return list;
    }

    // ================= ADD =================
    public void add(int studentId, double amount, String feeType, String dueDate) {

        String sql = "INSERT INTO fees (student_id, amount, fee_type, due_date, paid) " +
                     "VALUES (?, ?, ?, ?, false)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setDouble(2, amount);
            ps.setString(3, feeType);
            ps.setString(4, dueDate);

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Failed to add fee", e);
        }
    }

    // ================= MARK PAID =================
    public void markPaid(int id) {

        String sql = "UPDATE fees SET paid = true, paid_date = CURRENT_DATE WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Failed to mark fee paid", e);
        }
    }

    // ================= DELETE =================
    public void delete(int id) {

        String sql = "DELETE FROM fees WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete fee", e);
        }
    }

    // ================= DASHBOARD STATS =================
    public double getTotalFees() {

        String sql = "SELECT IFNULL(SUM(amount),0) FROM fees WHERE paid = true";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getDouble(1);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return 0;
    }

    public double getPendingFees() {

        String sql = "SELECT IFNULL(SUM(amount),0) FROM fees WHERE paid = false";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getDouble(1);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return 0;
    }
}