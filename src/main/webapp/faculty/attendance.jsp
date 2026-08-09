<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.CourseDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.Course"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = new StudentDAO().findAll();
List<Course> courses = new CourseDAO().findAll();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mark Attendance — ISPS</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--bg-deep: #08090d;
	--bg-card: rgba(255, 255, 255, 0.04);
	--bg-card-hover: rgba(255, 255, 255, 0.065);
	--border: rgba(255, 255, 255, 0.08);
	--border-focus: rgba(99, 179, 237, 0.5);
	--accent-blue: #63b3ed;
	--accent-violet: #9f7aea;
	--accent-green: #68d391;
	--accent-red: #fc8181;
	--accent-amber: #f6ad55;
	--text-primary: #f0f4f8;
	--text-sub: #a0aec0;
	--text-muted: #4a5568;
	--radius-lg: 18px;
	--radius-md: 12px;
	--radius-sm: 8px;
	--shadow-card: 0 8px 32px rgba(0, 0, 0, 0.5);
}

html, body {
	background: var(--bg-deep);
	color: var(--text-primary);
	font-family: 'DM Sans', sans-serif;
	min-height: 100vh;
	overflow-x: hidden;
}

/* mesh */
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 50% at 0% 10%, rgba(99, 179, 237, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 55% at 100% 5%, rgba(159, 122, 234, 0.08)
		0%, transparent 55%),
		radial-gradient(ellipse 55% 40% at 45% 100%, rgba(104, 211, 145, 0.06)
		0%, transparent 50%);
	pointer-events: none;
	z-index: 0;
}

body::after {
	content: '';
	position: fixed;
	inset: 0;
	background-image:
		url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
	pointer-events: none;
	z-index: 0;
	opacity: 0.55;
}

.page-wrap {
	position: relative;
	z-index: 1;
	max-width: 960px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 5rem;
}

/* ── page header ── */
.page-header {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 1rem;
	margin-bottom: 2.4rem;
	animation: fadeDown 0.5s ease both;
}

.page-eyebrow {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--accent-blue);
	display: flex;
	align-items: center;
	gap: 0.45rem;
	margin-bottom: 0.3rem;
}

.page-eyebrow::before {
	content: '';
	display: inline-block;
	width: 16px;
	height: 2px;
	background: var(--accent-blue);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.7rem, 3.5vw, 2.4rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-blue) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.back-btn {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	color: var(--text-sub);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	font-weight: 500;
	padding: 0.45rem 1rem;
	text-decoration: none;
	backdrop-filter: blur(10px);
	transition: background 0.2s, border-color 0.2s, color 0.2s, transform
		0.18s;
}

.back-btn:hover {
	background: var(--bg-card-hover);
	border-color: rgba(255, 255, 255, 0.14);
	color: var(--text-primary);
	transform: translateX(-2px);
}

/* ── section label ── */
.section-label {
	font-size: 0.68rem;
	font-weight: 500;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--text-muted);
	margin-bottom: 0.85rem;
}

/* ── glass card ── */
.glass-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--radius-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow-card);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s 0.07s ease both;
}

.glass-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.035) 0%,
		transparent 55%);
	pointer-events: none;
}

.gc-header {
	padding: 1.2rem 1.6rem;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 0.75rem;
}

.gc-header-left {
	display: flex;
	align-items: center;
	gap: 0.75rem;
}

.gc-icon {
	width: 34px;
	height: 34px;
	border-radius: var(--radius-sm);
	background: rgba(99, 179, 237, 0.12);
	border: 1px solid rgba(99, 179, 237, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--accent-blue);
	font-size: 0.95rem;
	flex-shrink: 0;
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text-primary);
	margin: 0;
}

.gc-body {
	padding: 1.6rem;
}

/* ── filter row ── */
.filter-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1rem;
	margin-bottom: 1.6rem;
}

.field-wrap {
	display: flex;
	flex-direction: column;
	gap: 0.3rem;
}

.field-label {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.07em;
	text-transform: uppercase;
	color: var(--text-muted);
}

/* shared input / select styles */
.form-input, .form-select-styled {
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	color: var(--text-primary);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	padding: 0.62rem 0.9rem;
	width: 100%;
	transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
	-webkit-appearance: none;
	appearance: none;
}

.form-input::placeholder {
	color: var(--text-muted);
}

.form-input:focus, .form-select-styled:focus {
	outline: none;
	background: rgba(255, 255, 255, 0.06);
	border-color: var(--border-focus);
	box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.12);
	color: var(--text-primary);
}

.form-select-styled option {
	background: #1a1d27;
	color: var(--text-primary);
}

/* custom select arrow */
.select-wrap {
	position: relative;
}

.select-wrap::after {
	content: '\F282';
	font-family: 'bootstrap-icons';
	position: absolute;
	right: 0.75rem;
	top: 50%;
	transform: translateY(-50%);
	color: var(--text-muted);
	font-size: 0.8rem;
	pointer-events: none;
}

/* date picker */
input[type="date"]::-webkit-calendar-picker-indicator {
	filter: invert(0.45) sepia(1) saturate(0.5);
	cursor: pointer;
}

/* ── divider ── */
.inner-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 0 0 1.4rem;
}

/* ── attendance table ── */
.att-table-wrap {
	overflow-x: auto;
	border-radius: var(--radius-md);
}

.att-table-wrap::-webkit-scrollbar {
	height: 5px;
}

.att-table-wrap::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

.att-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.875rem;
}

.att-table thead tr {
	background: rgba(255, 255, 255, 0.04);
}

.att-table thead th {
	padding: 0.85rem 1rem;
	font-size: 0.67rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--text-muted);
	border-bottom: 1px solid var(--border);
	text-align: left;
	white-space: nowrap;
}

.att-table thead th:first-child {
	padding-left: 1.4rem;
}

.att-table thead th:last-child {
	padding-right: 1.4rem;
}

.att-table tbody tr {
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	transition: background 0.18s;
}

.att-table tbody tr:last-child {
	border-bottom: none;
}

.att-table tbody tr:hover {
	background: rgba(255, 255, 255, 0.03);
}

.att-table tbody td {
	padding: 0.78rem 1rem;
	vertical-align: middle;
	color: var(--text-sub);
}

.att-table tbody td:first-child {
	padding-left: 1.4rem;
}

.att-table tbody td:last-child {
	padding-right: 1.4rem;
}

/* roll no pill */
.roll-pill {
	display: inline-flex;
	align-items: center;
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	border-radius: 6px;
	padding: 0.18rem 0.55rem;
	font-size: 0.75rem;
	font-weight: 600;
	font-family: 'Syne', monospace;
	color: var(--text-muted);
	letter-spacing: 0.04em;
}

/* student name cell */
.name-cell {
	display: flex;
	align-items: center;
	gap: 0.65rem;
}

.name-avatar {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	background: linear-gradient(135deg, var(--accent-blue),
		var(--accent-violet));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.72rem;
	font-weight: 700;
	color: #fff;
	text-transform: uppercase;
	flex-shrink: 0;
	border: 1px solid rgba(99, 179, 237, 0.25);
}

.name-label {
	font-weight: 500;
	color: var(--text-primary);
}

/* ── toggle switch attendance ── */
.att-toggle-wrap {
	display: flex;
	align-items: center;
	gap: 0;
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: 50px;
	overflow: hidden;
	width: fit-content;
}

/* hide the real select, use custom radio-toggle */
.att-toggle-wrap select.form-select-styled {
	display: none;
}

.toggle-btn {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	padding: 0.32rem 0.85rem;
	font-size: 0.75rem;
	font-weight: 500;
	font-family: 'DM Sans', sans-serif;
	border: none;
	background: transparent;
	cursor: pointer;
	border-radius: 50px;
	transition: background 0.18s, color 0.18s;
	color: var(--text-muted);
	position: relative;
	z-index: 1;
}

.toggle-btn.present.active, .toggle-btn.present:hover {
	background: rgba(104, 211, 145, 0.15);
	color: var(--accent-green);
}

.toggle-btn.absent.active, .toggle-btn.absent:hover {
	background: rgba(252, 129, 129, 0.15);
	color: var(--accent-red);
}

/* ── submit button ── */
.btn-submit {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background: linear-gradient(135deg, var(--accent-blue), #2b6cb0);
	border: none;
	border-radius: var(--radius-sm);
	color: #fff;
	font-family: 'DM Sans', sans-serif;
	font-size: 0.9rem;
	font-weight: 500;
	padding: 0.7rem 1.8rem;
	cursor: pointer;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 16px rgba(99, 179, 237, 0.3);
	margin-top: 1.4rem;
}

.btn-submit:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 22px rgba(99, 179, 237, 0.42);
}

.btn-submit:active {
	transform: translateY(0);
}

/* summary bar */
.summary-bar {
	display: flex;
	align-items: center;
	gap: 1rem;
	flex-wrap: wrap;
	margin-top: 1rem;
	padding: 0.75rem 1rem;
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	font-size: 0.8rem;
	color: var(--text-muted);
}

.sum-item {
	display: flex;
	align-items: center;
	gap: 0.4rem;
}

.sum-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	flex-shrink: 0;
}

.sum-dot.present {
	background: var(--accent-green);
}

.sum-dot.absent {
	background: var(--accent-red);
}

.sum-count {
	font-weight: 600;
	color: var(--text-primary);
}

/* empty state */
.empty-state {
	text-align: center;
	padding: 3rem 1rem;
	color: var(--text-muted);
}

.empty-state i {
	font-size: 2.5rem;
	opacity: 0.3;
	display: block;
	margin-bottom: 0.75rem;
}

.empty-state p {
	font-size: 0.88rem;
}

/* animations */
@
keyframes fadeDown {from { opacity:0;
	transform: translateY(-14px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
@
keyframes fadeUp {from { opacity:0;
	transform: translateY(18px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
::-webkit-scrollbar {
	width: 6px;
}

::-webkit-scrollbar-track {
	background: transparent;
}

::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

@media ( max-width : 640px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.filter-row {
		grid-template-columns: 1fr;
	}
	.gc-body {
		padding: 1.2rem;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
}
</style>
</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="page-wrap">

		<!-- PAGE HEADER -->
		<div class="page-header">
			<div>
				<div class="page-eyebrow">Faculty · Attendance</div>
				<h1 class="page-title">Mark Attendance</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<!-- FORM CARD -->
		<div class="section-label">Session Details &amp; Students</div>

		<div class="glass-card">

			<form method="post"
				action="${pageContext.request.contextPath}/faculty/attendance">

				<!-- card header -->
				<div class="gc-header">
					<div class="gc-header-left">
						<div class="gc-icon">
							<i class="bi bi-clipboard2-check-fill"></i>
						</div>
						<h6>Attendance Sheet</h6>
					</div>
					<span style="font-size: 0.78rem; color: var(--text-muted);">
						<i class="bi bi-people-fill" style="margin-right: 4px;"></i> <%=students.size()%>
						students
					</span>
				</div>

				<div class="gc-body">

					<!-- ── filter row: course + date ── -->
					<div class="filter-row">

						<div class="field-wrap">
							<label class="field-label">Course</label>
							<div class="select-wrap">
								<select name="courseId" class="form-select-styled" required>
									<option value="">— Select Course —</option>
									<%
									for (Course c : courses) {
									%>
									<option value="<%=c.getId()%>"><%=c.getName()%></option>
									<%
									}
									%>
								</select>
							</div>
						</div>

						<div class="field-wrap">
							<label class="field-label">Date</label> <input type="date"
								name="date" class="form-input" required>
						</div>

					</div>

					<div class="inner-divider"></div>

					<!-- ── students table ── -->
					<%
					if (students != null && !students.isEmpty()) {
					%>
					<div class="att-table-wrap">
						<table class="att-table">

							<thead>
								<tr>
									<th>Roll No</th>
									<th>Student</th>
									<th>Attendance</th>
								</tr>
							</thead>

							<tbody>
								<%
								int rowIdx = 0;
								for (Student s : students) {
									String initials = (s.getName() != null && s.getName().length() > 0)
									? String.valueOf(s.getName().charAt(0)).toUpperCase()
									: "S";
									String toggleId = "toggle_" + s.getId();
									rowIdx++;
								%>
								<tr>

									<td><span class="roll-pill"><%=s.getRollNo()%></span></td>

									<td>
										<div class="name-cell">
											<div class="name-avatar"><%=initials%></div>
											<span class="name-label"><%=s.getName()%></span>
										</div>
									</td>

									<td>
										<%-- Hidden real select (name unchanged for backend) --%> <select
										name="status_<%=s.getId()%>" id="<%=toggleId%>"
										class="form-select-styled" style="display: none;">
											<option value="PRESENT">PRESENT</option>
											<option value="ABSENT">ABSENT</option>
									</select> <%-- Visual toggle buttons --%>
										<div class="att-toggle-wrap" data-select="<%=toggleId%>">
											<button type="button" class="toggle-btn present active"
												data-value="PRESENT"
												onclick="setAttendance(this, '<%=toggleId%>', 'PRESENT')">
												<i class="bi bi-check-lg"></i> Present
											</button>
											<button type="button" class="toggle-btn absent"
												data-value="ABSENT"
												onclick="setAttendance(this, '<%=toggleId%>', 'ABSENT')">
												<i class="bi bi-x-lg"></i> Absent
											</button>
										</div>
									</td>

								</tr>
								<%
								}
								%>
							</tbody>

						</table>
					</div>

					<!-- summary bar -->
					<div class="summary-bar" id="summaryBar">
						<span class="sum-item"> <span class="sum-dot present"></span>
							Present: <span class="sum-count" id="presentCount"><%=students.size()%></span>
						</span> <span class="sum-item"> <span class="sum-dot absent"></span>
							Absent: <span class="sum-count" id="absentCount">0</span>
						</span> <span class="sum-item" style="margin-left: auto;"> Total:
							<span class="sum-count"><%=students.size()%></span>
						</span>
					</div>

					<%
					} else {
					%>
					<div class="empty-state">
						<i class="bi bi-people"></i>
						<p>No students found in the system.</p>
					</div>
					<%
					}
					%>

					<button type="submit" class="btn-submit">
						<i class="bi bi-floppy-fill"></i> Save Attendance
					</button>

				</div>
				<!-- gc-body -->
			</form>
		</div>
		<!-- glass-card -->

	</div>
	<!-- page-wrap -->

	<script>
		/* ── attendance toggle helper ── */
		function setAttendance(clickedBtn, selectId, value) {
			// update hidden select
			var sel = document.getElementById(selectId);
			sel.value = value;

			// update button states
			var wrap = clickedBtn.closest('.att-toggle-wrap');
			wrap.querySelectorAll('.toggle-btn').forEach(function(b) {
				b.classList.remove('active');
			});
			clickedBtn.classList.add('active');

			// update summary counts
			updateSummary();
		}

		function updateSummary() {
			var allSelects = document
					.querySelectorAll('select[name^="status_"]');
			var present = 0, absent = 0;
			allSelects.forEach(function(s) {
				if (s.value === 'PRESENT')
					present++;
				else
					absent++;
			});
			var pc = document.getElementById('presentCount');
			var ac = document.getElementById('absentCount');
			if (pc)
				pc.textContent = present;
			if (ac)
				ac.textContent = absent;
		}

		/* ── mark all present / absent shortcuts (optional keyboard) ── */
		document.addEventListener('keydown', function(e) {
			if (e.ctrlKey && e.key === 'p') {
				e.preventDefault();
				document.querySelectorAll('.toggle-btn.present').forEach(
						function(b) {
							b.click();
						});
			}
			if (e.ctrlKey && e.key === 'a') {
				e.preventDefault();
				document.querySelectorAll('.toggle-btn.absent').forEach(
						function(b) {
							b.click();
						});
			}
		});
	</script>

</body>
</html>
