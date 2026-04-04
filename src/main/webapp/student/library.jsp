<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.BookDAO"%>
<%@ page import="java.util.List"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
List<BookDAO.LibraryRecord> issued = null;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		BookDAO bookDAO = new BookDAO();
		issued = bookDAO.getIssuedByStudent(student.getId());
	}
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Library - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>My Library</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<%
		if (student != null) {
		%>

		<div class="card">

			<div class="card-header">Books Issued to Me</div>

			<div class="card-body">

				<table class="table">

					<thead>
						<tr>
							<th>Book Title</th>
							<th>Issue Date</th>
						</tr>
					</thead>

					<tbody>

						<%
						if (issued != null && !issued.isEmpty()) {
							for (BookDAO.LibraryRecord lr : issued) {
						%>

						<tr>

							<td><%=lr.getTitle()%></td>
							<td><%=lr.getIssueDate()%></td>

						</tr>

						<%
						}
						} else {
						%>

						<tr>
							<td colspan="2" class="text-center">No books issued</td>
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

		<div class="alert alert-warning">Student profile not found.</div>

		<%
		}
		%>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html> 