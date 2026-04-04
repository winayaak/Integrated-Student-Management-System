<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.FeeDAO.FeeRecord"%>
<%@ page import="model.Student"%>
<%@ page import="java.util.List"%>

<%
List<FeeRecord> fees = (List<FeeRecord>) request.getAttribute("fees");
List<Student> students = (List<Student>) request.getAttribute("students");

if (fees == null)
	fees = java.util.Collections.emptyList();
if (students == null)
	students = java.util.Collections.emptyList();
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin - Fee Management</title>

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

		<h2>💰 Fee Management (Admin)</h2>

		<a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
			class="btn btn-secondary mb-3">← Back</a>

		<!-- ================= ADD FEE ================= -->
		<div class="card mb-4">
			<div class="card-header">➕ Add Fee</div>

			<div class="card-body">

				<form method="post"
					action="${pageContext.request.contextPath}/admin/fees">

					<input type="hidden" name="action" value="add">

					<div class="row g-2">

						<!-- 🔥 DROPDOWN -->
						<div class="col-md-3">
							<select name="studentId" class="form-select" required>
								<option value="">-- Select Student --</option>

								<%
								for (Student s : students) {
								%>
								<option value="<%=s.getId()%>">
									<%=s.getRollNo()%> -
									<%=s.getName()%>
								</option>
								<%
								}
								%>

							</select>
						</div>

						<div class="col-md-2">
							<input type="number" name="amount" class="form-control"
								placeholder="Amount" required>
						</div>

						<div class="col-md-3">
							<input type="text" name="feeType" class="form-control"
								placeholder="Fee Type">
						</div>

						<div class="col-md-2">
							<input type="date" name="dueDate" class="form-control">
						</div>

						<div class="col-md-2">
							<button class="btn btn-primary w-100">Add</button>
						</div>

					</div>
				</form>

			</div>
		</div>

		<!-- ================= TABLE ================= -->
		<table class="table table-bordered table-striped">

			<thead class="table-dark">
				<tr>
					<th>Student</th>
					<th>Amount</th>
					<th>Type</th>
					<th>Due Date</th>
					<th>Status</th>
					<th>Action</th>
				</tr>
			</thead>

			<tbody>
				<%
				for (FeeRecord f : fees) {
				%>
				<tr>

					<td><%=f.getStudentName()%></td>
					<td>₹ <%=f.getAmount()%></td>
					<td><%=f.getFeeType()%></td>
					<td><%=f.getDueDate()%></td>

					<td><span
						class="badge bg-<%=f.isPaid() ? "success" : "warning"%>">
							<%=f.isPaid() ? "Paid" : "Pending"%>
					</span></td>

					<td>
						<%
						if (!f.isPaid()) {
						%>
						<form method="post"
							action="${pageContext.request.contextPath}/admin/fees"
							style="display: inline;">
							<input type="hidden" name="action" value="markPaid"> <input
								type="hidden" name="id" value="<%=f.getId()%>">
							<button class="btn btn-success btn-sm">Pay</button>
						</form> <%
 }
 %>

						<form method="post"
							action="${pageContext.request.contextPath}/admin/fees"
							style="display: inline;">
							<input type="hidden" name="action" value="delete"> <input
								type="hidden" name="id" value="<%=f.getId()%>">
							<button class="btn btn-danger btn-sm">Delete</button>
						</form>

					</td>

				</tr>
				<%
				}
				%>
			</tbody>

		</table>

	</div>

</body>
</html>