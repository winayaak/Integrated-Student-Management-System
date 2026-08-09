<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Exam — ISPS</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
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
	--accent-teal: #4fd1c5;
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
	background: radial-gradient(ellipse 60% 50% at 5% 0%, rgba(99, 179, 237, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 55% at 98% 8%, rgba(159, 122, 234, 0.08)
		0%, transparent 55%),
		radial-gradient(ellipse 55% 40% at 50% 100%, rgba(104, 211, 145, 0.06)
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

/* ── layout ── */
.page-wrap {
	position: relative;
	z-index: 1;
	max-width: 820px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 5rem;
}

/* ── page header ── */
.page-header {
	margin-bottom: 2.5rem;
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
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-blue) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.page-sub {
	margin-top: 0.4rem;
	font-size: 0.875rem;
	color: var(--text-muted);
	font-weight: 300;
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
	margin-bottom: 1.5rem;
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

.gc-icon.violet {
	background: rgba(159, 122, 234, 0.12);
	border-color: rgba(159, 122, 234, 0.15);
	color: var(--accent-violet);
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

/* ── form fields ── */
.form-create {
	animation: fadeUp 0.5s 0.05s ease both;
}

.form-grid-3 {
	display: grid;
	grid-template-columns: 2fr 1fr 1fr;
	gap: 1rem;
	margin-bottom: 1.3rem;
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

.form-input {
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

.form-input:focus {
	outline: none;
	background: rgba(255, 255, 255, 0.06);
	border-color: var(--border-focus);
	box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.12);
	color: var(--text-primary);
}
/* hide number spinners */
.form-input[type="number"]::-webkit-inner-spin-button, .form-input[type="number"]::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
}

.form-input[type="number"] {
	-moz-appearance: textfield;
}
/* datetime picker icon */
input[type="datetime-local"]::-webkit-calendar-picker-indicator {
	filter: invert(0.45) sepia(1) saturate(0.5);
	cursor: pointer;
}

/* ── create button ── */
.btn-create {
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
	padding: 0.68rem 1.6rem;
	cursor: pointer;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 16px rgba(99, 179, 237, 0.3);
}

.btn-create:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 22px rgba(99, 179, 237, 0.42);
}

.btn-create:active {
	transform: translateY(0);
}

/* ── divider ── */
.dash-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 2rem 0;
}

/* ── exams table ── */
.table-section {
	animation: fadeUp 0.5s 0.12s ease both;
}

.table-wrapper {
	overflow-x: auto;
	border-radius: var(--radius-lg);
}

.table-wrapper::-webkit-scrollbar {
	height: 5px;
}

.table-wrapper::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

.exams-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.875rem;
}

.exams-table thead tr {
	background: rgba(255, 255, 255, 0.04);
}

.exams-table thead th {
	padding: 0.9rem 1rem;
	font-size: 0.67rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--text-muted);
	border-bottom: 1px solid var(--border);
	text-align: left;
	white-space: nowrap;
}

.exams-table thead th:first-child {
	padding-left: 1.4rem;
}

.exams-table thead th:last-child {
	padding-right: 1.4rem;
}

.exams-table tbody tr {
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	transition: background 0.18s;
}

.exams-table tbody tr:last-child {
	border-bottom: none;
}

.exams-table tbody tr:hover {
	background: rgba(255, 255, 255, 0.03);
}

.exams-table tbody td {
	padding: 0.85rem 1rem;
	vertical-align: middle;
	color: var(--text-sub);
}

.exams-table tbody td:first-child {
	padding-left: 1.4rem;
}

.exams-table tbody td:last-child {
	padding-right: 1.4rem;
}

/* id pill */
.id-pill {
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

/* exam title cell */
.title-cell {
	display: flex;
	align-items: center;
	gap: 0.65rem;
}

.title-icon {
	width: 32px;
	height: 32px;
	border-radius: var(--radius-sm);
	flex-shrink: 0;
	background: linear-gradient(135deg, rgba(99, 179, 237, 0.18),
		rgba(159, 122, 234, 0.14));
	border: 1px solid rgba(99, 179, 237, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--accent-blue);
	font-size: 0.85rem;
}

.title-name {
	font-weight: 600;
	color: var(--text-primary);
	font-size: 0.9rem;
}

/* date cell */
.date-cell {
	display: flex;
	align-items: center;
	gap: 0.4rem;
	font-size: 0.82rem;
}

.date-cell i {
	color: var(--accent-teal);
	font-size: 0.8rem;
}

/* duration badge */
.dur-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	background: rgba(246, 173, 85, 0.08);
	border: 1px solid rgba(246, 173, 85, 0.18);
	border-radius: 50px;
	padding: 0.2rem 0.65rem;
	font-size: 0.78rem;
	font-weight: 600;
	color: var(--accent-amber);
}

/* upcoming / past chip */
.status-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.28rem;
	border-radius: 50px;
	padding: 0.18rem 0.6rem;
	font-size: 0.72rem;
	font-weight: 600;
}

.chip-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: currentColor;
}

.chip-upcoming {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--accent-green);
}

.chip-past {
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	color: var(--text-muted);
}

/* count badge in header */
.count-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.35rem;
	background: rgba(99, 179, 237, 0.1);
	border: 1px solid rgba(99, 179, 237, 0.2);
	color: var(--accent-blue);
	font-size: 0.75rem;
	font-weight: 500;
	padding: 0.28rem 0.7rem;
	border-radius: 50px;
}

/* empty state */
.empty-state {
	text-align: center;
	padding: 3.5rem 1rem;
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

@media ( max-width : 680px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.form-grid-3 {
		grid-template-columns: 1fr;
	}
	.gc-body {
		padding: 1.2rem;
	}
}
</style>
</head>

<body>

	<%
	/* ── session + DAO logic (unchanged) ── */
	HttpSession sessionObj = request.getSession(false);
	Integer facultyId = null;
	if (sessionObj != null) {
		facultyId = (Integer) sessionObj.getAttribute("userId");
	}
	if (facultyId == null) {
		facultyId = 1;
	}
	ExamDAO dao = new ExamDAO();
	List<Exam> exams = dao.getExamsByFaculty(facultyId);
	%>

	<div class="page-wrap">

		<!-- PAGE HEADER -->
		<div class="page-header">
			<div class="page-eyebrow">Faculty · Examinations</div>
			<h1 class="page-title">Create Exam</h1>
			<p class="page-sub">Schedule a new online exam and manage your
				existing ones.</p>
		</div>

		<!-- ═══ CREATE EXAM FORM ═══ -->
		<div class="form-create">
			<div class="section-label">New Exam</div>

			<div class="glass-card">
				<div class="gc-header">
					<div class="gc-icon">
						<i class="bi bi-journal-plus"></i>
					</div>
					<h6>Exam Details</h6>
				</div>
				<div class="gc-body">

					<form action="../faculty/createExam" method="post">

						<div class="form-grid-3">

							<div class="field-wrap">
								<label class="field-label">Exam Title</label> <input type="text"
									name="title" class="form-input"
									placeholder="e.g. Mid-Semester Exam — Data Structures" required>
							</div>

							<div class="field-wrap">
								<label class="field-label">Date &amp; Time</label> <input
									type="datetime-local" name="examDate" class="form-input"
									required>
							</div>

							<div class="field-wrap">
								<label class="field-label">Duration (min)</label> <input
									type="number" name="duration" class="form-input"
									placeholder="e.g. 60" min="1" required>
							</div>

						</div>

						<button type="submit" class="btn-create">
							<i class="bi bi-journal-plus"></i> Create Exam
						</button>

					</form>
				</div>
			</div>
		</div>

		<div class="dash-divider"></div>

		<!-- ═══ EXISTING EXAMS TABLE ═══ -->
		<div class="table-section">
			<div class="section-label">Your Exams</div>

			<div class="glass-card">

				<div class="gc-header">
					<div class="gc-icon violet">
						<i class="bi bi-file-earmark-text-fill"></i>
					</div>
					<h6>Existing Exams</h6>
					<span class="count-badge" style="margin-left: auto;"> <i
						class="bi bi-list-ul"></i> <%=exams.size()%> exam<%=exams.size() != 1 ? "s" : ""%>
					</span>
				</div>

				<div class="table-wrapper">
					<table class="exams-table">

						<thead>
							<tr>
								<th>ID</th>
								<th>Title</th>
								<th>Scheduled</th>
								<th>Duration</th>
								<th>Status</th>
							</tr>
						</thead>

						<tbody>

							<%
							if (exams != null && !exams.isEmpty()) {
								java.time.LocalDateTime now = java.time.LocalDateTime.now();
								for (Exam e : exams) {

									/* determine upcoming vs past purely from examDate string */
									boolean isUpcoming = true;
									try {
								java.time.LocalDateTime examDt = java.time.LocalDateTime
										.parse(e.getExamDate().toString().replace(" ", "T"));
								isUpcoming = examDt.isAfter(now);
									} catch (Exception ignored) {
									}
							%>

							<tr>

								<td><span class="id-pill">#<%=e.getId()%></span></td>

								<td>
									<div class="title-cell">
										<div class="title-icon">
											<i class="bi bi-journal-text"></i>
										</div>
										<span class="title-name"><%=e.getTitle()%></span>
									</div>
								</td>

								<td>
									<div class="date-cell">
										<i class="bi bi-calendar3"></i>
										<%=e.getExamDate()%>
									</div>
								</td>

								<td><span class="dur-badge"> <i
										class="bi bi-clock-fill" style="font-size: 0.65rem;"></i> <%=e.getDuration()%>
										min
								</span></td>

								<td>
									<%
									if (isUpcoming) {
									%> <span class="status-chip chip-upcoming">
										<span class="chip-dot"></span> Upcoming
								</span> <%
 } else {
 %> <span class="status-chip chip-past"> <span
										class="chip-dot"></span> Completed
								</span> <%
 }
 %>
								</td>

							</tr>

							<%
							}
							} else {
							%>
							<tr>
								<td colspan="5">
									<div class="empty-state">
										<i class="bi bi-journal-x"></i>
										<p>No exams created yet. Use the form above to schedule
											one.</p>
									</div>
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

	</div>

</body>
</html>
