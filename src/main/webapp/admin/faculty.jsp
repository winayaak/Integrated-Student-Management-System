<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Faculty"%>

<%
List<Faculty> faculty = (List<Faculty>) request.getAttribute("faculty");
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Faculty</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">

	<div class="max-w-6xl mx-auto mt-10 bg-white p-6 rounded-lg shadow">

		<h2 class="text-2xl font-bold mb-6">👨‍🏫 Manage Faculty</h2>

		<!-- ADD FACULTY -->
		<form method="post"
			action="${pageContext.request.contextPath}/admin/faculty"
			class="grid grid-cols-5 gap-4 mb-6">

			<input type="hidden" name="action" value="add"> <input
				type="text" name="username" placeholder="Username"
				class="border p-2 rounded" required> <input type="text"
				name="name" placeholder="Faculty Name" class="border p-2 rounded"
				required> <input type="email" name="email"
				placeholder="Email" class="border p-2 rounded" required> <input
				type="text" name="department" placeholder="Department"
				class="border p-2 rounded" required> <input type="text"
				name="phone" placeholder="Phone" class="border p-2 rounded">

			<button class="bg-blue-600 text-white p-2 rounded hover:bg-blue-700">
				Add Faculty</button>

		</form>

		<hr class="mb-6">

		<!-- TABLE -->
		<table class="w-full border">

			<thead class="bg-gray-800 text-white">
				<tr>
					<th class="p-2">ID</th>
					<th class="p-2">Name</th>
					<th class="p-2">Email</th>
					<th class="p-2">Department</th>
					<th class="p-2">Phone</th>
					<th class="p-2">Action</th>
				</tr>
			</thead>

			<tbody>

				<%
				if (faculty != null) {
					for (Faculty f : faculty) {
				%>

				<tr class="text-center border-t">

					<td class="p-2"><%=f.getId()%></td>
					<td><%=f.getName()%></td>
					<td><%=f.getEmail()%></td>
					<td><%=f.getDepartment()%></td>
					<td><%=f.getPhone()%></td>

					<td>

						<form method="post"
							action="${pageContext.request.contextPath}/admin/faculty">

							<input type="hidden" name="action" value="delete"> <input
								type="hidden" name="id" value="<%=f.getId()%>">

							<button class="bg-red-500 text-white px-3 py-1 rounded">
								Delete</button>

						</form>

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