<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.SubjectDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.Subject"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = new StudentDAO().findAll();
List<Subject> subjects = new SubjectDAO().findByCourseId(1); // default course
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Enter Marks — ISPS</title>

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
	--border-focus: rgba(159, 122, 234, 0.5);
	--accent-violet: #9f7aea;
	--accent-blue: #63b3ed;
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

body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 50% at 0% 10%, rgba(159, 122, 234, 0.10)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 55% at 100% 5%, rgba(99, 179, 237, 0.08)
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
	max-width: 900px;
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
	color: var(--accent-violet);
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
	background: var(--accent-violet);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.7rem, 3.5vw, 2.4rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-violet)
		100%);
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
	background: rgba(159, 122, 234, 0.12);
	border: 1px solid rgba(159, 122, 234, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--accent-violet);
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
	box-shadow: 0 0 0 3px rgba(159, 122, 234, 0.12);
	color: var(--text-primary);
}

.form-select-styled option {
	background: #1a1d27;
	color: var(--text-primary);
}

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
/* hide number spinners */
.form-input[type="number"]::-webkit-inner-spin-button, .form-input[type="number"]::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
}

.form-input[type="number"] {
	-moz-appearance: textfield;
}

/* ── inner divider ── */
.inner-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 0 0 1.4rem;
}

/* ── marks table ── */
.marks-table-wrap {
	overflow-x: auto;
	border-radius: var(--radius-md);
}

.marks-table-wrap::-webkit-scrollbar {
	height: 5px;
}

.marks-table-wrap::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

.marks-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.875rem;
}

.marks-table thead tr {
	background: rgba(255, 255, 255, 0.04);
}

.marks-table thead th {
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

.marks-table thead th:first-child {
	padding-left: 1.4rem;
}

.marks-table thead th:last-child {
	padding-right: 1.4rem;
}

.marks-table tbody tr {
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	transition: background 0.18s;
}

.marks-table tbody tr:last-child {
	border-bottom: none;
}

.marks-table tbody tr:hover {
	background: rgba(255, 255, 255, 0.03);
}

.marks-table tbody td {
	padding: 0.75rem 1rem;
	vertical-align: middle;
	color: var(--text-sub);
}

.marks-table tbody td:first-child {
	padding-left: 1.4rem;
}

.marks-table tbody td:last-child {
	padding-right: 1.4rem;
}

/* roll pill */
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
	background: linear-gradient(135deg, var(--accent-violet),
		var(--accent-blue));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.72rem;
	font-weight: 700;
	color: #fff;
	text-transform: uppercase;
	flex-shrink: 0;
	border: 1px solid rgba(159, 122, 234, 0.3);
}

.name-label {
	font-weight: 500;
	color: var(--text-primary);
}

/* marks input cell */
.marks-input-wrap {
	display: flex;
	align-items: center;
	gap: 0.6rem;
}

.marks-input {
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	color: var(--text-primary);
	font-family: 'Syne', sans-serif;
	font-size: 1rem;
	font-weight: 700;
	padding: 0.42rem 0.75rem;
	width: 90px;
	text-align: center;
	transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
	-webkit-appearance: none;
	-moz-appearance: textfield;
}

.marks-input::-webkit-inner-spin-button, .marks-input::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
}

.marks-input:focus {
	outline: none;
	background: rgba(255, 255, 255, 0.07);
	border-color: rgba(159, 122, 234, 0.45);
	box-shadow: 0 0 0 3px rgba(159, 122, 234, 0.1);
}

/* mini progress bar under input */
.marks-bar-track {
	flex: 1;
	height: 4px;
	border-radius: 2px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
	min-width: 60px;
}

.marks-bar-fill {
	height: 100%;
	border-radius: 2px;
	width: 0%;
	background: linear-gradient(90deg, var(--accent-violet),
		var(--accent-blue));
	transition: width 0.3s ease, background 0.3s ease;
}

/* grade badge */
.grade-badge {
	display: inline-flex;
	align-items: center;
	min-width: 30px;
	height: 24px;
	border-radius: 6px;
	padding: 0 0.5rem;
	font-size: 0.72rem;
	font-weight: 700;
	font-family: 'Syne', sans-serif;
	justify-content: center;
	flex-shrink: 0;
	transition: background 0.25s, color 0.25s, border-color 0.25s;
}

/* ── submit button ── */
.btn-submit {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background: linear-gradient(135deg, var(--accent-violet), #6b46c1);
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
	box-shadow: 0 4px 16px rgba(159, 122, 234, 0.32);
	margin-top: 1.4rem;
}

.btn-submit:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 22px rgba(159, 122, 234, 0.44);
}

.btn-submit:active {
	transform: translateY(0);
}

/* ── stats summary bar ── */
.summary-bar {
	display: flex;
	align-items: center;
	gap: 1.2rem;
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
	.marks-bar-track {
		display: none;
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
				<div class="page-eyebrow">Faculty · Academics</div>
				<h1 class="page-title">Enter Marks</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<div class="section-label">Subject, Semester &amp; Student Marks</div>

		<div class="glass-card">
			<form method="post"
				action="${pageContext.request.contextPath}/faculty/marks">

				<!-- card header -->
				<div class="gc-header">
					<div class="gc-header-left">
						<div class="gc-icon">
							<i class="bi bi-pencil-square"></i>
						</div>
						<h6>Marks Entry Sheet</h6>
					</div>
					<span style="font-size: 0.78rem; color: var(--text-muted);">
						<i class="bi bi-people-fill" style="margin-right: 4px;"></i> <%=students.size()%>
						students
					</span>
				</div>

				<div class="gc-body">

					<!-- filter row -->
					<div class="filter-row">

						<div class="field-wrap">
							<label class="field-label">Subject</label>
							<div class="select-wrap">
								<select name="subjectId" class="form-select-styled" required>
									<%
									for (Subject s : subjects) {
									%>
									<option value="<%=s.getId()%>"><%=s.getName()%></option>
									<%
									}
									%>
								</select>
							</div>
						</div>

						<div class="field-wrap">
							<label class="field-label">Semester</label> <input type="number"
								name="semester" class="form-input" value="1" min="1" max="8"
								required>
						</div>

					</div>

					<div class="inner-divider"></div>

					<!-- marks table -->
					<%
					if (students != null && !students.isEmpty()) {
					%>
					<div class="marks-table-wrap">
						<table class="marks-table">

							<thead>
								<tr>
									<th>Roll No</th>
									<th>Student</th>
									<th>Marks <span style="font-weight: 400; opacity: 0.5;">(out
											of 100)</span></th>
									<th>Grade</th>
								</tr>
							</thead>

							<tbody>
								<%
								for (Student s : students) {
									String initials = (s.getName() != null && s.getName().length() > 0)
									? String.valueOf(s.getName().charAt(0)).toUpperCase()
									: "S";
									String inputId = "marks_input_" + s.getId();
									String barId = "bar_" + s.getId();
									String gradeId = "grade_" + s.getId();
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
										<div class="marks-input-wrap">
											<%-- real input — name unchanged for backend --%>
											<input type="number" name="marks_<%=s.getId()%>"
												id="<%=inputId%>" class="marks-input" min="0" max="100"
												placeholder="—" required
												oninput="onMarksChange('<%=s.getId()%>')">
											<div class="marks-bar-track">
												<div class="marks-bar-fill" id="<%=barId%>"></div>
											</div>
										</div>
									</td>

									<td><span class="grade-badge" id="<%=gradeId%>"
										style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.08); color: var(--text-muted);">
											— </span></td>

								</tr>
								<%
								}
								%>
							</tbody>

						</table>
					</div>

					<!-- summary bar -->
					<div class="summary-bar" id="summaryBar">
						<span class="sum-item"> <i class="bi bi-people-fill"
							style="color: var(--accent-violet);"></i> Total: <span
							class="sum-count"><%=students.size()%></span>
						</span> <span class="sum-item"> <i class="bi bi-check-circle-fill"
							style="color: var(--accent-green);"></i> Filled: <span
							class="sum-count" id="filledCount">0</span>
						</span> <span class="sum-item"> <i class="bi bi-bar-chart-fill"
							style="color: var(--accent-blue);"></i> Avg: <span
							class="sum-count" id="avgMarks">—</span>
						</span> <span class="sum-item"
							style="margin-left: auto; font-size: 0.72rem;"> Tip: Tab
							through fields to move quickly </span>
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
						<i class="bi bi-floppy-fill"></i> Save Marks
					</button>

				</div>
			</form>
		</div>

	</div>

	<script>
		/* ── grade logic ── */
		function getGrade(marks) {
			if (marks >= 90)
				return {
					label : 'A+',
					bg : 'rgba(104,211,145,0.15)',
					border : 'rgba(104,211,145,0.3)',
					color : '#68d391'
				};
			if (marks >= 80)
				return {
					label : 'A',
					bg : 'rgba(104,211,145,0.10)',
					border : 'rgba(104,211,145,0.2)',
					color : '#9ae6b4'
				};
			if (marks >= 70)
				return {
					label : 'B+',
					bg : 'rgba(99,179,237,0.12)',
					border : 'rgba(99,179,237,0.25)',
					color : '#63b3ed'
				};
			if (marks >= 60)
				return {
					label : 'B',
					bg : 'rgba(99,179,237,0.08)',
					border : 'rgba(99,179,237,0.18)',
					color : '#90cdf4'
				};
			if (marks >= 50)
				return {
					label : 'C',
					bg : 'rgba(246,173,85,0.10)',
					border : 'rgba(246,173,85,0.22)',
					color : '#f6ad55'
				};
			if (marks >= 40)
				return {
					label : 'D',
					bg : 'rgba(246,173,85,0.08)',
					border : 'rgba(246,173,85,0.16)',
					color : '#fbd38d'
				};
			return {
				label : 'F',
				bg : 'rgba(252,129,129,0.12)',
				border : 'rgba(252,129,129,0.28)',
				color : '#fc8181'
			};
		}

		function onMarksChange(studentId) {
			var input = document.getElementById('marks_input_' + studentId);
			var bar = document.getElementById('bar_' + studentId);
			var grade = document.getElementById('grade_' + studentId);
			var val = parseInt(input.value, 10);

			if (isNaN(val) || input.value === '') {
				if (bar)
					bar.style.width = '0%';
				if (grade) {
					grade.textContent = '—';
					grade.style.background = 'rgba(255,255,255,0.05)';
					grade.style.borderColor = 'rgba(255,255,255,0.08)';
					grade.style.color = 'var(--text-muted)';
					grade.style.border = '1px solid rgba(255,255,255,0.08)';
				}
			} else {
				val = Math.min(100, Math.max(0, val));
				if (bar)
					bar.style.width = val + '%';

				/* bar colour based on score */
				if (val >= 75)
					bar.style.background = 'linear-gradient(90deg,#68d391,#4fd1c5)';
				else if (val >= 50)
					bar.style.background = 'linear-gradient(90deg,#f6ad55,#ed8936)';
				else
					bar.style.background = 'linear-gradient(90deg,#fc8181,#e53e3e)';

				if (grade) {
					var g = getGrade(val);
					grade.textContent = g.label;
					grade.style.background = g.bg;
					grade.style.border = '1px solid ' + g.border;
					grade.style.color = g.color;
				}
			}
			updateSummary();
		}

		function updateSummary() {
			var inputs = document.querySelectorAll('input[name^="marks_"]');
			var filled = 0;
			var total = 0;
			var count = 0;
			inputs.forEach(function(inp) {
				var v = parseInt(inp.value, 10);
				if (!isNaN(v) && inp.value !== '') {
					filled++;
					total += v;
					count++;
				}
			});
			var fc = document.getElementById('filledCount');
			var ac = document.getElementById('avgMarks');
			if (fc)
				fc.textContent = filled;
			if (ac)
				ac.textContent = count > 0 ? (total / count).toFixed(1) : '—';
		}
	</script>

</body>
</html>
