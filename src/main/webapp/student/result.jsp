<%@ page%>

<!DOCTYPE html>
<html>
<head>

<title>Exam Result</title>

<style>
body {
	font-family: Arial;
	background: #f4f6fb;
}

.container {
	width: 400px;
	margin: auto;
	margin-top: 100px;
	background: white;
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
	text-align: center;
}

.score {
	font-size: 40px;
	color: #16a34a;
	margin-top: 20px;
}
</style>

</head>

<body>

	<div class="container">

		<h2>Exam Submitted</h2>

		<p>Your Score</p>

		<div class="score">

			<%=request.getAttribute("score")%>
			/
			<%=request.getAttribute("total")%>

		</div>

		<br> <a href="dashboard.jsp">Back to Dashboard</a>

	</div>

</body>
</html>