<%@ page
	import="java.util.*,java.sql.*,model.QuestionDAO,model.Question,util.DBConnection"%>

<%
int examId = Integer.parseInt(request.getParameter("examId"));

HttpSession sessionObj = request.getSession();
Integer studentId = (Integer) sessionObj.getAttribute("userId");
if (studentId == null) {
	studentId = 1; // fallback if session not set
}

boolean alreadyAttempted = false;

try {
	Connection conn = DBConnection.getConnection();

	PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM exam_results WHERE student_id=? AND exam_id=?");

	ps.setInt(1, studentId);
	ps.setInt(2, examId);

	ResultSet rs = ps.executeQuery();

	if (rs.next()) {
		alreadyAttempted = true;
	}

} catch (Exception e) {
	e.printStackTrace();
}

QuestionDAO dao = new QuestionDAO();
List<Question> questions = dao.getQuestionsByExamId(examId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Online Exam — ISMS</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --bg:       #08090d;
  --bg-card:  rgba(255,255,255,0.04);
  --bg-hover: rgba(255,255,255,0.07);
  --border:   rgba(255,255,255,0.08);
  --blue:     #63b3ed;
  --violet:   #9f7aea;
  --green:    #68d391;
  --amber:    #f6ad55;
  --red:      #fc8181;
  --teal:     #4fd1c5;
  --text:     #f0f4f8;
  --sub:      #a0aec0;
  --muted:    #4a5568;
  --r-lg:     18px;
  --r-md:     12px;
  --r-sm:     8px;
  --shadow:   0 8px 32px rgba(0,0,0,0.5);
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
  position: fixed; inset: 0;
  background:
    radial-gradient(ellipse 60% 50% at 5%  0%,   rgba(99,179,237,0.09)  0%, transparent 60%),
    radial-gradient(ellipse 50% 55% at 98% 8%,   rgba(159,122,234,0.08) 0%, transparent 55%),
    radial-gradient(ellipse 55% 40% at 50% 100%, rgba(104,211,145,0.06) 0%, transparent 50%);
  pointer-events: none; z-index: 0;
}
body::after {
  content: '';
  position: fixed; inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
  pointer-events: none; z-index: 0; opacity: 0.55;
}

/* ── layout ── */
.page-wrap {
  position: relative; z-index: 1;
  max-width: 820px; margin: 0 auto;
  padding: 2.5rem 1.5rem 6rem;
}

/* ── page header ── */
.page-header {
  display: flex; align-items: flex-end; justify-content: space-between;
  flex-wrap: wrap; gap: 1rem; margin-bottom: 2rem;
  animation: fadeDown 0.5s ease both;
}
.page-eyebrow {
  font-size: 0.7rem; font-weight: 500;
  letter-spacing: 0.18em; text-transform: uppercase;
  color: var(--blue);
  display: flex; align-items: center; gap: 0.45rem; margin-bottom: 0.3rem;
}
.page-eyebrow::before {
  content: ''; display: inline-block; width: 16px; height: 2px;
  background: var(--blue); border-radius: 2px;
}
.page-title {
  font-family: 'Syne', sans-serif;
  font-size: clamp(1.8rem, 3.5vw, 2.5rem);
  font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
  background: linear-gradient(130deg, #f0f4f8 30%, var(--blue) 100%);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* exam meta badges */
.exam-meta { display: flex; gap: 0.6rem; flex-wrap: wrap; margin-top: 0.5rem; }
.meta-pill {
  display: inline-flex; align-items: center; gap: 0.35rem;
  background: rgba(255,255,255,0.05); border: 1px solid var(--border);
  border-radius: 50px; padding: 0.28rem 0.75rem;
  font-size: 0.73rem; color: var(--sub);
}
.meta-pill i { font-size: 0.7rem; color: var(--blue); }

/* ── timer bar ── */
.timer-bar-wrap {
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-md); padding: 0.85rem 1.2rem;
  display: flex; align-items: center; gap: 1rem;
  margin-bottom: 1.8rem;
  animation: fadeDown 0.5s 0.06s ease both;
  backdrop-filter: blur(14px);
}
.timer-display {
  font-family: 'Syne', sans-serif; font-size: 1.25rem; font-weight: 800;
  letter-spacing: -0.03em; color: var(--text); white-space: nowrap;
  min-width: 80px;
}
.timer-display.warning { color: var(--amber); }
.timer-display.danger  { color: var(--red); animation: timerPulse 0.8s ease-in-out infinite; }
.timer-track {
  flex: 1; height: 6px; border-radius: 3px;
  background: rgba(255,255,255,0.06); overflow: hidden;
}
.timer-fill {
  height: 100%; border-radius: 3px;
  background: linear-gradient(90deg, var(--blue), var(--teal));
  transition: width 1s linear, background 1s ease;
}
.timer-label { font-size: 0.72rem; color: var(--muted); white-space: nowrap; }

@keyframes timerPulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.5; }
}

/* ── progress tracker ── */
.progress-tracker {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 1.5rem;
  animation: fadeDown 0.5s 0.08s ease both;
}
.pt-label { font-size: 0.78rem; color: var(--muted); }
.pt-count {
  font-family: 'Syne', sans-serif; font-size: 0.88rem; font-weight: 700;
  color: var(--text);
}
.pt-bar-track {
  flex: 1; height: 4px; border-radius: 2px;
  background: rgba(255,255,255,0.06); overflow: hidden;
  margin: 0 1rem;
}
.pt-bar-fill {
  height: 100%; border-radius: 2px; width: 0%;
  background: linear-gradient(90deg, var(--blue), var(--violet));
  transition: width 0.4s ease;
}

/* ── question card ── */
.question-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--r-lg);
  backdrop-filter: blur(18px);
  box-shadow: var(--shadow);
  position: relative; overflow: hidden;
  margin-bottom: 1rem;
  animation: fadeUp 0.4s ease both;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.question-card::before {
  content: ''; position: absolute; inset: 0;
  background: linear-gradient(135deg, rgba(255,255,255,0.03) 0%, transparent 55%);
  pointer-events: none;
}
.question-card.answered {
  border-color: rgba(99,179,237,0.25);
  box-shadow: var(--shadow), 0 0 20px rgba(99,179,237,0.06);
}
.question-card.answered::after {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
  background: linear-gradient(90deg, var(--blue), var(--violet));
  border-radius: 2px 2px 0 0;
}

.q-header {
  padding: 1.1rem 1.4rem 0.75rem;
  display: flex; align-items: flex-start; gap: 0.85rem;
}
.q-num-badge {
  width: 30px; height: 30px; border-radius: 50%;
  background: rgba(99,179,237,0.1); border: 1px solid rgba(99,179,237,0.2);
  display: flex; align-items: center; justify-content: center;
  font-family: 'Syne', sans-serif; font-size: 0.78rem; font-weight: 800;
  color: var(--blue); flex-shrink: 0; margin-top: 1px;
}
.q-text {
  font-size: 0.95rem; font-weight: 500; color: var(--text);
  line-height: 1.55; flex: 1;
}

/* options */
.q-options { padding: 0.25rem 1.4rem 1.3rem 1.4rem; }

.option-label {
  display: flex; align-items: center; gap: 0.85rem;
  padding: 0.7rem 1rem;
  border-radius: var(--r-sm);
  border: 1px solid transparent;
  cursor: pointer;
  transition: background 0.18s, border-color 0.18s, transform 0.15s;
  margin-bottom: 0.45rem;
  position: relative;
}
.option-label:last-child { margin-bottom: 0; }
.option-label:hover {
  background: rgba(255,255,255,0.05);
  border-color: rgba(255,255,255,0.1);
  transform: translateX(3px);
}

/* hide native radio */
.option-label input[type="radio"] { display: none; }

/* custom radio circle */
.radio-circle {
  width: 20px; height: 20px; border-radius: 50%; flex-shrink: 0;
  border: 2px solid var(--muted);
  display: flex; align-items: center; justify-content: center;
  transition: border-color 0.18s, background 0.18s;
  position: relative;
}
.radio-circle::after {
  content: ''; width: 8px; height: 8px; border-radius: 50%;
  background: var(--blue); opacity: 0;
  transition: opacity 0.18s, transform 0.18s;
  transform: scale(0.5);
}

.option-letter {
  width: 22px; height: 22px; border-radius: 6px; flex-shrink: 0;
  background: rgba(255,255,255,0.05); border: 1px solid var(--border);
  display: flex; align-items: center; justify-content: center;
  font-family: 'Syne', sans-serif; font-size: 0.72rem; font-weight: 800;
  color: var(--muted);
  transition: background 0.18s, border-color 0.18s, color 0.18s;
}
.option-text { font-size: 0.88rem; color: var(--sub); flex: 1; transition: color 0.18s; }

/* checked state */
.option-label:has(input:checked) {
  background: rgba(99,179,237,0.08);
  border-color: rgba(99,179,237,0.3);
  transform: translateX(3px);
}
.option-label:has(input:checked) .radio-circle {
  border-color: var(--blue);
}
.option-label:has(input:checked) .radio-circle::after {
  opacity: 1; transform: scale(1);
}
.option-label:has(input:checked) .option-letter {
  background: rgba(99,179,237,0.15); border-color: rgba(99,179,237,0.35);
  color: var(--blue);
}
.option-label:has(input:checked) .option-text { color: var(--text); font-weight: 500; }

/* ── submit section ── */
.submit-section {
  margin-top: 2rem;
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-lg); padding: 1.5rem 1.6rem;
  display: flex; align-items: center; justify-content: space-between;
  flex-wrap: wrap; gap: 1rem;
  animation: fadeUp 0.5s ease both;
  backdrop-filter: blur(14px);
}
.submit-info { font-size: 0.82rem; color: var(--muted); }
.submit-info strong { color: var(--text); font-weight: 500; }

.btn-submit {
  display: inline-flex; align-items: center; gap: 0.5rem;
  background: linear-gradient(135deg, var(--blue), #2b6cb0);
  border: none; border-radius: var(--r-sm); color: #fff;
  font-family: 'DM Sans', sans-serif; font-size: 0.95rem; font-weight: 500;
  padding: 0.75rem 2rem; cursor: pointer;
  transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
  box-shadow: 0 4px 16px rgba(99,179,237,0.3);
}
.btn-submit:hover {
  transform: translateY(-2px); filter: brightness(1.1);
  box-shadow: 0 6px 22px rgba(99,179,237,0.44);
}
.btn-submit:active { transform: translateY(0); }

/* ── already attempted screen ── */
.attempted-card {
  background: var(--bg-card); border: 1px solid rgba(252,129,129,0.2);
  border-radius: var(--r-lg); padding: 3.5rem 2rem;
  text-align: center; backdrop-filter: blur(18px);
  box-shadow: var(--shadow);
  animation: fadeUp 0.5s ease both;
}
.attempted-icon {
  width: 64px; height: 64px; border-radius: 50%;
  background: rgba(252,129,129,0.1); border: 1px solid rgba(252,129,129,0.25);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.6rem; color: var(--red);
  margin: 0 auto 1.2rem;
}
.attempted-title {
  font-family: 'Syne', sans-serif; font-size: 1.4rem; font-weight: 800;
  color: var(--text); margin-bottom: 0.5rem;
}
.attempted-sub { font-size: 0.875rem; color: var(--muted); margin-bottom: 1.8rem; }
.back-link {
  display: inline-flex; align-items: center; gap: 0.45rem;
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-sm); color: var(--sub);
  font-family: 'DM Sans', sans-serif; font-size: 0.85rem; font-weight: 500;
  padding: 0.55rem 1.2rem; text-decoration: none;
  transition: background 0.2s, color 0.2s;
}
.back-link:hover { background: var(--bg-hover); color: var(--text); }

/* ── empty questions ── */
.empty-state {
  text-align: center; padding: 3.5rem 1rem; color: var(--muted);
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-lg); animation: fadeUp 0.5s ease both;
}
.empty-state i { font-size: 2.5rem; opacity: 0.25; display: block; margin-bottom: 0.75rem; }
.empty-state p { font-size: 0.88rem; }

/* ── question nav dots ── */
.q-nav {
  display: flex; flex-wrap: wrap; gap: 0.5rem;
  margin-bottom: 1.5rem;
  animation: fadeDown 0.5s 0.1s ease both;
}
.q-dot {
  width: 32px; height: 32px; border-radius: var(--r-sm);
  background: rgba(255,255,255,0.05); border: 1px solid var(--border);
  display: flex; align-items: center; justify-content: center;
  font-family: 'Syne', sans-serif; font-size: 0.72rem; font-weight: 700;
  color: var(--muted); cursor: pointer;
  transition: background 0.18s, border-color 0.18s, color 0.18s;
  text-decoration: none;
}
.q-dot:hover { background: rgba(255,255,255,0.08); color: var(--text); }
.q-dot.done {
  background: rgba(99,179,237,0.12); border-color: rgba(99,179,237,0.3);
  color: var(--blue);
}

.dash-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--border), transparent);
  margin: 1.5rem 0;
}

@keyframes fadeDown { from { opacity:0; transform:translateY(-14px); } to { opacity:1; transform:translateY(0); } }
@keyframes fadeUp   { from { opacity:0; transform:translateY(18px);  } to { opacity:1; transform:translateY(0); } }

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

@media (max-width: 640px) {
  .page-wrap { padding: 1.5rem 1rem 4rem; }
  .page-header { flex-direction: column; align-items: flex-start; }
  .submit-section { flex-direction: column; align-items: flex-start; }
  .btn-submit { width: 100%; justify-content: center; }
  .timer-bar-wrap { flex-wrap: wrap; }
}
</style>
</head>
<body>

<div class="page-wrap">

  <%
  if (alreadyAttempted) {
  %>

  <!-- ═══ ALREADY ATTEMPTED ═══ -->
  <div class="page-header">
    <div>
      <div class="page-eyebrow">Student · Examinations</div>
      <h1 class="page-title">Online Exam</h1>
    </div>
  </div>

  <div class="attempted-card">
    <div class="attempted-icon"><i class="bi bi-shield-x"></i></div>
    <div class="attempted-title">Already Attempted</div>
    <div class="attempted-sub">
      You have already submitted this exam. Each exam can only be attempted once.<br>
      Your results have been recorded.
    </div>
    <a href="dashboard.jsp" class="back-link">
      <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <%
  } else {
  %>

  <!-- ═══ EXAM HEADER ═══ -->
  <div class="page-header">
    <div>
      <div class="page-eyebrow">Student · Examinations</div>
      <h1 class="page-title">Online Exam</h1>
      <div class="exam-meta">
        <span class="meta-pill">
          <i class="bi bi-journal-text"></i> Exam ID #<%= examId %>
        </span>
        <span class="meta-pill">
          <i class="bi bi-question-circle-fill"></i>
          <%= questions.size() %> Question<%= questions.size() != 1 ? "s" : "" %>
        </span>
        <span class="meta-pill">
          <i class="bi bi-shield-check"></i> Secure · One Attempt
        </span>
      </div>
    </div>
  </div>

  <!-- ═══ TIMER BAR ═══ -->
  <div class="timer-bar-wrap">
    <div class="timer-display" id="timerDisplay">60:00</div>
    <div class="timer-track">
      <div class="timer-fill" id="timerFill" style="width:100%;"></div>
    </div>
    <div class="timer-label"><i class="bi bi-clock-fill" style="color:var(--blue);margin-right:4px;"></i>Time Remaining</div>
  </div>

  <!-- ═══ QUESTION NAV DOTS ═══ -->
  <div class="q-nav" id="qNav">
    <%
    int dotIdx = 1;
    for (Question qd : questions) {
    %>
    <a class="q-dot" href="#q<%= dotIdx %>" id="dot<%= dotIdx %>"><%= dotIdx %></a>
    <%
    dotIdx++;
    }
    %>
  </div>

  <!-- ═══ PROGRESS TRACKER ═══ -->
  <div class="progress-tracker">
    <span class="pt-label">Progress</span>
    <div class="pt-bar-track">
      <div class="pt-bar-fill" id="progressBar"></div>
    </div>
    <span class="pt-count"><span id="answeredCount">0</span> / <%= questions.size() %></span>
  </div>

  <!-- ═══ EXAM FORM ═══ -->
  <%
  if (questions != null && !questions.isEmpty()) {
  %>

  <form action="submitExam" method="post" id="examForm">
    <input type="hidden" name="examId" value="<%= examId %>">

    <%
    int i = 1;
    for (Question q : questions) {
    %>

    <div class="question-card" id="q<%= i %>" data-qnum="<%= i %>">

      <div class="q-header">
        <div class="q-num-badge"><%= i %></div>
        <div class="q-text"><%= q.getQuestion() %></div>
      </div>

      <div class="q-options">

        <label class="option-label">
          <input type="radio" name="q<%= q.getId() %>" value="A"
                 onchange="onAnswer(<%= i %>)">
          <div class="radio-circle"></div>
          <div class="option-letter">A</div>
          <div class="option-text"><%= q.getOptionA() %></div>
        </label>

        <label class="option-label">
          <input type="radio" name="q<%= q.getId() %>" value="B"
                 onchange="onAnswer(<%= i %>)">
          <div class="radio-circle"></div>
          <div class="option-letter">B</div>
          <div class="option-text"><%= q.getOptionB() %></div>
        </label>

        <label class="option-label">
          <input type="radio" name="q<%= q.getId() %>" value="C"
                 onchange="onAnswer(<%= i %>)">
          <div class="radio-circle"></div>
          <div class="option-letter">C</div>
          <div class="option-text"><%= q.getOptionC() %></div>
        </label>

        <label class="option-label">
          <input type="radio" name="q<%= q.getId() %>" value="D"
                 onchange="onAnswer(<%= i %>)">
          <div class="radio-circle"></div>
          <div class="option-letter">D</div>
          <div class="option-text"><%= q.getOptionD() %></div>
        </label>

      </div>
    </div>

    <%
    i++;
    }
    %>

    <!-- ═══ SUBMIT SECTION ═══ -->
    <div class="submit-section">
      <div class="submit-info">
        <strong id="submitAnsweredCount">0</strong> of <strong><%= questions.size() %></strong>
        questions answered. Unanswered questions will be marked incorrect.
      </div>
      <button type="submit" class="btn-submit" onclick="return confirmSubmit()">
        <i class="bi bi-send-fill"></i> Submit Exam
      </button>
    </div>

  </form>

  <%
  } else {
  %>

  <div class="empty-state">
    <i class="bi bi-journal-x"></i>
    <p>No questions found for this exam. Please contact your faculty.</p>
  </div>

  <%
  }
  %>

  <%
  }
  %>

</div>

<script>
var TOTAL_Q    = <%= questions.size() %>;
var DURATION_S = 60 * 60; /* 60 minutes — adjust as needed */
var remaining  = DURATION_S;
var answered   = {};
var timerInt   = null;

/* ── TIMER ── */
function formatTime(s) {
  var m = Math.floor(s / 60);
  var sec = s % 60;
  return String(m).padStart(2,'0') + ':' + String(sec).padStart(2,'0');
}

function tickTimer() {
  remaining--;
  if (remaining < 0) {
    clearInterval(timerInt);
    document.getElementById('examForm').submit();
    return;
  }

  var disp  = document.getElementById('timerDisplay');
  var fill  = document.getElementById('timerFill');
  var pct   = (remaining / DURATION_S) * 100;

  disp.textContent = formatTime(remaining);
  fill.style.width = pct + '%';

  if (remaining <= 300) { /* 5 min */
    fill.style.background = 'linear-gradient(90deg,#fc8181,#e53e3e)';
    disp.className = 'timer-display danger';
  } else if (remaining <= 600) { /* 10 min */
    fill.style.background = 'linear-gradient(90deg,#f6ad55,#ed8936)';
    disp.className = 'timer-display warning';
  }
}

if (TOTAL_Q > 0) {
  timerInt = setInterval(tickTimer, 1000);
}

/* ── ON ANSWER ── */
function onAnswer(qNum) {
  answered[qNum] = true;
  updateProgress();

  /* mark card as answered */
  var card = document.getElementById('q' + qNum);
  if (card) card.classList.add('answered');

  /* mark nav dot as done */
  var dot = document.getElementById('dot' + qNum);
  if (dot) dot.classList.add('done');
}

function updateProgress() {
  var count = Object.keys(answered).length;
  var pct   = TOTAL_Q > 0 ? (count / TOTAL_Q) * 100 : 0;

  var pb = document.getElementById('progressBar');
  if (pb) pb.style.width = pct + '%';

  var ac = document.getElementById('answeredCount');
  if (ac) ac.textContent = count;

  var sc = document.getElementById('submitAnsweredCount');
  if (sc) sc.textContent = count;
}

/* ── CONFIRM SUBMIT ── */
function confirmSubmit() {
  var count = Object.keys(answered).length;
  var unanswered = TOTAL_Q - count;
  if (unanswered > 0) {
    return confirm(unanswered + ' question(s) unanswered. Submit anyway?');
  }
  return confirm('Submit exam? This cannot be undone.');
}
</script>

</body>
</html>
