<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Faculty Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:       #08090d;
    --bg-sidebar:    #0c0d14;
    --bg-card:       rgba(255,255,255,0.04);
    --bg-card-hover: rgba(255,255,255,0.07);
    --border:        rgba(255,255,255,0.08);
    --accent-blue:   #63b3ed;
    --accent-violet: #9f7aea;
    --accent-green:  #68d391;
    --accent-red:    #fc8181;
    --accent-amber:  #f6ad55;
    --accent-teal:   #4fd1c5;
    --accent-pink:   #f687b3;
    --text-primary:  #f0f4f8;
    --text-sub:      #a0aec0;
    --text-muted:    #4a5568;
    --sidebar-w:     240px;
    --radius-lg:     18px;
    --radius-md:     12px;
    --radius-sm:     8px;
    --shadow-card:   0 8px 32px rgba(0,0,0,0.5);
  }

  html, body {
    background: var(--bg-deep);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    min-height: 100vh;
    overflow-x: hidden;
  }

  /* mesh */
  body::before {
    content: '';
    position: fixed; inset: 0;
    background:
      radial-gradient(ellipse 60% 50% at 5% 0%,    rgba(159,122,234,0.10) 0%, transparent 60%),
      radial-gradient(ellipse 45% 55% at 100% 10%,  rgba(99,179,237,0.08)  0%, transparent 55%),
      radial-gradient(ellipse 50% 40% at 50% 100%,  rgba(104,211,145,0.06) 0%, transparent 50%);
    pointer-events: none; z-index: 0;
  }
  body::after {
    content: '';
    position: fixed; inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
    pointer-events: none; z-index: 0; opacity: 0.55;
  }

  /* ── layout ── */
  .layout {
    display: flex; min-height: 100vh;
    position: relative; z-index: 1;
  }

  /* ══════════════ SIDEBAR ══════════════ */
  .sidebar {
    width: var(--sidebar-w); flex-shrink: 0;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border);
    display: flex; flex-direction: column;
    padding: 2rem 1.2rem;
    position: sticky; top: 0; height: 100vh;
    overflow-y: auto;
  }

  .sidebar-brand {
    display: flex; align-items: center; gap: 0.65rem;
    margin-bottom: 2.5rem; padding-bottom: 1.5rem;
    border-bottom: 1px solid var(--border);
  }
  .brand-icon {
    width: 36px; height: 36px; border-radius: var(--radius-sm);
    background: linear-gradient(135deg, var(--accent-violet), var(--accent-blue));
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; color: #fff; flex-shrink: 0;
  }
  .brand-text {
    font-family: 'Syne', sans-serif;
    font-size: 1rem; font-weight: 800; letter-spacing: -0.02em;
    color: var(--text-primary); line-height: 1.1;
  }
  .brand-sub { font-size: 0.67rem; color: var(--text-muted); letter-spacing: 0.06em; }

  .sidebar-section-label {
    font-size: 0.62rem; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--text-muted); padding: 0 0.5rem; margin-bottom: 0.5rem;
  }

  .nav-list { list-style: none; display: flex; flex-direction: column; gap: 0.18rem; }

  .nav-item a {
    display: flex; align-items: center; gap: 0.7rem;
    padding: 0.58rem 0.75rem; border-radius: var(--radius-sm);
    text-decoration: none; color: var(--text-sub);
    font-size: 0.875rem; font-weight: 400;
    transition: background 0.18s, color 0.18s, transform 0.18s;
    position: relative;
  }
  .nav-item a:hover {
    background: rgba(255,255,255,0.06);
    color: var(--text-primary); transform: translateX(2px);
  }
  .nav-item.active a {
    background: rgba(159,122,234,0.1);
    color: var(--accent-violet); font-weight: 500;
    border: 1px solid rgba(159,122,234,0.15);
  }
  .nav-item.active a::before {
    content: ''; position: absolute; left: 0; top: 20%; bottom: 20%;
    width: 3px; border-radius: 0 3px 3px 0; background: var(--accent-violet);
  }
  .nav-icon { font-size: 1rem; flex-shrink: 0; width: 18px; text-align: center; }

  .sidebar-spacer { flex: 1; min-height: 1.5rem; }

  .logout-item a {
    display: flex; align-items: center; gap: 0.7rem;
    padding: 0.58rem 0.75rem; border-radius: var(--radius-sm);
    text-decoration: none; color: var(--accent-red);
    font-size: 0.875rem; opacity: 0.75;
    transition: background 0.18s, opacity 0.18s;
  }
  .logout-item a:hover { background: rgba(252,129,129,0.08); opacity: 1; }

  /* ══════════════ MAIN ══════════════ */
  .main-content {
    flex: 1; padding: 2.5rem 2rem 5rem; overflow-x: hidden;
  }

  /* page header */
  .page-header {
    margin-bottom: 2.5rem;
    animation: fadeDown 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 0.7rem; font-weight: 500;
    letter-spacing: 0.18em; text-transform: uppercase;
    color: var(--accent-violet);
    display: flex; align-items: center; gap: 0.45rem;
    margin-bottom: 0.3rem;
  }
  .page-eyebrow::before {
    content: ''; display: inline-block;
    width: 16px; height: 2px;
    background: var(--accent-violet); border-radius: 2px;
  }
  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.8rem, 3.5vw, 2.6rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-violet) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .page-sub {
    margin-top: 0.4rem; font-size: 0.9rem;
    color: var(--text-muted); font-weight: 300;
  }

  /* section label */
  .section-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--text-muted); margin-bottom: 0.85rem;
  }

  /* ── stat cards ── */
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
    gap: 1rem; margin-bottom: 2.5rem;
    animation: fadeUp 0.5s 0.05s ease both;
  }
  .stat-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 1.25rem 1.3rem;
    backdrop-filter: blur(14px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
    transition: transform 0.25s cubic-bezier(.22,.68,0,1.2),
                border-color 0.25s, box-shadow 0.25s;
    cursor: default;
  }
  .stat-card::before {
    content: ''; position: absolute; inset: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.03) 0%, transparent 60%);
    pointer-events: none;
  }
  .stat-card::after {
    content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
    border-radius: 2px 2px 0 0;
    background: var(--sc-a); opacity: 0.7;
    transition: opacity 0.2s;
  }
  .stat-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-card), var(--sc-glow);
    border-color: rgba(255,255,255,0.12);
  }
  .stat-card:hover::after { opacity: 1; }

  .stat-card.sc-students { --sc-a: var(--accent-blue);   --sc-glow: 0 0 24px rgba(99,179,237,0.18); }
  .stat-card.sc-courses  { --sc-a: var(--accent-green);  --sc-glow: 0 0 24px rgba(104,211,145,0.18); }
  .stat-card.sc-exams    { --sc-a: var(--accent-violet);  --sc-glow: 0 0 24px rgba(159,122,234,0.18); }

  .sc-icon {
    width: 36px; height: 36px; border-radius: var(--radius-sm);
    background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.06);
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; color: var(--sc-a);
    margin-bottom: 0.9rem;
  }
  .sc-label {
    font-size: 0.7rem; text-transform: uppercase;
    letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 0.3rem;
  }
  .sc-value {
    font-family: 'Syne', sans-serif;
    font-size: 2.1rem; font-weight: 800; letter-spacing: -0.04em;
    color: var(--text-primary); line-height: 1;
  }

  /* ── quick-action cards ── */
  .cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 1rem;
    animation: fadeUp 0.5s 0.1s ease both;
  }

  .action-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 1.4rem 1.5rem;
    text-decoration: none;
    backdrop-filter: blur(16px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
    transition: transform 0.25s cubic-bezier(.22,.68,0,1.2),
                border-color 0.25s, box-shadow 0.25s, background 0.25s;
    display: flex; flex-direction: column; gap: 0.5rem;
  }
  .action-card::before {
    content: ''; position: absolute; inset: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.03) 0%, transparent 55%);
    pointer-events: none;
  }
  /* bottom-right glow blob */
  .action-card::after {
    content: ''; position: absolute;
    bottom: -30px; right: -30px;
    width: 90px; height: 90px;
    border-radius: 50%;
    background: var(--ac-color, var(--accent-blue));
    opacity: 0.06; filter: blur(20px);
    transition: opacity 0.3s, transform 0.3s;
    pointer-events: none;
  }
  .action-card:hover {
    transform: translateY(-5px);
    background: var(--bg-card-hover);
    border-color: rgba(255,255,255,0.13);
    box-shadow: var(--shadow-card), 0 0 30px rgba(0,0,0,0.2);
  }
  .action-card:hover::after { opacity: 0.12; transform: scale(1.3); }

  .ac-icon-wrap {
    width: 40px; height: 40px; border-radius: var(--radius-sm);
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.06);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem; color: var(--ac-color, var(--accent-blue));
    margin-bottom: 0.25rem;
    transition: transform 0.22s ease;
  }
  .action-card:hover .ac-icon-wrap { transform: scale(1.08); }

  .ac-title {
    font-family: 'Syne', sans-serif;
    font-size: 1rem; font-weight: 700;
    color: var(--ac-color, var(--accent-blue));
    letter-spacing: -0.01em;
  }
  .ac-desc { font-size: 0.82rem; color: var(--text-muted); font-weight: 300; line-height: 1.4; }

  .ac-arrow {
    margin-top: auto; padding-top: 0.6rem;
    font-size: 0.78rem; color: var(--text-muted);
    display: flex; align-items: center; gap: 0.3rem;
    transition: color 0.2s, transform 0.2s;
  }
  .action-card:hover .ac-arrow {
    color: var(--ac-color, var(--accent-blue));
    transform: translateX(3px);
  }

  /* card accent colors */
  .ac-blue    { --ac-color: var(--accent-blue); }
  .ac-violet  { --ac-color: var(--accent-violet); }
  .ac-red     { --ac-color: var(--accent-red); }
  .ac-green   { --ac-color: var(--accent-green); }
  .ac-amber   { --ac-color: var(--accent-amber); }
  .ac-indigo  { --ac-color: #7f9cf5; }

  /* divider */
  .dash-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border), transparent);
    margin: 2.2rem 0;
  }

  /* animations */
  @keyframes fadeDown { from { opacity: 0; transform: translateY(-14px); } to { opacity: 1; transform: translateY(0); } }
  @keyframes fadeUp   { from { opacity: 0; transform: translateY(18px);  } to { opacity: 1; transform: translateY(0); } }

  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  @media (max-width: 900px) {
    .sidebar { display: none; }
    .main-content { padding: 1.5rem 1rem 3rem; }
  }
  @media (max-width: 540px) {
    .cards-grid { grid-template-columns: 1fr; }
    .stats-grid { grid-template-columns: repeat(3, 1fr); gap: 0.6rem; }
    .sc-value { font-size: 1.6rem; }
  }
</style>
</head>

<body>
<div class="layout">

  <!-- ══════════ SIDEBAR ══════════ -->
  <aside class="sidebar">

    <div class="sidebar-brand">
      <div class="brand-icon"><i class="bi bi-person-workspace"></i></div>
      <div>
        <div class="brand-text">Faculty</div>
        <div class="brand-sub">ISMS Panel</div>
      </div>
    </div>

    <div class="sidebar-section-label">Menu</div>

    <ul class="nav-list">

      <li class="nav-item active">
        <a href="dashboard.jsp">
          <span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>
          Dashboard
        </a>
      </li>

      <li class="nav-item">
        <a href="attendance.jsp">
          <span class="nav-icon"><i class="bi bi-clipboard2-check-fill"></i></span>
          Mark Attendance
        </a>
      </li>

      <li class="nav-item">
        <a href="marks.jsp">
          <span class="nav-icon"><i class="bi bi-pencil-square"></i></span>
          Enter Marks
        </a>
      </li>

      <li class="nav-item">
        <a href="create_exam.jsp">
          <span class="nav-icon"><i class="bi bi-journal-plus"></i></span>
          Create Exam
        </a>
      </li>

      <li class="nav-item">
        <a href="add_questions.jsp">
          <span class="nav-icon"><i class="bi bi-patch-plus-fill"></i></span>
          Add Questions
        </a>
      </li>

      <li class="nav-item">
        <a href="exam_results.jsp">
          <span class="nav-icon"><i class="bi bi-bar-chart-fill"></i></span>
          Exam Results
        </a>
      </li>

      <li class="nav-item">
        <a href="../admin/placement">
          <span class="nav-icon"><i class="bi bi-briefcase-fill"></i></span>
          Placement
        </a>
      </li>

    </ul>

    <div class="sidebar-spacer"></div>

    <ul class="nav-list">
      <li class="logout-item">
        <a href="../logout">
          <span class="nav-icon"><i class="bi bi-box-arrow-left"></i></span>
          Logout
        </a>
      </li>
    </ul>

  </aside>

  <!-- ══════════ MAIN ══════════ -->
  <main class="main-content">

    <!-- header -->
    <div class="page-header">
      <div class="page-eyebrow">Faculty Panel</div>
      <h1 class="page-title">Welcome, Faculty</h1>
      <p class="page-sub">Manage attendance, marks, exams and student performance.</p>
    </div>

    <!-- STATS -->
    <div class="section-label">Overview</div>
    <div class="stats-grid">

      <div class="stat-card sc-students">
        <div class="sc-icon"><i class="bi bi-people-fill"></i></div>
        <div class="sc-label">Students</div>
        <div class="sc-value" id="students">0</div>
      </div>

      <div class="stat-card sc-courses">
        <div class="sc-icon"><i class="bi bi-journal-bookmark-fill"></i></div>
        <div class="sc-label">Courses</div>
        <div class="sc-value" id="courses">0</div>
      </div>

      <div class="stat-card sc-exams">
        <div class="sc-icon"><i class="bi bi-file-earmark-text-fill"></i></div>
        <div class="sc-label">Exams</div>
        <div class="sc-value" id="exams">0</div>
      </div>

    </div>

    <div class="dash-divider"></div>

    <!-- QUICK ACTION CARDS -->
    <div class="section-label">Quick Actions</div>
    <div class="cards-grid">

      <a href="attendance.jsp" class="action-card ac-blue">
        <div class="ac-icon-wrap"><i class="bi bi-clipboard2-check-fill"></i></div>
        <div class="ac-title">Mark Attendance</div>
        <div class="ac-desc">Record daily student attendance for your classes.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

      <a href="marks.jsp" class="action-card ac-violet">
        <div class="ac-icon-wrap"><i class="bi bi-pencil-square"></i></div>
        <div class="ac-title">Enter Marks</div>
        <div class="ac-desc">Add or update student marks and grades.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

      <a href="create_exam.jsp" class="action-card ac-red">
        <div class="ac-icon-wrap"><i class="bi bi-journal-plus"></i></div>
        <div class="ac-title">Create Exam</div>
        <div class="ac-desc">Set up a new online examination for students.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

      <a href="add_questions.jsp" class="action-card ac-green">
        <div class="ac-icon-wrap"><i class="bi bi-patch-plus-fill"></i></div>
        <div class="ac-title">Add Questions</div>
        <div class="ac-desc">Add MCQ questions to your question bank.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

      <a href="exam_results.jsp" class="action-card ac-amber">
        <div class="ac-icon-wrap"><i class="bi bi-bar-chart-fill"></i></div>
        <div class="ac-title">Exam Results</div>
        <div class="ac-desc">View and analyse student exam scores.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

      <a href="../admin/placement" class="action-card ac-indigo">
        <div class="ac-icon-wrap"><i class="bi bi-briefcase-fill"></i></div>
        <div class="ac-title">Placement</div>
        <div class="ac-desc">Manage campus placement drives and activities.</div>
        <div class="ac-arrow"><i class="bi bi-arrow-right"></i> Open</div>
      </a>

    </div>

  </main>
</div>

<!-- ANIMATED COUNTERS (unchanged logic) -->
<script>
  function animateValue(id, start, end, duration) {
    let range     = end - start;
    let current   = start;
    let increment = end > start ? 1 : -1;
    let stepTime  = Math.abs(Math.floor(duration / range));
    let obj       = document.getElementById(id);
    let timer = setInterval(function () {
      current += increment;
      obj.innerHTML = current;
      if (current == end) clearInterval(timer);
    }, stepTime);
  }

  animateValue("students", 0, 5, 1000);
  animateValue("courses",  0, 3, 1000);
  animateValue("exams",    0, 3, 1000);
</script>

</body>
</html>
