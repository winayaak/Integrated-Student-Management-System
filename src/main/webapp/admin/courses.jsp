<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.*,model.Course"%>

<%
List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Courses</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">

	<div class="max-w-6xl mx-auto mt-10 bg-white p-6 rounded-lg shadow">

		<h2 class="text-2xl font-bold mb-6">📚 Manage Courses</h2>

		<!-- ADD COURSE -->
		<form method="post"
			action="${pageContext.request.contextPath}/admin/courses"
			class="grid grid-cols-5 gap-4 mb-6">

			<input type="hidden" name="action" value="add"> <input
				type="text" name="name" placeholder="Course Name"
				class="border p-2 rounded" required> <input type="text"
				name="code" placeholder="Course Code" class="border p-2 rounded">

			<input type="number" name="credits" placeholder="Credits"
				class="border p-2 rounded" required> <input type="text"
				name="department" placeholder="Department"
				class="border p-2 rounded">

			<button
				class="bg-green-600 text-white p-2 rounded hover:bg-green-700">
				Add Course</button>

		</form>

		<hr class="mb-6">

		<!-- TABLE -->
		<table class="w-full border">

			<thead class="bg-gray-800 text-white">
				<tr>
					<th class="p-2">ID</th>
					<th class="p-2">Name</th>
					<th class="p-2">Code</th>
					<th class="p-2">Credits</th>
					<th class="p-2">Department</th>
					<th class="p-2">Action</th>
				</tr>
			</thead>

			<tbody>

				<%
				if (courses != null) {
					for (Course c : courses) {
				%>

				<tr class="text-center border-t">

					<td class="p-2"><%=c.getId()%></td>
					<td><%=c.getName()%></td>
					<td><%=c.getCode()%></td>
					<td><%=c.getCredits()%></td>
					<td><%=c.getDepartment()%></td>

					<td>

						<form method="post"
							action="${pageContext.request.contextPath}/admin/courses">

							<input type="hidden" name="action" value="delete"> <input
								type="hidden" name="id" value="<%=c.getId()%>">

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