<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.MarksDAO"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
double cgpa = 0;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		MarksDAO marksDAO = new MarksDAO();
		cgpa = marksDAO.getOverallCGPA(student.getId());
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Marks — ISMS</title>

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
	--bg: #08090d;
	--bg-card: rgba(255, 255, 255, 0.04);
	--bg-hover: rgba(255, 255, 255, 0.07);
	--border: rgba(255, 255, 255, 0.08);
	--blue: #63b3ed;
	--violet: #9f7aea;
	--green: #68d391;
	--amber: #f6ad55;
	--red: #fc8181;
	--teal: #4fd1c5;
	--text: #f0f4f8;
	--sub: #a0aec0;
	--muted: #4a5568;
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

.page-wrap {
	position: relative;
	z-index: 1;
	max-width: 820px;
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
	margin-bottom: 2.5rem;
	animation: fadeDown 0.5s ease both;
}

.page-eyebrow {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--violet);
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
	background: var(--violet);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--violet) 100%);
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
	border-radius: var(--r-sm);
	color: var(--sub);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	font-weight: 500;
	padding: 0.45rem 1rem;
	text-decoration: none;
	backdrop-filter: blur(10px);
	transition: background 0.2s, color 0.2s, transform 0.18s;
}

.back-btn:hover {
	background: var(--bg-hover);
	color: var(--text);
	transform: translateX(-2px);
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

/* ── glass card ── */
.glass-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	margin-bottom: 1.5rem;
	animation: fadeUp 0.5s 0.06s ease both;
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
	border-radius: var(--r-sm);
	background: rgba(159, 122, 234, 0.12);
	border: 1px solid rgba(159, 122, 234, 0.18);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--violet);
	font-size: 0.95rem;
	flex-shrink: 0;
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text);
	margin: 0;
}

.gc-body {
	padding: 2rem 1.8rem;
}

/* ── CGPA display ── */
.cgpa-section {
	display: flex;
	align-items: center;
	gap: 2.5rem;
	flex-wrap: wrap;
}

/* big score */
.cgpa-score-wrap {
	display: flex;
	flex-direction: column;
	align-items: center;
	flex-shrink: 0;
}

.cgpa-number {
	font-family: 'Syne', sans-serif;
	font-size: 5rem;
	font-weight: 800;
	letter-spacing: -0.06em;
	line-height: 1;
	background: linear-gradient(135deg, var(--violet), var(--blue));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.cgpa-label {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: var(--muted);
	margin-top: 0.35rem;
}

.cgpa-out-of {
	font-size: 0.82rem;
	color: var(--muted);
	margin-top: 0.15rem;
}

/* ring progress */
.cgpa-ring-wrap {
	position: relative;
	width: 120px;
	height: 120px;
	flex-shrink: 0;
}

.cgpa-ring-wrap svg {
	transform: rotate(-90deg);
}

.ring-track {
	fill: none;
	stroke: rgba(255, 255, 255, 0.06);
	stroke-width: 8;
}

.ring-fill {
	fill: none;
	stroke-width: 8;
	stroke-linecap: round;
	transition: stroke-dashoffset 1.2s ease;
}

.ring-center {
	position: absolute;
	inset: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
}

.ring-center-val {
	font-family: 'Syne', sans-serif;
	font-size: 1.35rem;
	font-weight: 800;
	letter-spacing: -0.04em;
	color: var(--text);
}

.ring-center-label {
	font-size: 0.6rem;
	color: var(--muted);
	letter-spacing: 0.08em;
	text-transform: uppercase;
}

/* info right side */
.cgpa-info {
	flex: 1;
	min-width: 200px;
}

.cgpa-info-title {
	font-family: 'Syne', sans-serif;
	font-size: 1.1rem;
	font-weight: 700;
	color: var(--text);
	margin-bottom: 0.5rem;
}

.cgpa-info-sub {
	font-size: 0.84rem;
	color: var(--sub);
	font-weight: 300;
	line-height: 1.55;
	margin-bottom: 1.1rem;
}

/* grade chip */
.grade-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	border-radius: var(--r-sm);
	padding: 0.45rem 1rem;
	font-family: 'Syne', sans-serif;
	font-size: 0.85rem;
	font-weight: 700;
}

/* performance bar */
.perf-bar-section {
	margin-top: 1.2rem;
}

.perf-bar-label {
	display: flex;
	justify-content: space-between;
	font-size: 0.72rem;
	color: var(--muted);
	margin-bottom: 0.4rem;
}

.perf-bar-track {
	height: 8px;
	border-radius: 4px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
}

.perf-bar-fill {
	height: 100%;
	border-radius: 4px;
	transition: width 1.2s cubic-bezier(.22, .68, 0, 1);
}

/* ── alert strip ── */
.alert-strip {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	border-radius: var(--r-md);
	padding: 1rem 1.2rem;
	margin-top: 1.4rem;
	font-size: 0.875rem;
	font-weight: 400;
}

.alert-strip i {
	font-size: 1.1rem;
	flex-shrink: 0;
}

.alert-danger-dark {
	background: rgba(252, 129, 129, 0.1);
	border: 1px solid rgba(252, 129, 129, 0.22);
	color: var(--red);
}

.alert-success-dark {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--green);
}

/* ── grade scale card ── */
.grade-scale {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
	gap: 0.6rem;
	animation: fadeUp 0.5s 0.12s ease both;
}

.grade-scale-item {
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	padding: 0.7rem 0.85rem;
	display: flex;
	flex-direction: column;
	gap: 0.2rem;
	transition: background 0.18s;
}

.grade-scale-item:hover {
	background: rgba(255, 255, 255, 0.055);
}

.gs-range {
	font-size: 0.68rem;
	color: var(--muted);
	text-transform: uppercase;
	letter-spacing: 0.06em;
}

.gs-grade {
	font-family: 'Syne', sans-serif;
	font-size: 1.1rem;
	font-weight: 800;
	letter-spacing: -0.02em;
}

.gs-desc {
	font-size: 0.72rem;
	color: var(--sub);
}

/* not found */
.not-found-card {
	background: rgba(252, 129, 129, 0.08);
	border: 1px solid rgba(252, 129, 129, 0.2);
	border-radius: var(--r-md);
	padding: 1.2rem 1.4rem;
	display: flex;
	align-items: center;
	gap: 0.75rem;
	font-size: 0.875rem;
	color: var(--red);
	animation: fadeUp 0.5s ease both;
}

/* divider */
.dash-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 2rem 0;
}

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

@media ( max-width : 560px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.cgpa-section {
		flex-direction: column;
		gap: 1.5rem;
	}
	.cgpa-number {
		font-size: 3.8rem;
	}
	.gc-body {
		padding: 1.4rem 1.2rem;
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
				<div class="page-eyebrow">Student · Academics</div>
				<h1 class="page-title">My Marks</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<%
		if (student != null) {

			/* compute grade info */
			String gradeLabel, gradeDesc;
			String gradeColor, gradeBg, gradeBorder;
			String barColor;
			double pct = (cgpa / 10.0) * 100;

			if (cgpa >= 9.0) {
				gradeLabel = "O";
				gradeDesc = "Outstanding";
				gradeColor = "#68d391";
				gradeBg = "rgba(104,211,145,0.12)";
				gradeBorder = "rgba(104,211,145,0.3)";
				barColor = "linear-gradient(90deg,#68d391,#4fd1c5)";
			} else if (cgpa >= 8.0) {
				gradeLabel = "A+";
				gradeDesc = "Excellent";
				gradeColor = "#63b3ed";
				gradeBg = "rgba(99,179,237,0.12)";
				gradeBorder = "rgba(99,179,237,0.3)";
				barColor = "linear-gradient(90deg,#63b3ed,#4fd1c5)";
			} else if (cgpa >= 7.0) {
				gradeLabel = "A";
				gradeDesc = "Very Good";
				gradeColor = "#63b3ed";
				gradeBg = "rgba(99,179,237,0.10)";
				gradeBorder = "rgba(99,179,237,0.25)";
				barColor = "linear-gradient(90deg,#4299e1,#63b3ed)";
			} else if (cgpa >= 6.0) {
				gradeLabel = "B+";
				gradeDesc = "Good";
				gradeColor = "#9f7aea";
				gradeBg = "rgba(159,122,234,0.12)";
				gradeBorder = "rgba(159,122,234,0.3)";
				barColor = "linear-gradient(90deg,#9f7aea,#63b3ed)";
			} else if (cgpa >= 5.0) {
				gradeLabel = "B";
				gradeDesc = "Average";
				gradeColor = "#f6ad55";
				gradeBg = "rgba(246,173,85,0.12)";
				gradeBorder = "rgba(246,173,85,0.3)";
				barColor = "linear-gradient(90deg,#f6ad55,#ed8936)";
			} else if (cgpa >= 4.0) {
				gradeLabel = "C";
				gradeDesc = "Pass";
				gradeColor = "#f6ad55";
				gradeBg = "rgba(246,173,85,0.10)";
				gradeBorder = "rgba(246,173,85,0.22)";
				barColor = "linear-gradient(90deg,#ed8936,#dd6b20)";
			} else {
				gradeLabel = "F";
				gradeDesc = "Fail";
				gradeColor = "#fc8181";
				gradeBg = "rgba(252,129,129,0.12)";
				gradeBorder = "rgba(252,129,129,0.3)";
				barColor = "linear-gradient(90deg,#fc8181,#e53e3e)";
			}

			/* ring circumference for r=46 */
			double circ = 2 * Math.PI * 46;
			double offset = circ - (pct / 100.0) * circ;

			/* ring stroke color */
			String ringColor = gradeColor;
		%>

		<!-- CGPA CARD -->
		<div class="sec-label">Overall Performance</div>

		<div class="glass-card">
			<div class="gc-header">
				<div class="gc-icon">
					<i class="bi bi-award-fill"></i>
				</div>
				<h6>Cumulative Grade Point Average</h6>
			</div>
			<div class="gc-body">

				<div class="cgpa-section">

					<!-- Big number -->
					<div class="cgpa-score-wrap">
						<div class="cgpa-number"><%=String.format("%.2f", cgpa)%></div>
						<div class="cgpa-label">CGPA</div>
						<div class="cgpa-out-of">out of 10.0</div>
					</div>

					<!-- Ring chart -->
					<div class="cgpa-ring-wrap">
						<svg width="120" height="120" viewBox="0 0 120 120">
            <circle class="ring-track" cx="60" cy="60" r="46" />
            <circle class="ring-fill" cx="60" cy="60" r="46"
								stroke="<%=ringColor%>"
								stroke-dasharray="<%=String.format("%.2f", circ)%>"
								stroke-dashoffset="<%=String.format("%.2f", circ)%>"
								data-pct="<%=String.format("%.2f", pct)%>" id="cgpaRing" />
          </svg>
						<div class="ring-center">
							<div class="ring-center-val"><%=String.format("%.1f", cgpa)%></div>
							<div class="ring-center-label">GPA</div>
						</div>
					</div>

					<!-- Info -->
					<div class="cgpa-info">
						<div class="cgpa-info-title">Academic Standing</div>
						<div class="cgpa-info-sub">Your current CGPA reflects your
							cumulative performance across all completed semesters and
							subjects.</div>

						<span class="grade-chip"
							style="background:<%=gradeBg%>;border:1px solid <%=gradeBorder%>;color:<%=gradeColor%>;">
							<i class="bi bi-patch-check-fill" style="font-size: 0.85rem;"></i>
							Grade <%=gradeLabel%> &nbsp;·&nbsp; <%=gradeDesc%>
						</span>

						<div class="perf-bar-section">
							<div class="perf-bar-label">
								<span>Score</span> <span><%=String.format("%.1f", pct)%>%</span>
							</div>
							<div class="perf-bar-track">
								<div class="perf-bar-fill" id="perfBar"
									data-w="<%=String.format("%.1f", pct)%>%"
									style="width:0%; background:<%=barColor%>;"></div>
							</div>
						</div>
					</div>

				</div>

				<!-- alert strip -->
				<%
				if (cgpa < 5) {
				%>
				<div class="alert-strip alert-danger-dark">
					<i class="bi bi-exclamation-triangle-fill"></i> <span>Your
						CGPA is below 5.0. Immediate academic improvement is required.
						Consider speaking with your academic advisor.</span>
				</div>
				<%
				} else {
				%>
				<div class="alert-strip alert-success-dark">
					<i class="bi bi-check-circle-fill"></i> <span>Good academic
						performance. Keep maintaining your grades for a strong academic
						record.</span>
				</div>
				<%
				}
				%>

			</div>
		</div>

		<!-- GRADE SCALE REFERENCE -->
		<div class="dash-divider"></div>
		<div class="sec-label">Grade Scale Reference</div>

		<div class="grade-scale">
			<div class="grade-scale-item">
				<div class="gs-range">9.0 – 10.0</div>
				<div class="gs-grade" style="color: #68d391;">O</div>
				<div class="gs-desc">Outstanding</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">8.0 – 8.9</div>
				<div class="gs-grade" style="color: #63b3ed;">A+</div>
				<div class="gs-desc">Excellent</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">7.0 – 7.9</div>
				<div class="gs-grade" style="color: #63b3ed;">A</div>
				<div class="gs-desc">Very Good</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">6.0 – 6.9</div>
				<div class="gs-grade" style="color: #9f7aea;">B+</div>
				<div class="gs-desc">Good</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">5.0 – 5.9</div>
				<div class="gs-grade" style="color: #f6ad55;">B</div>
				<div class="gs-desc">Average</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">4.0 – 4.9</div>
				<div class="gs-grade" style="color: #f6ad55;">C</div>
				<div class="gs-desc">Pass</div>
			</div>
			<div class="grade-scale-item">
				<div class="gs-range">Below 4.0</div>
				<div class="gs-grade" style="color: #fc8181;">F</div>
				<div class="gs-desc">Fail</div>
			</div>
		</div>

		<%
		} else {
		%>

		<div class="not-found-card">
			<i class="bi bi-exclamation-triangle-fill"></i> Student profile not
			found. Please contact the administration.
		</div>

		<%
		}
		%>

	</div>

	<script>
		/* ── animate ring and bar on load ──
		 Values are read from the DOM (data attributes) so Java scope is not needed
		 ── */
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {

							/* ── RING ── */
							var ring = document.getElementById('cgpaRing');
							if (ring) {
								var circ = parseFloat(ring
										.getAttribute('stroke-dasharray')
										|| '0');
								var targetPct = parseFloat(ring
										.getAttribute('data-pct')
										|| '0');
								var targetOff = circ - (targetPct / 100) * circ;
								/* start fully hidden (dashoffset = circ), then animate to target */
								ring.style.strokeDashoffset = circ;
								setTimeout(
										function() {
											ring.style.transition = 'stroke-dashoffset 1.3s cubic-bezier(.22,.68,0,1)';
											ring.style.strokeDashoffset = targetOff;
										}, 120);
							}

							/* ── BAR ── */
							var bar = document.getElementById('perfBar');
							if (bar) {
								var targetWidth = bar.getAttribute('data-w')
										|| '0%';
								setTimeout(function() {
									bar.style.width = targetWidth;
								}, 180);
							}

						});
	</script>

</body>
</html>
