<%@ page%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Exam Result — ISMS</title>

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
	display: flex;
	align-items: center;
	justify-content: center;
}

/* mesh */
body::before {
	content: '';
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 55% at 5% 0%, rgba(99, 179, 237, 0.10)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 60% at 98% 8%, rgba(159, 122, 234, 0.09)
		0%, transparent 55%),
		radial-gradient(ellipse 55% 40% at 50% 100%, rgba(104, 211, 145, 0.07)
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

/* ── page wrap ── */
.page-wrap {
	position: relative;
	z-index: 1;
	width: 100%;
	max-width: 560px;
	padding: 2rem 1.5rem;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 1.2rem;
}

/* ── result card ── */
.result-card {
	width: 100%;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	backdrop-filter: blur(22px);
	box-shadow: var(--shadow), 0 0 80px rgba(99, 179, 237, 0.06);
	position: relative;
	overflow: hidden;
	animation: cardIn 0.7s cubic-bezier(.22, .68, 0, 1) both;
	text-align: center;
}

.result-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.04) 0%,
		transparent 55%);
	pointer-events: none;
}

/* top accent line — dynamically colored via inline style */
.result-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 3px;
	border-radius: 3px 3px 0 0;
	background: var(--rc-line, var(--blue));
}

.rc-eyebrow {
	padding: 2rem 2rem 0;
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--muted);
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.45rem;
	animation: fadeDown 0.5s 0.15s ease both;
}

.rc-eyebrow::before, .rc-eyebrow::after {
	content: '';
	display: inline-block;
	width: 20px;
	height: 1px;
	background: var(--muted);
	border-radius: 1px;
}

/* trophy / medal icon */
.rc-icon-wrap {
	margin: 1.2rem auto 0.5rem;
	width: 72px;
	height: 72px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2rem;
	animation: iconPop 0.6s 0.25s cubic-bezier(.22, .68, 0, 1.3) both;
}

/* score ring */
.score-ring-wrap {
	position: relative;
	width: 170px;
	height: 170px;
	margin: 0.5rem auto 0;
	animation: fadeUp 0.5s 0.3s ease both;
}

.score-ring-wrap svg {
	transform: rotate(-90deg);
}

.ring-track {
	fill: none;
	stroke: rgba(255, 255, 255, 0.06);
	stroke-width: 10;
}

.ring-fill {
	fill: none;
	stroke-width: 10;
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

.score-fraction {
	font-family: 'Syne', sans-serif;
	font-size: 2.4rem;
	font-weight: 800;
	letter-spacing: -0.05em;
	line-height: 1;
	color: var(--text);
}

.score-fraction .total {
	font-size: 0.5em;
	opacity: 0.55;
}

.score-sublabel {
	font-size: 0.65rem;
	color: var(--muted);
	letter-spacing: 0.1em;
	text-transform: uppercase;
	margin-top: 0.25rem;
}

/* grade and pct row */
.score-meta-row {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.75rem;
	margin: 1rem 2rem 0;
	animation: fadeUp 0.5s 0.35s ease both;
	flex-wrap: wrap;
}

.grade-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	border-radius: var(--r-sm);
	padding: 0.45rem 1rem;
	font-family: 'Syne', sans-serif;
	font-size: 0.88rem;
	font-weight: 800;
}

.pct-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.35rem;
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	padding: 0.45rem 0.9rem;
	font-size: 0.85rem;
	font-weight: 500;
	color: var(--sub);
}

/* score bar */
.score-bar-section {
	margin: 1.4rem 2rem 0;
	animation: fadeUp 0.5s 0.4s ease both;
}

.score-bar-labels {
	display: flex;
	justify-content: space-between;
	font-size: 0.7rem;
	color: var(--muted);
	margin-bottom: 0.4rem;
}

.score-bar-track {
	height: 8px;
	border-radius: 4px;
	background: rgba(255, 255, 255, 0.06);
	overflow: hidden;
}

.score-bar-fill {
	height: 100%;
	border-radius: 4px;
	transition: width 1.2s cubic-bezier(.22, .68, 0, 1);
}

/* message */
.result-message {
	margin: 1.4rem 2rem 0;
	font-size: 0.875rem;
	color: var(--sub);
	line-height: 1.6;
	font-weight: 300;
	animation: fadeUp 0.5s 0.42s ease both;
}

/* stat pills row */
.stat-pills {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.6rem;
	flex-wrap: wrap;
	margin: 1.2rem 2rem 0;
	animation: fadeUp 0.5s 0.45s ease both;
}

.stat-pill {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 0.32rem 0.8rem;
	font-size: 0.75rem;
	color: var(--muted);
}

.stat-pill i {
	font-size: 0.72rem;
}

/* divider */
.card-divider {
	height: 1px;
	margin: 1.5rem 2rem 0;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
}

/* actions */
.rc-actions {
	padding: 1.4rem 2rem 2rem;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.85rem;
	flex-wrap: wrap;
	animation: fadeUp 0.5s 0.5s ease both;
}

.btn-primary-act {
	display: inline-flex;
	align-items: center;
	gap: 0.45rem;
	background: linear-gradient(135deg, var(--blue), #2b6cb0);
	border: none;
	border-radius: var(--r-sm);
	color: #fff;
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	font-weight: 500;
	padding: 0.65rem 1.5rem;
	cursor: pointer;
	text-decoration: none;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 14px rgba(99, 179, 237, 0.28);
}

.btn-primary-act:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 20px rgba(99, 179, 237, 0.42);
}

.btn-secondary-act {
	display: inline-flex;
	align-items: center;
	gap: 0.45rem;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	color: var(--sub);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	font-weight: 500;
	padding: 0.65rem 1.3rem;
	cursor: pointer;
	text-decoration: none;
	transition: background 0.2s, color 0.2s, border-color 0.2s;
	backdrop-filter: blur(8px);
}

.btn-secondary-act:hover {
	background: var(--bg-hover);
	color: var(--text);
	border-color: rgba(255, 255, 255, 0.14);
}

/* confetti burst (CSS only, pure decorative) */
.confetti-wrap {
	position: fixed;
	inset: 0;
	pointer-events: none;
	z-index: 0;
	overflow: hidden;
}

.confetti-piece {
	position: absolute;
	top: -10px;
	width: 8px;
	height: 8px;
	border-radius: 2px;
	opacity: 0;
}

/* animations */
@
keyframes cardIn {from { opacity:0;
	transform: translateY(28px) scale(0.96);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}

}
@
keyframes fadeDown {from { opacity:0;
	transform: translateY(-12px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
@
keyframes fadeUp {from { opacity:0;
	transform: translateY(14px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
@
keyframes iconPop {from { opacity:0;
	transform: scale(0.5) rotate(-10deg);
}

to {
	opacity: 1;
	transform: scale(1) rotate(0deg);
}

}
@
keyframes confettiFall { 0% {
	opacity: 1;
	transform: translateY(0) rotate(0deg);
}

100
%
{
opacity
:
0;
transform
:
translateY(
100vh
)
rotate(
720deg
);
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

@media ( max-width : 480px) {
	.page-wrap {
		padding: 1.5rem 1rem;
	}
	.score-fraction {
		font-size: 2rem;
	}
	.score-ring-wrap {
		width: 150px;
		height: 150px;
	}
	.rc-actions {
		flex-direction: column;
		align-items: stretch;
	}
	.btn-primary-act, .btn-secondary-act {
		justify-content: center;
	}
}
</style>
</head>
<body>

	<%
	/* ── read score and total from request attributes (unchanged) ── */
	Object scoreObj = request.getAttribute("score");
	Object totalObj = request.getAttribute("total");

	int score = 0, total = 1;
	try {
		score = Integer.parseInt(String.valueOf(scoreObj));
	} catch (Exception e2) {
	}
	try {
		total = Integer.parseInt(String.valueOf(totalObj));
	} catch (Exception e3) {
		total = 1;
	}
	if (total == 0)
		total = 1;

	double pctD = (score * 100.0) / total;

	/* grade */
	String gradeLabel, gradeDesc;
	String accentColor, gradA, gradB, chipBg, chipBorder;
	String iconClass, iconBg;
	String msgText;
	boolean showConfetti;

	if (pctD >= 90) {
		gradeLabel = "A+";
		gradeDesc = "Outstanding";
		accentColor = "#68d391";
		gradA = "#68d391";
		gradB = "#4fd1c5";
		chipBg = "rgba(104,211,145,0.12)";
		chipBorder = "rgba(104,211,145,0.3)";
		iconClass = "bi-trophy-fill";
		iconBg = "rgba(104,211,145,0.12)";
		msgText = "Outstanding performance! You've excelled in this exam. Keep up the excellent work.";
		showConfetti = true;
	} else if (pctD >= 75) {
		gradeLabel = "A";
		gradeDesc = "Excellent";
		accentColor = "#63b3ed";
		gradA = "#63b3ed";
		gradB = "#4fd1c5";
		chipBg = "rgba(99,179,237,0.12)";
		chipBorder = "rgba(99,179,237,0.3)";
		iconClass = "bi-star-fill";
		iconBg = "rgba(99,179,237,0.12)";
		msgText = "Great job! You've performed excellently. A little more focus and you'll hit the top.";
		showConfetti = true;
	} else if (pctD >= 60) {
		gradeLabel = "B+";
		gradeDesc = "Very Good";
		accentColor = "#9f7aea";
		gradA = "#9f7aea";
		gradB = "#63b3ed";
		chipBg = "rgba(159,122,234,0.12)";
		chipBorder = "rgba(159,122,234,0.3)";
		iconClass = "bi-patch-check-fill";
		iconBg = "rgba(159,122,234,0.12)";
		msgText = "Good performance! You're on the right track. Focus on your weak areas to improve further.";
		showConfetti = false;
	} else if (pctD >= 50) {
		gradeLabel = "B";
		gradeDesc = "Good";
		accentColor = "#f6ad55";
		gradA = "#f6ad55";
		gradB = "#ed8936";
		chipBg = "rgba(246,173,85,0.12)";
		chipBorder = "rgba(246,173,85,0.3)";
		iconClass = "bi-clipboard-check";
		iconBg = "rgba(246,173,85,0.10)";
		msgText = "You passed! There's room for improvement. Review the topics you found difficult and prepare better next time.";
		showConfetti = false;
	} else {
		gradeLabel = "F";
		gradeDesc = "Needs Improvement";
		accentColor = "#fc8181";
		gradA = "#fc8181";
		gradB = "#e53e3e";
		chipBg = "rgba(252,129,129,0.12)";
		chipBorder = "rgba(252,129,129,0.3)";
		iconClass = "bi-book";
		iconBg = "rgba(252,129,129,0.10)";
		msgText = "Don't be discouraged. Review the material, seek help from your faculty, and you'll do better next time.";
		showConfetti = false;
	}

	/* ring geometry — r=72 */
	double circ = 2 * Math.PI * 72;
	double ringPct = Math.min(100, Math.max(0, pctD));
	%>

	<!-- confetti burst for high scores -->
	<%
	if (showConfetti) {
	%>
	<div class="confetti-wrap" id="confettiWrap"></div>
	<%
	}
	%>

	<div class="page-wrap">

		<div class="result-card" style="--rc-line: <%=accentColor%>;">

			<!-- eyebrow -->
			<div class="rc-eyebrow">Exam Submitted</div>

			<!-- icon -->
			<div class="rc-icon-wrap"
				style="background:<%=iconBg%>;border:1px solid <%=chipBorder%>;color:<%=accentColor%>;">
				<i class="bi <%=iconClass%>"></i>
			</div>

			<!-- score ring -->
			<div class="score-ring-wrap">
				<svg width="170" height="170" viewBox="0 0 170 170">
        <circle class="ring-track" cx="85" cy="85" r="72" />
        <circle class="ring-fill" cx="85" cy="85" r="72"
						stroke="<%=accentColor%>"
						stroke-dasharray="<%=String.format("%.2f", circ)%>"
						stroke-dashoffset="<%=String.format("%.2f", circ)%>"
						data-pct="<%=String.format("%.4f", ringPct)%>"
						data-circ="<%=String.format("%.4f", circ)%>" id="scoreRing" />
      </svg>
				<div class="ring-center">
					<div class="score-fraction">
						<%=request.getAttribute("score")%><span class="total"> /
							<%=request.getAttribute("total")%></span>
					</div>
					<div class="score-sublabel">Your Score</div>
				</div>
			</div>

			<!-- grade + pct row -->
			<div class="score-meta-row">
				<span class="grade-chip"
					style="background:<%=chipBg%>;border:1px solid <%=chipBorder%>;color:<%=accentColor%>;">
					<i class="bi bi-award-fill" style="font-size: 0.85rem;"></i> Grade
					<%=gradeLabel%> &nbsp;·&nbsp; <%=gradeDesc%>
				</span> <span class="pct-chip"> <i class="bi bi-percent"
					style="color:<%=accentColor%>;font-size:0.8rem;"></i> <%=String.format("%.1f", pctD)%>%
				</span>
			</div>

			<!-- score bar -->
			<div class="score-bar-section">
				<div class="score-bar-labels">
					<span>Score</span> <span><%=String.format("%.1f", pctD)%>%</span>
				</div>
				<div class="score-bar-track">
					<div class="score-bar-fill" id="scoreBar"
						data-w="<%=String.format("%.2f", Math.min(100, pctD))%>%"
						style="width:0%;background:linear-gradient(90deg,<%=gradA%>,<%=gradB%>);">
					</div>
				</div>
			</div>

			<!-- message -->
			<div class="result-message"><%=msgText%></div>

			<!-- stat pills -->
			<div class="stat-pills">
				<span class="stat-pill"> <i class="bi bi-check-circle"
					style="color: var(--green);"></i> Correct: <%=score%>
				</span> <span class="stat-pill"> <i class="bi bi-x-circle"
					style="color: var(--red);"></i> Wrong: <%=(total - score)%>
				</span> <span class="stat-pill"> <i class="bi bi-journals"
					style="color: var(--blue);"></i> Total: <%=total%>
				</span>
			</div>

			<div class="card-divider"></div>

			<!-- actions -->
			<div class="rc-actions">
				<a href="dashboard.jsp" class="btn-primary-act"> <i
					class="bi bi-grid-1x2-fill"></i> Back to Dashboard
				</a> <a href="exams.jsp" class="btn-secondary-act"> <i
					class="bi bi-journal-text"></i> View All Exams
				</a>
			</div>

		</div>

	</div>

	<script>
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {

							/* ── ring animation ── */
							var ring = document.getElementById('scoreRing');
							if (ring) {
								var circ = parseFloat(ring
										.getAttribute('data-circ')
										|| '0');
								var pct = parseFloat(ring
										.getAttribute('data-pct')
										|| '0');
								var off = circ - (pct / 100) * circ;
								ring.style.strokeDashoffset = circ;
								setTimeout(
										function() {
											ring.style.transition = 'stroke-dashoffset 1.4s cubic-bezier(.22,.68,0,1)';
											ring.style.strokeDashoffset = off;
										}, 200);
							}

							/* ── bar animation ── */
							var bar = document.getElementById('scoreBar');
							if (bar) {
								var tw = bar.getAttribute('data-w') || '0%';
								setTimeout(function() {
									bar.style.width = tw;
								}, 250);
							}

							/* ── confetti (only spawned if element exists) ── */
							var cWrap = document.getElementById('confettiWrap');
							if (!cWrap)
								return;

							var colors = [ '#63b3ed', '#9f7aea', '#68d391',
									'#f6ad55', '#4fd1c5', '#f687b3' ];
							for (var i = 0; i < 60; i++) {
								(function(idx) {
									var el = document.createElement('div');
									el.className = 'confetti-piece';
									el.style.left = Math.random() * 100 + 'vw';
									el.style.background = colors[idx
											% colors.length];
									el.style.width = (6 + Math.random() * 6)
											+ 'px';
									el.style.height = (6 + Math.random() * 6)
											+ 'px';
									el.style.borderRadius = Math.random() > 0.5 ? '50%'
											: '2px';
									var delay = Math.random() * 1.5;
									var duration = 2.5 + Math.random() * 2;
									el.style.animation = 'confettiFall '
											+ duration + 's ' + delay
											+ 's ease-in forwards';
									cWrap.appendChild(el);
								})(i);
							}
						});
	</script>

</body>
</html>
