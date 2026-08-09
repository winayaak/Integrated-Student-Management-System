<%@ page import="java.sql.*,util.DBConnection"%>

<%
HttpSession sessionObj = request.getSession(false);

Integer facultyId = null;

if (sessionObj != null) {
	facultyId = (Integer) sessionObj.getAttribute("userId");
}

if (facultyId == null) {
	facultyId = 1;
}

Connection conn = DBConnection.getConnection();

PreparedStatement ps = conn
		.prepareStatement("SELECT s.name AS student_name, e.title AS exam_name, r.score, r.submitted_at "
		+ "FROM exam_results r " + "JOIN exams e ON r.exam_id = e.id "
		+ "JOIN students s ON r.student_id = s.id " + "WHERE e.faculty_id = ?");

ps.setInt(1, facultyId);

ResultSet rs = ps.executeQuery();

/* ── collect all rows first so we can compute stats ── */
java.util.List<Object[]> rows = new java.util.ArrayList<>();
int totalEntries = 0, passCount = 0, failCount = 0, topScore = 0;
double scoreSum = 0;
while (rs.next()) {
	int score = rs.getInt("score");
	String sn = rs.getString("student_name");
	String en = rs.getString("exam_name");
	String sat = rs.getTimestamp("submitted_at") != null ? rs.getTimestamp("submitted_at").toString() : "—";
	rows.add(new Object[]{sn, en, score, sat});
	totalEntries++;
	scoreSum += score;
	if (score >= 50)
		passCount++;
	else
		failCount++;
	if (score > topScore)
		topScore = score;
}
double avgScore = totalEntries > 0 ? scoreSum / totalEntries : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Exam Results — ISPS</title>

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
	--accent-amber: #f6ad55;
	--accent-blue: #63b3ed;
	--accent-violet: #9f7aea;
	--accent-green: #68d391;
	--accent-red: #fc8181;
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

/* full-page mesh */
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 65% 55% at 0% 5%, rgba(246, 173, 85, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 60% at 100% 10%, rgba(99, 179, 237, 0.08)
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

/* ── full-width layout ── */
.page-wrap {
	position: relative;
	z-index: 1;
	width: 100%;
	max-width: 1300px;
	margin: 0 auto;
	padding: 2.5rem 2rem 5rem;
}

/* ── page header ── */
.page-header {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 1rem;
	margin-bottom: 2.5rem;
	animation: fadeDown 0.5s ease both;
}

.page-eyebrow {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--accent-amber);
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
	background: var(--accent-amber);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.9rem, 3.5vw, 2.7rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-amber)
		100%);
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

.header-right {
	display: flex;
	gap: 0.75rem;
	align-items: center;
}

.total-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: rgba(246, 173, 85, 0.1);
	border: 1px solid rgba(246, 173, 85, 0.22);
	color: var(--accent-amber);
	font-size: 0.78rem;
	font-weight: 500;
	padding: 0.38rem 0.85rem;
	border-radius: 50px;
	backdrop-filter: blur(8px);
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

/* ── stat cards ── */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
	gap: 1rem;
	margin-bottom: 2rem;
	animation: fadeUp 0.5s 0.05s ease both;
}

.stat-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--radius-md);
	padding: 1.25rem 1.3rem;
	backdrop-filter: blur(14px);
	box-shadow: var(--shadow-card);
	position: relative;
	overflow: hidden;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s, box-shadow 0.25s;
	cursor: default;
}

.stat-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%,
		transparent 60%);
	pointer-events: none;
}

.stat-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	background: var(--sc-a);
	opacity: 0.7;
	transition: opacity 0.2s;
}

.stat-card:hover {
	transform: translateY(-4px);
	border-color: rgba(255, 255, 255, 0.12);
	box-shadow: var(--shadow-card), var(--sc-glow);
}

.stat-card:hover::after {
	opacity: 1;
}

.stat-card.sc-total {
	--sc-a: var(--accent-amber);
	--sc-glow: 0 0 24px rgba(246, 173, 85, 0.18);
}

.stat-card.sc-avg {
	--sc-a: var(--accent-blue);
	--sc-glow: 0 0 24px rgba(99, 179, 237, 0.18);
}

.stat-card.sc-pass {
	--sc-a: var(--accent-green);
	--sc-glow: 0 0 24px rgba(104, 211, 145, 0.18);
}

.stat-card.sc-fail {
	--sc-a: var(--accent-red);
	--sc-glow: 0 0 24px rgba(252, 129, 129, 0.18);
}

.stat-card.sc-top {
	--sc-a: var(--accent-violet);
	--sc-glow: 0 0 24px rgba(159, 122, 234, 0.18);
}

.sc-icon {
	width: 36px;
	height: 36px;
	border-radius: var(--radius-sm);
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1rem;
	color: var(--sc-a);
	margin-bottom: 0.9rem;
}

.sc-label {
	font-size: 0.7rem;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: var(--text-muted);
	margin-bottom: 0.3rem;
}

.sc-value {
	font-family: 'Syne', sans-serif;
	font-size: 2rem;
	font-weight: 800;
	letter-spacing: -0.04em;
	color: var(--text-primary);
	line-height: 1;
}

.sc-value .sc-suffix {
	font-size: 0.5em;
	font-weight: 500;
	opacity: 0.6;
	margin-left: 2px;
}

/* ── pass rate bar ── */
.pass-bar-track {
	margin-top: 0.65rem;
	height: 4px;
	border-radius: 2px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
}

.pass-bar-fill {
	height: 100%;
	border-radius: 2px;
	background: linear-gradient(90deg, var(--accent-green),
		var(--accent-teal));
	transition: width 1s ease;
}

/* ── glass card / table ── */
.glass-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--radius-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow-card);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s 0.12s ease both;
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
	padding: 1.1rem 1.6rem;
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
	background: rgba(246, 173, 85, 0.12);
	border: 1px solid rgba(246, 173, 85, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--accent-amber);
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

/* search box */
.search-wrap {
	position: relative;
}

.search-wrap i {
	position: absolute;
	left: 0.75rem;
	top: 50%;
	transform: translateY(-50%);
	color: var(--text-muted);
	font-size: 0.85rem;
	pointer-events: none;
}

.search-input {
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	color: var(--text-primary);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	padding: 0.45rem 0.85rem 0.45rem 2.1rem;
	width: 220px;
	transition: border-color 0.2s, box-shadow 0.2s;
}

.search-input::placeholder {
	color: var(--text-muted);
}

.search-input:focus {
	outline: none;
	border-color: rgba(246, 173, 85, 0.4);
	box-shadow: 0 0 0 3px rgba(246, 173, 85, 0.08);
}

/* table */
.table-wrapper {
	overflow-x: auto;
}

.table-wrapper::-webkit-scrollbar {
	height: 5px;
}

.table-wrapper::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

.results-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.875rem;
}

.results-table thead tr {
	background: rgba(255, 255, 255, 0.04);
}

.results-table thead th {
	padding: 0.9rem 1rem;
	font-size: 0.67rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--text-muted);
	border-bottom: 1px solid var(--border);
	text-align: left;
	white-space: nowrap;
	cursor: pointer;
	user-select: none;
	transition: color 0.18s;
}

.results-table thead th:hover {
	color: var(--text-sub);
}

.results-table thead th:first-child {
	padding-left: 1.4rem;
}

.results-table thead th:last-child {
	padding-right: 1.4rem;
}

.results-table tbody tr {
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	transition: background 0.18s;
}

.results-table tbody tr:last-child {
	border-bottom: none;
}

.results-table tbody tr:hover {
	background: rgba(255, 255, 255, 0.03);
}

.results-table tbody td {
	padding: 0.9rem 1rem;
	vertical-align: middle;
	color: var(--text-sub);
}

.results-table tbody td:first-child {
	padding-left: 1.4rem;
}

.results-table tbody td:last-child {
	padding-right: 1.4rem;
}

/* student cell */
.student-cell {
	display: flex;
	align-items: center;
	gap: 0.7rem;
}

.student-avatar {
	width: 34px;
	height: 34px;
	border-radius: 50%;
	flex-shrink: 0;
	background: linear-gradient(135deg, var(--accent-amber), #c05621);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.78rem;
	font-weight: 700;
	color: #1a1207;
	text-transform: uppercase;
	border: 1px solid rgba(246, 173, 85, 0.3);
}

.student-name {
	font-weight: 500;
	color: var(--text-primary);
}

/* exam chip */
.exam-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	background: rgba(99, 179, 237, 0.08);
	border: 1px solid rgba(99, 179, 237, 0.16);
	border-radius: 50px;
	padding: 0.2rem 0.7rem;
	font-size: 0.76rem;
	color: var(--accent-blue);
	max-width: 220px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

/* score cell */
.score-cell {
	display: flex;
	align-items: center;
	gap: 0.85rem;
}

.score-num {
	font-family: 'Syne', sans-serif;
	font-size: 1.05rem;
	font-weight: 800;
	letter-spacing: -0.02em;
	min-width: 36px;
	color: var(--text-primary);
}

.score-track {
	flex: 1;
	height: 6px;
	border-radius: 3px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
	min-width: 80px;
}

.score-fill {
	height: 100%;
	border-radius: 3px;
	transition: width 0.8s ease;
}

.score-fill.grade-a {
	background: linear-gradient(90deg, #68d391, #4fd1c5);
}

.score-fill.grade-b {
	background: linear-gradient(90deg, #63b3ed, #4299e1);
}

.score-fill.grade-c {
	background: linear-gradient(90deg, #f6ad55, #ed8936);
}

.score-fill.grade-f {
	background: linear-gradient(90deg, #fc8181, #e53e3e);
}

/* grade badge */
.grade-badge {
	display: inline-flex;
	align-items: center;
	min-width: 32px;
	height: 22px;
	border-radius: 6px;
	padding: 0 0.5rem;
	font-size: 0.72rem;
	font-weight: 700;
	font-family: 'Syne', sans-serif;
	justify-content: center;
	flex-shrink: 0;
}

.gb-a {
	background: rgba(104, 211, 145, 0.12);
	border: 1px solid rgba(104, 211, 145, 0.25);
	color: var(--accent-green);
}

.gb-b {
	background: rgba(99, 179, 237, 0.12);
	border: 1px solid rgba(99, 179, 237, 0.25);
	color: var(--accent-blue);
}

.gb-c {
	background: rgba(246, 173, 85, 0.12);
	border: 1px solid rgba(246, 173, 85, 0.25);
	color: var(--accent-amber);
}

.gb-f {
	background: rgba(252, 129, 129, 0.12);
	border: 1px solid rgba(252, 129, 129, 0.25);
	color: var(--accent-red);
}

/* pass/fail chip */
.pf-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.28rem;
	border-radius: 50px;
	padding: 0.2rem 0.65rem;
	font-size: 0.73rem;
	font-weight: 600;
}

.pf-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: currentColor;
}

.pf-pass {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--accent-green);
}

.pf-fail {
	background: rgba(252, 129, 129, 0.1);
	border: 1px solid rgba(252, 129, 129, 0.22);
	color: var(--accent-red);
}

/* date cell */
.date-cell {
	font-size: 0.8rem;
	color: var(--text-muted);
	letter-spacing: 0.02em;
}

/* table footer */
.table-footer {
	padding: 0.85rem 1.6rem;
	border-top: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: space-between;
	font-size: 0.78rem;
	color: var(--text-muted);
	flex-wrap: wrap;
	gap: 0.5rem;
}

.tf-showing {
	display: flex;
	align-items: center;
	gap: 0.4rem;
}

.tf-count {
	font-weight: 600;
	color: var(--text-sub);
}

/* empty state */
.empty-state {
	text-align: center;
	padding: 4rem 1rem;
	color: var(--text-muted);
}

.empty-state i {
	font-size: 3rem;
	opacity: 0.25;
	display: block;
	margin-bottom: 1rem;
}

.empty-state h4 {
	font-family: 'Syne', sans-serif;
	font-size: 1.1rem;
	font-weight: 700;
	color: var(--text-sub);
	margin-bottom: 0.4rem;
}

.empty-state p {
	font-size: 0.875rem;
}

/* divider */
.dash-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 2rem 0;
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

@media ( max-width : 900px) {
	.page-wrap {
		padding: 1.5rem 1rem 3rem;
	}
	.search-input {
		width: 160px;
	}
	.score-track {
		min-width: 50px;
	}
}

@media ( max-width : 600px) {
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.search-input {
		width: 130px;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
}
</style>
</head>

<body>

	<div class="page-wrap">

		<!-- PAGE HEADER -->
		<div class="page-header">
			<div>
				<div class="page-eyebrow">Faculty · Examinations</div>
				<h1 class="page-title">Exam Results</h1>
				<p class="page-sub">Performance overview across all your
					scheduled exams.</p>
			</div>
			<div class="header-right">
				<span class="total-badge"> <i class="bi bi-bar-chart-fill"></i>
					<%=totalEntries%> submission<%=totalEntries != 1 ? "s" : ""%>
				</span>
			</div>
		</div>

		<!-- ═══ STAT CARDS ═══ -->
		<div class="section-label">Overview</div>
		<div class="stats-grid">

			<div class="stat-card sc-total">
				<div class="sc-icon">
					<i class="bi bi-people-fill"></i>
				</div>
				<div class="sc-label">Total Submissions</div>
				<div class="sc-value"><%=totalEntries%></div>
			</div>

			<div class="stat-card sc-avg">
				<div class="sc-icon">
					<i class="bi bi-graph-up"></i>
				</div>
				<div class="sc-label">Class Average</div>
				<div class="sc-value">
					<%=String.format("%.1f", avgScore)%><span class="sc-suffix">/
						100</span>
				</div>
			</div>

			<div class="stat-card sc-pass">
				<div class="sc-icon">
					<i class="bi bi-check-circle-fill"></i>
				</div>
				<div class="sc-label">Passed</div>
				<div class="sc-value"><%=passCount%></div>
				<%
				if (totalEntries > 0) {
				%>
				<div class="pass-bar-track">
					<div class="pass-bar-fill"
						style="width:<%=(passCount * 100 / totalEntries)%>%"></div>
				</div>
				<%
				}
				%>
			</div>

			<div class="stat-card sc-fail">
				<div class="sc-icon">
					<i class="bi bi-x-circle-fill"></i>
				</div>
				<div class="sc-label">Failed</div>
				<div class="sc-value"><%=failCount%></div>
			</div>

			<div class="stat-card sc-top">
				<div class="sc-icon">
					<i class="bi bi-trophy-fill"></i>
				</div>
				<div class="sc-label">Top Score</div>
				<div class="sc-value"><%=topScore%><span class="sc-suffix">/
						100</span>
				</div>
			</div>

		</div>

		<div class="dash-divider"></div>

		<!-- ═══ RESULTS TABLE ═══ -->
		<div class="section-label">All Results</div>

		<div class="glass-card">

			<div class="gc-header">
				<div class="gc-header-left">
					<div class="gc-icon">
						<i class="bi bi-bar-chart-fill"></i>
					</div>
					<h6>Result Sheet</h6>
				</div>
				<div class="search-wrap">
					<i class="bi bi-search"></i> <input type="text"
						class="search-input" id="searchInput"
						placeholder="Search student or exam…" oninput="filterTable()">
				</div>
			</div>

			<%
			if (!rows.isEmpty()) {
			%>
			<div class="table-wrapper">
				<table class="results-table" id="resultsTable">

					<thead>
						<tr>
							<th onclick="sortTable(0)">Student <i
								class="bi bi-chevron-expand"
								style="opacity: 0.4; font-size: 0.65rem;"></i></th>
							<th onclick="sortTable(1)">Exam <i
								class="bi bi-chevron-expand"
								style="opacity: 0.4; font-size: 0.65rem;"></i></th>
							<th onclick="sortTable(2)">Score <i
								class="bi bi-chevron-expand"
								style="opacity: 0.4; font-size: 0.65rem;"></i></th>
							<th>Grade</th>
							<th>Status</th>
							<th onclick="sortTable(5)">Submitted <i
								class="bi bi-chevron-expand"
								style="opacity: 0.4; font-size: 0.65rem;"></i></th>
						</tr>
					</thead>

					<tbody id="resultsBody">
						<%
						for (Object[] row : rows) {
							String studentName = (String) row[0];
							String examName = (String) row[1];
							int score = (Integer) row[2];
							String submittedAt = (String) row[3];

							String initials = (studentName != null && studentName.length() > 0)
							? String.valueOf(studentName.charAt(0)).toUpperCase()
							: "S";

							/* grade logic */
							String gradeLabel, gradeClass, fillClass;
							if (score >= 90) {
								gradeLabel = "A+";
								gradeClass = "gb-a";
								fillClass = "grade-a";
							} else if (score >= 75) {
								gradeLabel = "A";
								gradeClass = "gb-a";
								fillClass = "grade-a";
							} else if (score >= 60) {
								gradeLabel = "B";
								gradeClass = "gb-b";
								fillClass = "grade-b";
							} else if (score >= 50) {
								gradeLabel = "C";
								gradeClass = "gb-c";
								fillClass = "grade-c";
							} else {
								gradeLabel = "F";
								gradeClass = "gb-f";
								fillClass = "grade-f";
							}

							boolean passed = score >= 50;
						%>
						<tr>

							<td>
								<div class="student-cell">
									<div class="student-avatar"><%=initials%></div>
									<span class="student-name"><%=studentName%></span>
								</div>
							</td>

							<td><span class="exam-chip"> <i
									class="bi bi-journal-text" style="font-size: 0.68rem;"></i> <%=examName%>
							</span></td>

							<td>
								<div class="score-cell">
									<span class="score-num"><%=score%></span>
									<div class="score-track">
										<div class="score-fill <%=fillClass%>"
											style="width:<%=score%>%"></div>
									</div>
								</div>
							</td>

							<td><span class="grade-badge <%=gradeClass%>"><%=gradeLabel%></span>
							</td>

							<td>
								<%
								if (passed) {
								%> <span class="pf-chip pf-pass"><span
									class="pf-dot"></span> Pass</span> <%
 } else {
 %> <span
								class="pf-chip pf-fail"><span class="pf-dot"></span> Fail</span>
								<%
								}
								%>
							</td>

							<td><span class="date-cell"> <i class="bi bi-clock"
									style="margin-right: 4px; opacity: 0.5;"></i> <%=submittedAt%>
							</span></td>

						</tr>
						<%
						}
						%>
					</tbody>

				</table>
			</div>

			<div class="table-footer">
				<span class="tf-showing"> Showing <span class="tf-count"
					id="visibleCount"><%=rows.size()%></span> of <span
					class="tf-count"><%=rows.size()%></span> results
				</span> <span> Pass rate: <strong
					style="color: var(--accent-green);"> <%=totalEntries > 0 ? String.format("%.0f", (passCount * 100.0 / totalEntries)) : 0%>%
				</strong>
				</span>
			</div>

			<%
			} else {
			%>
			<div class="empty-state">
				<i class="bi bi-bar-chart"></i>
				<h4>No results yet</h4>
				<p>Student submissions will appear here once exams are
					completed.</p>
			</div>
			<%
			}
			%>

		</div>
	</div>

	<script>
		/* ── live search filter ── */
		function filterTable() {
			var query = document.getElementById('searchInput').value
					.toLowerCase();
			var rows = document.querySelectorAll('#resultsBody tr');
			var visible = 0;
			rows.forEach(function(row) {
				var text = row.textContent.toLowerCase();
				var show = text.indexOf(query) > -1;
				row.style.display = show ? '' : 'none';
				if (show)
					visible++;
			});
			var vc = document.getElementById('visibleCount');
			if (vc)
				vc.textContent = visible;
		}

		/* ── column sort ── */
		var sortDir = {};
		function sortTable(colIdx) {
			var tbody = document.getElementById('resultsBody');
			if (!tbody)
				return;
			var rows = Array.from(tbody.querySelectorAll('tr'));
			var asc = !sortDir[colIdx];
			sortDir = {};
			sortDir[colIdx] = asc;

			rows.sort(function(a, b) {
				var av = a.cells[colIdx] ? a.cells[colIdx].textContent.trim()
						: '';
				var bv = b.cells[colIdx] ? b.cells[colIdx].textContent.trim()
						: '';
				var an = parseFloat(av), bn = parseFloat(bv);
				if (!isNaN(an) && !isNaN(bn))
					return asc ? an - bn : bn - an;
				return asc ? av.localeCompare(bv) : bv.localeCompare(av);
			});
			rows.forEach(function(r) {
				tbody.appendChild(r);
			});
		}

		/* ── animate score bars on load ── */
		document.addEventListener('DOMContentLoaded', function() {
			document.querySelectorAll('.score-fill, .pass-bar-fill').forEach(
					function(el) {
						var w = el.style.width;
						el.style.width = '0%';
						setTimeout(function() {
							el.style.width = w;
						}, 120);
					});
		});
	</script>

</body>
</html>
