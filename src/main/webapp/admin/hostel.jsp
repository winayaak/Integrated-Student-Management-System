<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html>
<head>

<title>Hostel Allocation</title>

<script src="https://cdn.tailwindcss.com"></script>

</head>

<body class="bg-gray-100 min-h-screen">

	<div class="flex">

		<!-- Sidebar -->
		<div class="w-64 bg-indigo-700 min-h-screen text-white p-6">

			<h2 class="text-2xl font-bold mb-8">ISMS Admin</h2>

			<ul class="space-y-4">

				<li class="hover:bg-indigo-500 p-2 rounded"><a
					href="dashboard.jsp">Dashboard</a></li>

				<li class="hover:bg-indigo-500 p-2 rounded"><a href="placement">Placement</a>
				</li>

				<li class="hover:bg-indigo-500 p-2 rounded"><a href="hostel">Hostel</a>
				</li>

				<li class="hover:bg-indigo-500 p-2 rounded"><a href="../logout">Logout</a>
				</li>

			</ul>

		</div>


		<!-- Main Content -->
		<div class="flex-1 p-10">

			<h1 class="text-3xl font-bold mb-8 text-gray-700">Hostel Room
				Allocation</h1>


			<div class="bg-white shadow-lg rounded-lg p-8 w-full max-w-2xl">

				<form method="post" class="space-y-6">

					<!-- Student -->
					<div>
						<label class="block text-gray-700 font-semibold mb-2">
							Select Student </label> <select name="studentId"
							class="w-full border rounded-lg p-3 focus:ring-2 focus:ring-indigo-400">

							<%
							Connection conn = DBConnection.getConnection();
							Statement st = conn.createStatement();
							ResultSet rs = st.executeQuery("SELECT id,name FROM students");

							while (rs.next()) {
							%>

							<option value="<%=rs.getInt("id")%>">
								<%=rs.getString("name")%>
							</option>

							<%
							}
							%>

						</select>

					</div>


					<!-- Room -->
					<div>

						<label class="block text-gray-700 font-semibold mb-2">
							Select Room </label> <select name="roomId"
							class="w-full border rounded-lg p-3 focus:ring-2 focus:ring-indigo-400">

							<%
							ResultSet r = st.executeQuery("SELECT id,room_no,block FROM hostel_rooms");

							while (r.next()) {
							%>

							<option value="<%=r.getInt("id")%>">Room
								<%=r.getString("room_no")%> - Block
								<%=r.getString("block")%>
							</option>

							<%
							}
							%>

						</select>

					</div>


					<!-- Button -->
					<div>

						<button type="submit"
							class="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold px-6 py-3 rounded-lg w-full">

							Allocate Room</button>

					</div>

				</form>

			</div>


			<!-- Current Allocations -->
			<div class="mt-10">

				<h2 class="text-2xl font-bold mb-4 text-gray-700">Current
					Hostel Allocations</h2>

				<div class="bg-white shadow-lg rounded-lg p-6">

					<table class="w-full text-left">

						<thead class="border-b">

							<tr class="text-gray-600">
								<th class="p-3">Student</th>
								<th class="p-3">Room</th>
								<th class="p-3">Block</th>
								<th class="p-3">Date</th>
							</tr>

						</thead>

						<tbody>

							<%
							ResultSet data = st.executeQuery("SELECT s.name,r.room_no,r.block,h.allocated_date FROM hostel h "
									+ "JOIN students s ON h.student_id=s.id " + "JOIN hostel_rooms r ON h.room_id=r.id");

							while (data.next()) {
							%>

							<tr class="border-b hover:bg-gray-50">

								<td class="p-3"><%=data.getString("name")%></td>
								<td class="p-3"><%=data.getString("room_no")%></td>
								<td class="p-3"><%=data.getString("block")%></td>
								<td class="p-3"><%=data.getString("allocated_date")%></td>

							</tr>

							<%
							}
							%>

						</tbody>

					</table>

				</div>

			</div>

		</div>

	</div>

</body>
</html>