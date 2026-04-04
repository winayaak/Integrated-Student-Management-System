<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.FeeDAO"%>
<%@ page import="model.FeeDAO.FeeRecord"%>
<%@ page import="java.util.List"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
List<FeeRecord> fees = java.util.Collections.emptyList();

double total = 0;
double paid = 0;
double pending = 0;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		FeeDAO feeDAO = new FeeDAO();
		fees = feeDAO.getByStudent(student.getId());

		for (FeeRecord f : fees) {
	total += f.getAmount();
	if (f.isPaid())
		paid += f.getAmount();
	else
		pending += f.getAmount();
		}
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>My Fees</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>💳 My Fees</h2>

		<a href="${pageContext.request.contextPath}/student/dashboard.jsp"
			class="btn btn-secondary mb-3">← Back</a>

		<%
		if (student != null) {
		%>

		<!-- 🔥 STATS CARDS -->
		<div class="row mb-4">

			<div class="col-md-4">
				<div class="card text-center">
					<div class="card-body">
						<h6>Total Fees</h6>
						<h4>
							₹
							<%=total%></h4>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card text-center">
					<div class="card-body">
						<h6>Paid</h6>
						<h4 class="text-success">
							₹
							<%=paid%></h4>
					</div>
				</div>
			</div>

			<div class="col-md-4">
				<div class="card text-center">
					<div class="card-body">
						<h6>Pending</h6>
						<h4 class="text-danger">
							₹
							<%=pending%></h4>
					</div>
				</div>
			</div>

		</div>

		<!-- TABLE -->
		<div class="card">
			<div class="card-body">

				<table class="table table-bordered table-striped">

					<thead class="table-dark">
						<tr>
							<th>Amount</th>
							<th>Type</th>
							<th>Due Date</th>
							<th>Status</th>
						</tr>
					</thead>

					<tbody>

						<%
						for (FeeRecord f : fees) {
						%>

						<tr>
							<td>₹ <%=f.getAmount()%></td>
							<td><%=f.getFeeType()%></td>
							<td><%=f.getDueDate()%></td>

							<td><span
								class="badge bg-<%=f.isPaid() ? "success" : "warning"%>">
									<%=f.isPaid() ? "Paid" : "Pending"%>
							</span></td>
						</tr>

						<%
						}
						%>

					</tbody>

				</table>

				<%
				if (fees.isEmpty()) {
				%>
				<p class="text-muted">No fee records found.</p>
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

</body>
</html>