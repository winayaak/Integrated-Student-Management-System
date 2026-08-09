<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.AttendanceDAO"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
double attendancePct = 0;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		AttendanceDAO attDAO = new AttendanceDAO();
		attendancePct = attDAO.getAttendancePercentage(student.getId());
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Attendance — ISMS</title>

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
	max-width: 1000px;
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
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--blue) 100%);
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

/* ── two col layout ── */
.two-col {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1.5rem;
	margin-bottom: 1.5rem;
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
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.95rem;
	flex-shrink: 0;
}

.gc-icon.blue {
	background: rgba(99, 179, 237, 0.12);
	border: 1px solid rgba(99, 179, 237, 0.18);
	color: var(--blue);
}

.gc-icon.green {
	background: rgba(104, 211, 145, 0.12);
	border: 1px solid rgba(104, 211, 145, 0.18);
	color: var(--green);
}

.gc-icon.violet {
	background: rgba(159, 122, 234, 0.12);
	border: 1px solid rgba(159, 122, 234, 0.18);
	color: var(--violet);
}

.gc-icon.amber {
	background: rgba(246, 173, 85, 0.12);
	border: 1px solid rgba(246, 173, 85, 0.18);
	color: var(--amber);
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text);
	margin: 0;
}

.gc-body {
	padding: 1.8rem;
}

/* ══════════════════════════════════
   ATTENDANCE HERO CARD
══════════════════════════════════ */
.att-hero {
	animation: fadeUp 0.5s 0.05s ease both;
	grid-column: 1/-1; /* full width */
}

.att-hero-body {
	display: flex;
	align-items: center;
	gap: 2.5rem;
	flex-wrap: wrap;
}

/* big percentage */
.att-pct-wrap {
	display: flex;
	flex-direction: column;
	align-items: center;
	flex-shrink: 0;
}

.att-pct-num {
	font-family: 'Syne', sans-serif;
	font-size: 5.5rem;
	font-weight: 800;
	letter-spacing: -0.06em;
	line-height: 1;
}

.att-pct-label {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	color: var(--muted);
	margin-top: 0.35rem;
}

/* ring */
.att-ring-wrap {
	position: relative;
	width: 130px;
	height: 130px;
	flex-shrink: 0;
}

.att-ring-wrap svg {
	transform: rotate(-90deg);
}

.ring-track {
	fill: none;
	stroke: rgba(255, 255, 255, 0.06);
	stroke-width: 9;
}

.ring-fill {
	fill: none;
	stroke-width: 9;
	stroke-linecap: round;
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
	font-size: 1.4rem;
	font-weight: 800;
	letter-spacing: -0.04em;
	color: var(--text);
}

.ring-center-lbl {
	font-size: 0.6rem;
	color: var(--muted);
	letter-spacing: 0.08em;
	text-transform: uppercase;
}

/* info */
.att-info {
	flex: 1;
	min-width: 220px;
}

.att-info-title {
	font-family: 'Syne', sans-serif;
	font-size: 1.1rem;
	font-weight: 700;
	color: var(--text);
	margin-bottom: 0.5rem;
}

.att-info-sub {
	font-size: 0.84rem;
	color: var(--sub);
	font-weight: 300;
	line-height: 1.55;
	margin-bottom: 1rem;
}

/* status chip */
.att-status-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.45rem;
	border-radius: var(--r-sm);
	padding: 0.5rem 1rem;
	font-family: 'Syne', sans-serif;
	font-size: 0.85rem;
	font-weight: 700;
	margin-bottom: 1.1rem;
}

/* threshold bar */
.threshold-section {
	margin-top: 0.5rem;
}

.threshold-row {
	display: flex;
	justify-content: space-between;
	font-size: 0.72rem;
	color: var(--muted);
	margin-bottom: 0.4rem;
}

.threshold-track {
	height: 10px;
	border-radius: 5px;
	background: rgba(255, 255, 255, 0.06);
	overflow: visible;
	position: relative;
}

.threshold-fill {
	height: 100%;
	border-radius: 5px;
	transition: width 1.3s cubic-bezier(.22, .68, 0, 1);
	position: relative;
}
/* 75% threshold marker */
.threshold-marker {
	position: absolute;
	top: -4px;
	bottom: -4px;
	width: 2px;
	background: rgba(246, 173, 85, 0.7);
	border-radius: 2px;
	left: 75%;
}

.threshold-marker::after {
	content: '75%';
	position: absolute;
	top: -18px;
	left: 50%;
	transform: translateX(-50%);
	font-size: 0.6rem;
	color: var(--amber);
	white-space: nowrap;
	font-family: 'DM Sans', sans-serif;
}

/* alert strip */
.att-alert {
	display: flex;
	align-items: flex-start;
	gap: 0.75rem;
	border-radius: var(--r-md);
	padding: 1rem 1.2rem;
	margin-top: 1.5rem;
	font-size: 0.875rem;
}

.att-alert i {
	font-size: 1.05rem;
	flex-shrink: 0;
	margin-top: 1px;
}

.att-alert strong {
	display: block;
	margin-bottom: 0.15rem;
	font-weight: 600;
}

.att-alert-warn {
	background: rgba(246, 173, 85, 0.1);
	border: 1px solid rgba(246, 173, 85, 0.22);
	color: var(--amber);
}

.att-alert-ok {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--green);
}

/* ══════════════════════════════════
   STAT MINI CARDS
══════════════════════════════════ */
.stat-mini-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(155px, 1fr));
	gap: 1rem;
	margin-bottom: 2rem;
	animation: fadeUp 0.5s 0.1s ease both;
}

.stat-mini {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-md);
	padding: 1.1rem 1.2rem;
	backdrop-filter: blur(14px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	transition: transform 0.22s cubic-bezier(.22, .68, 0, 1.2);
	cursor: default;
}

.stat-mini::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	background: var(--sm-c, var(--blue));
	opacity: 0.7;
}

.stat-mini:hover {
	transform: translateY(-3px);
}

.sm-icon {
	width: 30px;
	height: 30px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.85rem;
	color: var(--sm-c, var(--blue));
	margin-bottom: 0.7rem;
}

.sm-label {
	font-size: 0.67rem;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: var(--muted);
	margin-bottom: 0.22rem;
}

.sm-val {
	font-family: 'Syne', sans-serif;
	font-size: 1.45rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	color: var(--text);
}

.smc-1 {
	--sm-c: var(--blue);
}

.smc-2 {
	--sm-c: var(--green);
}

.smc-3 {
	--sm-c: var(--red);
}

.smc-4 {
	--sm-c: var(--amber);
}

/* ══════════════════════════════════
   REQUIREMENT CARD
══════════════════════════════════ */
.req-card {
	animation: fadeUp 0.5s 0.12s ease both;
}

.req-item {
	display: flex;
	align-items: center;
	gap: 0.85rem;
	padding: 0.85rem 0;
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
}

.req-item:last-child {
	border-bottom: none;
}

.req-icon {
	width: 32px;
	height: 32px;
	border-radius: var(--r-sm);
	flex-shrink: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.9rem;
}

.req-label {
	flex: 1;
	font-size: 0.875rem;
	color: var(--sub);
}

.req-val {
	font-family: 'Syne', sans-serif;
	font-size: 0.9rem;
	font-weight: 700;
	color: var(--text);
}

.req-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.28rem;
	border-radius: 50px;
	padding: 0.2rem 0.65rem;
	font-size: 0.72rem;
	font-weight: 600;
}

.chip-dot {
	width: 5px;
	height: 5px;
	border-radius: 50%;
	background: currentColor;
}

.chip-ok {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--green);
}

.chip-warn {
	background: rgba(246, 173, 85, 0.1);
	border: 1px solid rgba(246, 173, 85, 0.22);
	color: var(--amber);
}

.chip-bad {
	background: rgba(252, 129, 129, 0.1);
	border: 1px solid rgba(252, 129, 129, 0.22);
	color: var(--red);
}

/* ══════════════════════════════════
   TIPS CARD
══════════════════════════════════ */
.tips-card {
	animation: fadeUp 0.5s 0.14s ease both;
}

.tip-item {
	display: flex;
	align-items: flex-start;
	gap: 0.75rem;
	padding: 0.75rem 0;
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	font-size: 0.85rem;
	color: var(--sub);
	line-height: 1.5;
}

.tip-item:last-child {
	border-bottom: none;
}

.tip-num {
	width: 22px;
	height: 22px;
	border-radius: 50%;
	flex-shrink: 0;
	background: rgba(99, 179, 237, 0.1);
	border: 1px solid rgba(99, 179, 237, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.68rem;
	font-weight: 800;
	color: var(--blue);
	font-family: 'Syne', sans-serif;
	margin-top: 1px;
}

/* ── not found ── */
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

@media ( max-width : 760px) {
	.two-col {
		grid-template-columns: 1fr;
	}
	.att-hero-body {
		flex-direction: column;
		gap: 1.5rem;
	}
	.att-pct-num {
		font-size: 4rem;
	}
}

@media ( max-width : 540px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.stat-mini-grid {
		grid-template-columns: 1fr 1fr;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.gc-body {
		padding: 1.3rem;
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
				<h1 class="page-title">My Attendance</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<%
		if (student != null) {

			/* ── compute display values in JSP ── */
			double pct = attendancePct;
			boolean isGood = pct >= 75;
			boolean isLow = pct < 75 && pct >= 50;
			boolean isCritical = pct < 50;

			/* ring values — r=52, circumference = 2π×52 */
			double circ = 2 * Math.PI * 52;
			double ringPct = Math.min(100, Math.max(0, pct));

			/* colour tokens */
			String accentColor, gradColor1, gradColor2, chipBg, chipBorder;
			String alertClass, alertIcon, alertTitle, alertMsg;

			if (isGood) {
				accentColor = "#68d391";
				gradColor1 = "#68d391";
				gradColor2 = "#4fd1c5";
				chipBg = "rgba(104,211,145,0.12)";
				chipBorder = "rgba(104,211,145,0.3)";
				alertClass = "att-alert-ok";
				alertIcon = "bi-check-circle-fill";
				alertTitle = "Attendance looks great!";
				alertMsg = "You are meeting the minimum 75% requirement. Keep attending regularly to maintain your eligibility.";
			} else if (isLow) {
				accentColor = "#f6ad55";
				gradColor1 = "#f6ad55";
				gradColor2 = "#ed8936";
				chipBg = "rgba(246,173,85,0.12)";
				chipBorder = "rgba(246,173,85,0.3)";
				alertClass = "att-alert-warn";
				alertIcon = "bi-exclamation-triangle-fill";
				alertTitle = "Attendance below 75%";
				alertMsg = "You may not be eligible for exams. Attend all remaining classes and speak to your faculty immediately.";
			} else {
				accentColor = "#fc8181";
				gradColor1 = "#fc8181";
				gradColor2 = "#e53e3e";
				chipBg = "rgba(252,129,129,0.12)";
				chipBorder = "rgba(252,129,129,0.3)";
				alertClass = "att-alert-warn";
				alertIcon = "bi-x-circle-fill";
				alertTitle = "Critical — Attendance below 50%";
				alertMsg = "Your attendance is critically low. You are at serious risk of being barred from exams. Consult your academic advisor immediately.";
			}

			/* need to attend X more classes to reach 75% — simple heuristic display */
			double needed = 0;
			if (!isGood) {
				/* if currently at pct%, need (0.75 * total - present) more classes */
				/* without total we show a simple delta */
				needed = 75 - pct;
			}
		%>

		<!-- ══ HERO: ATTENDANCE PERCENTAGE ══ -->
		<div class="sec-label">Attendance Overview</div>

		<div
			style="margin-bottom: 1.5rem; animation: fadeUp 0.5s 0.05s ease both;">
			<div class="glass-card att-hero">
				<div class="gc-header">
					<div class="gc-icon blue">
						<i class="bi bi-clipboard2-check-fill"></i>
					</div>
					<h6>Overall Attendance</h6>
				</div>
				<div class="gc-body">
					<div class="att-hero-body">

						<!-- Big number -->
						<div class="att-pct-wrap">
							<div class="att-pct-num" style="color:<%=accentColor%>;">
								<%=String.format("%.1f", attendancePct)%><span
									style="font-size: 0.45em; opacity: 0.7;">%</span>
							</div>
							<div class="att-pct-label">Attendance</div>
						</div>

						<!-- Ring -->
						<div class="att-ring-wrap">
							<svg width="130" height="130" viewBox="0 0 130 130">
              <circle class="ring-track" cx="65" cy="65" r="52" />
              <circle class="ring-fill" cx="65" cy="65" r="52"
									stroke="<%=accentColor%>"
									stroke-dasharray="<%=String.format("%.2f", circ)%>"
									stroke-dashoffset="<%=String.format("%.2f", circ)%>"
									data-pct="<%=String.format("%.4f", ringPct)%>"
									data-circ="<%=String.format("%.4f", circ)%>" id="attRing" />
            </svg>
							<div class="ring-center">
								<div class="ring-center-val"><%=String.format("%.0f", attendancePct)%>%
								</div>
								<div class="ring-center-lbl">Present</div>
							</div>
						</div>

						<!-- Info panel -->
						<div class="att-info">
							<div class="att-info-title">Attendance Standing</div>
							<div class="att-info-sub">
								Your current attendance percentage across all registered
								subjects this semester. Minimum required: <strong
									style="color: var(--amber);">75%</strong>
							</div>

							<span class="att-status-chip"
								style="background:<%=chipBg%>;border:1px solid <%=chipBorder%>;color:<%=accentColor%>;">
								<i
								class="bi bi-<%=isGood ? "check-circle-fill" : (isCritical ? "x-circle-fill" : "exclamation-triangle-fill")%>"></i>
								<%=isGood ? "Eligible for Exams" : (isCritical ? "Critical — Action Required" : "Below Minimum — At Risk")%>
							</span>

							<div class="threshold-section">
								<div class="threshold-row">
									<span>Your attendance</span> <span><%=String.format("%.1f", attendancePct)%>%</span>
								</div>
								<div class="threshold-track">
									<div class="threshold-fill" id="attBar"
										data-w="<%=String.format("%.2f", Math.min(100, attendancePct))%>%"
										style="width:0%;background:linear-gradient(90deg,<%=gradColor1%>,<%=gradColor2%>);"></div>
									<div class="threshold-marker"></div>
								</div>
							</div>
						</div>

					</div>

					<!-- Alert strip -->
					<%
					if (attendancePct < 75) {
					%>
					<div class="att-alert <%=alertClass%>">
						<i class="bi <%=alertIcon%>"></i>
						<div>
							<strong><%=alertTitle%></strong><%=alertMsg%></div>
					</div>
					<%
					} else {
					%>
					<div class="att-alert <%=alertClass%>">
						<i class="bi <%=alertIcon%>"></i>
						<div>
							<strong><%=alertTitle%></strong><%=alertMsg%></div>
					</div>
					<%
					}
					%>

				</div>
			</div>
		</div>

		<!-- ══ STAT MINI CARDS ══ -->
		<div class="dash-divider"></div>
		<div class="sec-label">Breakdown</div>
		<div class="stat-mini-grid">

			<div class="stat-mini smc-1">
				<div class="sm-icon">
					<i class="bi bi-percent"></i>
				</div>
				<div class="sm-label">Current %</div>
				<div class="sm-val"><%=String.format("%.1f", attendancePct)%></div>
			</div>

			<div class="stat-mini smc-2">
				<div class="sm-icon">
					<i class="bi bi-check-circle-fill"></i>
				</div>
				<div class="sm-label">Required %</div>
				<div class="sm-val">75.0</div>
			</div>

			<div class="stat-mini smc-3">
				<div class="sm-icon">
					<i class="bi bi-graph-down-arrow"></i>
				</div>
				<div class="sm-label">Deficit</div>
				<div class="sm-val"><%=isGood ? "0.0" : String.format("%.1f", 75 - attendancePct)%></div>
			</div>

			<div class="stat-mini smc-4">
				<div class="sm-icon">
					<i class="bi bi-shield-check"></i>
				</div>
				<div class="sm-label">Status</div>
				<div class="sm-val" style="font-size:1rem;color:<%=accentColor%>;"><%=isGood ? "Safe" : (isCritical ? "Critical" : "At Risk")%></div>
			</div>

		</div>

		<!-- ══ REQUIREMENTS + TIPS ══ -->
		<div class="two-col">

			<!-- Requirements card -->
			<div class="req-card">
				<div class="sec-label">Eligibility Criteria</div>
				<div class="glass-card">
					<div class="gc-header">
						<div class="gc-icon green">
							<i class="bi bi-shield-check"></i>
						</div>
						<h6>Exam Eligibility Rules</h6>
					</div>
					<div class="gc-body" style="padding: 1.2rem 1.5rem;">

						<div class="req-item">
							<div class="req-icon"
								style="background: rgba(99, 179, 237, 0.1); color: var(--blue);">
								<i class="bi bi-clipboard2-check"></i>
							</div>
							<div class="req-label">Minimum required attendance</div>
							<div class="req-val">75%</div>
						</div>

						<div class="req-item">
							<div class="req-icon"
								style="background: rgba(246, 173, 85, 0.1); color: var(--amber);">
								<i class="bi bi-exclamation-circle"></i>
							</div>
							<div class="req-label">Condonation possible below</div>
							<div class="req-val">65%</div>
						</div>

						<div class="req-item">
							<div class="req-icon"
								style="background: rgba(252, 129, 129, 0.1); color: var(--red);">
								<i class="bi bi-x-circle"></i>
							</div>
							<div class="req-label">Barred from exams below</div>
							<div class="req-val">65%</div>
						</div>

						<div class="req-item">
							<div class="req-icon"
								style="background: rgba(104, 211, 145, 0.1); color: var(--green);">
								<i class="bi bi-person-check"></i>
							</div>
							<div class="req-label">Your current status</div>
							<span
								class="req-chip <%=isGood ? "chip-ok" : (isCritical ? "chip-bad" : "chip-warn")%>">
								<span class="chip-dot"></span> <%=isGood ? "Eligible" : (isCritical ? "Barred Risk" : "Condonation")%>
							</span>
						</div>

					</div>
				</div>
			</div>

			<!-- Tips card -->
			<div class="tips-card">
				<div class="sec-label">Improvement Tips</div>
				<div class="glass-card">
					<div class="gc-header">
						<div class="gc-icon violet">
							<i class="bi bi-lightbulb-fill"></i>
						</div>
						<h6>How to Improve</h6>
					</div>
					<div class="gc-body" style="padding: 1.2rem 1.5rem;">

						<div class="tip-item">
							<div class="tip-num">1</div>
							Attend every scheduled lecture and lab session without
							exceptions.
						</div>
						<div class="tip-item">
							<div class="tip-num">2</div>
							If absent due to illness, submit a medical certificate to the
							faculty on the same day.
						</div>
						<div class="tip-item">
							<div class="tip-num">3</div>
							Speak to your class coordinator about possible condonation if
							below 75%.
						</div>
						<div class="tip-item">
							<div class="tip-num">4</div>
							Track your attendance weekly so small deficits don't become large
							ones.
						</div>
						<div class="tip-item">
							<div class="tip-num">5</div>
							Avoid proxy or bunking — it risks your entire academic year
							eligibility.
						</div>

					</div>
				</div>
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
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {

							/* ── ring animation ── */
							var ring = document.getElementById('attRing');
							if (ring) {
								var circ = parseFloat(ring
										.getAttribute('data-circ')
										|| '0');
								var pctVal = parseFloat(ring
										.getAttribute('data-pct')
										|| '0');
								var offset = circ - (pctVal / 100) * circ;
								ring.style.strokeDashoffset = circ;
								setTimeout(
										function() {
											ring.style.transition = 'stroke-dashoffset 1.3s cubic-bezier(.22,.68,0,1)';
											ring.style.strokeDashoffset = offset;
										}, 150);
							}

							/* ── bar animation ── */
							var bar = document.getElementById('attBar');
							if (bar) {
								var targetW = bar.getAttribute('data-w')
										|| '0%';
								setTimeout(function() {
									bar.style.width = targetW;
								}, 200);
							}

						});
	</script>

</body>
</html>
