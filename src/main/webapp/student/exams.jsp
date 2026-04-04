<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html>

<head>

<title>Available Exams</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
	margin: 0;
}

.container {
	width: 800px;
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
	padding: 12px;
}

td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	text-align: center;
}

button {
	background: #2563eb;
	color: white;
	border: none;
	padding: 8px 15px;
	border-radius: 5px;
	cursor: pointer;
}

button:hover {
	background: #1e4fd1;
}
</style>

</head>

<body>

	<div class="container">

		<h2>Available Exams</h2>

		<table>

			<tr>
				<th>ID</th>
				<th>Exam Title</th>
				<th>Date</th>
				<th>Duration</th>
				<th>Action</th>
			</tr>

			<%
			ExamDAO dao = new ExamDAO();
			List<Exam> exams = dao.getAllExams();

			for (Exam e : exams) {
			%>

			<tr>

				<td><%=e.getId()%></td>

				<td><%=e.getTitle()%></td>

				<td><%=e.getExamDate()%></td>

				<td><%=e.getDuration()%> min</td>

				<td><a href="take_exam.jsp?examId=<%=e.getId()%>">

						<button>Start Exam</button>

				</a></td>

			</tr>

			<%
			}
			%>

		</table>

	</div>

</body>

</html>