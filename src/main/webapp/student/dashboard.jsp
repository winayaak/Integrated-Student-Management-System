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
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard — ISMS</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
/* ══════════════════════════════════════
   RESET & TOKENS
══════════════════════════════════════ */
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
	--pink: #f687b3;
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

/* mesh blobs */
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 55% at 5% 0%, rgba(99, 179, 237, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 60% at 98% 8%, rgba(159, 122, 234, 0.08)
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

/* mouse glow */
#mglow {
	position: fixed;
	width: 600px;
	height: 600px;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(99, 179, 237, 0.055) 0%,
		transparent 70%);
	pointer-events: none;
	z-index: 0;
	transform: translate(-50%, -50%);
	transition: left 0.6s ease, top 0.6s ease;
}

/* ══════════════════════════════════════
   LAYOUT
══════════════════════════════════════ */
.layout {
	display: flex;
	min-height: 100vh;
	position: relative;
	z-index: 1;
}

/* ══════════════════════════════════════
   SIDEBAR
══════════════════════════════════════ */
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

/* ══════════════════════════════════════
   MAIN
══════════════════════════════════════ */
.main {
	flex: 1;
	padding: 2.5rem 2rem 5rem;
	overflow-x: hidden;
}

/* ── hero header ── */
.hero {
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 1rem;
	margin-bottom: 2.5rem;
	animation: fadeDown 0.55s ease both;
}

.hero-left {
	
}

.hero-eyebrow {
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

.hero-eyebrow::before {
	content: '';
	display: inline-block;
	width: 16px;
	height: 2px;
	background: var(--blue);
	border-radius: 2px;
}

.hero-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3.5vw, 2.6rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--blue) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.hero-sub {
	margin-top: 0.4rem;
	font-size: 0.875rem;
	color: var(--muted);
	font-weight: 300;
}

.hero-right {
	display: flex;
	align-items: center;
	gap: 1rem;
	flex-wrap: wrap;
}

/* profile badge */
.profile-badge {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 0.5rem 1rem 0.5rem 0.5rem;
	backdrop-filter: blur(12px);
}

.profile-avatar {
	width: 36px;
	height: 36px;
	border-radius: 50%;
	background: linear-gradient(135deg, var(--blue), var(--violet));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.88rem;
	font-weight: 700;
	color: #fff;
	text-transform: uppercase;
	flex-shrink: 0;
	border: 2px solid rgba(99, 179, 237, 0.3);
}

.profile-info {
	
}

.profile-name {
	font-size: 0.82rem;
	font-weight: 500;
	color: var(--text);
	line-height: 1.2;
}

.profile-roll {
	font-size: 0.68rem;
	color: var(--muted);
}

/* live clock */
.hero-clock {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	padding: 0.5rem 1rem;
	backdrop-filter: blur(12px);
	text-align: right;
}

.clock-t {
	font-family: 'Syne', sans-serif;
	font-size: 1.1rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	color: var(--text);
	line-height: 1;
}

.clock-d {
	font-size: 0.68rem;
	color: var(--muted);
	letter-spacing: 0.05em;
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

/* ── overview stat cards ── */
.stat-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(175px, 1fr));
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
	cursor: default;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s, box-shadow 0.25s;
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
	background: var(--sc-a, var(--blue));
	opacity: 0.7;
	transition: opacity 0.2s;
}

.stat-card:hover {
	transform: translateY(-4px);
	border-color: rgba(255, 255, 255, 0.12);
	box-shadow: var(--shadow), var(--sc-glow, none);
}

.stat-card:hover::after {
	opacity: 1;
}

.sc-1 {
	--sc-a: var(--blue);
	--sc-glow: 0 0 24px rgba(99, 179, 237, 0.18);
}

.sc-2 {
	--sc-a: var(--violet);
	--sc-glow: 0 0 24px rgba(159, 122, 234, 0.18);
}

.sc-3 {
	--sc-a: var(--green);
	--sc-glow: 0 0 24px rgba(104, 211, 145, 0.18);
}

.sc-4 {
	--sc-a: var(--amber);
	--sc-glow: 0 0 24px rgba(246, 173, 85, 0.18);
}

.sc-5 {
	--sc-a: var(--red);
	--sc-glow: 0 0 24px rgba(252, 129, 129, 0.18);
}

.sc-6 {
	--sc-a: var(--teal);
	--sc-glow: 0 0 24px rgba(79, 209, 197, 0.18);
}

.sc-icon {
	width: 34px;
	height: 34px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.95rem;
	color: var(--sc-a, var(--blue));
	margin-bottom: 0.85rem;
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
	font-size: 1.65rem;
	font-weight: 800;
	letter-spacing: -0.04em;
	color: var(--text);
	line-height: 1;
}

.sc-value .sc-unit {
	font-size: 0.55em;
	font-weight: 500;
	opacity: 0.6;
}

.sc-trend {
	font-size: 0.72rem;
	color: var(--muted);
	margin-top: 0.35rem;
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
	padding: 1.1rem 1.5rem;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 0.7rem;
	flex-wrap: wrap;
	justify-content: space-between;
}

.gc-header-left {
	display: flex;
	align-items: center;
	gap: 0.7rem;
}

.gc-icon {
	width: 32px;
	height: 32px;
	border-radius: var(--r-sm);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.9rem;
	flex-shrink: 0;
}

.gc-icon.blue {
	background: rgba(99, 179, 237, 0.12);
	border: 1px solid rgba(99, 179, 237, 0.18);
	color: var(--blue);
}

.gc-icon.violet {
	background: rgba(159, 122, 234, 0.12);
	border: 1px solid rgba(159, 122, 234, 0.18);
	color: var(--violet);
}

.gc-icon.green {
	background: rgba(104, 211, 145, 0.12);
	border: 1px solid rgba(104, 211, 145, 0.18);
	color: var(--green);
}

.gc-icon.amber {
	background: rgba(246, 173, 85, 0.12);
	border: 1px solid rgba(246, 173, 85, 0.18);
	color: var(--amber);
}

.gc-icon.teal {
	background: rgba(79, 209, 197, 0.12);
	border: 1px solid rgba(79, 209, 197, 0.18);
	color: var(--teal);
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.9rem;
	font-weight: 700;
	color: var(--text);
	margin: 0;
}

.gc-body {
	padding: 1.5rem;
}

/* ── two-column grid ── */
.two-col {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1.5rem;
}

.three-col {
	display: grid;
	grid-template-columns: 1fr 1fr 1fr;
	gap: 1.5rem;
}

/* ── student info table ── */
.info-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1rem;
}

.info-row {
	display: flex;
	flex-direction: column;
	gap: 0.2rem;
	padding: 0.85rem 1rem;
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
}

.info-key {
	font-size: 0.66rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--muted);
}

.info-val {
	font-size: 0.925rem;
	font-weight: 500;
	color: var(--text);
}

/* ── quick action cards ── */
.action-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(175px, 1fr));
	gap: 0.85rem;
	animation: fadeUp 0.5s 0.1s ease both;
}

.action-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	padding: 1.25rem 1.3rem;
	text-decoration: none;
	color: var(--text);
	backdrop-filter: blur(16px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	gap: 0.45rem;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s, box-shadow 0.25s, background 0.25s;
}

.action-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%,
		transparent 55%);
	pointer-events: none;
}

.action-card::after {
	content: '';
	position: absolute;
	bottom: -25px;
	right: -25px;
	width: 80px;
	height: 80px;
	border-radius: 50%;
	background: var(--ac-c, var(--blue));
	opacity: 0.06;
	filter: blur(18px);
	transition: opacity 0.3s, transform 0.3s;
}

.action-card:hover {
	transform: translateY(-5px);
	background: var(--bg-hover);
	border-color: rgba(255, 255, 255, 0.13);
	box-shadow: var(--shadow), 0 0 30px rgba(0, 0, 0, 0.2);
}

.action-card:hover::after {
	opacity: 0.14;
	transform: scale(1.3);
}

.ac-icon-box {
	width: 38px;
	height: 38px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.05rem;
	color: var(--ac-c, var(--blue));
	transition: transform 0.22s ease;
}

.action-card:hover .ac-icon-box {
	transform: scale(1.1);
}

.ac-title {
	font-family: 'Syne', sans-serif;
	font-size: 0.95rem;
	font-weight: 700;
	color: var(--ac-c, var(--blue));
}

.ac-desc {
	font-size: 0.78rem;
	color: var(--muted);
	font-weight: 300;
	line-height: 1.4;
}

.ac-arrow {
	margin-top: auto;
	padding-top: 0.5rem;
	font-size: 0.75rem;
	color: var(--muted);
	display: flex;
	align-items: center;
	gap: 0.3rem;
	transition: color 0.2s, transform 0.2s;
}

.action-card:hover .ac-arrow {
	color: var(--ac-c, var(--blue));
	transform: translateX(3px);
}

.ac-blue {
	--ac-c: var(--blue);
}

.ac-violet {
	--ac-c: var(--violet);
}

.ac-red {
	--ac-c: var(--red);
}

.ac-green {
	--ac-c: var(--green);
}

.ac-indigo {
	--ac-c: #7f9cf5;
}

.ac-pink {
	--ac-c: var(--pink);
}

.ac-amber {
	--ac-c: var(--amber);
}

.ac-teal {
	--ac-c: var(--teal);
}

/* ── chart wrapper ── */
.chart-container {
	position: relative;
	height: 280px;
}

/* ── progress bars ── */
.progress-item {
	margin-bottom: 1rem;
}

.progress-item:last-child {
	margin-bottom: 0;
}

.progress-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 0.45rem;
}

.progress-label {
	font-size: 0.82rem;
	color: var(--sub);
	font-weight: 400;
}

.progress-pct {
	font-family: 'Syne', sans-serif;
	font-size: 0.8rem;
	font-weight: 700;
	color: var(--text);
}

.progress-track {
	height: 6px;
	border-radius: 3px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
}

.progress-fill {
	height: 100%;
	border-radius: 3px;
	transition: width 1.2s cubic-bezier(.22, .68, 0, 1);
}

/* ── announcements / notices ── */
.notice-list {
	display: flex;
	flex-direction: column;
	gap: 0.75rem;
}

.notice-item {
	display: flex;
	align-items: flex-start;
	gap: 0.85rem;
	padding: 0.9rem 1rem;
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	transition: background 0.18s, border-color 0.18s;
}

.notice-item:hover {
	background: rgba(255, 255, 255, 0.055);
	border-color: rgba(255, 255, 255, 0.13);
}

.notice-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
	flex-shrink: 0;
	margin-top: 5px;
}

.notice-content {
	flex: 1;
}

.notice-title {
	font-size: 0.875rem;
	font-weight: 500;
	color: var(--text);
	margin-bottom: 0.15rem;
}

.notice-meta {
	font-size: 0.72rem;
	color: var(--muted);
}

/* ── semester badge ── */
.sem-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	background: rgba(99, 179, 237, 0.1);
	border: 1px solid rgba(99, 179, 237, 0.2);
	color: var(--blue);
	font-size: 0.75rem;
	font-weight: 500;
	padding: 0.28rem 0.7rem;
	border-radius: 50px;
}

/* ── floating chat btn ── */
.chat-fab {
	position: fixed;
	bottom: 2rem;
	right: 2rem;
	width: 54px;
	height: 54px;
	border-radius: 50%;
	background: linear-gradient(135deg, var(--blue), var(--violet));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.3rem;
	color: #fff;
	text-decoration: none;
	box-shadow: 0 6px 24px rgba(99, 179, 237, 0.4);
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s;
	z-index: 100;
}

.chat-fab:hover {
	transform: translateY(-3px) scale(1.06);
	box-shadow: 0 10px 32px rgba(99, 179, 237, 0.55);
}

/* ── divider ── */
.dash-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 2rem 0;
}

/* ── animations ── */
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

/* ── responsive ── */
@media ( max-width : 1024px) {
	.two-col, .three-col {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 900px) {
	.sidebar {
		display: none;
	}
	.main {
		padding: 1.5rem 1rem 4rem;
	}
}

@media ( max-width : 600px) {
	.stat-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.action-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.hero {
		flex-direction: column;
		align-items: flex-start;
	}
	.info-grid {
		grid-template-columns: 1fr;
	}
}
</style>
</head>

<body>

	<div id="mglow"></div>

	<div class="layout">

		<!-- ═══════════════ SIDEBAR ═══════════════ -->
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

				<li class="nav-item active"><a href="dashboard.jsp"> <span
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
				<li class="nav-item"><a href="exams.jsp"> <span
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

		<!-- ═══════════════ MAIN ═══════════════ -->
		<main class="main">

			<!-- HERO HEADER -->
			<div class="hero">
				<div class="hero-left">
					<div class="hero-eyebrow">Student Dashboard</div>
					<h1 class="hero-title">
						Hello,
						<%=name%>.
					</h1>
					<p class="hero-sub">Here's your academic overview for today.</p>
				</div>
				<div class="hero-right">
					<div class="profile-badge">
						<div class="profile-avatar"><%=name != null && name.length() > 0 ? String.valueOf(name.charAt(0)).toUpperCase() : "S"%></div>
						<div class="profile-info">
							<div class="profile-name"><%=name%></div>
							<div class="profile-roll"><%=roll%></div>
						</div>
					</div>
					<div class="hero-clock">
						<div class="clock-t" id="clock">--:--</div>
						<div class="clock-d" id="clockDate">—</div>
					</div>
				</div>
			</div>

			<!-- OVERVIEW STAT CARDS -->
			<div class="sec-label">Overview</div>
			<div class="stat-grid">

				<div class="stat-card sc-1">
					<div class="sc-icon">
						<i class="bi bi-clipboard2-check-fill"></i>
					</div>
					<div class="sc-label">Attendance</div>
					<div class="sc-value">
						—<span class="sc-unit">%</span>
					</div>
					<div class="sc-trend">This semester</div>
				</div>

				<div class="stat-card sc-2">
					<div class="sc-icon">
						<i class="bi bi-award-fill"></i>
					</div>
					<div class="sc-label">Semester</div>
					<div class="sc-value"><%=semester%><span class="sc-unit">sem</span>
					</div>
					<div class="sc-trend">Current semester</div>
				</div>

				<div class="stat-card sc-3">
					<div class="sc-icon">
						<i class="bi bi-journal-bookmark-fill"></i>
					</div>
					<div class="sc-label">Course ID</div>
					<div class="sc-value" style="font-size: 1.2rem;"><%=course%></div>
					<div class="sc-trend">Enrolled course</div>
				</div>

				<div class="stat-card sc-4">
					<div class="sc-icon">
						<i class="bi bi-cash-stack"></i>
					</div>
					<div class="sc-label">Fees Status</div>
					<div class="sc-value" style="font-size: 1.1rem;">—</div>
					<div class="sc-trend">Check fees portal</div>
				</div>

				<div class="stat-card sc-5">
					<div class="sc-icon">
						<i class="bi bi-briefcase-fill"></i>
					</div>
					<div class="sc-label">Placement</div>
					<div class="sc-value" style="font-size: 1.1rem;">—</div>
					<div class="sc-trend">Applications</div>
				</div>

				<div class="stat-card sc-6">
					<div class="sc-icon">
						<i class="bi bi-bell-fill"></i>
					</div>
					<div class="sc-label">Notices</div>
					<div class="sc-value">3</div>
					<div class="sc-trend">New announcements</div>
				</div>

			</div>

			<div class="dash-divider"></div>

			<!-- QUICK ACTIONS + STUDENT INFO -->
			<div class="two-col"
				style="margin-bottom: 1.5rem; animation: fadeUp 0.5s 0.1s ease both;">

				<!-- Quick Actions -->
				<div>
					<div class="sec-label">Quick Actions</div>
					<div class="action-grid">

						<a href="attendance.jsp" class="action-card ac-blue">
							<div class="ac-icon-box">
								<i class="bi bi-clipboard2-check-fill"></i>
							</div>
							<div class="ac-title">Attendance</div>
							<div class="ac-desc">Your attendance record</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a> <a href="marks.jsp" class="action-card ac-violet">
							<div class="ac-icon-box">
								<i class="bi bi-bar-chart-fill"></i>
							</div>
							<div class="ac-title">Marks</div>
							<div class="ac-desc">Academic performance</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a> <a href="exams.jsp" class="action-card ac-red">
							<div class="ac-icon-box">
								<i class="bi bi-journal-text"></i>
							</div>
							<div class="ac-title">Online Exam</div>
							<div class="ac-desc">Start available exams</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a> <a href="library.jsp" class="action-card ac-green">
							<div class="ac-icon-box">
								<i class="bi bi-book-half"></i>
							</div>
							<div class="ac-title">Library</div>
							<div class="ac-desc">Library services</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a> <a href="hostel.jsp" class="action-card ac-indigo">
							<div class="ac-icon-box">
								<i class="bi bi-building"></i>
							</div>
							<div class="ac-title">Hostel</div>
							<div class="ac-desc">Hostel information</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a> <a href="${pageContext.request.contextPath}/student/placement"
							class="action-card ac-pink">
							<div class="ac-icon-box">
								<i class="bi bi-briefcase-fill"></i>
							</div>
							<div class="ac-title">Placement</div>
							<div class="ac-desc">Opportunities</div>
							<div class="ac-arrow">
								<i class="bi bi-arrow-right"></i> Open
							</div>
						</a>

					</div>
				</div>

				<!-- Student Info -->
				<div>
					<div class="sec-label">Student Profile</div>
					<div class="glass-card">
						<div class="gc-header">
							<div class="gc-header-left">
								<div class="gc-icon blue">
									<i class="bi bi-person-fill"></i>
								</div>
								<h6>Academic Details</h6>
							</div>
							<span class="sem-badge"><i class="bi bi-layers-fill"></i>
								Semester <%=semester%></span>
						</div>
						<div class="gc-body">
							<div class="info-grid">
								<div class="info-row">
									<span class="info-key">Full Name</span> <span class="info-val"><%=name%></span>
								</div>
								<div class="info-row">
									<span class="info-key">Roll No</span> <span class="info-val"><%=roll%></span>
								</div>
								<div class="info-row">
									<span class="info-key">Course ID</span> <span class="info-val"><%=course%></span>
								</div>
								<div class="info-row">
									<span class="info-key">Semester</span> <span class="info-val">Semester
										<%=semester%></span>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>

			<!-- ACADEMIC PERFORMANCE CHART + NOTICES -->
			<div class="two-col" style="animation: fadeUp 0.5s 0.15s ease both;">

				<!-- Performance chart -->
				<div>
					<div class="sec-label">Academic Performance</div>
					<div class="glass-card">
						<div class="gc-header">
							<div class="gc-header-left">
								<div class="gc-icon violet">
									<i class="bi bi-bar-chart-fill"></i>
								</div>
								<h6>Subject-wise Marks</h6>
							</div>
						</div>
						<div class="gc-body">
							<div class="chart-container">
								<canvas id="marksChart"></canvas>
							</div>
						</div>
					</div>
				</div>

				<!-- Notices + Progress -->
				<div style="display: flex; flex-direction: column; gap: 1.5rem;">

					<!-- Progress bars -->
					<div>
						<div class="sec-label">Academic Progress</div>
						<div class="glass-card">
							<div class="gc-header">
								<div class="gc-header-left">
									<div class="gc-icon green">
										<i class="bi bi-graph-up-arrow"></i>
									</div>
									<h6>Subject Progress</h6>
								</div>
							</div>
							<div class="gc-body">
								<div class="progress-item">
									<div class="progress-header">
										<span class="progress-label">Mathematics</span> <span
											class="progress-pct">82%</span>
									</div>
									<div class="progress-track">
										<div class="progress-fill"
											style="width: 0%; background: linear-gradient(90deg, var(--blue), var(--teal));"
											data-w="82%"></div>
									</div>
								</div>
								<div class="progress-item">
									<div class="progress-header">
										<span class="progress-label">Data Structures</span> <span
											class="progress-pct">75%</span>
									</div>
									<div class="progress-track">
										<div class="progress-fill"
											style="width: 0%; background: linear-gradient(90deg, var(--violet), var(--blue));"
											data-w="75%"></div>
									</div>
								</div>
								<div class="progress-item">
									<div class="progress-header">
										<span class="progress-label">Operating Systems</span> <span
											class="progress-pct">68%</span>
									</div>
									<div class="progress-track">
										<div class="progress-fill"
											style="width: 0%; background: linear-gradient(90deg, var(--amber), var(--red));"
											data-w="68%"></div>
									</div>
								</div>
								<div class="progress-item">
									<div class="progress-header">
										<span class="progress-label">Database Systems</span> <span
											class="progress-pct">91%</span>
									</div>
									<div class="progress-track">
										<div class="progress-fill"
											style="width: 0%; background: linear-gradient(90deg, var(--green), var(--teal));"
											data-w="91%"></div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<!-- Notices -->
					<div>
						<div class="sec-label">Announcements</div>
						<div class="glass-card">
							<div class="gc-header">
								<div class="gc-header-left">
									<div class="gc-icon amber">
										<i class="bi bi-megaphone-fill"></i>
									</div>
									<h6>Recent Notices</h6>
								</div>
							</div>
							<div class="gc-body">
								<div class="notice-list">
									<div class="notice-item">
										<div class="notice-dot" style="background: var(--red);"></div>
										<div class="notice-content">
											<div class="notice-title">Mid-Semester Exam Schedule
												Released</div>
											<div class="notice-meta">2 days ago · Academic</div>
										</div>
									</div>
									<div class="notice-item">
										<div class="notice-dot" style="background: var(--green);"></div>
										<div class="notice-content">
											<div class="notice-title">Campus Placement Drive — TCS
												Next Week</div>
											<div class="notice-meta">4 days ago · Placement</div>
										</div>
									</div>
									<div class="notice-item">
										<div class="notice-dot" style="background: var(--blue);"></div>
										<div class="notice-content">
											<div class="notice-title">Library Timings Updated for
												Semester</div>
											<div class="notice-meta">1 week ago · General</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>

		</main>
	</div>

	<!-- floating chat button -->
	<a href="chatbot.jsp" class="chat-fab" title="Open Chatbot"> <i
		class="bi bi-chat-dots-fill"></i>
	</a>

	<!-- ═══════════════ SCRIPTS ═══════════════ -->
	<script>
		/* ── live clock ── */
		function tick() {
			var n = new Date();
			var h = String(n.getHours()).padStart(2, '0');
			var m = String(n.getMinutes()).padStart(2, '0');
			var s = String(n.getSeconds()).padStart(2, '0');
			document.getElementById('clock').textContent = h + ':' + m + ':'
					+ s;
			var days = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ];
			var months = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
					'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ];
			document.getElementById('clockDate').textContent = days[n.getDay()]
					+ ', ' + months[n.getMonth()] + ' ' + n.getDate() + ' '
					+ n.getFullYear();
		}
		tick();
		setInterval(tick, 1000);

		/* ── mouse glow ── */
		var mg = document.getElementById('mglow');
		document.addEventListener('mousemove', function(e) {
			mg.style.left = e.clientX + 'px';
			mg.style.top = e.clientY + 'px';
		});

		/* ── animate progress bars on load ── */
		document.addEventListener('DOMContentLoaded', function() {
			document.querySelectorAll('.progress-fill[data-w]').forEach(
					function(el) {
						setTimeout(function() {
							el.style.width = el.getAttribute('data-w');
						}, 200);
					});
		});

		/* ── marks chart (Chart.js — unchanged data vars) ── */
		const ctx = document.getElementById('marksChart');
		new Chart(ctx, {
			type : 'bar',
			data : {
				labels : [
	<%=subjects%>
		],
				datasets : [ {
					label : 'Marks Obtained',
					data : [
	<%=marks%>
		],
					backgroundColor : [ 'rgba(99,179,237,0.55)',
							'rgba(159,122,234,0.55)', 'rgba(104,211,145,0.55)',
							'rgba(246,173,85,0.55)', 'rgba(252,129,129,0.55)',
							'rgba(79,209,197,0.55)' ],
					borderColor : [ 'rgba(99,179,237,0.9)',
							'rgba(159,122,234,0.9)', 'rgba(104,211,145,0.9)',
							'rgba(246,173,85,0.9)', 'rgba(252,129,129,0.9)',
							'rgba(79,209,197,0.9)' ],
					borderWidth : 1,
					borderRadius : 8,
					borderSkipped : false
				} ]
			},
			options : {
				responsive : true,
				maintainAspectRatio : false,
				plugins : {
					legend : {
						display : false
					},
					tooltip : {
						backgroundColor : 'rgba(14,16,24,0.95)',
						borderColor : 'rgba(255,255,255,0.08)',
						borderWidth : 1,
						titleColor : '#f0f4f8',
						bodyColor : '#a0aec0',
						padding : 10,
						cornerRadius : 8
					}
				},
				scales : {
					x : {
						grid : {
							color : 'rgba(255,255,255,0.04)'
						},
						ticks : {
							color : '#4a5568',
							font : {
								family : 'DM Sans',
								size : 11
							}
						}
					},
					y : {
						beginAtZero : true,
						grid : {
							color : 'rgba(255,255,255,0.05)'
						},
						ticks : {
							color : '#4a5568',
							font : {
								family : 'DM Sans',
								size : 11
							}
						}
					}
				}
			}
		});
	</script>

</body>
</html>
