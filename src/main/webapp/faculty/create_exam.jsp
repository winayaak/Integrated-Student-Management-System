<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html>

<head>
<title>Create Exam</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
	margin: 0;
}

.container {
	width: 700px;
	margin: auto;
	margin-top: 40px;
	background: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
}

input {
	width: 100%;
	padding: 10px;
	margin: 10px 0;
}

button {
	background: #2563eb;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

table {
	width: 100%;
	margin-top: 30px;
	border-collapse: collapse;
}

th {
	background: #2563eb;
	color: white;
	padding: 10px;
}

td {
	padding: 10px;
	border-bottom: 1px solid #eee;
}
</style>

</head>

<body>

	<div class="container">

		<h2>Create Exam</h2>

		<form action="../faculty/createExam" method="post">

			<label>Exam Title</label> <input type="text" name="title" required>

			<label>Exam Date</label> <input type="datetime-local" name="examDate"
				required> <label>Duration (minutes)</label> <input
				type="number" name="duration" required>

			<button>Create Exam</button>

		</form>

		<h2>Existing Exams</h2>

		<table>

			<tr>
				<th>ID</th>
				<th>Title</th>
				<th>Date</th>
				<th>Duration</th>
			</tr>

			<%
			HttpSession sessionObj = request.getSession(false);

			Integer facultyId = null;

			if (sessionObj != null) {
				facultyId = (Integer) sessionObj.getAttribute("userId");
			}

			if (facultyId == null) {
				facultyId = 1;
			}

			ExamDAO dao = new ExamDAO();
			List<Exam> exams = dao.getExamsByFaculty(facultyId);

			for (Exam e : exams) {
			%>

			<tr>

				<td><%=e.getId()%></td>
				<td><%=e.getTitle()%></td>
				<td><%=e.getExamDate()%></td>
				<td><%=e.getDuration()%> min</td>

			</tr>

			<%
			}
			%>

		</table>

	</div>

</body>

</html>