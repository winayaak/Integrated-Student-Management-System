<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html>
<head>

<title>Faculty Dashboard</title>

<script src="https://cdn.tailwindcss.com"></script>

</head>

<body
	class="bg-gradient-to-br from-blue-50 via-purple-50 to-indigo-100 min-h-screen">

	<div class="flex">

		<!-- SIDEBAR -->

		<div class="w-64 h-screen bg-white shadow-lg p-6">

			<h2 class="text-2xl font-bold text-blue-600 mb-8">Faculty Panel
			</h2>

			<ul class="space-y-4">

				<li><a href="dashboard.jsp" class="block hover:text-blue-600">
						 Dashboard </a></li>

				<li><a href="attendance.jsp" class="block hover:text-blue-600">
						 Mark Attendance </a></li>

				<li><a href="marks.jsp" class="block hover:text-blue-600">
						 Enter Marks </a></li>

				<li><a href="create_exam.jsp" class="block hover:text-blue-600">
						 Create Exam </a></li>

				<li><a href="add_questions.jsp"
					class="block hover:text-blue-600">  Add Questions </a></li>

				<li><a href="exam_results.jsp"
					class="block hover:text-blue-600">  Exam Results </a></li>

				<li><a href="../admin/placement"
					class="block hover:text-blue-600">  Placement </a></li>

			</ul>

			<div class="mt-10">

				<a href="../logout"
					class="bg-red-500 text-white px-4 py-2 rounded-lg block text-center hover:bg-red-600">
					Logout </a>

			</div>

		</div>

		<!-- MAIN CONTENT -->

		<div class="flex-1 p-10">

			<h1 class="text-3xl font-bold mb-2">Welcome, Faculty</h1>

			<p class="text-gray-500 mb-8">Manage attendance, marks, exams and
				student performance</p>


			<!-- STATS -->

			<div class="grid grid-cols-3 gap-6 mb-10">

				<div class="bg-white p-6 rounded-xl shadow text-center">
					<p class="text-gray-500">Students</p>
					<p id="students" class="text-3xl font-bold text-blue-600">0</p>
				</div>

				<div class="bg-white p-6 rounded-xl shadow text-center">
					<p class="text-gray-500">Courses</p>
					<p id="courses" class="text-3xl font-bold text-green-600">0</p>
				</div>

				<div class="bg-white p-6 rounded-xl shadow text-center">
					<p class="text-gray-500">Exams</p>
					<p id="exams" class="text-3xl font-bold text-purple-600">0</p>
				</div>

			</div>


			<!-- CARDS -->

			<div class="grid grid-cols-3 gap-6">

				<a href="attendance.jsp"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-blue-600">Mark
						Attendance</h2>

					<p class="text-gray-500">Record daily student attendance</p>

				</a> <a href="marks.jsp"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-purple-600">Enter Marks
					</h2>

					<p class="text-gray-500">Add or update student marks</p>

				</a> <a href="create_exam.jsp"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-red-600">Create Exam</h2>

					<p class="text-gray-500">Create new online exam</p>

				</a> <a href="add_questions.jsp"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-green-600">Add Questions
					</h2>

					<p class="text-gray-500">Add MCQ questions</p>

				</a> <a href="exam_results.jsp"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-yellow-600">Exam Results
					</h2>

					<p class="text-gray-500">View student exam scores</p>

				</a> <a href="../admin/placement"
					class="bg-white p-6 rounded-xl shadow transition transform hover:-translate-y-1 hover:shadow-xl">

					<h2 class="text-xl font-semibold text-indigo-600">Placement</h2>

					<p class="text-gray-500">Manage placement activities</p>

				</a>

			</div>

		</div>

	</div>


	<!-- ANIMATED COUNTERS -->

	<script>
		function animateValue(id, start, end, duration) {

			let range = end - start
			let current = start
			let increment = end > start ? 1 : -1
			let stepTime = Math.abs(Math.floor(duration / range))

			let obj = document.getElementById(id)

			let timer = setInterval(function() {

				current += increment
				obj.innerHTML = current

				if (current == end) {
					clearInterval(timer)
				}

			}, stepTime)

		}

		animateValue("students", 0, 5, 1000)
		animateValue("courses", 0, 3, 1000)
		animateValue("exams", 0, 3, 1000)
	</script>

</body>

</html>