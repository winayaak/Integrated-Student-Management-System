<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.HostelDAO"%>
<%@ page import="java.util.List"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
List<HostelDAO.HostelAllocation> hostel = null;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		HostelDAO hostelDAO = new HostelDAO();
		hostel = hostelDAO.getByStudent(student.getId());
	}
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Hostel - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>My Hostel</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<div class="card">

			<div class="card-body">

				<table class="table">

					<thead>
						<tr>
							<th>Block</th>
							<th>Room</th>
							<th>Allocated Date</th>
						</tr>
					</thead>

					<tbody>

						<%
						if (hostel != null && !hostel.isEmpty()) {
							for (HostelDAO.HostelAllocation h : hostel) {
						%>

						<tr>

							<td><%=h.getBlock()%></td>
							<td><%=h.getRoomNo()%></td>
							<td><%=h.getAllocatedDate()%></td>

						</tr>

						<%
						}
						} else {
						%>

						<tr>
							<td colspan="3" class="text-center">No hostel allocated</td>
						</tr>

						<%
						}
						%>

					</tbody>

				</table>

			</div>

		</div>

	</div>

</body>
</html>