<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Student Registration - ISMS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

</head>

<body class="bg-light">

	<div class="container mt-5" style="max-width: 500px">

		<div class="card shadow">

			<div class="card-body">

				<h4 class="text-center mb-4">Student Registration</h4>

				<%
				if (request.getAttribute("error") != null) {
				%>

				<div class="alert alert-danger">
					<%=request.getAttribute("error")%>
				</div>

				<%
				}
				%>

				<form method="post"
					action="${pageContext.request.contextPath}/register">

					<div class="mb-3">
						<label>Username</label> <input type="text" name="username"
							class="form-control" required>
					</div>

					<div class="mb-3">
						<label>Password</label> <input type="password" name="password"
							class="form-control" required>
					</div>

					<div class="mb-3">
						<label>Name</label> <input type="text" name="name"
							class="form-control" required>
					</div>

					<div class="mb-3">
						<label>Email</label> <input type="email" name="email"
							class="form-control" required>
					</div>

					<div class="mb-3">
						<label>Roll Number</label> <input type="text" name="rollNo"
							class="form-control" required>
					</div>

					<button type="submit" class="btn btn-success w-100">
						Register</button>

				</form>

				<div class="text-center mt-3">

					<a href="login.jsp"> Back to Login </a>

				</div>

			</div>

		</div>

	</div>

</body>
</html>