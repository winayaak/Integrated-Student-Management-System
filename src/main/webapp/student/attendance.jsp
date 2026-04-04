<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.AttendanceDAO"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
double attendancePct = 0;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		AttendanceDAO attDAO = new AttendanceDAO();
		attendancePct = attDAO.getAttendancePercentage(student.getId());
	}
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Attendance - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>My Attendance</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<%
		if (student != null) {
		%>

		<div class="card">

			<div class="card-body">

				<h5>Attendance Percentage</h5>

				<div class="display-4">

					<%=String.format("%.1f", attendancePct)%>%

				</div>

				<%
				if (attendancePct < 75) {
				%>

				<div class="alert alert-warning mt-3">Your attendance is below
					75%. You may not be eligible for exams.</div>

				<%
				} else {
				%>

				<div class="alert alert-success mt-3">Good attendance. Keep it
					up!</div>

				<%
				}
				%>

			</div>

		</div>

		<%
		} else {
		%>

		<div class="alert alert-warning">Student profile not found.</div>

		<%
		}
		%>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>