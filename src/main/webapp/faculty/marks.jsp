<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.SubjectDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.Subject"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = new StudentDAO().findAll();
List<Subject> subjects = new SubjectDAO().findByCourseId(1); // default course
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Enter Marks - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>Enter Marks</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<div class="card">

			<div class="card-body">

				<form method="post"
					action="${pageContext.request.contextPath}/faculty/marks">

					<div class="row mb-3">

						<div class="col-md-4">

							<label>Subject</label> <select name="subjectId"
								class="form-select" required>

								<%
								for (Subject s : subjects) {
								%>

								<option value="<%=s.getId()%>">
									<%=s.getName()%>
								</option>

								<%
								}
								%>

							</select>

						</div>

						<div class="col-md-4">

							<label>Semester</label> <input type="number" name="semester"
								class="form-control" value="1" required>

						</div>

					</div>

					<table class="table">

						<thead>
							<tr>
								<th>Roll No</th>
								<th>Name</th>
								<th>Marks</th>
							</tr>
						</thead>

						<tbody>

							<%
							for (Student s : students) {
							%>

							<tr>

								<td><%=s.getRollNo()%></td>
								<td><%=s.getName()%></td>

								<td><input type="number" name="marks_<%=s.getId()%>"
									class="form-control" min="0" max="100" required></td>

							</tr>

							<%
							}
							%>

						</tbody>

					</table>

					<button type="submit" class="btn btn-primary">Save Marks</button>

				</form>

			</div>

		</div>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>