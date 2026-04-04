<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.MarksDAO"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
double cgpa = 0;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		MarksDAO marksDAO = new MarksDAO();
		cgpa = marksDAO.getOverallCGPA(student.getId());
	}
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Marks - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>My Marks</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<%
		if (student != null) {
		%>

		<div class="card">

			<div class="card-body">

				<h5>Overall CGPA</h5>

				<div class="display-4">

					<%=String.format("%.2f", cgpa)%>

				</div>

				<%
				if (cgpa < 5) {
				%>

				<div class="alert alert-danger mt-3">Your CGPA is very low.
					Academic improvement required.</div>

				<%
				} else {
				%>

				<div class="alert alert-success mt-3">Good academic
					performance.</div>

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