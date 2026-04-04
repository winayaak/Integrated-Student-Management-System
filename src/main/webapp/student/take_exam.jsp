<%@ page
	import="java.util.*,java.sql.*,model.QuestionDAO,model.Question,util.DBConnection"%>

<%
int examId = Integer.parseInt(request.getParameter("examId"));

HttpSession sessionObj = request.getSession();
Integer studentId = (Integer) sessionObj.getAttribute("userId");
if (studentId == null) {
	studentId = 1; // fallback if session not set
}

boolean alreadyAttempted = false;

try {
	Connection conn = DBConnection.getConnection();

	PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM exam_results WHERE student_id=? AND exam_id=?");

	ps.setInt(1, studentId);
	ps.setInt(2, examId);

	ResultSet rs = ps.executeQuery();

	if (rs.next()) {
		alreadyAttempted = true;
	}

} catch (Exception e) {
	e.printStackTrace();
}

QuestionDAO dao = new QuestionDAO();
List<Question> questions = dao.getQuestionsByExamId(examId);
%>

<!DOCTYPE html>
<html>
<head>
<title>Online Exam</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
	margin: 0
}

.container {
	width: 700px;
	margin: auto;
	margin-top: 60px;
	background: white;
	padding: 40px;
	border-radius: 10px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1)
}

h2 {
	text-align: center;
	margin-bottom: 30px
}

.question {
	margin-bottom: 25px
}

.option {
	margin-left: 15px;
	margin-top: 5px
}

button {
	background: #2563eb;
	color: white;
	border: none;
	padding: 12px 25px;
	border-radius: 6px;
	cursor: pointer;
	font-size: 16px
}

button:hover {
	background: #1d4ed8
}

.submit {
	text-align: center;
	margin-top: 30px
}

.warning {
	color: red;
	text-align: center;
	font-size: 20px;
	margin-top: 40px
}

a {
	text-decoration: none;
	color: #2563eb;
	font-weight: bold
}
</style>

</head>

<body>

	<div class="container">

		<%
		if (alreadyAttempted) {
		%>

		<div class="warning">
			You already attempted this exam<br>
			<br> <a href="dashboard.jsp">Back to Dashboard</a>
		</div>

		<%
		} else {
		%>

		<h2>Online Exam</h2>

		<form action="submitExam" method="post">

			<input type="hidden" name="examId" value="<%=examId%>">

			<%
			int i = 1;

			for (Question q : questions) {
			%>

			<div class="question">

				<p>
					<b>Question <%=i%>:
					</b>
					<%=q.getQuestion()%></p>

				<div class="option">
					<input type="radio" name="q<%=q.getId()%>" value="A">
					<%=q.getOptionA()%>
				</div>

				<div class="option">
					<input type="radio" name="q<%=q.getId()%>" value="B">
					<%=q.getOptionB()%>
				</div>

				<div class="option">
					<input type="radio" name="q<%=q.getId()%>" value="C">
					<%=q.getOptionC()%>
				</div>

				<div class="option">
					<input type="radio" name="q<%=q.getId()%>" value="D">
					<%=q.getOptionD()%>
				</div>

			</div>

			<%
			i++;
			}
			%>

			<div class="submit">
				<button type="submit">Submit Exam</button>
			</div>

		</form>

		<%
		}
		%>

	</div>

</body>
</html>