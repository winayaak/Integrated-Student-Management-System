<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.Student"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = (List<Student>) request.getAttribute("students");
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Students</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>

<body>

	<div class="container mt-4">

		<h2>Manage Students</h2>

		<!-- ================= ADD FORM ================= -->
		<div class="card mb-3">
			<div class="card-body">

				<form method="post">
					<input type="hidden" name="action" value="add"> <input
						name="username" placeholder="Username" class="form-control mb-2"
						required> <input name="password" placeholder="Password"
						class="form-control mb-2" required> <input name="name"
						placeholder="Name" class="form-control mb-2" required> <input
						name="email" placeholder="Email" class="form-control mb-2"
						required> <input name="courseId" placeholder="Course ID"
						class="form-control mb-2" required> <input name="rollNo"
						placeholder="Roll No" class="form-control mb-2" required>

					<button class="btn btn-success">Add Student</button>

				</form>

			</div>
		</div>

		<!-- ================= TABLE ================= -->
		<table class="table table-bordered table-striped">

			<thead class="table-dark">
				<tr>
					<th>ID</th>
					<th>Name</th>
					<th>Email</th>
					<th>Roll No</th>
					<th>Actions</th>
				</tr>
			</thead>

			<tbody>

				<%
				for (Student s : students) {
				%>

				<tr>

					<form method="post">

						<td><%=s.getId()%> <input type="hidden" name="id"
							value="<%=s.getId()%>"></td>

						<td><input name="name" value="<%=s.getName()%>"
							class="form-control"></td>

						<td><input name="email" value="<%=s.getEmail()%>"
							class="form-control"></td>

						<td><input name="rollNo" value="<%=s.getRollNo()%>"
							class="form-control"></td>

						<td><input type="hidden" name="courseId"
							value="<%=s.getCourseId()%>"> <input type="hidden"
							name="semester" value="<%=s.getSemester()%>">

							<button name="action" value="update"
								class="btn btn-primary btn-sm">Update</button>
							<button name="action" value="delete"
								class="btn btn-danger btn-sm">Delete</button></td>

					</form>

				</tr>

				<%
				}
				%>

			</tbody>
		</table>

	</div>

</body>
</html>