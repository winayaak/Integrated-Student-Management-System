<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html>
<head>
<title>Placement Management</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen">

	<div class="flex">

		<!-- Sidebar -->
		<div class="w-64 bg-blue-700 text-white min-h-screen p-6">

			<h2 class="text-2xl font-bold mb-8">ISMS Admin</h2>

			<ul class="space-y-4">

				<li class="hover:bg-blue-500 p-2 rounded"><a
					href="dashboard.jsp">Dashboard</a></li>

				<li class="hover:bg-blue-500 p-2 rounded"><a href="placement">Placement</a>
				</li>

				<li class="hover:bg-blue-500 p-2 rounded"><a href="hostel">Hostel</a>
				</li>

				<li class="hover:bg-blue-500 p-2 rounded"><a href="../logout">Logout</a>
				</li>

			</ul>

		</div>

		<!-- Main Content -->
		<div class="flex-1 p-10">

			<h1 class="text-3xl font-bold text-gray-700 mb-8">Placement
				Management</h1>

			<!-- Add Company -->
			<div class="bg-white p-6 rounded shadow mb-8">

				<h2 class="text-xl font-semibold mb-4">Add Company</h2>

				<form method="post" action="placement">

					<input type="hidden" name="action" value="addCompany">

					<div class="grid grid-cols-3 gap-4">

						<input type="text" name="name" placeholder="Company Name"
							class="border p-2 rounded"> <input type="text"
							name="packageAmt" placeholder="Package (LPA)"
							class="border p-2 rounded"> <input type="text"
							name="requirements" placeholder="Requirements"
							class="border p-2 rounded">

					</div>

					<button
						class="mt-4 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
						Add Company</button>

				</form>

			</div>


			<!-- Applications Table -->

			<div class="bg-white p-6 rounded shadow">

				<h2 class="text-xl font-semibold mb-4">Student Applications</h2>

				<table class="w-full text-left border">

					<thead class="bg-blue-600 text-white">
						<tr>
							<th class="p-3">Student</th>
							<th class="p-3">Company</th>
							<th class="p-3">Package</th>
							<th class="p-3">Status</th>
							<th class="p-3">Action</th>
						</tr>
					</thead>

					<tbody>

						<%
						Connection conn = DBConnection.getConnection();

						Statement st = conn.createStatement();

						ResultSet rs = st.executeQuery(

								"SELECT p.id, s.name as student, c.name as company, c.package_amt, p.status " + "FROM placement p "
								+ "JOIN students s ON p.student_id=s.id " + "JOIN companies c ON p.company_id=c.id"

						);

						while (rs.next()) {
						%>

						<tr class="border-b hover:bg-gray-50">

							<td class="p-3"><%=rs.getString("student")%></td>

							<td class="p-3"><%=rs.getString("company")%></td>

							<td class="p-3"><%=rs.getString("package_amt")%> LPA</td>

							<td class="p-3"><span
								class="bg-yellow-200 text-yellow-800 px-2 py-1 rounded text-sm">
									<%=rs.getString("status")%>
							</span></td>

							<td class="p-3">

								<form method="post" action="placement" class="flex gap-2">

									<input type="hidden" name="action" value="updateStatus">
									<input type="hidden" name="id" value="<%=rs.getInt("id")%>">

									<select name="status" class="border p-1 rounded">

										<option>APPLIED</option>
										<option>SELECTED</option>
										<option>REJECTED</option>

									</select>

									<button class="bg-green-500 text-white px-2 py-1 rounded">
										Update</button>

								</form>

							</td>

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