<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.CourseDAO"%>
<%@ page import="model.FacultyDAO"%>
<%@ page import="model.FeeDAO"%>

<%
User user = (User) session.getAttribute("user");

StudentDAO studentDAO = new StudentDAO();
CourseDAO courseDAO = new CourseDAO();
FacultyDAO facultyDAO = new FacultyDAO();
FeeDAO feeDAO = new FeeDAO();

int totalStudents = studentDAO.findAll().size();
int totalCourses = courseDAO.findAll().size();
int totalFaculty = facultyDAO.findAll().size();

double totalFees = feeDAO.getTotalFees();
double pendingFees = feeDAO.getPendingFees();
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>Admin Dashboard</h2>
		<p>
			Welcome,
			<%=user.getUsername()%></p>

		<!-- 🔥 CARDS -->
		<div class="row mb-4">

			<div class="col-md-4">
				<div class="card text-center shadow">
					<div class="card-body">
						<h6>Total Students</h6>
						<h3><%=totalStudents%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card text-center shadow">
					<div class="card-body">
						<h6>Total Faculty</h6>
						<h3><%=totalFaculty%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card text-center shadow">
					<div class="card-body">
						<h6>Total Courses</h6>
						<h3><%=totalCourses%></h3>
					</div>
				</div>
			</div>

		</div>

		<!-- 💰 FEES STATS -->
		<div class="row mb-4">

			<div class="col-md-6">
				<div class="card text-center shadow">
					<div class="card-body">
						<h6>Total Fees Collected</h6>
						<h3 class="text-success">
							₹
							<%=totalFees%></h3>
					</div>
				</div>
			</div>

			<div class="col-md-6">
				<div class="card text-center shadow">
					<div class="card-body">
						<h6>Pending Fees</h6>
						<h3 class="text-danger">
							₹
							<%=pendingFees%></h3>
					</div>
				</div>
			</div>

		</div>

		<!-- 🔗 LINKS -->
		<div class="card">
			<div class="card-header">Quick Links</div>

			<div class="list-group list-group-flush">
				<a href="${pageContext.request.contextPath}/admin/students"
					class="list-group-item">Manage Students</a> <a
					href="${pageContext.request.contextPath}/admin/faculty"
					class="list-group-item">Manage Faculty</a> <a
					href="${pageContext.request.contextPath}/admin/courses"
					class="list-group-item">Manage Courses</a> <a
					href="${pageContext.request.contextPath}/admin/fees"
					class="list-group-item">Fee Management</a> <a
					href="${pageContext.request.contextPath}/admin/library"
					class="list-group-item">Library</a> <a
					href="${pageContext.request.contextPath}/admin/hostel"
					class="list-group-item">Hostel</a> <a
					href="${pageContext.request.contextPath}/admin/placement"
					class="list-group-item">Placement</a> <a
					href="${pageContext.request.contextPath}/admin/ai-insights"
					class="list-group-item">AI Insights</a>
			</div>

		</div>

	</div>

</body>
</html>