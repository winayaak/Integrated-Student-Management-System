<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.CourseDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.Course"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = new StudentDAO().findAll();
List<Course> courses = new CourseDAO().findAll();
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Mark Attendance - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>Mark Attendance</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<div class="card">

			<div class="card-body">

				<form method="post"
					action="${pageContext.request.contextPath}/faculty/attendance">

					<div class="row mb-3">

						<div class="col-md-4">

							<label>Course</label> <select name="courseId" class="form-select"
								required>

								<option value="">Select Course</option>

								<%
								for (Course c : courses) {
								%>

								<option value="<%=c.getId()%>">
									<%=c.getName()%>
								</option>

								<%
								}
								%>

							</select>

						</div>

						<div class="col-md-4">

							<label>Date</label> <input type="date" name="date"
								class="form-control" required>

						</div>

					</div>

					<table class="table">

						<thead>
							<tr>
								<th>Roll No</th>
								<th>Name</th>
								<th>Status</th>
							</tr>
						</thead>

						<tbody>

							<%
							for (Student s : students) {
							%>

							<tr>

								<td><%=s.getRollNo()%></td>
								<td><%=s.getName()%></td>

								<td><select name="status_<%=s.getId()%>"
									class="form-select">

										<option value="PRESENT">Present</option>
										<option value="ABSENT">Absent</option>

								</select></td>

							</tr>

							<%
							}
							%>

						</tbody>

					</table>

					<button type="submit" class="btn btn-primary">Save
						Attendance</button>

				</form>

			</div>

		</div>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>