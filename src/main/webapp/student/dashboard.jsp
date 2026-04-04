<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>
<%@ page import="model.User"%>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
	response.sendRedirect("../login.jsp");
	return;
}

int studentId = 0;
String name = "";
String roll = "";
String course = "";
int semester = 0;

Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn.prepareStatement("SELECT * FROM students WHERE user_id=?");

ps.setInt(1, user.getId());

ResultSet rs = ps.executeQuery();

if (rs.next()) {
	studentId = rs.getInt("id");
	name = rs.getString("name");
	roll = rs.getString("roll_no");
	course = rs.getString("course_id");
	semester = rs.getInt("semester");
}

rs.close();
ps.close();

String subjects = "";
String marks = "";

PreparedStatement ps2 = conn.prepareStatement("SELECT subject_id, marks_obtained FROM marks WHERE student_id=?");

ps2.setInt(1, studentId);

ResultSet rs2 = ps2.executeQuery();

while (rs2.next()) {

	subjects += "'Sub-" + rs2.getInt("subject_id") + "',";
	marks += rs2.getDouble("marks_obtained") + ",";

}

rs2.close();
ps2.close();
conn.close();

if (subjects.endsWith(",")) {
	subjects = subjects.substring(0, subjects.length() - 1);
	marks = marks.substring(0, marks.length() - 1);
}
%>


<!DOCTYPE html>
<html>

<head>

<title>Student Dashboard</title>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

</head>


<body class="bg-gradient-to-br from-blue-50 via-purple-50 to-indigo-100">


	<div class="flex min-h-screen">


		<!-- SIDEBAR -->

		<div class="w-64 bg-white shadow-lg p-6">

			<h2 class="text-2xl font-bold text-indigo-600 mb-8">Student
				Panel</h2>

			<ul class="space-y-4">

				<li><a href="dashboard.jsp"
					class="text-gray-700 hover:text-indigo-600">Dashboard</a></li>

				<li><a href="attendance.jsp"
					class="text-gray-700 hover:text-indigo-600">Attendance</a></li>

				<li><a href="marks.jsp"
					class="text-gray-700 hover:text-indigo-600">Marks</a></li>

				<li><a href="exams.jsp"
					class="text-gray-700 hover:text-indigo-600">Online Exam</a></li>

				<li><a href="library.jsp"
					class="text-gray-700 hover:text-indigo-600">Library</a></li>

				<li><a href="hostel.jsp"
					class="text-gray-700 hover:text-indigo-600">Hostel</a></li>

				<li><a href="placement.jsp"
					class="text-gray-700 hover:text-indigo-600">Placement</a></li>

				<li><a href="chatbot.jsp"
					class="text-gray-700 hover:text-indigo-600">Chatbot</a></li>

			</ul>


			<a href="../logout"
				class="block mt-10 bg-red-500 text-white text-center py-2 rounded-lg hover:bg-red-600">
				Logout </a>

		</div>



		<!-- MAIN CONTENT -->

		<div class="flex-1 p-10">


			<h1 class="text-3xl font-bold text-gray-800 mb-8">
				Welcome,
				<%=name%>
			</h1>



			<!-- DASHBOARD CARDS -->

			<div class="grid grid-cols-3 gap-6 mb-10">

				<a href="attendance.jsp"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-blue-600">Attendance</h3>
					<p class="text-gray-500">View your attendance record</p>
				</a> <a href="marks.jsp"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-purple-600">Marks</h3>
					<p class="text-gray-500">View your academic marks</p>
				</a> <a href="exams.jsp"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-red-500">Online Exam</h3>
					<p class="text-gray-500">Start available exams</p>
				</a> <a href="library.jsp"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-green-600">Library</h3>
					<p class="text-gray-500">Access library services</p>
				</a> <a href="hostel.jsp"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-indigo-600">Hostel</h3>
					<p class="text-gray-500">View hostel information</p>
				</a> <a href="${pageContext.request.contextPath}/student/placement"
					class="bg-white p-6 rounded-xl shadow hover:shadow-xl transition">
					<h3 class="text-lg font-semibold text-pink-500">Placement</h3>
					<p class="text-gray-500">Placement opportunities</p>
				</a>

			</div>



			<!-- GRAPH -->

			<div class="bg-white p-6 rounded-xl shadow-lg mb-8">

				<h2 class="text-xl font-semibold mb-4">Academic Performance</h2>

				<canvas id="marksChart"></canvas>

			</div>



			<!-- STUDENT INFO -->

			<div class="bg-white p-6 rounded-xl shadow-lg">

				<h2 class="text-xl font-semibold mb-4">Student Info</h2>

				<div class="grid grid-cols-2 gap-4">

					<p>
						<b>Name:</b>
						<%=name%></p>
					<p>
						<b>Roll No:</b>
						<%=roll%></p>
					<p>
						<b>Course:</b>
						<%=course%></p>
					<p>
						<b>Semester:</b>
						<%=semester%></p>

				</div>

			</div>


		</div>

	</div>



	<!-- FLOATING CHAT BUTTON -->

	<a href="chatbot.jsp"
		class="fixed bottom-6 right-6 bg-indigo-600 text-white w-14 h-14 rounded-full flex items-center justify-center text-2xl shadow-lg hover:bg-indigo-700">

		💬 </a>



	<script>
		const ctx = document.getElementById('marksChart');

		new Chart(ctx, {

			type : 'bar',

			data : {

				labels : [
	<%=subjects%>
		],

				datasets : [ {

					label : 'Marks',

					data : [
	<%=marks%>
		],

					backgroundColor : 'rgba(99,102,241,0.6)',
					borderRadius : 6

				} ]

			},

			options : {

				scales : {
					y : {
						beginAtZero : true
					}
				}

			}

		});
	</script>


</body>

</html>