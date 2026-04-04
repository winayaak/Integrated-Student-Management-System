package ai;

import model.AttendanceDAO;
import model.MarksDAO;

public class AcademicRiskDetector {

	public static RiskResult assess(int studentId) {

		AttendanceDAO attDAO = new AttendanceDAO();
		MarksDAO marksDAO = new MarksDAO();

		double attendancePct = attDAO.getAttendancePercentage(studentId);
		double cgpa = marksDAO.getOverallCGPA(studentId);

		int backlogCount = 0; // simplified

		String riskLevel = "SAFE";
		StringBuilder reasons = new StringBuilder();

		if (attendancePct < 75) {
			riskLevel = "AT_RISK";
			reasons.append("Attendance below 75%. ");
		}

		if (cgpa > 0 && cgpa < 2.0) {
			riskLevel = "AT_RISK";
			reasons.append("CGPA below 2.0. ");
		}

		if (attendancePct < 75 && cgpa > 0 && cgpa < 2.0) {
			riskLevel = "HIGH_RISK";
		}

		if (reasons.length() == 0 && "SAFE".equals(riskLevel)) {
			reasons.append("No concerns detected.");
		}

		return new RiskResult(riskLevel, attendancePct, cgpa, backlogCount, reasons.toString());
	}

	// Inner class
	public static class RiskResult {

		private final String riskLevel;
		private final double attendancePct;
		private final double cgpa;
		private final int backlogCount;
		private final String reasons;

		public RiskResult(String riskLevel, double attendancePct, double cgpa, int backlogCount, String reasons) {

			this.riskLevel = riskLevel;
			this.attendancePct = attendancePct;
			this.cgpa = cgpa;
			this.backlogCount = backlogCount;
			this.reasons = reasons;
		}

		public String getRiskLevel() {
			return riskLevel;
		}

		public double getAttendancePct() {
			return attendancePct;
		}

		public double getCgpa() {
			return cgpa;
		}

		public int getBacklogCount() {
			return backlogCount;
		}

		public String getReasons() {
			return reasons;
		}
	}
}