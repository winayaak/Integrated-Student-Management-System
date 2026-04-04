<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Library"%>

<%
List<Library> list = (List<Library>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
<title>Library Management</title>

<script src="https://cdn.tailwindcss.com"></script>

</head>

<body class="bg-gray-100">

	<div class="max-w-6xl mx-auto mt-10 bg-white p-6 rounded-lg shadow">

		<h2 class="text-2xl font-bold mb-6">📚 Library Management</h2>

		<!-- ISSUE BOOK FORM -->

		<form method="post"
			action="${pageContext.request.contextPath}/admin/library"
			class="grid grid-cols-3 gap-4 mb-6">

			<input type="hidden" name="action" value="add"> <input
				type="number" name="student_id" placeholder="Student ID"
				class="border p-2 rounded" required> <input type="number"
				name="book_id" placeholder="Book ID" class="border p-2 rounded"
				required>

			<button class="bg-blue-600 text-white p-2 rounded hover:bg-blue-700">

				Issue Book</button>

		</form>

		<!-- TABLE -->

		<table class="w-full border">

			<thead class="bg-gray-800 text-white">

				<tr>

					<th class="p-2">ID</th>
					<th class="p-2">Student ID</th>
					<th class="p-2">Book ID</th>
					<th class="p-2">Issue Date</th>
					<th class="p-2">Return Date</th>
					<th class="p-2">Status</th>
					<th class="p-2">Action</th>

				</tr>

			</thead>

			<tbody>

				<%
				if (list != null) {
					for (Library l : list) {
				%>

				<tr class="text-center border-t">

					<td class="p-2"><%=l.getId()%></td>
					<td><%=l.getStudentId()%></td>
					<td><%=l.getBookId()%></td>
					<td><%=l.getIssueDate()%></td>
					<td><%=l.getReturnDate()%></td>
					<td><%=l.getStatus()%></td>

					<td>
						<%
						if ("ISSUED".equals(l.getStatus())) {
						%>

						<form method="post"
							action="${pageContext.request.contextPath}/admin/library">

							<input type="hidden" name="action" value="return"> <input
								type="hidden" name="id" value="<%=l.getId()%>">

							<button class="bg-red-500 text-white px-3 py-1 rounded">
								Return</button>

						</form> <%
 }
 %>

					</td>

				</tr>

				<%
				}
				}
				%>

			</tbody>

		</table>

	</div>

</body>
</html>