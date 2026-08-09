<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Assistant — ISMS</title>

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
	max-width: 860px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 3rem;
	display: flex;
	flex-direction: column;
	height: 100vh;
	min-height: 600px;
}

/* ── page header ── */
.page-header {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 1rem;
	margin-bottom: 1.5rem;
	flex-shrink: 0;
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
	font-size: clamp(1.7rem, 3.5vw, 2.3rem);
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

/* ── topic quick-chips ── */
.topic-chips {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
	margin-bottom: 1rem;
	flex-shrink: 0;
	animation: fadeDown 0.5s 0.06s ease both;
}

.topic-chip {
	display: inline-flex;
	align-items: center;
	gap: 0.35rem;
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: 50px;
	padding: 0.3rem 0.8rem;
	font-size: 0.74rem;
	color: var(--sub);
	cursor: pointer;
	transition: background 0.18s, border-color 0.18s, color 0.18s;
}

.topic-chip:hover {
	background: rgba(159, 122, 234, 0.1);
	border-color: rgba(159, 122, 234, 0.25);
	color: var(--violet);
}

.topic-chip i {
	font-size: 0.7rem;
}

/* ── chat window ── */
.chat-shell {
	flex: 1;
	display: flex;
	flex-direction: column;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s 0.08s ease both;
	min-height: 0;
}

.chat-shell::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.03) 0%,
		transparent 55%);
	pointer-events: none;
	z-index: 0;
}

/* chat header bar */
.chat-header {
	padding: 1rem 1.4rem;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 0.8rem;
	flex-shrink: 0;
	position: relative;
	z-index: 1;
}

.bot-avatar {
	width: 38px;
	height: 38px;
	border-radius: 50%;
	background: linear-gradient(135deg, var(--violet), var(--blue));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1rem;
	color: #fff;
	flex-shrink: 0;
	box-shadow: 0 0 14px rgba(159, 122, 234, 0.3);
}

.chat-header-info {
	
}

.chat-header-name {
	font-family: 'Syne', sans-serif;
	font-size: 0.9rem;
	font-weight: 700;
	color: var(--text);
	line-height: 1.2;
}

.chat-header-status {
	font-size: 0.7rem;
	color: var(--green);
	display: flex;
	align-items: center;
	gap: 0.3rem;
}

.status-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--green);
	animation: statusPulse 2s ease-in-out infinite;
}

@
keyframes statusPulse { 0%,100%{
	opacity: 1;
}

50
%
{
opacity
:
0.4;
}
}
.chat-header-actions {
	margin-left: auto;
	display: flex;
	gap: 0.5rem;
}

.hdr-btn {
	width: 30px;
	height: 30px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--muted);
	font-size: 0.82rem;
	cursor: pointer;
	transition: background 0.18s, color 0.18s;
}

.hdr-btn:hover {
	background: rgba(255, 255, 255, 0.09);
	color: var(--text);
}

/* ── chat area ── */
#chatArea {
	flex: 1;
	overflow-y: auto;
	overflow-x: hidden;
	padding: 1.4rem 1.4rem 0.5rem;
	display: flex;
	flex-direction: column;
	gap: 0.75rem;
	position: relative;
	z-index: 1;
	min-height: 0;
	scroll-behavior: smooth;
}

#chatArea::-webkit-scrollbar {
	width: 5px;
}

#chatArea::-webkit-scrollbar-track {
	background: transparent;
}

#chatArea::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.08);
	border-radius: 3px;
}

/* welcome message */
.chat-welcome {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 0.6rem;
	padding: 1.5rem 1rem;
	text-align: center;
	color: var(--muted);
}

.welcome-icon {
	width: 52px;
	height: 52px;
	border-radius: 50%;
	background: rgba(159, 122, 234, 0.1);
	border: 1px solid rgba(159, 122, 234, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.3rem;
	color: var(--violet);
	margin-bottom: 0.25rem;
}

.welcome-title {
	font-family: 'Syne', sans-serif;
	font-size: 0.95rem;
	font-weight: 700;
	color: var(--sub);
}

.welcome-sub {
	font-size: 0.8rem;
	max-width: 320px;
	line-height: 1.55;
}

/* message bubbles */
.msg-row {
	display: flex;
	align-items: flex-end;
	gap: 0.6rem;
	animation: msgIn 0.3s ease both;
}

.msg-row.user {
	flex-direction: row-reverse;
}

@
keyframes msgIn {from { opacity:0;
	transform: translateY(8px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.msg-avatar {
	width: 28px;
	height: 28px;
	border-radius: 50%;
	flex-shrink: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.75rem;
	font-weight: 700;
}

.msg-avatar.bot {
	background: linear-gradient(135deg, var(--violet), var(--blue));
	color: #fff;
}

.msg-avatar.user {
	background: linear-gradient(135deg, var(--blue), var(--teal));
	color: #fff;
}

.msg-bubble {
	max-width: 75%;
	padding: 0.7rem 1rem;
	border-radius: 14px;
	font-size: 0.875rem;
	line-height: 1.55;
	position: relative;
}

.msg-bubble.bot {
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.08);
	color: var(--sub);
	border-bottom-left-radius: 4px;
}

.msg-bubble.user {
	background: linear-gradient(135deg, rgba(99, 179, 237, 0.2),
		rgba(159, 122, 234, 0.15));
	border: 1px solid rgba(99, 179, 237, 0.25);
	color: var(--text);
	border-bottom-right-radius: 4px;
	text-align: right;
}

.msg-time {
	font-size: 0.62rem;
	color: var(--muted);
	margin-top: 0.25rem;
	display: block;
}

.msg-row.user .msg-time {
	text-align: right;
}

/* typing indicator */
.typing-row {
	display: flex;
	align-items: flex-end;
	gap: 0.6rem;
}

.typing-bubble {
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid rgba(255, 255, 255, 0.08);
	border-radius: 14px;
	border-bottom-left-radius: 4px;
	padding: 0.65rem 1rem;
	display: flex;
	align-items: center;
	gap: 4px;
}

.typing-dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--muted);
	animation: typingBounce 1.2s ease-in-out infinite;
}

.typing-dot:nth-child(2) {
	animation-delay: 0.2s;
}

.typing-dot:nth-child(3) {
	animation-delay: 0.4s;
}

@
keyframes typingBounce { 0%,80%,100% {
	transform: translateY(0);
	opacity: 0.4;
}

40
%
{
transform
:
translateY(
-6px
);
opacity
:
1;
}
}

/* ── input bar ── */
.chat-input-bar {
	padding: 0.9rem 1.2rem;
	border-top: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 0.6rem;
	flex-shrink: 0;
	position: relative;
	z-index: 1;
}

#userInput {
	flex: 1;
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	border-radius: 50px;
	color: var(--text);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	padding: 0.62rem 1.1rem;
	outline: none;
	transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
}

#userInput::placeholder {
	color: var(--muted);
}

#userInput:focus {
	background: rgba(255, 255, 255, 0.07);
	border-color: rgba(159, 122, 234, 0.4);
	box-shadow: 0 0 0 3px rgba(159, 122, 234, 0.1);
}

.send-btn {
	width: 42px;
	height: 42px;
	border-radius: 50%;
	flex-shrink: 0;
	background: linear-gradient(135deg, var(--violet), var(--blue));
	border: none;
	color: #fff;
	font-size: 1rem;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 14px rgba(159, 122, 234, 0.3);
}

.send-btn:hover {
	transform: scale(1.1);
	filter: brightness(1.1);
	box-shadow: 0 6px 18px rgba(159, 122, 234, 0.45);
}

.send-btn:active {
	transform: scale(0.95);
}

/* char count */
.char-count {
	font-size: 0.65rem;
	color: var(--muted);
	min-width: 32px;
	text-align: right;
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
@media ( max-width : 600px) {
	.page-wrap {
		padding: 1.2rem 1rem 1rem;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.msg-bubble {
		max-width: 88%;
	}
	.topic-chips {
		gap: 0.4rem;
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
				<div class="page-eyebrow">Student · Assistant</div>
				<h1 class="page-title">Chatbot</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<!-- QUICK TOPIC CHIPS -->
		<div class="topic-chips">
			<div class="topic-chip" onclick="quickAsk('What is my attendance?')">
				<i class="bi bi-clipboard2-check-fill"></i> Attendance
			</div>
			<div class="topic-chip" onclick="quickAsk('What are my marks?')">
				<i class="bi bi-bar-chart-fill"></i> Marks
			</div>
			<div class="topic-chip"
				onclick="quickAsk('What are my pending fees?')">
				<i class="bi bi-cash-stack"></i> Fees
			</div>
			<div class="topic-chip"
				onclick="quickAsk('Show me placement opportunities')">
				<i class="bi bi-briefcase-fill"></i> Placement
			</div>
			<div class="topic-chip"
				onclick="quickAsk('What books do I have from library?')">
				<i class="bi bi-book-half"></i> Library
			</div>
			<div class="topic-chip" onclick="quickAsk('What is my hostel room?')">
				<i class="bi bi-building"></i> Hostel
			</div>
		</div>

		<!-- CHAT WINDOW -->
		<div class="chat-shell">

			<!-- chat top bar -->
			<div class="chat-header">
				<div class="bot-avatar">
					<i class="bi bi-stars"></i>
				</div>
				<div class="chat-header-info">
					<div class="chat-header-name">ISMS Assistant</div>
					<div class="chat-header-status">
						<span class="status-dot"></span> Online · Ready to help
					</div>
				</div>
				<div class="chat-header-actions">
					<div class="hdr-btn" onclick="clearChat()" title="Clear chat">
						<i class="bi bi-trash3"></i>
					</div>
				</div>
			</div>

			<!-- messages -->
			<div id="chatArea">
				<div class="chat-welcome" id="welcomeMsg">
					<div class="welcome-icon">
						<i class="bi bi-chat-dots-fill"></i>
					</div>
					<div class="welcome-title">Hi! I'm your ISMS Assistant 👋</div>
					<div class="welcome-sub">Ask me about your attendance, marks,
						fees, placement, library or hostel. Use the quick chips above or
						type your question below.</div>
				</div>
			</div>

			<!-- input bar -->
			<div class="chat-input-bar">
				<input type="text" id="userInput" placeholder="Type your question…"
					onkeypress="if(event.key==='Enter') sendMessage()"
					oninput="updateCharCount()" maxlength="300"> <span
					class="char-count" id="charCount">300</span>
				<button class="send-btn" onclick="sendMessage()" title="Send">
					<i class="bi bi-send-fill"></i>
				</button>
			</div>

		</div>

	</div>

	<script>
/* ════════════════════════════════
   CHAT ENGINE — all fetch logic
   unchanged from original
════════════════════════════════ */

var contextPath = '${pageContext.request.contextPath}';

function getTime() {
  var d = new Date();
  var h = String(d.getHours()).padStart(2,'0');
  var m = String(d.getMinutes()).padStart(2,'0');
  return h + ':' + m;
}

function removeWelcome() {
  var w = document.getElementById('welcomeMsg');
  if (w) { w.remove(); }
}

function addUserBubble(msg) {
  removeWelcome();
  var chat = document.getElementById('chatArea');
  var row  = document.createElement('div');
  row.className = 'msg-row user';
  row.innerHTML =
    '<div class="msg-avatar user"><i class="bi bi-person-fill"></i></div>' +
    '<div>' +
      '<div class="msg-bubble user">' + escapeHtml(msg) + '</div>' +
      '<span class="msg-time">' + getTime() + '</span>' +
    '</div>';
  chat.appendChild(row);
  chat.scrollTop = chat.scrollHeight;
}

function addBotBubble(text) {
  var chat = document.getElementById('chatArea');
  var row  = document.createElement('div');
  row.className = 'msg-row';
  row.innerHTML =
    '<div class="msg-avatar bot"><i class="bi bi-stars"></i></div>' +
    '<div>' +
      '<div class="msg-bubble bot">' + text + '</div>' +
      '<span class="msg-time">' + getTime() + '</span>' +
    '</div>';
  chat.appendChild(row);
  chat.scrollTop = chat.scrollHeight;
  return row;
}

function showTyping() {
  var chat = document.getElementById('chatArea');
  var row  = document.createElement('div');
  row.className = 'typing-row'; row.id = 'typingIndicator';
  row.innerHTML =
    '<div class="msg-avatar bot"><i class="bi bi-stars"></i></div>' +
    '<div class="typing-bubble">' +
      '<div class="typing-dot"></div>' +
      '<div class="typing-dot"></div>' +
      '<div class="typing-dot"></div>' +
    '</div>';
  chat.appendChild(row);
  chat.scrollTop = chat.scrollHeight;
}

function removeTyping() {
  var t = document.getElementById('typingIndicator');
  if (t) t.remove();
}

function escapeHtml(str) {
  return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function updateCharCount() {
  var input = document.getElementById('userInput');
  var cc    = document.getElementById('charCount');
  if (cc) cc.textContent = 300 - input.value.length;
}

/* ── SEND MESSAGE (unchanged fetch logic) ── */
function sendMessage() {
  var input   = document.getElementById('userInput');
  var message = input.value.trim();
  if (!message) return;

  addUserBubble(message);
  input.value = '';
  updateCharCount();
  showTyping();

  fetch(contextPath + '/student/chatbot', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'query=' + encodeURIComponent(message)
  })
  .then(function(res) { return res.json(); })
  .then(function(data) {
    removeTyping();
    addBotBubble(data.response);
  })
  .catch(function() {
    removeTyping();
    addBotBubble('Sorry, I encountered an error. Please try again.');
  });
}

/* ── QUICK ASK ── */
function quickAsk(text) {
  var input = document.getElementById('userInput');
  input.value = text;
  sendMessage();
}

/* ── CLEAR CHAT ── */
function clearChat() {
  var chat = document.getElementById('chatArea');
  chat.innerHTML =
    '<div class="chat-welcome" id="welcomeMsg">' +
      '<div class="welcome-icon"><i class="bi bi-chat-dots-fill"></i></div>' +
      '<div class="welcome-title">Chat cleared!</div>' +
      '<div class="welcome-sub">Ask me anything about your attendance, marks, fees, placement, library or hostel.</div>' +
    '</div>';
}
</script>

</body>
</html>
