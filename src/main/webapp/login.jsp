<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>

<title>ISMS Login</title>

<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500&display=swap"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
	margin: 0;
	font-family: 'Poppins', sans-serif;
	background: linear-gradient(135deg, #f5f7fa, #e4e8f0);
}

.container {
	height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
}

.login-wrapper {
	display: flex;
	align-items: center;
	gap: 50px;
}

.image-section img {
	width: 340px;
	border: 1px solid #e6e6e6;
	border-radius: 10px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
}

.login-box {
	width: 340px;
	background: white;
	padding: 35px;
	border-radius: 12px;
	border: 1px solid #e6e6e6;
	box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
}

.login-box h2 {
	text-align: center;
	font-weight: 500;
	margin-bottom: 5px;
}

.login-box p {
	text-align: center;
	font-size: 13px;
	color: #777;
	margin-bottom: 25px;
}

.input-group {
	position: relative;
	margin-bottom: 18px;
}

.input-group i:first-child {
	position: absolute;
	left: 12px;
	top: 50%;
	transform: translateY(-50%);
	color: #888;
}

.eye-icon {
	position: absolute;
	right: 14px;
	top: 50%;
	transform: translateY(-50%);
	cursor: pointer;
	color: #444;
	font-size: 15px;
	transition: 0.2s;
}

.eye-icon:hover {
	color: #2563eb;
}

.input-group input {
	width: 100%;
	padding: 11px 40px 11px 38px;
	border: 1px solid #e3e3e3;
	border-radius: 7px;
	background: #fafafa;
	font-size: 13px;
	transition: 0.2s;
}

.input-group input:focus {
	outline: none;
	border: 1px solid #2563eb;
	box-shadow: 0 0 4px rgba(37, 99, 235, 0.2);
	background: white;
}

.login-btn {
	width: 100%;
	padding: 11px;
	border: none;
	border-radius: 7px;
	background: linear-gradient(90deg, #2563eb, #1d4ed8);
	color: white;
	font-size: 14px;
	font-weight: 500;
	cursor: pointer;
	transition: 0.3s;
}

.login-btn:hover {
	background: linear-gradient(90deg, #1d4ed8, #1e40af);
}

.register {
	text-align: center;
	margin-top: 15px;
	font-size: 13px;
}

.register a {
	color: #2563eb;
	text-decoration: none;
}

.register a:hover {
	text-decoration: underline;
}

.error {
	color: red;
	text-align: center;
	margin-top: 10px;
	font-size: 13px;
}
</style>

</head>

<body>

	<div class="container">

		<div class="login-wrapper">

			<div class="image-section">
				<img src="<%=request.getContextPath()%>/images/login.jpeg">
			</div>

			<div class="login-box">

				<h2>ISMS Portal</h2>

				<p>Integrated Student Management System</p>

				<form action="login" method="post">

					<div class="input-group">
						<i class="fa-solid fa-user"></i> <input type="text"
							name="username" placeholder="Username" required>
					</div>

					<div class="input-group">
						<i class="fa-solid fa-lock"></i> <input type="password"
							id="password" name="password" placeholder="Password" required>
						<i class="fa-solid fa-eye eye-icon" onclick="togglePassword()"></i>
					</div>

					<button type="submit" class="login-btn">Login</button>

				</form>

				<div class="register">
					<a href="register.jsp">Register as Student</a>
				</div>

				<%
				String error = (String) request.getAttribute("error");
				if (error != null) {
				%>

				<div class="error">
					<%=error%>
				</div>

				<%
				}
				%>

			</div>

		</div>

	</div>

	<script>
		function togglePassword() {

			var password = document.getElementById("password");
			var eye = document.querySelector(".eye-icon");

			if (password.type === "password") {
				password.type = "text";
				eye.classList.remove("fa-eye");
				eye.classList.add("fa-eye-slash");
			} else {
				password.type = "password";
				eye.classList.remove("fa-eye-slash");
				eye.classList.add("fa-eye");
			}

		}
	</script>

</body>

</html>