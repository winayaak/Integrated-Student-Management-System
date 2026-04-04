<%@ page import="java.sql.*,util.DBConnection"%>

<%
HttpSession sessionObj = request.getSession(false);

Integer facultyId = null;

if (sessionObj != null) {
	facultyId = (Integer) sessionObj.getAttribute("userId");
}

if (facultyId == null) {
	facultyId = 1;
}

Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn
		.prepareStatement("SELECT s.name AS student_name, e.title AS exam_name, r.score, r.submitted_at "
		+ "FROM exam_results r " + "JOIN exams e ON r.exam_id = e.id "
		+ "JOIN students s ON r.student_id = s.id " + "WHERE e.faculty_id = ?");

ps.setInt(1, facultyId);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>

<title>Exam Results</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
}

.container {
	width: 900px;
	margin: auto;
	margin-top: 50px;
	background: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

th {
	background: #2563eb;
	color: white;
	padding: 10px;
}

td {
	padding: 10px;
	border-bottom: 1px solid #eee;
	text-align: center;
}
</style>

</head>

<body>

	<div class="container">

		<h2>Exam Results</h2>

		<table>

			<tr>
				<th>Student Name</th>
				<th>Exam</th>
				<th>Score</th>
				<th>Date</th>
			</tr>

			<%
			while (rs.next()) {
			%>

			<tr>

				<td><%=rs.getString("student_name")%></td>
				<td><%=rs.getString("exam_name")%></td>
				<td><%=rs.getInt("score")%></td>
				<td><%=rs.getTimestamp("submitted_at")%></td>

			</tr>

			<%
			}
			%>

		</table>

	</div>

</body>

</html>