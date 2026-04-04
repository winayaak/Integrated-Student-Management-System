<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html>
<head>

<title>Add Question</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
	margin: 0;
}

.container {
	width: 600px;
	margin: auto;
	margin-top: 40px;
	background: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
}

input, select {
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
</style>

</head>

<body>

	<div class="container">

		<h2>Add Question</h2>

		<form action="addQuestion" method="post">

			<label>Select Exam</label> <select name="exam_id" required>

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

				<option value="<%=e.getId()%>">
					<%=e.getTitle()%>
				</option>

				<%
				}
				%>

			</select> <label>Question</label> <input type="text" name="question" required>

			<label>Option A</label> <input type="text" name="option_a" required>

			<label>Option B</label> <input type="text" name="option_b" required>

			<label>Option C</label> <input type="text" name="option_c" required>

			<label>Option D</label> <input type="text" name="option_d" required>

			<label>Correct Answer</label> <select name="correct_answer">
				<option value="A">A</option>
				<option value="B">B</option>
				<option value="C">C</option>
				<option value="D">D</option>
			</select>

			<button>Add Question</button>

		</form>

	</div>

</body>

</html>