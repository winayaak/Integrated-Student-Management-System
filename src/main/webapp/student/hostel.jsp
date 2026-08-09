<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.HostelDAO"%>
<%@ page import="java.util.List"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
List<HostelDAO.HostelAllocation> hostel = null;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		HostelDAO hostelDAO = new HostelDAO();
		hostel = hostelDAO.getByStudent(student.getId());
	}
}

String block = "A";
String roomNo = "101";
String allocDate = "—";
boolean hasHostel = (hostel != null && !hostel.isEmpty());
if (hasHostel) {
	HostelDAO.HostelAllocation first = hostel.get(0);
	if (first.getBlock() != null)
		block = first.getBlock();
	if (first.getRoomNo() != null)
		roomNo = first.getRoomNo();
	if (first.getAllocatedDate() != null)
		allocDate = first.getAllocatedDate().toString();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hostel — ISMS</title>

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
	max-width: 1100px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 5rem;
}

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
	color: var(--teal);
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
	background: var(--teal);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--teal) 100%);
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

.sec-label {
	font-size: 0.68rem;
	font-weight: 500;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--muted);
	margin-bottom: 0.85rem;
}

/* ══ CINEMA ══ */
.cinema-wrap {
	position: relative;
	width: 100%;
	height: 520px;
	border-radius: var(--r-lg);
	border: 1px solid rgba(79, 209, 197, 0.15);
	overflow: hidden;
	box-shadow: var(--shadow), 0 0 80px rgba(79, 209, 197, 0.07);
	margin-bottom: 2rem;
	animation: fadeUp 0.6s 0.08s ease both;
	background: #04080e;
}

#hostelCanvas {
	width: 100%;
	height: 100%;
	display: block;
}

.cinema-caption {
	position: absolute;
	bottom: 20px;
	left: 50%;
	transform: translateX(-50%);
	background: rgba(4, 8, 16, 0.88);
	border: 1px solid rgba(79, 209, 197, 0.25);
	border-radius: 50px;
	backdrop-filter: blur(16px);
	padding: 0.5rem 1.6rem;
	font-size: 0.82rem;
	color: var(--sub);
	white-space: nowrap;
	z-index: 10;
	transition: opacity 0.4s;
	font-family: 'DM Sans', sans-serif;
}

.cinema-caption strong {
	color: var(--teal);
}

.stage-controls {
	position: absolute;
	top: 1rem;
	right: 1rem;
	display: flex;
	gap: 0.5rem;
	z-index: 10;
}

.ctrl-btn {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: rgba(255, 255, 255, 0.07);
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 50px;
	padding: 0.38rem 0.95rem;
	font-size: 0.72rem;
	color: var(--sub);
	cursor: pointer;
	backdrop-filter: blur(8px);
	font-family: 'DM Sans', sans-serif;
	transition: background 0.2s, color 0.2s;
}

.ctrl-btn:hover {
	background: rgba(255, 255, 255, 0.13);
	color: var(--text);
}

.phase-indicator {
	position: absolute;
	top: 1.1rem;
	left: 1.1rem;
	display: flex;
	gap: 0.45rem;
	z-index: 10;
	align-items: center;
}

.phase-dot {
	width: 7px;
	height: 7px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.12);
	transition: background 0.4s, transform 0.4s, box-shadow 0.4s;
}

.phase-dot.active {
	background: var(--teal);
	transform: scale(1.5);
	box-shadow: 0 0 8px rgba(79, 209, 197, 0.7);
}

.phase-label {
	font-size: 0.68rem;
	color: var(--muted);
	font-family: 'DM Sans', sans-serif;
	letter-spacing: 0.06em;
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
	animation: fadeUp 0.5s 0.15s ease both;
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
	background: rgba(79, 209, 197, 0.12);
	border: 1px solid rgba(79, 209, 197, 0.18);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--teal);
	font-size: 0.95rem;
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text);
	margin: 0;
}

.allot-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
	gap: 1rem;
	margin-bottom: 1.5rem;
}

.allot-card {
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--r-md);
	padding: 1.2rem 1.3rem;
	display: flex;
	flex-direction: column;
	gap: 0.4rem;
	position: relative;
	overflow: hidden;
	transition: background 0.2s, transform 0.22s;
}

.allot-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	background: var(--ac-c, var(--teal));
	border-radius: 2px 2px 0 0;
	opacity: 0.75;
}

.allot-card:hover {
	background: rgba(255, 255, 255, 0.055);
	transform: translateY(-2px);
}

.allot-card .ac-icon {
	width: 30px;
	height: 30px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.85rem;
	color: var(--ac-c, var(--teal));
	margin-bottom: 0.25rem;
}

.allot-card .ac-label {
	font-size: 0.67rem;
	text-transform: uppercase;
	letter-spacing: 0.1em;
	color: var(--muted);
}

.allot-card .ac-val {
	font-family: 'Syne', sans-serif;
	font-size: 1.4rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	color: var(--text);
}

.allot-card.c-block {
	--ac-c: var(--teal);
}

.allot-card.c-room {
	--ac-c: var(--blue);
}

.allot-card.c-date {
	--ac-c: var(--violet);
}

.allot-card.c-status {
	--ac-c: var(--green);
}

.hostel-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 0.875rem;
}

.hostel-table thead tr {
	background: rgba(255, 255, 255, 0.04);
}

.hostel-table thead th {
	padding: 0.85rem 1rem;
	font-size: 0.67rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--muted);
	border-bottom: 1px solid var(--border);
	text-align: left;
}

.hostel-table thead th:first-child {
	padding-left: 1.4rem;
}

.hostel-table thead th:last-child {
	padding-right: 1.4rem;
}

.hostel-table tbody tr {
	border-bottom: 1px solid rgba(255, 255, 255, 0.04);
	transition: background 0.18s;
}

.hostel-table tbody tr:last-child {
	border-bottom: none;
}

.hostel-table tbody tr:hover {
	background: rgba(255, 255, 255, 0.03);
}

.hostel-table tbody td {
	padding: 0.85rem 1rem;
	vertical-align: middle;
	color: var(--sub);
}

.hostel-table tbody td:first-child {
	padding-left: 1.4rem;
}

.hostel-table tbody td:last-child {
	padding-right: 1.4rem;
}

.block-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.3rem;
	background: rgba(79, 209, 197, 0.1);
	border: 1px solid rgba(79, 209, 197, 0.22);
	border-radius: 50px;
	padding: 0.2rem 0.7rem;
	font-size: 0.78rem;
	font-weight: 600;
	color: var(--teal);
	font-family: 'Syne', sans-serif;
}

.room-badge {
	display: inline-flex;
	align-items: center;
	background: rgba(99, 179, 237, 0.1);
	border: 1px solid rgba(99, 179, 237, 0.22);
	border-radius: 6px;
	padding: 0.2rem 0.6rem;
	font-size: 0.78rem;
	font-weight: 700;
	color: var(--blue);
	font-family: 'Syne', monospace;
	letter-spacing: 0.04em;
}

.status-ok {
	display: inline-flex;
	align-items: center;
	gap: 0.28rem;
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	border-radius: 50px;
	padding: 0.2rem 0.65rem;
	font-size: 0.73rem;
	font-weight: 600;
	color: var(--green);
}

.status-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: currentColor;
}

.empty-state {
	text-align: center;
	padding: 3rem 1rem;
	color: var(--muted);
}

.empty-state i {
	font-size: 2.5rem;
	opacity: 0.25;
	display: block;
	margin-bottom: 0.75rem;
}

.empty-state p {
	font-size: 0.88rem;
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

@media ( max-width : 640px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.allot-grid {
		grid-template-columns: 1fr 1fr;
	}
	.cinema-wrap {
		height: 380px;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.cinema-caption {
		font-size: 0.72rem;
		padding: 0.4rem 1rem;
		white-space: normal;
		text-align: center;
		max-width: 90%;
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
				<div class="page-eyebrow">Student · Accommodation</div>
				<h1 class="page-title">My Hostel</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<!-- ANIMATION STAGE -->
		<div class="sec-label">Your Room — Interactive 3D View</div>
		<div class="cinema-wrap">
			<canvas id="hostelCanvas"></canvas>

			<div class="stage-controls">
				<div class="ctrl-btn" onclick="window.hostelReplay()">
					<i class="bi bi-arrow-clockwise"></i> Replay
				</div>
			</div>

			<div class="phase-indicator">
				<div class="phase-dot active" id="pd0"></div>
				<div class="phase-dot" id="pd1"></div>
				<div class="phase-dot" id="pd2"></div>
				<div class="phase-dot" id="pd3"></div>
				<span class="phase-label" id="phaseLabel">360° Scan</span>
			</div>

			<div class="cinema-caption" id="cinCaption">Initialising 3D
				view…</div>
		</div>

		<!-- ALLOTMENT -->
		<div class="dash-divider"></div>
		<div class="sec-label">Allotment Summary</div>

		<%
		if (hasHostel) {
		%>
		<div class="allot-grid">
			<div class="allot-card c-block">
				<div class="ac-icon">
					<i class="bi bi-building"></i>
				</div>
				<div class="ac-label">Block</div>
				<div class="ac-val"><%=block%></div>
			</div>
			<div class="allot-card c-room">
				<div class="ac-icon">
					<i class="bi bi-door-open-fill"></i>
				</div>
				<div class="ac-label">Room No</div>
				<div class="ac-val"><%=roomNo%></div>
			</div>
			<div class="allot-card c-date">
				<div class="ac-icon">
					<i class="bi bi-calendar3"></i>
				</div>
				<div class="ac-label">Since</div>
				<div class="ac-val" style="font-size: 1rem;"><%=allocDate%></div>
			</div>
			<div class="allot-card c-status">
				<div class="ac-icon">
					<i class="bi bi-check-circle-fill"></i>
				</div>
				<div class="ac-label">Status</div>
				<div class="ac-val" style="font-size: 1rem; color: var(--green);">Active</div>
			</div>
		</div>

		<div class="glass-card">
			<div class="gc-header">
				<div class="gc-icon">
					<i class="bi bi-building"></i>
				</div>
				<h6>Hostel Allocation Details</h6>
			</div>
			<div style="padding: 0;">
				<table class="hostel-table">
					<thead>
						<tr>
							<th>Block</th>
							<th>Room No</th>
							<th>Allocated Date</th>
							<th>Status</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (HostelDAO.HostelAllocation h : hostel) {
						%>
						<tr>
							<td><span class="block-badge"><i
									class="bi bi-building" style="font-size: 0.7rem;"></i> Block <%=h.getBlock()%></span></td>
							<td><span class="room-badge">Room <%=h.getRoomNo()%></span></td>
							<td style="font-size: 0.82rem; color: var(--muted);"><i
								class="bi bi-calendar3" style="margin-right: 5px; opacity: 0.5;"></i><%=h.getAllocatedDate()%></td>
							<td><span class="status-ok"><span class="status-dot"></span>
									Active</span></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>
		<%
		} else {
		%>
		<div class="glass-card">
			<div style="padding: 1.6rem;">
				<div class="empty-state">
					<i class="bi bi-building-x"></i>
					<p>No hostel allotment found. Please contact the
						administration.</p>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<script>
(function () {
  /* ── JSP values injected ── */
  var BLOCK   = '<%=block%>';
  var ROOM_NO = '<%=roomNo%>';

  /* ── canvas setup ── */
  var canvas = document.getElementById('hostelCanvas');
  var wrap   = canvas.parentElement;
  var ctx    = canvas.getContext('2d');
  var W = 0, H = 0;

  function resize() {
    W = canvas.width  = wrap.clientWidth;
    H = canvas.height = wrap.clientHeight;
  }
  resize();
  window.addEventListener('resize', resize);

  /* ── helpers ── */
  function lerp(a, b, t) { return a + (b - a) * Math.min(1, Math.max(0, t)); }
  function easeOut3(t)   { return 1 - Math.pow(1 - Math.min(1,t), 3); }
  function easeInOut(t)  { t = Math.min(1,t); return t < 0.5 ? 4*t*t*t : 1 - Math.pow(-2*t+2,3)/2; }

  /* ── stars ── */
  var STARS = [];
  for (var i = 0; i < 160; i++) {
    STARS.push({ x: Math.random(), y: Math.random() * 0.65,
                 r: Math.random() * 1.4 + 0.3, a: Math.random() * 0.55 + 0.15,
                 speed: Math.random() * 0.5 + 0.3 });
  }

  /* ── window colours (4 floors × 4 cols) ── */
  var WIN_COLS = [
    ['rgba(246,173,85,',  'rgba(99,179,237,',  'rgba(104,211,145,', 'rgba(99,179,237,' ],
    ['rgba(104,211,145,', 'rgba(246,173,85,',  'rgba(99,179,237,',  'rgba(104,211,145,'],
    ['rgba(246,173,85,',  'rgba(99,179,237,',  'rgba(79,209,197,',  'rgba(246,173,85,' ], // floor 2 col 2 = allocated
    ['rgba(104,211,145,', 'rgba(246,173,85,',  'rgba(99,179,237,',  'rgba(104,211,145,']
  ];
  var ALLOC_FLOOR = 2, ALLOC_COL = 2;

  /* ── caption / phase ui ── */
  var capEl   = document.getElementById('cinCaption');
  var phaseLbl = document.getElementById('phaseLabel');
  var phaseLabels = ['360° Scan', 'Zooming In', 'Hallway', 'Your Room'];
  function setCaption(html) { capEl.innerHTML = html; }
  function setPhaseUI(p) {
    for (var i = 0; i < 4; i++) {
      var d = document.getElementById('pd' + i);
      if (d) d.classList.toggle('active', i === p);
    }
    if (phaseLbl) phaseLbl.textContent = phaseLabels[p] || '';
  }

  /* ══════════════════════════════════
     DRAW: BACKGROUND
  ══════════════════════════════════ */
  function drawBG(t) {
    /* deep space gradient */
    var grd = ctx.createLinearGradient(0, 0, 0, H);
    grd.addColorStop(0,   '#04080e');
    grd.addColorStop(0.7, '#060d1a');
    grd.addColorStop(1,   '#080f1e');
    ctx.fillStyle = grd;
    ctx.fillRect(0, 0, W, H);

    /* stars */
    STARS.forEach(function (s) {
      ctx.beginPath();
      ctx.arc(s.x * W, s.y * H * 0.9, s.r, 0, Math.PI * 2);
      ctx.fillStyle = 'rgba(255,255,255,' + (s.a * (0.55 + 0.45 * Math.sin(t * s.speed))) + ')';
      ctx.fill();
    });

    /* horizon glow */
    var hg = ctx.createLinearGradient(0, H * 0.68, 0, H);
    hg.addColorStop(0, 'rgba(79,209,197,0.07)');
    hg.addColorStop(1, 'rgba(4,8,16,0.95)');
    ctx.fillStyle = hg;
    ctx.fillRect(0, H * 0.68, W, H * 0.32);

    /* ground line */
    var lg = ctx.createLinearGradient(0, 0, W, 0);
    lg.addColorStop(0,   'transparent');
    lg.addColorStop(0.5, 'rgba(79,209,197,0.4)');
    lg.addColorStop(1,   'transparent');
    ctx.beginPath();
    ctx.moveTo(0, H * 0.72); ctx.lineTo(W, H * 0.72);
    ctx.strokeStyle = lg; ctx.lineWidth = 1; ctx.stroke();
  }

  /* ══════════════════════════════════
     DRAW: 3D BUILDING (Canvas 3D perspective)
  ══════════════════════════════════ */
  function drawBuilding(cx, groundY, angleRad, scale, t) {
    var BW = 200 * scale;
    var BH = 280 * scale;
    var DEPTH = 55 * scale;

    /* perspective projection */
    var cosA = Math.cos(angleRad);
    var sinA = Math.sin(angleRad);
    var sideW = Math.abs(cosA) * DEPTH;
    var sideRight = cosA >= 0;

    ctx.save();

    /* ── ground shadow ── */
    ctx.beginPath();
    ctx.ellipse(cx + (sideRight ? sideW * 0.3 : -sideW * 0.3), groundY + 8,
                (BW / 2 + sideW * 0.5) * 0.9, 14, 0, 0, Math.PI * 2);
    var sg = ctx.createRadialGradient(cx, groundY + 8, 0, cx, groundY + 8, BW * 0.7);
    sg.addColorStop(0, 'rgba(0,0,0,0.5)'); sg.addColorStop(1, 'transparent');
    ctx.fillStyle = sg; ctx.fill();

    var topY = groundY - BH;

    /* ── SIDE FACE ── */
    if (sideW > 0.5) {
      var sx = sideRight ? cx + BW / 2 : cx - BW / 2;
      var dir = sideRight ? 1 : -1;
      ctx.beginPath();
      ctx.moveTo(sx,              topY);
      ctx.lineTo(sx + dir * sideW, topY + 16 * scale);
      ctx.lineTo(sx + dir * sideW, groundY + 10 * scale);
      ctx.lineTo(sx,               groundY);
      ctx.closePath();
      var sideBrightness = Math.abs(cosA) * 0.4;
      ctx.fillStyle = 'rgba(' + Math.round(15 + sideBrightness * 20) + ',' +
                                Math.round(22 + sideBrightness * 25) + ',' +
                                Math.round(40 + sideBrightness * 30) + ',1)';
      ctx.fill();
      ctx.strokeStyle = 'rgba(79,209,197,0.12)';
      ctx.lineWidth = 1; ctx.stroke();

      /* side windows */
      var sWinW = sideW * 0.28;
      var sWinH = 16 * scale;
      for (var sr = 0; sr < 4; sr++) {
        var swx = sideRight ? sx + dir * sideW * 0.35 : sx + dir * sideW * 0.35;
        var swy = topY + 45 * scale + sr * 60 * scale;
        ctx.fillStyle = 'rgba(99,179,237,0.1)';
        ctx.fillRect(swx - sWinW / 2, swy, sWinW, sWinH);
      }
    }

    /* ── FRONT FACE ── */
    var wallG = ctx.createLinearGradient(cx - BW / 2, 0, cx + BW / 2, 0);
    wallG.addColorStop(0,   '#0e1a2e');
    wallG.addColorStop(0.5, '#111e30');
    wallG.addColorStop(1,   '#0e1a2e');
    ctx.fillStyle = wallG;
    ctx.strokeStyle = 'rgba(79,209,197,0.35)';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.rect(cx - BW / 2, topY, BW, BH);
    ctx.fill(); ctx.stroke();

    /* ── FLOOR SEPARATOR LINES ── */
    for (var fl = 1; fl < 4; fl++) {
      var fy = topY + (BH / 4) * fl;
      ctx.beginPath();
      ctx.moveTo(cx - BW / 2, fy); ctx.lineTo(cx + BW / 2, fy);
      ctx.strokeStyle = 'rgba(255,255,255,0.05)'; ctx.lineWidth = 1; ctx.stroke();
    }

    /* ── CORNER PILLARS ── */
    var pilW = 8 * scale;
    ctx.fillStyle = '#0a1220';
    ctx.strokeStyle = 'rgba(99,179,237,0.2)'; ctx.lineWidth = 0.5;
    ctx.beginPath(); ctx.rect(cx - BW / 2, topY, pilW, BH); ctx.fill(); ctx.stroke();
    ctx.beginPath(); ctx.rect(cx + BW / 2 - pilW, topY, pilW, BH); ctx.fill(); ctx.stroke();

    /* ── WINDOWS (4×4) ── */
    var wW = 32 * scale, wH = 24 * scale;
    var colXs = [-0.35, -0.12, 0.12, 0.35]; /* relative to center */
    var rowYs = [0.13, 0.38, 0.60, 0.82];   /* relative to building height from top */

    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 4; col++) {
        var wx = cx + BW * colXs[col] - wW / 2;
        var wy = topY + BH * rowYs[row] - wH / 2;
        var isAlloc = (row === ALLOC_FLOOR && col === ALLOC_COL);
        var blinkVal = 0.5 + 0.5 * Math.sin(t * 2.5);

        /* frame */
        ctx.fillStyle = '#0d1828';
        ctx.strokeStyle = isAlloc
          ? 'rgba(79,209,197,' + (0.5 + 0.5 * blinkVal) + ')'
          : 'rgba(99,179,237,0.18)';
        ctx.lineWidth = isAlloc ? 2 : 0.8;
        ctx.shadowColor = isAlloc ? '#4fd1c5' : 'transparent';
        ctx.shadowBlur  = isAlloc ? 14 * blinkVal : 0;
        ctx.beginPath(); ctx.rect(wx, wy, wW, wH); ctx.fill(); ctx.stroke();
        ctx.shadowBlur = 0;

        /* inner light */
        var alpha = isAlloc
          ? (0.45 + 0.35 * blinkVal).toFixed(2)
          : '0.3';
        ctx.fillStyle = isAlloc
          ? 'rgba(79,209,197,' + alpha + ')'
          : WIN_COLS[row][col] + alpha + ')';
        ctx.fillRect(wx + 2, wy + 2, wW - 4, wH - 4);
      }
    }

    /* ── ROOF ── */
    ctx.fillStyle = '#090f1e';
    ctx.strokeStyle = 'rgba(99,179,237,0.4)'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.rect(cx - BW / 2 - 10 * scale, topY - 22 * scale, BW + 20 * scale, 24 * scale);
    ctx.fill(); ctx.stroke();

    /* roof teal accent */
    ctx.beginPath();
    ctx.moveTo(cx - BW / 2 - 10 * scale, topY - 22 * scale);
    ctx.lineTo(cx + BW / 2 + 10 * scale, topY - 22 * scale);
    ctx.strokeStyle = '#4fd1c5'; ctx.lineWidth = 2.5; ctx.stroke();

    /* ── ANTENNA ── */
    ctx.beginPath();
    ctx.moveTo(cx, topY - 22 * scale);
    ctx.lineTo(cx, topY - 60 * scale);
    ctx.strokeStyle = 'rgba(79,209,197,0.65)'; ctx.lineWidth = 2; ctx.stroke();

    var blinkOn = Math.sin(t * 3) > 0;
    ctx.beginPath();
    ctx.arc(cx, topY - 63 * scale, 5 * scale, 0, Math.PI * 2);
    ctx.fillStyle   = blinkOn ? '#4fd1c5' : 'rgba(79,209,197,0.25)';
    ctx.shadowColor = '#4fd1c5';
    ctx.shadowBlur  = blinkOn ? 18 : 2;
    ctx.fill(); ctx.shadowBlur = 0;

    /* antenna pulse ring */
    if (blinkOn) {
      ctx.beginPath();
      ctx.arc(cx, topY - 63 * scale, 10 * scale * (0.8 + 0.2 * Math.sin(t * 3)), 0, Math.PI * 2);
      ctx.strokeStyle = 'rgba(79,209,197,0.25)'; ctx.lineWidth = 1; ctx.stroke();
    }

    /* ── BLOCK LABEL ── */
    ctx.fillStyle   = 'rgba(79,209,197,0.1)';
    ctx.strokeStyle = 'rgba(79,209,197,0.4)'; ctx.lineWidth = 1;
    var lblW = 80 * scale, lblH = 20 * scale;
    ctx.beginPath(); ctx.rect(cx - lblW / 2, groundY - 95 * scale, lblW, lblH);
    ctx.fill(); ctx.stroke();
    ctx.fillStyle = 'rgba(79,209,197,0.9)';
    ctx.font = 'bold ' + Math.round(10 * scale) + 'px monospace';
    ctx.textAlign = 'center';
    ctx.fillText('BLOCK ' + BLOCK, cx, groundY - 95 * scale + lblH * 0.72);

    /* ── ENTRANCE DOOR ── */
    var dW = 50 * scale, dH = 72 * scale;
    ctx.fillStyle   = '#080e1a';
    ctx.strokeStyle = 'rgba(79,209,197,0.35)'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.rect(cx - dW / 2, groundY - dH, dW, dH); ctx.fill(); ctx.stroke();
    ctx.fillStyle = 'rgba(79,209,197,0.06)';
    ctx.fillRect(cx - dW / 2 + 2, groundY - dH + 2, dW / 2 - 4, dH - 4);
    ctx.fillRect(cx + 2, groundY - dH + 2, dW / 2 - 4, dH - 4);

    /* ── STEPS ── */
    ctx.fillStyle = '#0a1220';
    ctx.fillRect(cx - 38 * scale, groundY, 76 * scale, 8 * scale);
    ctx.fillRect(cx - 48 * scale, groundY + 7 * scale, 96 * scale, 8 * scale);

    ctx.restore();
  }

  /* ══════════════════════════════════
     DRAW: HALLWAY
  ══════════════════════════════════ */
  function drawHallway(alpha, roomAmt, t) {
    ctx.save();
    ctx.globalAlpha = alpha;

    var vx = W / 2, vy = H * 0.48;      /* vanishing point */
    var L = 0, R = W, T = 0, Bot = H;
    var hL = W * 0.28, hR = W * 0.72;
    var hT = H * 0.18, hBot = H * 0.82;

    /* fill bg */
    ctx.fillStyle = '#04080e';
    ctx.fillRect(0, 0, W, H);

    /* ceiling polygon */
    ctx.beginPath();
    ctx.moveTo(L, T); ctx.lineTo(R, T); ctx.lineTo(hR, hT); ctx.lineTo(hL, hT); ctx.closePath();
    ctx.fillStyle = '#070d18'; ctx.fill();

    /* floor polygon */
    ctx.beginPath();
    ctx.moveTo(L, Bot); ctx.lineTo(R, Bot); ctx.lineTo(hR, hBot); ctx.lineTo(hL, hBot); ctx.closePath();
    var fg = ctx.createLinearGradient(0, hBot, 0, Bot);
    fg.addColorStop(0, '#0a1220'); fg.addColorStop(1, '#050a12');
    ctx.fillStyle = fg; ctx.fill();

    /* left wall */
    ctx.beginPath();
    ctx.moveTo(L, T); ctx.lineTo(hL, hT); ctx.lineTo(hL, hBot); ctx.lineTo(L, Bot); ctx.closePath();
    ctx.fillStyle = '#0c1422'; ctx.fill();

    /* right wall */
    ctx.beginPath();
    ctx.moveTo(R, T); ctx.lineTo(hR, hT); ctx.lineTo(hR, hBot); ctx.lineTo(R, Bot); ctx.closePath();
    ctx.fillStyle = '#0c1422'; ctx.fill();

    /* back wall */
    ctx.fillStyle = '#0f1c30';
    ctx.strokeStyle = 'rgba(79,209,197,0.1)'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.rect(hL, hT, hR - hL, hBot - hT); ctx.fill(); ctx.stroke();

    /* ceiling light strip */
    var ls = ctx.createLinearGradient(W * 0.3, 0, W * 0.7, 0);
    ls.addColorStop(0, 'transparent'); ls.addColorStop(0.5, 'rgba(79,209,197,0.9)'); ls.addColorStop(1, 'transparent');
    ctx.beginPath(); ctx.moveTo(W * 0.3, hT + 3); ctx.lineTo(W * 0.7, hT + 3);
    ctx.strokeStyle = ls; ctx.lineWidth = 3; ctx.stroke();

    var cg = ctx.createRadialGradient(vx, hT, 0, vx, hT, 160);
    cg.addColorStop(0, 'rgba(79,209,197,0.12)'); cg.addColorStop(1, 'transparent');
    ctx.fillStyle = cg; ctx.fillRect(vx - 160, hT - 30, 320, 100);

    /* floor glow stripe */
    var fglow = ctx.createLinearGradient(hL, 0, hR, 0);
    fglow.addColorStop(0, 'transparent'); fglow.addColorStop(0.5, 'rgba(79,209,197,0.08)'); fglow.addColorStop(1, 'transparent');
    ctx.fillStyle = fglow; ctx.fillRect(hL, hBot - 5, hR - hL, 10);

    /* perspective lines */
    [[L,T],[R,T],[L,Bot],[R,Bot]].forEach(function(p) {
      ctx.beginPath(); ctx.moveTo(p[0], p[1]); ctx.lineTo(vx, vy);
      ctx.strokeStyle = 'rgba(255,255,255,0.025)'; ctx.lineWidth = 1; ctx.stroke();
    });

    /* wall tile lines */
    for (var wi = 1; wi <= 4; wi++) {
      var wx = L + (hL - L) * wi / 5;
      ctx.beginPath();
      ctx.moveTo(wx, T + (hT - T) * wi / 5);
      ctx.lineTo(wx, Bot - (Bot - hBot) * wi / 5);
      ctx.strokeStyle = 'rgba(255,255,255,0.02)'; ctx.lineWidth = 0.8; ctx.stroke();

      var wx2 = R - (R - hR) * wi / 5;
      ctx.beginPath(); ctx.moveTo(wx2, T + (hT - T) * wi / 5); ctx.lineTo(wx2, Bot - (Bot - hBot) * wi / 5);
      ctx.strokeStyle = 'rgba(255,255,255,0.02)'; ctx.lineWidth = 0.8; ctx.stroke();
    }

    /* ── SIDE DOORS ── */
    var midY  = (hT + hBot) / 2;
    var dInfo = [
      { x: L + W * 0.06, y: midY - H * 0.04, w: W * 0.07, h: H * 0.40, label: '101' },
      { x: L + W * 0.16, y: midY + H * 0.02, w: W * 0.06, h: H * 0.32, label: '102' },
      { x: R - W * 0.06, y: midY - H * 0.04, w: W * 0.07, h: H * 0.40, label: '103' },
      { x: R - W * 0.16, y: midY + H * 0.02, w: W * 0.06, h: H * 0.32, label: '104' }
    ];
    dInfo.forEach(function (d) {
      ctx.fillStyle   = '#0d1826';
      ctx.strokeStyle = 'rgba(255,255,255,0.07)'; ctx.lineWidth = 1;
      ctx.beginPath(); ctx.rect(d.x - d.w/2, d.y - d.h/2, d.w, d.h); ctx.fill(); ctx.stroke();
      ctx.fillStyle = 'rgba(255,255,255,0.03)';
      ctx.fillRect(d.x - d.w/2 + 2, d.y - d.h/2 + 2, d.w/2 - 3, d.h - 4);
      ctx.fillRect(d.x + 1,          d.y - d.h/2 + 2, d.w/2 - 3, d.h - 4);
      ctx.beginPath(); ctx.arc(d.x - 4, d.y + 5, 3, 0, Math.PI*2);
      ctx.fillStyle = 'rgba(255,255,255,0.15)'; ctx.fill();
      ctx.fillStyle = 'rgba(255,255,255,0.2)';
      ctx.font = 'bold ' + Math.round(W * 0.012) + 'px monospace'; ctx.textAlign = 'center';
      ctx.fillText(d.label, d.x, d.y - d.h/2 - 8);
    });

    /* ── ALLOCATED ROOM (back wall centre) ── */
    var bdW   = (hR - hL) * 0.5;
    var bdH   = (hBot - hT) * 0.78;
    var bdX   = vx;
    var bdY   = (hT + hBot) / 2;
    var blink = 0.5 + 0.5 * Math.sin(t * 2.2);

    ctx.shadowColor = '#4fd1c5'; ctx.shadowBlur = 30 * roomAmt;
    ctx.fillStyle   = 'rgba(79,209,197,' + (0.07 + 0.05 * blink) + ')';
    ctx.strokeStyle = 'rgba(79,209,197,' + (0.55 + 0.45 * blink) + ')';
    ctx.lineWidth   = 2.5;
    ctx.beginPath(); ctx.rect(bdX - bdW/2, bdY - bdH/2, bdW, bdH); ctx.fill(); ctx.stroke();
    ctx.shadowBlur  = 0;

    /* door panels */
    ctx.fillStyle = 'rgba(79,209,197,0.05)';
    ctx.fillRect(bdX - bdW/2 + 3, bdY - bdH/2 + 3, bdW/2 - 5, bdH - 6);
    ctx.fillRect(bdX + 2,          bdY - bdH/2 + 3, bdW/2 - 5, bdH - 6);

    /* handles */
    [[bdX - 9, bdY + 12],[bdX + 9, bdY + 12]].forEach(function(p) {
      ctx.beginPath(); ctx.arc(p[0], p[1], 5, 0, Math.PI*2);
      ctx.fillStyle = '#4fd1c5'; ctx.shadowColor = '#4fd1c5';
      ctx.shadowBlur = 8 * roomAmt; ctx.fill(); ctx.shadowBlur = 0;
    });

    /* room number plate */
    var plateW = bdW * 0.8, plateH = 22;
    ctx.fillStyle   = 'rgba(79,209,197,0.15)';
    ctx.strokeStyle = 'rgba(79,209,197,' + (0.5 + 0.4 * blink) + ')';
    ctx.lineWidth = 1.5; ctx.shadowColor = '#4fd1c5'; ctx.shadowBlur = 10 * roomAmt;
    ctx.beginPath(); ctx.rect(bdX - plateW/2, bdY - bdH/2 - 30, plateW, plateH); ctx.fill(); ctx.stroke();
    ctx.shadowBlur = 0;
    ctx.fillStyle = '#4fd1c5';
    ctx.font = 'bold ' + Math.round(W * 0.016) + 'px monospace'; ctx.textAlign = 'center';
    ctx.fillText('ROOM ' + ROOM_NO, bdX, bdY - bdH/2 - 30 + plateH * 0.7);

    /* YOU ARE HERE — appears with roomAmt */
    if (roomAmt > 0.3) {
      ctx.globalAlpha = alpha * Math.min(1, (roomAmt - 0.3) / 0.7);
      var arrowBaseY = hBot + H * 0.04;

      ctx.setLineDash([5, 4]);
      ctx.beginPath(); ctx.moveTo(bdX, arrowBaseY - 4); ctx.lineTo(bdX, hBot + 4);
      ctx.strokeStyle = 'rgba(79,209,197,0.7)'; ctx.lineWidth = 1.5; ctx.stroke();
      ctx.setLineDash([]);

      ctx.beginPath(); ctx.moveTo(bdX, hBot - 3); ctx.lineTo(bdX - 9, hBot + 11); ctx.lineTo(bdX + 9, hBot + 11); ctx.closePath();
      ctx.fillStyle = 'rgba(79,209,197,0.85)'; ctx.fill();

      var badgeW = W * 0.2;
      ctx.fillStyle = 'rgba(79,209,197,0.12)';
      ctx.strokeStyle = 'rgba(79,209,197,0.35)'; ctx.lineWidth = 1;
      ctx.beginPath(); ctx.rect(bdX - badgeW/2, arrowBaseY, badgeW, 22); ctx.fill(); ctx.stroke();
      ctx.fillStyle = 'rgba(79,209,197,0.95)';
      ctx.font = 'bold ' + Math.round(W * 0.012) + 'px monospace'; ctx.textAlign = 'center';
      ctx.fillText('YOU ARE HERE', bdX, arrowBaseY + 15);
      ctx.globalAlpha = alpha;
    }

    ctx.restore();
  }

  /* ══════════════════════════════════
     ANIMATION TIMELINE
     P0: 0      → 5500  ms — 360° rotation
     P1: 5500   → 6700  ms — zoom in
     P2: 6700   → 7800  ms — hallway fade
     P3: 7800   → 9000  ms — room reveal
     P4: 9000+           ms — idle hold
  ══════════════════════════════════ */
  var T0 = 5500, T1 = 1200, T2 = 1100, T3 = 1200;
  var startMs = null, frameId = null;

  function frame(now) {
    if (!startMs) startMs = now;
    var e = now - startMs;
    var t = e / 1000; /* seconds for blink etc */

    ctx.clearRect(0, 0, W, H);
    drawBG(t);

    var groundY = H * 0.76;
    var cx      = W / 2;

    if (e < T0) {
      /* ── PHASE 0: 360° ── */
      var p0 = e / T0;
      var angle = easeInOut(p0) * Math.PI * 2;
      drawBuilding(cx, groundY, angle, 1.0, t);
      setPhaseUI(0);
      setCaption('Performing 360° scan of <strong>Block ' + BLOCK + '</strong>…');

    } else if (e < T0 + T1) {
      /* ── PHASE 1: ZOOM ── */
      var p1 = (e - T0) / T1;
      var sc  = lerp(1.0, 6.0, easeInOut(p1));
      var alp = lerp(1.0, 0.0, easeOut3(p1));
      ctx.save(); ctx.globalAlpha = alp;
      drawBuilding(cx, groundY, Math.PI * 2, sc, t);
      ctx.restore();
      setPhaseUI(1);
      setCaption('Zooming into <strong>Block ' + BLOCK + '</strong>…');

    } else if (e < T0 + T1 + T2) {
      /* ── PHASE 2: HALLWAY ── */
      var p2   = (e - T0 - T1) / T2;
      var hAlp = easeOut3(p2);
      drawHallway(hAlp, 0, t);
      setPhaseUI(2);
      setCaption('Walking the hallway to <strong>Room ' + ROOM_NO + '</strong>…');

    } else if (e < T0 + T1 + T2 + T3) {
      /* ── PHASE 3: ROOM REVEAL ── */
      var p3   = (e - T0 - T1 - T2) / T3;
      var rAmt = easeOut3(p3);
      drawHallway(1, rAmt, t);
      setPhaseUI(3);
      setCaption('📍 Your room: <strong>Block ' + BLOCK + ' · Room ' + ROOM_NO + '</strong>');

    } else {
      /* ── IDLE HOLD ── */
      drawHallway(1, 1, t);
      setPhaseUI(3);
      setCaption('📍 Your room: <strong>Block ' + BLOCK + ' · Room ' + ROOM_NO + '</strong>');
    }

    frameId = requestAnimationFrame(frame);
  }

  function start() {
    startMs = null;
    if (frameId) cancelAnimationFrame(frameId);
    frameId = requestAnimationFrame(frame);
  }

  window.hostelReplay = function () { start(); };
  start();
})();
</script>

</body>
</html>
