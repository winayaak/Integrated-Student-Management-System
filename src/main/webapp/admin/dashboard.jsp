<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.User"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.CourseDAO"%>
<%@ page import="model.FacultyDAO"%>
<%@ page import="model.FeeDAO"%>

<%
User user = (User) session.getAttribute("user");

StudentDAO studentDAO = new StudentDAO();
CourseDAO courseDAO = new CourseDAO();
FacultyDAO facultyDAO = new FacultyDAO();
FeeDAO feeDAO = new FeeDAO();

int totalStudents = studentDAO.findAll().size();
int totalCourses = courseDAO.findAll().size();
int totalFaculty = facultyDAO.findAll().size();

double totalFees = feeDAO.getTotalFees();
double pendingFees = feeDAO.getPendingFees();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  /* ─── RESET & BASE ─── */
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:       #08090d;
    --bg-mid:        #0e1018;
    --bg-card:       rgba(255,255,255,0.04);
    --bg-card-hover: rgba(255,255,255,0.07);
    --border:        rgba(255,255,255,0.08);
    --border-glow:   rgba(99,179,237,0.35);
    --accent-1:      #63b3ed;   /* sky blue  */
    --accent-2:      #9f7aea;   /* violet    */
    --accent-3:      #68d391;   /* emerald   */
    --accent-4:      #fc8181;   /* rose      */
    --accent-5:      #f6ad55;   /* amber     */
    --text-primary:  #f0f4f8;
    --text-muted:    #718096;
    --text-sub:      #a0aec0;
    --radius-lg:     18px;
    --radius-md:     12px;
    --radius-sm:     8px;
    --shadow-card:   0 8px 32px rgba(0,0,0,0.45);
    --shadow-glow-b: 0 0 28px rgba(99,179,237,0.18);
    --shadow-glow-v: 0 0 28px rgba(159,122,234,0.18);
    --shadow-glow-g: 0 0 28px rgba(104,211,145,0.18);
  }

  html, body {
    background: var(--bg-deep);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    min-height: 100vh;
    overflow-x: hidden;
  }

  /* ─── ANIMATED BACKGROUND MESH ─── */
  body::before {
    content: '';
    position: fixed;
    inset: 0;
    background:
      radial-gradient(ellipse 70% 50% at 10% 0%,   rgba(99,179,237,0.10) 0%, transparent 60%),
      radial-gradient(ellipse 50% 60% at 90% 20%,  rgba(159,122,234,0.09) 0%, transparent 55%),
      radial-gradient(ellipse 60% 40% at 50% 100%, rgba(104,211,145,0.07) 0%, transparent 50%);
    pointer-events: none;
    z-index: 0;
  }

  /* Noise grain overlay */
  body::after {
    content: '';
    position: fixed;
    inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
    pointer-events: none;
    z-index: 0;
    opacity: 0.6;
  }

  /* ─── WRAPPER ─── */
  .dash-wrapper {
    position: relative;
    z-index: 1;
    max-width: 1200px;
    margin: 0 auto;
    padding: 2.5rem 1.5rem 4rem;
  }

  /* ─── PAGE HEADER ─── */
  .page-header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 1rem;
    margin-bottom: 2.8rem;
    animation: fadeSlideDown 0.55s ease both;
  }

  .page-header-left {}

  .page-eyebrow {
    font-family: 'DM Sans', sans-serif;
    font-size: 0.72rem;
    font-weight: 500;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--accent-1);
    margin-bottom: 0.35rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  .page-eyebrow::before {
    content: '';
    display: inline-block;
    width: 18px; height: 2px;
    background: var(--accent-1);
    border-radius: 2px;
  }

  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.9rem, 4vw, 2.75rem);
    font-weight: 800;
    line-height: 1.1;
    letter-spacing: -0.03em;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-1) 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }

  .page-subtitle {
    margin-top: 0.5rem;
    font-size: 0.9rem;
    color: var(--text-sub);
    font-weight: 300;
  }
  .page-subtitle strong {
    color: var(--text-primary);
    font-weight: 500;
  }

  /* ─── GREETING BADGE ─── */
  .greeting-badge {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 50px;
    padding: 0.55rem 1.1rem;
    font-size: 0.85rem;
    color: var(--text-sub);
    backdrop-filter: blur(12px);
    animation: fadeSlideDown 0.55s 0.1s ease both;
    white-space: nowrap;
  }
  .greeting-badge .avatar {
    width: 32px; height: 32px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-1), var(--accent-2));
    display: flex; align-items: center; justify-content: center;
    font-size: 0.8rem;
    font-weight: 700;
    color: #fff;
    text-transform: uppercase;
    flex-shrink: 0;
  }
  .greeting-badge .name { color: var(--text-primary); font-weight: 500; }

  /* ─── SECTION LABEL ─── */
  .section-label {
    font-family: 'DM Sans', sans-serif;
    font-size: 0.7rem;
    font-weight: 500;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: var(--text-muted);
    margin-bottom: 1rem;
    padding-left: 2px;
  }

  /* ─── STAT CARDS ─── */
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .stat-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 1.5rem 1.6rem;
    backdrop-filter: blur(16px);
    box-shadow: var(--shadow-card);
    position: relative;
    overflow: hidden;
    cursor: default;
    transition: transform 0.28s cubic-bezier(.22,.68,0,1.2),
                border-color 0.28s ease,
                box-shadow 0.28s ease;
    animation: fadeSlideUp 0.5s ease both;
  }

  .stat-card::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: inherit;
    background: linear-gradient(135deg, rgba(255,255,255,0.04) 0%, transparent 60%);
    pointer-events: none;
  }

  /* Top accent line */
  .stat-card::after {
    content: '';
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 2px;
    border-radius: 2px 2px 0 0;
    background: var(--card-accent, var(--accent-1));
    opacity: 0.7;
    transition: opacity 0.25s;
  }

  .stat-card:hover {
    transform: translateY(-4px);
    border-color: rgba(255,255,255,0.14);
    box-shadow: var(--shadow-card), var(--card-shadow, var(--shadow-glow-b));
  }
  .stat-card:hover::after { opacity: 1; }

  .stat-card.c-students  { --card-accent: var(--accent-1); --card-shadow: var(--shadow-glow-b); animation-delay: 0.05s; }
  .stat-card.c-faculty   { --card-accent: var(--accent-2); --card-shadow: var(--shadow-glow-v); animation-delay: 0.1s;  }
  .stat-card.c-courses   { --card-accent: var(--accent-3); --card-shadow: var(--shadow-glow-g); animation-delay: 0.15s; }
  .stat-card.c-collected { --card-accent: var(--accent-3); --card-shadow: var(--shadow-glow-g); animation-delay: 0.2s;  }
  .stat-card.c-pending   { --card-accent: var(--accent-4); --card-shadow: 0 0 28px rgba(252,129,129,0.18); animation-delay: 0.25s; }

  .stat-icon {
    width: 40px; height: 40px;
    border-radius: var(--radius-sm);
    background: rgba(255,255,255,0.07);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
    margin-bottom: 1.1rem;
    color: var(--card-accent, var(--accent-1));
    border: 1px solid rgba(255,255,255,0.06);
  }

  .stat-label {
    font-size: 0.75rem;
    font-weight: 400;
    color: var(--text-muted);
    letter-spacing: 0.04em;
    margin-bottom: 0.35rem;
    text-transform: uppercase;
  }

  .stat-value {
    font-family: 'Syne', sans-serif;
    font-size: 2.2rem;
    font-weight: 800;
    letter-spacing: -0.03em;
    line-height: 1;
    color: var(--text-primary);
  }
  .stat-value.rupee {
    font-size: 1.75rem;
  }
  .stat-value .rupee-sym {
    font-size: 0.65em;
    font-weight: 500;
    opacity: 0.7;
    vertical-align: super;
    margin-right: 1px;
  }

  /* ─── QUICK LINKS ─── */
  .links-section { animation: fadeSlideUp 0.55s 0.3s ease both; }

  .links-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 0.75rem;
  }

  .quick-link {
    display: flex;
    align-items: center;
    gap: 0.9rem;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 1rem 1.2rem;
    text-decoration: none;
    color: var(--text-primary);
    backdrop-filter: blur(12px);
    transition: background 0.22s ease,
                border-color 0.22s ease,
                transform 0.22s cubic-bezier(.22,.68,0,1.2),
                box-shadow 0.22s ease;
    position: relative;
    overflow: hidden;
  }

  .quick-link::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.02));
    opacity: 0;
    transition: opacity 0.25s;
  }

  .quick-link:hover {
    background: var(--bg-card-hover);
    border-color: rgba(255,255,255,0.15);
    transform: translateX(4px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.3);
    color: #fff;
  }
  .quick-link:hover::before { opacity: 1; }

  .ql-icon {
    width: 36px; height: 36px;
    border-radius: var(--radius-sm);
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem;
    flex-shrink: 0;
    transition: transform 0.22s ease;
  }
  .quick-link:hover .ql-icon { transform: scale(1.1); }

  .ql-text { flex: 1; }
  .ql-name {
    font-size: 0.9rem;
    font-weight: 500;
    display: block;
  }
  .ql-desc {
    font-size: 0.73rem;
    color: var(--text-muted);
    margin-top: 1px;
    display: block;
  }

  .ql-arrow {
    color: var(--text-muted);
    font-size: 0.85rem;
    transition: transform 0.22s ease, color 0.22s ease;
  }
  .quick-link:hover .ql-arrow {
    transform: translateX(3px);
    color: var(--text-sub);
  }

  /* Individual link color accents */
  .ql-students .ql-icon { background: rgba(99,179,237,0.12); color: var(--accent-1); }
  .ql-faculty  .ql-icon { background: rgba(159,122,234,0.12); color: var(--accent-2); }
  .ql-courses  .ql-icon { background: rgba(104,211,145,0.12); color: var(--accent-3); }
  .ql-fees     .ql-icon { background: rgba(246,173,85,0.12);  color: var(--accent-5); }
  .ql-library  .ql-icon { background: rgba(99,179,237,0.10);  color: #76e4f7; }
  .ql-hostel   .ql-icon { background: rgba(252,129,129,0.10); color: var(--accent-4); }
  .ql-place    .ql-icon { background: rgba(104,211,145,0.10); color: #9ae6b4; }
  .ql-ai       .ql-icon { background: rgba(159,122,234,0.14); color: #d6bcfa; }

  /* ─── DIVIDER ─── */
  .dash-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border), transparent);
    margin: 2.2rem 0;
  }

  /* ─── ANIMATIONS ─── */
  @keyframes fadeSlideDown {
    from { opacity: 0; transform: translateY(-16px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  @keyframes fadeSlideUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ─── SCROLLBAR ─── */
  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }
  ::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.18); }

  /* ─── RESPONSIVE ─── */
  @media (max-width: 768px) {
    .dash-wrapper { padding: 1.5rem 1rem 3rem; }
    .page-header { flex-direction: column; gap: 0.75rem; }
    .stat-value { font-size: 1.9rem; }
    .stat-value.rupee { font-size: 1.5rem; }
    .links-grid { grid-template-columns: 1fr; }
    .stats-grid { grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); }
  }

  /* ─── COUNTER ANIMATION ─── */
  .counter { display: inline-block; }
</style>
</head>

<body>

<%@ include file="/WEB-INF/includes/header.jsp"%>

<div class="dash-wrapper">

  <!-- PAGE HEADER -->
  <div class="page-header">
    <div class="page-header-left">
      <div class="page-eyebrow">Admin Dashboard</div>
      <h1 class="page-title">Welcome back<br>to your HQ.</h1>
      <p class="page-subtitle">
        Here's what's happening at
        <strong>Integrated Student Management</strong> today.
      </p>
    </div>

    <div class="greeting-badge">
      <div class="avatar"><%= user.getUsername().length() > 0 ? String.valueOf(user.getUsername().charAt(0)) : "A" %></div>
      <span>Logged in as&nbsp;<span class="name"><%= user.getUsername() %></span></span>
    </div>
  </div>

  <!-- ── STATS SECTION ── -->
  <div class="section-label">Overview</div>

  <div class="stats-grid mb-4">

    <div class="stat-card c-students">
      <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
      <div class="stat-label">Total Students</div>
      <div class="stat-value counter" data-target="<%= totalStudents %>">0</div>
    </div>

    <div class="stat-card c-faculty">
      <div class="stat-icon"><i class="bi bi-person-workspace"></i></div>
      <div class="stat-label">Total Faculty</div>
      <div class="stat-value counter" data-target="<%= totalFaculty %>">0</div>
    </div>

    <div class="stat-card c-courses">
      <div class="stat-icon"><i class="bi bi-journal-bookmark-fill"></i></div>
      <div class="stat-label">Total Courses</div>
      <div class="stat-value counter" data-target="<%= totalCourses %>">0</div>
    </div>

    <div class="stat-card c-collected">
      <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
      <div class="stat-label">Fees Collected</div>
      <div class="stat-value rupee">
        <span class="rupee-sym">₹</span><span class="counter" data-target="<%= (long) totalFees %>" data-prefix="">0</span>
      </div>
    </div>

    <div class="stat-card c-pending">
      <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
      <div class="stat-label">Pending Fees</div>
      <div class="stat-value rupee">
        <span class="rupee-sym">₹</span><span class="counter" data-target="<%= (long) pendingFees %>">0</span>
      </div>
    </div>

  </div>

  <div class="dash-divider"></div>

  <!-- ── QUICK LINKS ── -->
  <div class="links-section">
    <div class="section-label">Quick Actions</div>

    <div class="links-grid">

      <a href="${pageContext.request.contextPath}/admin/students" class="quick-link ql-students">
        <div class="ql-icon"><i class="bi bi-people-fill"></i></div>
        <div class="ql-text">
          <span class="ql-name">Manage Students</span>
          <span class="ql-desc">Enroll, edit & track students</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/faculty" class="quick-link ql-faculty">
        <div class="ql-icon"><i class="bi bi-person-workspace"></i></div>
        <div class="ql-text">
          <span class="ql-name">Manage Faculty</span>
          <span class="ql-desc">Faculty records & assignments</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/courses" class="quick-link ql-courses">
        <div class="ql-icon"><i class="bi bi-journal-bookmark-fill"></i></div>
        <div class="ql-text">
          <span class="ql-name">Manage Courses</span>
          <span class="ql-desc">Curriculum & course setup</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/fees" class="quick-link ql-fees">
        <div class="ql-icon"><i class="bi bi-cash-stack"></i></div>
        <div class="ql-text">
          <span class="ql-name">Fee Management</span>
          <span class="ql-desc">Payments, dues & receipts</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/library" class="quick-link ql-library">
        <div class="ql-icon"><i class="bi bi-book-half"></i></div>
        <div class="ql-text">
          <span class="ql-name">Library</span>
          <span class="ql-desc">Books, issues & returns</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/hostel" class="quick-link ql-hostel">
        <div class="ql-icon"><i class="bi bi-building"></i></div>
        <div class="ql-text">
          <span class="ql-name">Hostel</span>
          <span class="ql-desc">Rooms, allotments & wardens</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/placement" class="quick-link ql-place">
        <div class="ql-icon"><i class="bi bi-briefcase-fill"></i></div>
        <div class="ql-text">
          <span class="ql-name">Placement</span>
          <span class="ql-desc">Drives, offers & statistics</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

      <a href="${pageContext.request.contextPath}/admin/ai-insights" class="quick-link ql-ai">
        <div class="ql-icon"><i class="bi bi-stars"></i></div>
        <div class="ql-text">
          <span class="ql-name">AI Insights</span>
          <span class="ql-desc">Smart analytics & predictions</span>
        </div>
        <i class="bi bi-arrow-right ql-arrow"></i>
      </a>

    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ── Animated counter ── */
(function () {
  function easeOut(t) { return 1 - Math.pow(1 - t, 3); }

  function animateCounter(el) {
    var target = parseInt(el.getAttribute('data-target'), 10);
    if (isNaN(target)) return;
    var duration = 900;
    var start = null;

    function step(ts) {
      if (!start) start = ts;
      var elapsed = ts - start;
      var progress = Math.min(elapsed / duration, 1);
      var value = Math.round(easeOut(progress) * target);
      el.textContent = value.toLocaleString('en-IN');
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  /* Trigger when visible */
  var counters = document.querySelectorAll('.counter');

  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) {
          animateCounter(e.target);
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.3 });
    counters.forEach(function (c) { io.observe(c); });
  } else {
    counters.forEach(animateCounter);
  }
})();
</script>

</body>
</html>