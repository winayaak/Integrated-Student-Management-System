<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Available Exams — ISMS</title>

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
	--bg: #08090d;
	--bg-sidebar: #0c0d14;
	--bg-card: rgba(255, 255, 255, 0.04);
	--bg-hover: rgba(255, 255, 255, 0.07);
	--border: rgba(255, 255, 255, 0.08);
	--blue: #63b3ed;
	--violet: #9f7aea;
	--green: #68d391;
	--red: #fc8181;
	--amber: #f6ad55;
	--teal: #4fd1c5;
	--text: #f0f4f8;
	--sub: #a0aec0;
	--muted: #4a5568;
	--sidebar-w: 240px;
	--r-lg: 18px;
	--r-md: 12px;
	--r-sm: 8px;
	--shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
}

html, body {
	background: var(--bg);
	color: var(--text);
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
.layout {
	display: flex;
	min-height: 100vh;
	position: relative;
	z-index: 1;
}

/* ══════════ SIDEBAR ══════════ */
.sidebar {
	width: var(--sidebar-w);
	flex-shrink: 0;
	background: var(--bg-sidebar);
	border-right: 1px solid var(--border);
	display: flex;
	flex-direction: column;
	padding: 2rem 1.2rem;
	position: sticky;
	top: 0;
	height: 100vh;
	overflow-y: auto;
}

.sidebar-brand {
	display: flex;
	align-items: center;
	gap: 0.65rem;
	margin-bottom: 2.5rem;
	padding-bottom: 1.5rem;
	border-bottom: 1px solid var(--border);
}

.brand-icon {
	width: 36px;
	height: 36px;
	border-radius: var(--r-sm);
	background: linear-gradient(135deg, var(--blue), var(--violet));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1rem;
	color: #fff;
	flex-shrink: 0;
}

.brand-text {
	font-family: 'Syne', sans-serif;
	font-size: 1rem;
	font-weight: 800;
	letter-spacing: -0.02em;
	color: var(--text);
	line-height: 1.15;
}

.brand-sub {
	font-size: 0.65rem;
	color: var(--muted);
	letter-spacing: 0.06em;
}

.nav-section-label {
	font-size: 0.62rem;
	font-weight: 600;
	letter-spacing: 0.14em;
	text-transform: uppercase;
	color: var(--muted);
	padding: 0 0.5rem;
	margin-bottom: 0.5rem;
}

.nav-list {
	list-style: none;
	display: flex;
	flex-direction: column;
	gap: 0.18rem;
}

.nav-item a {
	display: flex;
	align-items: center;
	gap: 0.7rem;
	padding: 0.58rem 0.75rem;
	border-radius: var(--r-sm);
	text-decoration: none;
	color: var(--sub);
	font-size: 0.875rem;
	font-weight: 400;
	transition: background 0.18s, color 0.18s, transform 0.18s;
	position: relative;
}

.nav-item a:hover {
	background: rgba(255, 255, 255, 0.06);
	color: var(--text);
	transform: translateX(2px);
}

.nav-item.active a {
	background: rgba(99, 179, 237, 0.1);
	color: var(--blue);
	font-weight: 500;
	border: 1px solid rgba(99, 179, 237, 0.15);
}

.nav-item.active a::before {
	content: '';
	position: absolute;
	left: 0;
	top: 20%;
	bottom: 20%;
	width: 3px;
	border-radius: 0 3px 3px 0;
	background: var(--blue);
}

.nav-icon {
	font-size: 1rem;
	flex-shrink: 0;
	width: 18px;
	text-align: center;
}

.sidebar-spacer {
	flex: 1;
	min-height: 1rem;
}

.logout-item a {
	display: flex;
	align-items: center;
	gap: 0.7rem;
	padding: 0.58rem 0.75rem;
	border-radius: var(--r-sm);
	text-decoration: none;
	color: var(--red);
	font-size: 0.875rem;
	opacity: 0.75;
	transition: background 0.18s, opacity 0.18s;
}

.logout-item a:hover {
	background: rgba(252, 129, 129, 0.08);
	opacity: 1;
}

/* ══════════ MAIN ══════════ */
.main {
	flex: 1;
	padding: 2.5rem 2rem 5rem;
	overflow-x: hidden;
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
	color: var(--blue);
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
	background: var(--blue);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--blue) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.page-sub {
	margin-top: 0.4rem;
	font-size: 0.875rem;
	color: var(--muted);
	font-weight: 300;
}

.count-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: rgba(99, 179, 237, 0.1);
	border: 1px solid rgba(99, 179, 237, 0.2);
	color: var(--blue);
	font-size: 0.78rem;
	font-weight: 500;
	padding: 0.38rem 0.85rem;
	border-radius: 50px;
	backdrop-filter: blur(8px);
}

/* ── section label ── */
.sec-label {
	font-size: 0.68rem;
	font-weight: 500;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--muted);
	margin-bottom: 0.85rem;
}

/* ── stat cards ── */
.stat-row {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
	gap: 1rem;
	margin-bottom: 2rem;
	animation: fadeUp 0.5s 0.05s ease both;
}

.stat-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-md);
	padding: 1.2rem 1.3rem;
	backdrop-filter: blur(14px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s, box-shadow 0.25s;
	cursor: default;
}

.stat-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	background: var(--sc-a, var(--blue));
	opacity: 0.7;
	transition: opacity 0.2s;
}

.stat-card:hover {
	transform: translateY(-3px);
}

.stat-card:hover::after {
	opacity: 1;
}

.sc-1 {
	--sc-a: var(--blue);
}

.sc-2 {
	--sc-a: var(--green);
}

.sc-3 {
	--sc-a: var(--amber);
}

.sc-icon {
	width: 32px;
	height: 32px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.9rem;
	color: var(--sc-a, var(--blue));
	margin-bottom: 0.8rem;
}

.sc-label {
	font-size: 0.68rem;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: var(--muted);
	margin-bottom: 0.25rem;
}

.sc-value {
	font-family: 'Syne', sans-serif;
	font-size: 1.6rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	color: var(--text);
}

/* ── exam cards grid ── */
.exam-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 1.1rem;
	animation: fadeUp 0.5s 0.12s ease both;
}

.exam-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s, box-shadow 0.25s, background 0.25s;
}

.exam-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.035) 0%,
		transparent 55%);
	pointer-events: none;
}
/* top accent line — cycles through colors by nth-child */
.exam-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	background: var(--ec-a, var(--blue));
	opacity: 0.75;
	transition: opacity 0.22s;
}

.exam-card:hover {
	transform: translateY(-5px);
	border-color: rgba(255, 255, 255, 0.13);
	background: var(--bg-hover);
	box-shadow: var(--shadow), 0 0 40px rgba(99, 179, 237, 0.08);
}

.exam-card:hover::after {
	opacity: 1;
}

/* color rotation for cards */
.exam-card:nth-child(6n+1) {
	--ec-a: var(--blue);
}

.exam-card:nth-child(6n+2) {
	--ec-a: var(--violet);
}

.exam-card:nth-child(6n+3) {
	--ec-a: var(--green);
}

.exam-card:nth-child(6n+4) {
	--ec-a: var(--amber);
}

.exam-card:nth-child(6n+5) {
	--ec-a: var(--teal);
}

.exam-card:nth-child(6n+6) {
	--ec-a: var(--red);
}

.ec-body {
	padding: 1.4rem 1.5rem;
	flex: 1;
}

/* exam icon row */
.ec-top {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	margin-bottom: 1rem;
}

.ec-icon-box {
	width: 42px;
	height: 42px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.07);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.1rem;
	color: var(--ec-a, var(--blue));
	flex-shrink: 0;
	transition: transform 0.22s ease;
}

.exam-card:hover .ec-icon-box {
	transform: scale(1.1) rotate(-3deg);
}

/* status chip */
.ec-status {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	border-radius: 50px;
	padding: 0.2rem 0.65rem;
	font-size: 0.7rem;
	font-weight: 600;
}

.ec-status .dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: currentColor;
}

.status-live {
	background: rgba(104, 211, 145, 0.12);
	border: 1px solid rgba(104, 211, 145, 0.25);
	color: var(--green);
}

.status-upcoming {
	background: rgba(246, 173, 85, 0.10);
	border: 1px solid rgba(246, 173, 85, 0.22);
	color: var(--amber);
}

.status-past {
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	color: var(--muted);
}

.ec-id {
	font-size: 0.68rem;
	color: var(--muted);
	font-family: 'Syne', monospace;
	letter-spacing: 0.05em;
	margin-bottom: 0.3rem;
}

.ec-title {
	font-family: 'Syne', sans-serif;
	font-size: 1.05rem;
	font-weight: 700;
	color: var(--text);
	letter-spacing: -0.01em;
	line-height: 1.25;
	margin-bottom: 1rem;
}

/* meta pills row */
.ec-meta {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
	margin-bottom: 1.1rem;
}

.ec-pill {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 0.22rem 0.65rem;
	font-size: 0.73rem;
	color: var(--sub);
}

.ec-pill i {
	font-size: 0.68rem;
	color: var(--ec-a, var(--blue));
}

/* separator */
.ec-sep {
	height: 1px;
	background: var(--border);
	margin: 0 1.5rem;
}

/* footer */
.ec-footer {
	padding: 1rem 1.5rem;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 0.75rem;
}

.ec-footer-info {
	font-size: 0.74rem;
	color: var(--muted);
}

/* Start Exam button */
.btn-start {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: linear-gradient(135deg, var(--blue), #2b6cb0);
	border: none;
	border-radius: var(--r-sm);
	color: #fff;
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	font-weight: 500;
	padding: 0.5rem 1.1rem;
	cursor: pointer;
	text-decoration: none;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 14px rgba(99, 179, 237, 0.3);
	white-space: nowrap;
}

.btn-start:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 20px rgba(99, 179, 237, 0.44);
}

.btn-start:active {
	transform: translateY(0);
}

/* empty state */
.empty-state {
	grid-column: 1/-1;
	text-align: center;
	padding: 5rem 1rem;
	color: var(--muted);
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
	color: var(--sub);
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
	.sidebar {
		display: none;
	}
	.main {
		padding: 1.5rem 1rem 3.5rem;
	}
}

@media ( max-width : 600px) {
	.exam-grid {
		grid-template-columns: 1fr;
	}
	.stat-row {
		grid-template-columns: repeat(3, 1fr);
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
}
</style>
</head>

<body>

	<%
	ExamDAO dao = new ExamDAO();
	List<Exam> exams = dao.getAllExams();
	int totalExams = exams.size();

	/* count upcoming vs past */
	int upcomingCount = 0;
	java.time.LocalDateTime now = java.time.LocalDateTime.now();
	for (Exam e : exams) {
		try {
			java.time.LocalDateTime dt = java.time.LocalDateTime.parse(e.getExamDate().toString().replace(" ", "T"));
			if (dt.isAfter(now))
		upcomingCount++;
		} catch (Exception ignored) {
		}
	}
	int pastCount = totalExams - upcomingCount;
	%>

	<div class="layout">

		<!-- ═══════════ SIDEBAR ═══════════ -->
		<aside class="sidebar">
			<div class="sidebar-brand">
				<div class="brand-icon">
					<i class="bi bi-mortarboard-fill"></i>
				</div>
				<div>
					<div class="brand-text">Student</div>
					<div class="brand-sub">ISMS Portal</div>
				</div>
			</div>

			<div class="nav-section-label">Menu</div>
			<ul class="nav-list">
				<li class="nav-item"><a href="dashboard.jsp"> <span
						class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>
						Dashboard
				</a></li>
				<li class="nav-item"><a href="attendance.jsp"> <span
						class="nav-icon"><i class="bi bi-clipboard2-check-fill"></i></span>
						Attendance
				</a></li>
				<li class="nav-item"><a href="marks.jsp"> <span
						class="nav-icon"><i class="bi bi-bar-chart-fill"></i></span> Marks
				</a></li>
				<li class="nav-item active"><a href="exams.jsp"> <span
						class="nav-icon"><i class="bi bi-journal-text"></i></span> Online
						Exam
				</a></li>
				<li class="nav-item"><a href="library.jsp"> <span
						class="nav-icon"><i class="bi bi-book-half"></i></span> Library
				</a></li>
				<li class="nav-item"><a href="hostel.jsp"> <span
						class="nav-icon"><i class="bi bi-building"></i></span> Hostel
				</a></li>
				<li class="nav-item"><a href="placement.jsp"> <span
						class="nav-icon"><i class="bi bi-briefcase-fill"></i></span>
						Placement
				</a></li>
				<li class="nav-item"><a href="chatbot.jsp"> <span
						class="nav-icon"><i class="bi bi-chat-dots-fill"></i></span>
						Chatbot
				</a></li>
			</ul>

			<div class="sidebar-spacer"></div>
			<ul class="nav-list">
				<li class="logout-item"><a href="../logout"> <span
						class="nav-icon"><i class="bi bi-box-arrow-left"></i></span>
						Logout
				</a></li>
			</ul>
		</aside>

		<!-- ═══════════ MAIN ═══════════ -->
		<main class="main">

			<!-- page header -->
			<div class="page-header">
				<div>
					<div class="page-eyebrow">Student · Examinations</div>
					<h1 class="page-title">Available Exams</h1>
					<p class="page-sub">Browse and start your scheduled online
						examinations.</p>
				</div>
				<span class="count-badge"> <i class="bi bi-journal-text"></i>
					<%=totalExams%> exam<%=totalExams != 1 ? "s" : ""%> available
				</span>
			</div>

			<!-- stat cards -->
			<div class="sec-label">Overview</div>
			<div class="stat-row">
				<div class="stat-card sc-1">
					<div class="sc-icon">
						<i class="bi bi-journals"></i>
					</div>
					<div class="sc-label">Total Exams</div>
					<div class="sc-value"><%=totalExams%></div>
				</div>
				<div class="stat-card sc-2">
					<div class="sc-icon">
						<i class="bi bi-hourglass-split"></i>
					</div>
					<div class="sc-label">Upcoming</div>
					<div class="sc-value"><%=upcomingCount%></div>
				</div>
				<div class="stat-card sc-3">
					<div class="sc-icon">
						<i class="bi bi-check-circle-fill"></i>
					</div>
					<div class="sc-label">Past</div>
					<div class="sc-value"><%=pastCount%></div>
				</div>
			</div>

			<div class="dash-divider"></div>

			<!-- exam cards grid -->
			<div class="sec-label">All Examinations</div>
			<div class="exam-grid">

				<%
				if (exams != null && !exams.isEmpty()) {
					for (Exam e : exams) {

						/* determine status */
						String statusClass = "status-upcoming";
						String statusLabel = "Upcoming";
						try {
					java.time.LocalDateTime examDt = java.time.LocalDateTime
							.parse(e.getExamDate().toString().replace(" ", "T"));
					if (examDt.isBefore(now)) {
						statusClass = "status-past";
						statusLabel = "Completed";
					} else if (examDt.isBefore(now.plusHours(1))) {
						statusClass = "status-live";
						statusLabel = "Live Now";
					}
						} catch (Exception ignored) {
						}
				%>

				<div class="exam-card">
					<div class="ec-body">

						<div class="ec-top">
							<div class="ec-icon-box">
								<i class="bi bi-journal-text"></i>
							</div>
							<span class="ec-status <%=statusClass%>"> <span
								class="dot"></span> <%=statusLabel%>
							</span>
						</div>

						<div class="ec-id">
							EXAM #<%=e.getId()%></div>
						<div class="ec-title"><%=e.getTitle()%></div>

						<div class="ec-meta">
							<span class="ec-pill"> <i class="bi bi-calendar3"></i> <%=e.getExamDate()%>
							</span> <span class="ec-pill"> <i class="bi bi-clock-fill"></i> <%=e.getDuration()%>
								min
							</span>
						</div>

					</div>

					<div class="ec-sep"></div>

					<div class="ec-footer">
						<span class="ec-footer-info"> <i class="bi bi-shield-check"
							style="color: var(--green); margin-right: 4px;"></i> Secure ·
							Timed
						</span> <a href="take_exam.jsp?examId=<%=e.getId()%>" class="btn-start">
							<i class="bi bi-play-fill"></i> Start Exam
						</a>
					</div>
				</div>

				<%
				}
				} else {
				%>

				<div class="empty-state">
					<i class="bi bi-journal-x"></i>
					<h4>No exams available</h4>
					<p>There are no scheduled exams at the moment. Check back
						later.</p>
				</div>

				<%
				}
				%>

			</div>
		</main>
	</div>

</body>
</html>
