<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.PlacementDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.User"%>
<%@ page import="java.util.List"%>

<%
Student student = (Student) request.getAttribute("student");

/* If servlet did not send student, take it from session */
if (student == null) {
	User u = (User) session.getAttribute("user");
	if (u != null) {
		student = new Student();
		student.setId(u.getId());
		student.setName(u.getUsername());
	}
}

List<PlacementDAO.Company> companies = (List<PlacementDAO.Company>) request.getAttribute("companies");
List<PlacementDAO.PlacementRecord> applications = (List<PlacementDAO.PlacementRecord>) request
		.getAttribute("applications");

if (companies == null)
	companies = java.util.Collections.emptyList();

if (applications == null)
	applications = java.util.Collections.emptyList();
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Placement - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>Placement</h2>

		<a href="${pageContext.request.contextPath}/student/dashboard.jsp"
			class="btn btn-outline-secondary mb-3">Back</a>

		<%
		if (student != null) {
		%>

		<!-- ML Prediction -->

		<div class="card mb-4">
			<div class="card-body">

				<h5>Placement Prediction (ML Based)</h5>

				<div id="mlPrediction" class="display-6">Loading...</div>

				<p class="text-muted">Based on your CGPA and Attendance</p>

			</div>
		</div>

		<script>

fetch('${pageContext.request.contextPath}/student/ml-prediction')
.then(r=>r.json())
.then(d=>{

const el = document.getElementById('mlPrediction');

const colors = {
HIGH:'success',
MEDIUM:'primary',
LOW:'warning',
VERY_LOW:'danger',
N/A:'secondary'
};

el.innerHTML =
'<span class="badge bg-'+(colors[d.likelihood]||'secondary')+'">'+
(d.likelihood || 'N/A')+
'</span>';

});

</script>

		<!-- Apply for Placement -->

		<div class="card mb-4">

			<div class="card-header">Apply for Company</div>

			<div class="card-body">

				<form method="post"
					action="${pageContext.request.contextPath}/student/placement">

					<input type="hidden" name="action" value="apply"> <select
						name="companyId" class="form-select" required>

						<option value="">Select Company</option>

						<%
						for (PlacementDAO.Company c : companies) {
						%>

						<option value="<%=c.getId()%>">
							<%=c.getName()%> (<%=c.getPackageAmt() / 100000%> LPA)
						</option>

						<%
						}
						%>

					</select>

					<button type="submit" class="btn btn-primary mt-2">Apply</button>

				</form>

			</div>

		</div>

		<!-- Applications -->

		<div class="card">

			<div class="card-header">My Applications</div>

			<div class="card-body">

				<table class="table">

					<thead>

						<tr>
							<th>Company</th>
							<th>Status</th>
							<th>Package</th>
							<th>Applied Date</th>
						</tr>

					</thead>

					<tbody>

						<%
						for (PlacementDAO.PlacementRecord p : applications) {
						%>

						<tr>

							<td><%=p.getCompanyName()%></td>

							<td><%=p.getStatus()%></td>

							<%=p.getPackageAmt() / 100000%>
							LPA

							<td><%=p.getAppliedDate()%></td>

						</tr>

						<%
						}
						%>

					</tbody>

				</table>

			</div>

		</div>

		<%
		} else {
		%>

		<div class="alert alert-warning">Student profile not found</div>

		<%
		}
		%>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>