<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Placement Management</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:        #08090d;
    --bg-sidebar:     #0c0d14;
    --bg-card:        rgba(255,255,255,0.04);
    --bg-card-hover:  rgba(255,255,255,0.065);
    --border:         rgba(255,255,255,0.08);
    --border-focus:   rgba(99,179,237,0.5);
    --accent-blue:    #63b3ed;
    --accent-violet:  #9f7aea;
    --accent-green:   #68d391;
    --accent-red:     #fc8181;
    --accent-amber:   #f6ad55;
    --accent-teal:    #4fd1c5;
    --text-primary:   #f0f4f8;
    --text-sub:       #a0aec0;
    --text-muted:     #4a5568;
    --sidebar-w:      240px;
    --radius-lg:      18px;
    --radius-md:      12px;
    --radius-sm:      8px;
    --shadow-card:    0 8px 32px rgba(0,0,0,0.5);
  }

  html, body {
    background: var(--bg-deep);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    min-height: 100vh;
    overflow-x: hidden;
  }

  /* ── mesh background ── */
  body::before {
    content: '';
    position: fixed; inset: 0;
    background:
      radial-gradient(ellipse 55% 50% at 15% 0%,   rgba(99,179,237,0.09)  0%, transparent 60%),
      radial-gradient(ellipse 45% 55% at 95% 10%,  rgba(159,122,234,0.08) 0%, transparent 55%),
      radial-gradient(ellipse 50% 40% at 55% 100%, rgba(104,211,145,0.06) 0%, transparent 50%);
    pointer-events: none; z-index: 0;
  }
  body::after {
    content: '';
    position: fixed; inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
    pointer-events: none; z-index: 0; opacity: 0.55;
  }

  /* ══════════════════════════
     LAYOUT
  ══════════════════════════ */
  .layout {
    display: flex;
    min-height: 100vh;
    position: relative; z-index: 1;
  }

  /* ══════════════════════════
     SIDEBAR
  ══════════════════════════ */
  .sidebar {
    width: var(--sidebar-w);
    flex-shrink: 0;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border);
    display: flex; flex-direction: column;
    padding: 2rem 1.2rem;
    position: sticky; top: 0;
    height: 100vh;
    overflow-y: auto;
    backdrop-filter: blur(20px);
  }

  .sidebar-brand {
    display: flex; align-items: center; gap: 0.65rem;
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 1px solid var(--border);
  }
  .brand-icon {
    width: 36px; height: 36px;
    border-radius: var(--radius-sm);
    background: linear-gradient(135deg, var(--accent-blue), var(--accent-violet));
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem; color: #fff; flex-shrink: 0;
  }
  .brand-text {
    font-family: 'Syne', sans-serif;
    font-size: 1rem; font-weight: 800;
    letter-spacing: -0.02em;
    color: var(--text-primary);
    line-height: 1.1;
  }
  .brand-sub {
    font-size: 0.67rem; color: var(--text-muted);
    font-weight: 400; letter-spacing: 0.06em;
  }

  .sidebar-section-label {
    font-size: 0.62rem; font-weight: 600;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--text-muted);
    padding: 0 0.5rem;
    margin-bottom: 0.5rem;
  }

  .nav-list { list-style: none; display: flex; flex-direction: column; gap: 0.2rem; flex: 1; }

  .nav-item a {
    display: flex; align-items: center; gap: 0.7rem;
    padding: 0.6rem 0.75rem;
    border-radius: var(--radius-sm);
    text-decoration: none;
    color: var(--text-sub);
    font-size: 0.875rem; font-weight: 400;
    transition: background 0.18s, color 0.18s, transform 0.18s;
    position: relative;
  }
  .nav-item a:hover {
    background: rgba(255,255,255,0.06);
    color: var(--text-primary);
    transform: translateX(2px);
  }
  .nav-item.active a {
    background: rgba(99,179,237,0.1);
    color: var(--accent-blue);
    font-weight: 500;
    border: 1px solid rgba(99,179,237,0.15);
  }
  .nav-item.active a::before {
    content: '';
    position: absolute; left: 0; top: 20%; bottom: 20%;
    width: 3px; border-radius: 0 3px 3px 0;
    background: var(--accent-blue);
  }
  .nav-icon { font-size: 1rem; flex-shrink: 0; width: 18px; text-align: center; }

  .sidebar-spacer { flex: 1; }

  .logout-item a {
    display: flex; align-items: center; gap: 0.7rem;
    padding: 0.6rem 0.75rem;
    border-radius: var(--radius-sm);
    text-decoration: none;
    color: var(--accent-red);
    font-size: 0.875rem; font-weight: 400;
    opacity: 0.75;
    transition: background 0.18s, opacity 0.18s;
  }
  .logout-item a:hover {
    background: rgba(252,129,129,0.08);
    opacity: 1;
  }

  /* ══════════════════════════
     MAIN CONTENT
  ══════════════════════════ */
  .main-content {
    flex: 1;
    padding: 2.5rem 2rem 5rem;
    overflow-x: hidden;
  }

  /* ── page header ── */
  .page-header {
    margin-bottom: 2.4rem;
    animation: fadeDown 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 0.7rem; font-weight: 500;
    letter-spacing: 0.18em; text-transform: uppercase;
    color: var(--accent-blue);
    display: flex; align-items: center; gap: 0.45rem;
    margin-bottom: 0.3rem;
  }
  .page-eyebrow::before {
    content: ''; display: inline-block;
    width: 16px; height: 2px;
    background: var(--accent-blue); border-radius: 2px;
  }
  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.7rem, 3vw, 2.4rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-blue) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .page-sub {
    margin-top: 0.4rem;
    font-size: 0.875rem; color: var(--text-muted); font-weight: 300;
  }

  /* ── section label ── */
  .section-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--text-muted); margin-bottom: 0.85rem;
  }

  /* ── stats row ── */
  .stats-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 0.85rem;
    margin-bottom: 2rem;
    animation: fadeUp 0.5s 0.04s ease both;
  }
  .stat-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 1.1rem 1.2rem;
    backdrop-filter: blur(14px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
    transition: transform 0.25s cubic-bezier(.22,.68,0,1.2), border-color 0.25s;
  }
  .stat-card::after {
    content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
    border-radius: 2px 2px 0 0;
    background: var(--sc-a, var(--accent-blue)); opacity: 0.7;
  }
  .stat-card:hover { transform: translateY(-3px); }
  .stat-card:hover::after { opacity: 1; }
  .stat-card.s1 { --sc-a: var(--accent-blue); }
  .stat-card.s2 { --sc-a: var(--accent-green); }
  .stat-card.s3 { --sc-a: var(--accent-red); }
  .stat-card.s4 { --sc-a: var(--accent-amber); }
  .sc-icon {
    width: 30px; height: 30px; border-radius: var(--radius-sm);
    background: rgba(255,255,255,0.05);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.85rem; color: var(--sc-a, var(--accent-blue));
    margin-bottom: 0.7rem;
  }
  .sc-label { font-size: 0.68rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 0.25rem; }
  .sc-val {
    font-family: 'Syne', sans-serif;
    font-size: 1.5rem; font-weight: 800; letter-spacing: -0.03em;
    color: var(--text-primary); line-height: 1;
  }

  /* ── glass card ── */
  .glass-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    backdrop-filter: blur(18px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
    margin-bottom: 1.5rem;
  }
  .glass-card::before {
    content: ''; position: absolute; inset: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.035) 0%, transparent 55%);
    pointer-events: none;
  }
  .gc-header {
    padding: 1.1rem 1.5rem;
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 0.7rem;
  }
  .gc-icon {
    width: 32px; height: 32px; border-radius: var(--radius-sm);
    background: rgba(99,179,237,0.12); border: 1px solid rgba(99,179,237,0.15);
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-blue); font-size: 0.9rem;
  }
  .gc-icon.green { background: rgba(104,211,145,0.12); border-color: rgba(104,211,145,0.15); color: var(--accent-green); }
  .gc-header h6 {
    font-family: 'Syne', sans-serif;
    font-size: 0.9rem; font-weight: 700; color: var(--text-primary); margin: 0;
  }
  .gc-body { padding: 1.5rem; }

  /* ── form ── */
  .add-form { animation: fadeUp 0.5s 0.07s ease both; }

  .form-grid-3 {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 0.85rem; margin-bottom: 1.1rem;
  }
  .field-wrap { display: flex; flex-direction: column; gap: 0.28rem; }
  .field-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.07em; text-transform: uppercase; color: var(--text-muted);
  }
  .form-input {
    background: rgba(255,255,255,0.04);
    border: 1px solid var(--border); border-radius: var(--radius-sm);
    color: var(--text-primary); font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem; padding: 0.58rem 0.85rem; width: 100%;
    transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
  }
  .form-input::placeholder { color: var(--text-muted); }
  .form-input:focus {
    outline: none; background: rgba(255,255,255,0.06);
    border-color: var(--border-focus);
    box-shadow: 0 0 0 3px rgba(99,179,237,0.12); color: var(--text-primary);
  }

  /* ── buttons ── */
  .btn-add {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: linear-gradient(135deg, var(--accent-blue), #2b6cb0);
    border: none; border-radius: var(--radius-sm); color: #fff;
    font-family: 'DM Sans', sans-serif; font-size: 0.875rem; font-weight: 500;
    padding: 0.6rem 1.3rem; cursor: pointer;
    transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
    box-shadow: 0 4px 14px rgba(99,179,237,0.28);
  }
  .btn-add:hover {
    transform: translateY(-2px); filter: brightness(1.1);
    box-shadow: 0 6px 20px rgba(99,179,237,0.4);
  }
  .btn-add:active { transform: translateY(0); }

  .btn-update {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(104,211,145,0.12);
    border: 1px solid rgba(104,211,145,0.25); border-radius: var(--radius-sm);
    color: var(--accent-green); font-family: 'DM Sans', sans-serif;
    font-size: 0.76rem; font-weight: 500; padding: 0.38rem 0.8rem;
    cursor: pointer; white-space: nowrap;
    transition: background 0.2s, border-color 0.2s,
                transform 0.18s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s;
  }
  .btn-update:hover {
    background: rgba(104,211,145,0.22); border-color: rgba(104,211,145,0.4);
    transform: translateY(-1px); box-shadow: 0 4px 12px rgba(104,211,145,0.2);
  }

  /* ── table ── */
  .table-section { animation: fadeUp 0.5s 0.13s ease both; }
  .table-wrapper { overflow-x: auto; }
  .table-wrapper::-webkit-scrollbar { height: 5px; }
  .table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  .placements-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
  .placements-table thead tr { background: rgba(255,255,255,0.04); }
  .placements-table thead th {
    padding: 0.9rem 1rem;
    font-size: 0.67rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--text-muted); border-bottom: 1px solid var(--border);
    white-space: nowrap; text-align: left;
  }
  .placements-table thead th:first-child { padding-left: 1.4rem; }
  .placements-table thead th:last-child  { padding-right: 1.4rem; }

  .placements-table tbody tr {
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.18s;
  }
  .placements-table tbody tr:last-child { border-bottom: none; }
  .placements-table tbody tr:hover { background: rgba(255,255,255,0.03); }

  .placements-table tbody td {
    padding: 0.85rem 1rem; vertical-align: middle; color: var(--text-sub);
  }
  .placements-table tbody td:first-child { padding-left: 1.4rem; }
  .placements-table tbody td:last-child  { padding-right: 1.4rem; }

  /* student cell */
  .student-cell { display: flex; align-items: center; gap: 0.65rem; }
  .student-avatar {
    width: 30px; height: 30px; border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-blue), var(--accent-violet));
    display: flex; align-items: center; justify-content: center;
    font-size: 0.72rem; font-weight: 700; color: #fff; text-transform: uppercase; flex-shrink: 0;
    border: 1px solid rgba(99,179,237,0.25);
  }
  .student-name { font-weight: 500; color: var(--text-primary); }

  /* company cell */
  .company-cell { display: flex; align-items: center; gap: 0.55rem; }
  .company-dot {
    width: 8px; height: 8px; border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-teal), var(--accent-blue));
    flex-shrink: 0;
  }

  /* package badge */
  .pkg-badge {
    display: inline-flex; align-items: center; gap: 0.28rem;
    background: rgba(246,173,85,0.08); border: 1px solid rgba(246,173,85,0.18);
    border-radius: 50px; padding: 0.18rem 0.65rem;
    font-size: 0.78rem; font-weight: 600; color: var(--accent-amber);
    font-family: 'Syne', sans-serif;
  }

  /* status badges */
  .status-badge {
    display: inline-flex; align-items: center; gap: 0.3rem;
    border-radius: 50px; padding: 0.2rem 0.7rem;
    font-size: 0.73rem; font-weight: 600;
  }
  .status-badge .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
  .sb-applied  { background: rgba(246,173,85,0.1);  border: 1px solid rgba(246,173,85,0.22);  color: var(--accent-amber); }
  .sb-selected { background: rgba(104,211,145,0.1); border: 1px solid rgba(104,211,145,0.22); color: var(--accent-green); }
  .sb-rejected { background: rgba(252,129,129,0.1); border: 1px solid rgba(252,129,129,0.22); color: var(--accent-red); }
  .sb-default  { background: rgba(255,255,255,0.06); border: 1px solid var(--border); color: var(--text-muted); }

  /* action cell */
  .action-form { display: flex; align-items: center; gap: 0.5rem; }
  .status-select {
    background: rgba(255,255,255,0.05); border: 1px solid var(--border);
    border-radius: var(--radius-sm); color: var(--text-primary);
    font-family: 'DM Sans', sans-serif; font-size: 0.8rem;
    padding: 0.38rem 0.7rem; cursor: pointer;
    transition: border-color 0.18s, background 0.18s;
    -webkit-appearance: none; appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6'%3E%3Cpath d='M0 0l5 6 5-6z' fill='%234a5568'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 0.6rem center;
    padding-right: 1.8rem;
  }
  .status-select option { background: #1a1d27; }
  .status-select:focus { outline: none; border-color: rgba(99,179,237,0.4); }

  /* empty state */
  .empty-state { text-align: center; padding: 3.5rem 1rem; color: var(--text-muted); }
  .empty-state i { font-size: 2.5rem; opacity: 0.3; display: block; margin-bottom: 0.75rem; }
  .empty-state p { font-size: 0.88rem; }

  /* divider */
  .dash-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border), transparent);
    margin: 2rem 0;
  }

  /* animations */
  @keyframes fadeDown { from { opacity: 0; transform: translateY(-14px); } to { opacity: 1; transform: translateY(0); } }
  @keyframes fadeUp   { from { opacity: 0; transform: translateY(18px);  } to { opacity: 1; transform: translateY(0); } }

  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  /* ── mobile ── */
  @media (max-width: 900px) {
    .sidebar { display: none; }
    .main-content { padding: 1.5rem 1rem 3rem; }
  }
  @media (max-width: 600px) {
    .form-grid-3 { grid-template-columns: 1fr; }
    .gc-body { padding: 1.1rem; }
  }
</style>
</head>

<body>

<div class="layout">

  <!-- ════════════ SIDEBAR ════════════ -->
  <aside class="sidebar">

    <div class="sidebar-brand">
      <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
      <div>
        <div class="brand-text">ISMS</div>
        <div class="brand-sub">Admin Panel</div>
      </div>
    </div>

    <div class="sidebar-section-label">Navigation</div>

    <ul class="nav-list">

      <li class="nav-item">
        <a href="dashboard.jsp">
          <span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span>
          Dashboard
        </a>
      </li>

      <li class="nav-item active">
        <a href="placement">
          <span class="nav-icon"><i class="bi bi-briefcase-fill"></i></span>
          Placement
        </a>
      </li>

      <li class="nav-item">
        <a href="hostel">
          <span class="nav-icon"><i class="bi bi-building"></i></span>
          Hostel
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

  <!-- ════════════ MAIN CONTENT ════════════ -->
  <main class="main-content">

    <!-- page header -->
    <div class="page-header">
      <div class="page-eyebrow">Placement Management</div>
      <h1 class="page-title">Campus Placements</h1>
      <p class="page-sub">Manage companies, track applications, and update offer statuses.</p>
    </div>

    <%
    /* ── live stats from DB ── */
    int totalApps = 0, selectedCount = 0, rejectedCount = 0, appliedCount = 0;
    Connection connStats = null;
    Statement stStats = null;
    ResultSet rsStats = null;
    try {
        connStats = DBConnection.getConnection();
        stStats = connStats.createStatement();
        rsStats = stStats.executeQuery(
            "SELECT status, COUNT(*) as cnt FROM placement GROUP BY status"
        );
        while (rsStats.next()) {
            int cnt = rsStats.getInt("cnt");
            totalApps += cnt;
            String st2 = rsStats.getString("status");
            if ("SELECTED".equalsIgnoreCase(st2)) selectedCount = cnt;
            else if ("REJECTED".equalsIgnoreCase(st2)) rejectedCount = cnt;
            else appliedCount += cnt;
        }
    } catch (Exception ignored) {}
    finally {
        if (rsStats != null) try { rsStats.close(); } catch (Exception e2) {}
        if (stStats  != null) try { stStats.close();  } catch (Exception e2) {}
    }
    %>

    <!-- STATS -->
    <div class="section-label">Overview</div>
    <div class="stats-row">
      <div class="stat-card s1">
        <div class="sc-icon"><i class="bi bi-people-fill"></i></div>
        <div class="sc-label">Total Applications</div>
        <div class="sc-val"><%= totalApps %></div>
      </div>
      <div class="stat-card s2">
        <div class="sc-icon"><i class="bi bi-check-circle-fill"></i></div>
        <div class="sc-label">Selected</div>
        <div class="sc-val"><%= selectedCount %></div>
      </div>
      <div class="stat-card s3">
        <div class="sc-icon"><i class="bi bi-x-circle-fill"></i></div>
        <div class="sc-label">Rejected</div>
        <div class="sc-val"><%= rejectedCount %></div>
      </div>
      <div class="stat-card s4">
        <div class="sc-icon"><i class="bi bi-send-fill"></i></div>
        <div class="sc-label">In Progress</div>
        <div class="sc-val"><%= appliedCount %></div>
      </div>
    </div>

    <!-- ═══ ADD COMPANY ═══ -->
    <div class="add-form">
      <div class="section-label">Add Company</div>
      <div class="glass-card">
        <div class="gc-header">
          <div class="gc-icon green"><i class="bi bi-building-add"></i></div>
          <h6>Register New Company</h6>
        </div>
        <div class="gc-body">
          <form method="post" action="placement">
            <input type="hidden" name="action" value="addCompany">
            <div class="form-grid-3">

              <div class="field-wrap">
                <label class="field-label">Company Name</label>
                <input type="text" name="name" placeholder="e.g. Google"
                       class="form-input">
              </div>

              <div class="field-wrap">
                <label class="field-label">Package (LPA)</label>
                <input type="text" name="packageAmt" placeholder="e.g. 18"
                       class="form-input">
              </div>

              <div class="field-wrap">
                <label class="field-label">Requirements</label>
                <input type="text" name="requirements" placeholder="e.g. B.Tech CS, 7+ CGPA"
                       class="form-input">
              </div>

            </div>
            <button type="submit" class="btn-add">
              <i class="bi bi-building-add"></i> Add Company
            </button>
          </form>
        </div>
      </div>
    </div>

    <div class="dash-divider"></div>

    <!-- ═══ APPLICATIONS TABLE ═══ -->
    <div class="table-section">
      <div class="section-label">Student Applications</div>

      <div class="glass-card">
        <div class="table-wrapper">
          <table class="placements-table">

            <thead>
              <tr>
                <th>Student</th>
                <th>Company</th>
                <th>Package</th>
                <th>Status</th>
                <th>Update Status</th>
              </tr>
            </thead>

            <tbody>

            <%
            Connection conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT p.id, s.name as student, c.name as company, c.package_amt, p.status " +
                "FROM placement p " +
                "JOIN students s ON p.student_id=s.id " +
                "JOIN companies c ON p.company_id=c.id"
            );

            boolean hasRows = false;
            while (rs.next()) {
              hasRows = true;
              String status   = rs.getString("status");
              String initials = (rs.getString("student") != null && rs.getString("student").length() > 0)
                  ? String.valueOf(rs.getString("student").charAt(0)).toUpperCase() : "S";
              String statusClass = "sb-default";
              if ("SELECTED".equalsIgnoreCase(status))  statusClass = "sb-selected";
              else if ("REJECTED".equalsIgnoreCase(status)) statusClass = "sb-rejected";
              else if ("APPLIED".equalsIgnoreCase(status))  statusClass = "sb-applied";
            %>

              <tr>

                <td>
                  <div class="student-cell">
                    <div class="student-avatar"><%= initials %></div>
                    <span class="student-name"><%= rs.getString("student") %></span>
                  </div>
                </td>

                <td>
                  <div class="company-cell">
                    <div class="company-dot"></div>
                    <%= rs.getString("company") %>
                  </div>
                </td>

                <td>
                  <span class="pkg-badge">
                    <i class="bi bi-star-fill" style="font-size:0.62rem;"></i>
                    <%= rs.getString("package_amt") %> LPA
                  </span>
                </td>

                <td>
                  <span class="status-badge <%= statusClass %>">
                    <span class="dot"></span>
                    <%= status %>
                  </span>
                </td>

                <td>
                  <form method="post" action="placement" class="action-form">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <select name="status" class="status-select">
                      <option>APPLIED</option>
                      <option>SELECTED</option>
                      <option>REJECTED</option>
                    </select>
                    <button type="submit" class="btn-update">
                      <i class="bi bi-check-lg"></i> Update
                    </button>
                  </form>
                </td>

              </tr>

            <%
            }

            if (!hasRows) {
            %>
              <tr>
                <td colspan="5">
                  <div class="empty-state">
                    <i class="bi bi-briefcase"></i>
                    <p>No placement applications found yet.</p>
                  </div>
                </td>
              </tr>
            <%
            }
            %>

            </tbody>
          </table>
        </div>
      </div>
    </div>

  </main>
</div>

</body>
</html>
