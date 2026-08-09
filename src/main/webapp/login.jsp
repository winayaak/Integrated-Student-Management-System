<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ISMS — Login</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;1,9..40,300&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* ══════════════════════════════════════════
   RESET & BASE
══════════════════════════════════════════ */
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--bg: #06070d;
	--glass: rgba(255, 255, 255, 0.045);
	--glass-border: rgba(255, 255, 255, 0.09);
	--glass-hover: rgba(255, 255, 255, 0.07);
	--blue: #4f8ef7;
	--violet: #9f7aea;
	--teal: #4fd1c5;
	--green: #68d391;
	--text: #f0f4f8;
	--sub: #94a3b8;
	--muted: #475569;
	--input-bg: rgba(255, 255, 255, 0.05);
	--input-border: rgba(255, 255, 255, 0.1);
	--focus: rgba(79, 142, 247, 0.5);
	--r: 16px;
	--r-sm: 10px;
}

html, body {
	height: 100%;
	background: var(--bg);
	color: var(--text);
	font-family: 'DM Sans', sans-serif;
	overflow: hidden;
}

/* ══════════════════════════════════════════
   ANIMATED CANVAS BACKGROUND
══════════════════════════════════════════ */
#bg-canvas {
	position: fixed;
	inset: 0;
	z-index: 0;
	pointer-events: none;
}

/* floating blobs */
.blob {
	position: fixed;
	border-radius: 50%;
	filter: blur(80px);
	opacity: 0.25;
	animation: blobFloat linear infinite;
	pointer-events: none;
	z-index: 0;
}

.blob-1 {
	width: 520px;
	height: 520px;
	background: radial-gradient(circle, #4f8ef7, transparent);
	top: -100px;
	left: -100px;
	animation-duration: 22s;
}

.blob-2 {
	width: 420px;
	height: 420px;
	background: radial-gradient(circle, #9f7aea, transparent);
	bottom: -80px;
	right: -80px;
	animation-duration: 28s;
	animation-delay: -8s;
}

.blob-3 {
	width: 320px;
	height: 320px;
	background: radial-gradient(circle, #4fd1c5, transparent);
	top: 40%;
	left: 55%;
	animation-duration: 18s;
	animation-delay: -4s;
}

.blob-4 {
	width: 250px;
	height: 250px;
	background: radial-gradient(circle, #68d391, transparent);
	bottom: 20%;
	left: 10%;
	animation-duration: 32s;
	animation-delay: -14s;
	opacity: 0.15;
}

@
keyframes blobFloat { 0% {
	transform: translate(0, 0) scale(1);
}

25
%
{
transform
:
translate(
30px
,
-25px
)
scale(
1.05
);
}
50
%
{
transform
:
translate(
-20px
,
30px
)
scale(
0.95
);
}
75
%
{
transform
:
translate(
25px
,
15px
)
scale(
1.03
);
}
100
%
{
transform
:
translate(
0
,
0
)
scale(
1
);
}
}

/* mouse-follow glow */
#mouse-glow {
	position: fixed;
	width: 500px;
	height: 500px;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(79, 142, 247, 0.07) 0%,
		transparent 70%);
	pointer-events: none;
	z-index: 0;
	transform: translate(-50%, -50%);
	transition: left 0.5s ease, top 0.5s ease;
}

/* grid overlay */
.grid-overlay {
	position: fixed;
	inset: 0;
	z-index: 0;
	pointer-events: none;
	background-image: linear-gradient(rgba(255, 255, 255, 0.022) 1px,
		transparent 1px), linear-gradient(90deg, rgba(255, 255, 255, 0.022)
		1px, transparent 1px);
	background-size: 60px 60px;
	mask-image: radial-gradient(ellipse 80% 80% at 50% 50%, black 30%, transparent 100%);
}

/* ══════════════════════════════════════════
   LAYOUT
══════════════════════════════════════════ */
.page {
	position: relative;
	z-index: 1;
	height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 1.5rem;
}

.login-shell {
	display: flex;
	width: 100%;
	max-width: 1000px;
	min-height: 600px;
	border-radius: 24px;
	overflow: hidden;
	border: 1px solid var(--glass-border);
	box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.04), 0 32px 80px
		rgba(0, 0, 0, 0.6), 0 0 120px rgba(79, 142, 247, 0.06);
	animation: shellIn 0.8s cubic-bezier(.22, .68, 0, 1) both;
	transform-style: preserve-3d;
	transition: transform 0.15s ease, box-shadow 0.15s ease;
}

@
keyframes shellIn {from { opacity:0;
	transform: translateY(28px) scale(0.97);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}

}

/* ── LEFT PANEL ── */
.left-panel {
	flex: 1.15;
	background: linear-gradient(145deg, rgba(79, 142, 247, 0.12) 0%,
		rgba(159, 122, 234, 0.1) 50%, rgba(79, 209, 197, 0.07) 100%),
		rgba(255, 255, 255, 0.025);
	backdrop-filter: blur(24px);
	border-right: 1px solid var(--glass-border);
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	padding: 2.8rem 2.6rem;
	position: relative;
	overflow: hidden;
}

/* decorative ring */
.left-panel::before {
	content: '';
	position: absolute;
	width: 420px;
	height: 420px;
	border-radius: 50%;
	border: 1px solid rgba(79, 142, 247, 0.12);
	top: -120px;
	left: -100px;
	animation: ringPulse 6s ease-in-out infinite;
}

.left-panel::after {
	content: '';
	position: absolute;
	width: 280px;
	height: 280px;
	border-radius: 50%;
	border: 1px solid rgba(159, 122, 234, 0.1);
	bottom: -60px;
	right: -60px;
	animation: ringPulse 8s ease-in-out infinite reverse;
}

@
keyframes ringPulse { 0%, 100% {
	transform: scale(1);
	opacity: 0.5;
}

50
%
{
transform
:
scale(
1.06
);
opacity
:
1;
}
}
.brand-top {
	position: relative;
	z-index: 2;
}

.brand-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background: rgba(79, 142, 247, 0.1);
	border: 1px solid rgba(79, 142, 247, 0.2);
	border-radius: 50px;
	padding: 0.35rem 0.85rem;
	font-size: 0.72rem;
	font-weight: 600;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--blue);
	margin-bottom: 1.4rem;
}

.brand-badge span.dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--blue);
	animation: dotPulse 2s ease-in-out infinite;
}

@
keyframes dotPulse { 0%, 100% {
	opacity: 1;
	transform: scale(1);
}

50
%
{
opacity
:
0.4;
transform
:
scale(
0.7
);
}
}
.brand-logo {
	display: flex;
	align-items: center;
	gap: 0.8rem;
	margin-bottom: 1.5rem;
}

.logo-mark {
	width: 48px;
	height: 48px;
	border-radius: 14px;
	background: linear-gradient(135deg, var(--blue), var(--violet));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.3rem;
	color: #fff;
	box-shadow: 0 8px 24px rgba(79, 142, 247, 0.35);
}

.logo-name {
	font-family: 'Syne', sans-serif;
	font-size: 1.55rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	background: linear-gradient(130deg, #f0f4f8, var(--blue));
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.brand-headline {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.5rem, 2.2vw, 1.95rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.18;
	margin-bottom: 1rem;
	background: linear-gradient(150deg, #f0f4f8 40%, var(--violet) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.brand-desc {
	font-size: 0.875rem;
	color: var(--sub);
	font-weight: 300;
	line-height: 1.65;
	max-width: 340px;
}

/* feature pills */
.feature-pills {
	display: flex;
	flex-direction: column;
	gap: 0.6rem;
	margin-top: 1.4rem;
	position: relative;
	z-index: 2;
}

.pill {
	display: inline-flex;
	align-items: center;
	gap: 0.55rem;
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid rgba(255, 255, 255, 0.07);
	border-radius: 50px;
	padding: 0.42rem 0.9rem;
	font-size: 0.78rem;
	color: var(--sub);
	font-weight: 400;
	transition: background 0.2s, border-color 0.2s;
}

.pill:hover {
	background: rgba(255, 255, 255, 0.07);
	border-color: rgba(255, 255, 255, 0.13);
}

.pill i {
	font-size: 0.75rem;
}

.pill.p1 i {
	color: var(--blue);
}

.pill.p2 i {
	color: var(--violet);
}

.pill.p3 i {
	color: var(--green);
}

/* live clock */
.panel-bottom {
	position: relative;
	z-index: 2;
}

.live-clock {
	display: flex;
	flex-direction: column;
	gap: 0.1rem;
}

.clock-time {
	font-family: 'Syne', sans-serif;
	font-size: 2rem;
	font-weight: 800;
	letter-spacing: -0.05em;
	color: var(--text);
	line-height: 1;
}

.clock-date {
	font-size: 0.77rem;
	color: var(--muted);
	letter-spacing: 0.05em;
}

/* ── RIGHT PANEL (form) ── */
.right-panel {
	width: 400px;
	flex-shrink: 0;
	background: rgba(255, 255, 255, 0.035);
	backdrop-filter: blur(32px);
	display: flex;
	flex-direction: column;
	justify-content: center;
	padding: 2.8rem 2.4rem;
	position: relative;
}

/* entrance stagger */
.right-panel>* {
	animation: itemIn 0.6s cubic-bezier(.22, .68, 0, 1) both;
}

.right-panel>*:nth-child(1) {
	animation-delay: 0.15s;
}

.right-panel>*:nth-child(2) {
	animation-delay: 0.22s;
}

.right-panel>*:nth-child(3) {
	animation-delay: 0.28s;
}

.right-panel>*:nth-child(4) {
	animation-delay: 0.34s;
}

.right-panel>*:nth-child(5) {
	animation-delay: 0.40s;
}

.right-panel>*:nth-child(6) {
	animation-delay: 0.46s;
}

@
keyframes itemIn {from { opacity:0;
	transform: translateY(16px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.form-eyebrow {
	font-size: 0.68rem;
	font-weight: 600;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--blue);
	margin-bottom: 0.5rem;
	display: flex;
	align-items: center;
	gap: 0.4rem;
}

.form-eyebrow::before {
	content: '';
	display: inline-block;
	width: 14px;
	height: 2px;
	background: var(--blue);
	border-radius: 2px;
}

.form-title {
	font-family: 'Syne', sans-serif;
	font-size: 1.85rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	margin-bottom: 0.4rem;
	color: var(--text);
}

.form-sub {
	font-size: 0.82rem;
	color: var(--muted);
	font-weight: 300;
	margin-bottom: 2rem;
}

/* ── INPUT GROUPS ── */
.input-group {
	position: relative;
	margin-bottom: 1rem;
}

.input-group label {
	display: block;
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.06em;
	text-transform: uppercase;
	color: var(--muted);
	margin-bottom: 0.4rem;
}

.input-wrap {
	position: relative;
}

.input-icon {
	position: absolute;
	left: 0.9rem;
	top: 50%;
	transform: translateY(-50%);
	color: var(--muted);
	font-size: 0.85rem;
	pointer-events: none;
	transition: color 0.2s;
	z-index: 2;
}

.input-wrap input {
	width: 100%;
	padding: 0.72rem 2.6rem 0.72rem 2.6rem;
	background: var(--input-bg);
	border: 1px solid var(--input-border);
	border-radius: var(--r-sm);
	color: var(--text);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	transition: border-color 0.22s, box-shadow 0.22s, background 0.22s;
	position: relative;
	z-index: 1;
}

.input-wrap input::placeholder {
	color: var(--muted);
}

.input-wrap input:focus {
	outline: none;
	background: rgba(255, 255, 255, 0.07);
	border-color: var(--blue);
	box-shadow: 0 0 0 3px rgba(79, 142, 247, 0.15), 0 0 20px
		rgba(79, 142, 247, 0.08);
}

.input-wrap input:focus+.input-line {
	width: 100%;
}

.input-wrap input:focus ~ .input-icon-left {
	color: var(--blue);
}

/* animated underline */
.input-line {
	position: absolute;
	bottom: 0;
	left: 0;
	height: 2px;
	width: 0%;
	background: linear-gradient(90deg, var(--blue), var(--violet));
	border-radius: 0 0 2px 2px;
	transition: width 0.35s ease;
	z-index: 3;
}

.eye-icon {
	position: absolute;
	right: 0.9rem;
	top: 50%;
	transform: translateY(-50%);
	cursor: pointer;
	color: var(--muted);
	font-size: 0.85rem;
	transition: color 0.2s;
	z-index: 2;
}

.eye-icon:hover {
	color: var(--blue);
}

/* ── LOGIN BUTTON ── */
.login-btn-wrap {
	margin-top: 0.5rem;
}

.login-btn {
	width: 100%;
	padding: 0.82rem 1rem;
	border: none;
	border-radius: var(--r-sm);
	background: linear-gradient(135deg, #4f8ef7, #7c6fef);
	color: #fff;
	font-family: 'Syne', sans-serif;
	font-size: 0.95rem;
	font-weight: 700;
	letter-spacing: 0.01em;
	cursor: pointer;
	position: relative;
	overflow: hidden;
	transition: transform 0.18s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 6px 24px rgba(79, 142, 247, 0.35);
}

.login-btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 32px rgba(79, 142, 247, 0.5);
	filter: brightness(1.07);
}

.login-btn:active {
	transform: translateY(0);
}

/* ripple */
.login-btn::after {
	content: '';
	position: absolute;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.25);
	width: 0;
	height: 0;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	transition: width 0.5s ease, height 0.5s ease, opacity 0.5s ease;
	opacity: 0;
}

.login-btn:active::after {
	width: 300px;
	height: 300px;
	opacity: 0;
}

/* loading state */
.login-btn.loading {
	pointer-events: none;
	filter: brightness(0.85);
}

.login-btn .btn-text {
	transition: opacity 0.2s;
}

.login-btn .btn-spinner {
	display: none;
	width: 16px;
	height: 16px;
	border: 2px solid rgba(255, 255, 255, 0.3);
	border-top-color: #fff;
	border-radius: 50%;
	animation: spin 0.65s linear infinite;
	margin: 0 auto;
}

.login-btn.loading .btn-text {
	display: none;
}

.login-btn.loading .btn-spinner {
	display: block;
}

@
keyframes spin {to { transform:rotate(360deg);
	
}

}

/* ── REGISTER LINK ── */
.register {
	text-align: center;
	margin-top: 1.2rem;
	font-size: 0.8rem;
	color: var(--muted);
}

.register a {
	color: var(--blue);
	text-decoration: none;
	font-weight: 500;
	transition: color 0.18s, text-shadow 0.18s;
}

.register a:hover {
	color: #76acff;
	text-shadow: 0 0 12px rgba(79, 142, 247, 0.4);
}

/* ── ERROR ── */
.error {
	margin-top: 1rem;
	background: rgba(252, 129, 129, 0.1);
	border: 1px solid rgba(252, 129, 129, 0.25);
	border-radius: var(--r-sm);
	padding: 0.65rem 0.9rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;
	font-size: 0.8rem;
	color: #fc8181;
	animation: shakeIn 0.4s ease both;
}

.error i {
	flex-shrink: 0;
	font-size: 0.85rem;
}

@
keyframes shakeIn { 0% {
	opacity: 0;
	transform: translateX(-8px);
}

60
%
{
transform
:
translateX(
4px
);
}
100
%
{
opacity
:
1;
transform
:
translateX(
0
);
}
}

/* ── DIVIDER ── */
.divider {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	margin: 1.2rem 0 0;
}

.divider-line {
	flex: 1;
	height: 1px;
	background: rgba(255, 255, 255, 0.07);
}

.divider-text {
	font-size: 0.7rem;
	color: var(--muted);
	white-space: nowrap;
}

/* ══════════════════════════════════════════
   TYPING TAGLINE
══════════════════════════════════════════ */
.typing-wrap {
	font-size: 0.8rem;
	color: var(--sub);
	margin-top: 0.5rem;
	min-height: 1.2em;
}

.typing-cursor {
	display: inline-block;
	width: 2px;
	height: 0.9em;
	background: var(--blue);
	margin-left: 1px;
	vertical-align: middle;
	animation: blink 1s step-end infinite;
}

@
keyframes blink { 0%,100%{
	opacity: 1;
}

50
%
{
opacity
:
0;
}
}

/* ══════════════════════════════════════════
   FLOATING STAT BADGES
══════════════════════════════════════════ */
.stat-badge {
	position: absolute;
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid rgba(255, 255, 255, 0.09);
	backdrop-filter: blur(12px);
	border-radius: 50px;
	padding: 0.4rem 0.85rem;
	font-size: 0.72rem;
	color: var(--sub);
	display: flex;
	align-items: center;
	gap: 0.4rem;
	white-space: nowrap;
	animation: badgeFloat 4s ease-in-out infinite;
	pointer-events: none;
	z-index: 10;
}

.stat-badge .sb-dot {
	width: 7px;
	height: 7px;
	border-radius: 50%;
}

.sb1 {
	top: 8%;
	right: -18%;
	animation-delay: 0s;
}

.sb2 {
	bottom: 22%;
	left: -14%;
	animation-delay: -2s;
}

.sb3 {
	top: 55%;
	right: -16%;
	animation-delay: -1s;
}

@
keyframes badgeFloat { 0%, 100% {
	transform: translateY(0);
}

50
%
{
transform
:
translateY(
-7px
);
}
}

/* ══════════════════════════════════════════
   RESPONSIVE
══════════════════════════════════════════ */
@media ( max-width : 820px) {
	.left-panel {
		display: none;
	}
	.right-panel {
		width: 100%;
		min-width: 0;
		padding: 2.5rem 2rem;
	}
	.login-shell {
		max-width: 440px;
		min-height: auto;
	}
	html, body {
		overflow: auto;
	}
}

@media ( max-width : 480px) {
	.page {
		padding: 1rem;
	}
	.right-panel {
		padding: 2rem 1.5rem;
	}
	.form-title {
		font-size: 1.55rem;
	}
}

/* scrollbar */
::-webkit-scrollbar {
	width: 5px;
}

::-webkit-scrollbar-track {
	background: transparent;
}

::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}
</style>
</head>

<body>

	<!-- animated blobs -->
	<div class="blob blob-1"></div>
	<div class="blob blob-2"></div>
	<div class="blob blob-3"></div>
	<div class="blob blob-4"></div>

	<!-- mouse glow -->
	<div id="mouse-glow"></div>

	<!-- grid overlay -->
	<div class="grid-overlay"></div>

	<!-- particle canvas -->
	<canvas id="bg-canvas"></canvas>

	<div class="page">
		<div class="login-shell" id="loginShell">

			<!-- ═══════════ LEFT PANEL ═══════════ -->
			<div class="left-panel">

				<!-- floating stat badges -->
				<div class="stat-badge sb1">
					<div class="sb-dot" style="background: #68d391;"></div>
					1,200+ students enrolled
				</div>
				<div class="stat-badge sb2">
					<div class="sb-dot" style="background: #4f8ef7;"></div>
					48 active courses
				</div>
				<div class="stat-badge sb3">
					<div class="sb-dot" style="background: #9f7aea;"></div>
					Real-time analytics
				</div>

				<div class="brand-top">
					<div class="brand-badge">
						<span class="dot"></span> v2.0 · Now Live
					</div>

					<div class="brand-logo">
						<div class="logo-mark">
							<i class="fa-solid fa-graduation-cap"></i>
						</div>
						<div class="logo-name">ISMS</div>
					</div>

					<h2 class="brand-headline">
						Smart campus.<br>Smarter management.
					</h2>

					<p class="brand-desc">Integrated Student Management System — a
						unified platform for students, faculty and administration to
						collaborate, track, and grow.</p>

					<div class="typing-wrap" id="typingText"></div>

					<div class="feature-pills">
						<div class="pill p1">
							<i class="fa-solid fa-users"></i> Centralized Student Records
						</div>
						<div class="pill p2">
							<i class="fa-solid fa-chart-bar"></i> Real-Time Performance
							Analytics
						</div>
						<div class="pill p3">
							<i class="fa-solid fa-shield-halved"></i> Secure Role-Based
							Access
						</div>
					</div>
				</div>

				<div class="panel-bottom">
					<div class="live-clock">
						<div class="clock-time" id="clock">--:--:--</div>
						<div class="clock-date" id="clockDate">Loading…</div>
					</div>
				</div>

			</div>

			<!-- ═══════════ RIGHT PANEL ═══════════ -->
			<div class="right-panel">

				<div class="form-eyebrow">Secure Access</div>

				<h1 class="form-title">
					Welcome<br>back.
				</h1>
				<p class="form-sub">Sign in to your ISMS account to continue.</p>

				<form action="login" method="post" id="loginForm">

					<!-- username -->
					<div class="input-group">
						<label for="username-field">Username</label>
						<div class="input-wrap">
							<i class="fa-solid fa-user input-icon"></i> <input type="text"
								id="username-field" name="username"
								placeholder="Enter your username" autocomplete="username"
								required>
							<div class="input-line"></div>
						</div>
					</div>

					<!-- password -->
					<div class="input-group">
						<label for="password">Password</label>
						<div class="input-wrap">
							<i class="fa-solid fa-lock input-icon"></i> <input
								type="password" id="password" name="password"
								placeholder="Enter your password"
								autocomplete="current-password" required>
							<div class="input-line"></div>
							<i class="fa-solid fa-eye eye-icon" onclick="togglePassword()"></i>
						</div>
					</div>

					<!-- submit -->
					<div class="login-btn-wrap">
						<button type="submit" class="login-btn" id="loginBtn">
							<span class="btn-text"> Sign In &nbsp;<i
								class="fa-solid fa-arrow-right-long"></i>
							</span>
							<div class="btn-spinner"></div>
						</button>
					</div>

				</form>

				<!-- register link -->
				<div class="register">
					New here? <a href="register.jsp">Create a student account</a>
				</div>

				<!-- error (backend — unchanged) -->
				<%
				String error = (String) request.getAttribute("error");
				if (error != null) {
				%>
				<div class="error">
					<i class="fa-solid fa-circle-exclamation"></i>
					<%=error%>
				</div>
				<%
				}
				%>

				<div class="divider">
					<div class="divider-line"></div>
					<div class="divider-text">Integrated Student Management
						System</div>
					<div class="divider-line"></div>
				</div>

			</div>
		</div>
	</div>

	<!-- ══════════════════════════════════════════
     SCRIPTS
══════════════════════════════════════════ -->
	<script>
/* ── toggle password (unchanged logic) ── */
function togglePassword() {
  var password = document.getElementById("password");
  var eye      = document.querySelector(".eye-icon");
  if (password.type === "password") {
    password.type = "text";
    eye.classList.remove("fa-eye");
    eye.classList.add("fa-eye-slash");
  } else {
    password.type = "password";
    eye.classList.remove("fa-eye-slash");
    eye.classList.add("fa-eye");
  }
}

/* ── loading state on submit ── */
document.getElementById('loginForm').addEventListener('submit', function() {
  var btn = document.getElementById('loginBtn');
  btn.classList.add('loading');
});

/* ── live clock ── */
function updateClock() {
  var now  = new Date();
  var h    = String(now.getHours()).padStart(2, '0');
  var m    = String(now.getMinutes()).padStart(2, '0');
  var s    = String(now.getSeconds()).padStart(2, '0');
  document.getElementById('clock').textContent = h + ':' + m + ':' + s;
  var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  document.getElementById('clockDate').textContent =
    days[now.getDay()] + ', ' + months[now.getMonth()] + ' ' + now.getDate() + ' ' + now.getFullYear();
}
updateClock();
setInterval(updateClock, 1000);

/* ── typing effect ── */
(function() {
  var phrases = [
    'Empowering 1,200+ students daily.',
    'Seamless attendance tracking.',
    'Real-time grade analytics.',
    'Role-based access for all.',
    'Built for the modern campus.'
  ];
  var idx = 0, charIdx = 0, deleting = false;
  var el  = document.getElementById('typingText');
  el.innerHTML = '<span id="typingSpan"></span><span class="typing-cursor"></span>';
  var span = document.getElementById('typingSpan');

  function type() {
    var phrase = phrases[idx];
    if (!deleting) {
      span.textContent = phrase.substring(0, ++charIdx);
      if (charIdx === phrase.length) {
        deleting = true;
        setTimeout(type, 1800);
        return;
      }
    } else {
      span.textContent = phrase.substring(0, --charIdx);
      if (charIdx === 0) {
        deleting = false;
        idx = (idx + 1) % phrases.length;
      }
    }
    setTimeout(type, deleting ? 35 : 55);
  }
  setTimeout(type, 600);
})();

/* ── mouse follow glow ── */
var glow = document.getElementById('mouse-glow');
document.addEventListener('mousemove', function(e) {
  glow.style.left = e.clientX + 'px';
  glow.style.top  = e.clientY + 'px';
});

/* ── 3D tilt on login card ── */
var shell = document.getElementById('loginShell');
document.addEventListener('mousemove', function(e) {
  var rect  = shell.getBoundingClientRect();
  var cx    = rect.left + rect.width  / 2;
  var cy    = rect.top  + rect.height / 2;
  var dx    = (e.clientX - cx) / (rect.width  / 2);
  var dy    = (e.clientY - cy) / (rect.height / 2);
  var tiltX = dy * -4;
  var tiltY = dx *  4;
  shell.style.transform = 'perspective(1200px) rotateX(' + tiltX + 'deg) rotateY(' + tiltY + 'deg)';
  shell.style.boxShadow =
    '0 0 0 1px rgba(255,255,255,0.04),' +
    '0 ' + (32 + tiltX * 2) + 'px 80px rgba(0,0,0,0.6),' +
    '0 0 120px rgba(79,142,247,0.08)';
});
document.addEventListener('mouseleave', function() {
  shell.style.transform = 'perspective(1200px) rotateX(0deg) rotateY(0deg)';
});

/* ── particle canvas ── */
(function() {
  var canvas  = document.getElementById('bg-canvas');
  var ctx     = canvas.getContext('2d');
  var W, H, particles;

  function resize() {
    W = canvas.width  = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }
  resize();
  window.addEventListener('resize', function() { resize(); init(); });

  function rand(a, b) { return Math.random() * (b - a) + a; }

  function init() {
    var count = Math.floor((W * H) / 18000);
    particles = [];
    for (var i = 0; i < count; i++) {
      particles.push({
        x: rand(0, W), y: rand(0, H),
        r: rand(0.8, 2.2),
        vx: rand(-0.18, 0.18),
        vy: rand(-0.18, 0.18),
        alpha: rand(0.1, 0.45),
        color: ['#4f8ef7','#9f7aea','#4fd1c5','#68d391'][Math.floor(rand(0,4))]
      });
    }
  }
  init();

  function draw() {
    ctx.clearRect(0, 0, W, H);
    particles.forEach(function(p) {
      p.x += p.vx; p.y += p.vy;
      if (p.x < 0) p.x = W; if (p.x > W) p.x = 0;
      if (p.y < 0) p.y = H; if (p.y > H) p.y = 0;

      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fillStyle = p.color;
      ctx.globalAlpha = p.alpha;
      ctx.fill();
    });

    /* draw lines between nearby particles */
    ctx.globalAlpha = 1;
    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        var dx  = particles[i].x - particles[j].x;
        var dy  = particles[i].y - particles[j].y;
        var dst = Math.sqrt(dx*dx + dy*dy);
        if (dst < 90) {
          ctx.beginPath();
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.strokeStyle = 'rgba(99,179,237,' + (0.06 * (1 - dst/90)) + ')';
          ctx.lineWidth   = 0.5;
          ctx.stroke();
        }
      }
    }
    requestAnimationFrame(draw);
  }
  draw();
})();

/* ── input icon color on focus ── */
document.querySelectorAll('.input-wrap input').forEach(function(inp) {
  var icon = inp.parentElement.querySelector('.input-icon');
  inp.addEventListener('focus', function() {
    if (icon) icon.style.color = 'var(--blue)';
  });
  inp.addEventListener('blur', function() {
    if (icon) icon.style.color = 'var(--muted)';
  });
});
</script>

</body>
</html>
