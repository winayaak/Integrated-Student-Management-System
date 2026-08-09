<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.FeeDAO.FeeRecord"%>
<%@ page import="model.Student"%>
<%@ page import="java.util.List"%>

<%
List<FeeRecord> fees = (List<FeeRecord>) request.getAttribute("fees");
List<Student> students = (List<Student>) request.getAttribute("students");

if (fees == null)
	fees = java.util.Collections.emptyList();
if (students == null)
	students = java.util.Collections.emptyList();

double totalCollected = 0;
double totalPending   = 0;
for (FeeRecord f : fees) {
    if (f.isPaid()) totalCollected += f.getAmount();
    else            totalPending   += f.getAmount();
}
int paidCount    = 0;
int pendingCount = 0;
for (FeeRecord f : fees) { if (f.isPaid()) paidCount++; else pendingCount++; }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fee Management</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:       #08090d;
    --bg-card:       rgba(255,255,255,0.04);
    --bg-card-hover: rgba(255,255,255,0.065);
    --border:        rgba(255,255,255,0.08);
    --border-focus:  rgba(246,173,85,0.5);
    --accent-amber:  #f6ad55;
    --accent-gold:   #ecc94b;
    --accent-green:  #68d391;
    --accent-red:    #fc8181;
    --accent-blue:   #63b3ed;
    --accent-violet: #9f7aea;
    --text-primary:  #f0f4f8;
    --text-sub:      #a0aec0;
    --text-muted:    #4a5568;
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
      radial-gradient(ellipse 60% 50% at 0% 10%,   rgba(246,173,85,0.09)  0%, transparent 60%),
      radial-gradient(ellipse 50% 50% at 100% 5%,   rgba(236,201,75,0.07)  0%, transparent 55%),
      radial-gradient(ellipse 55% 40% at 40% 100%,  rgba(104,211,145,0.06) 0%, transparent 50%);
    pointer-events: none; z-index: 0;
  }
  body::after {
    content: '';
    position: fixed; inset: 0;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
    pointer-events: none; z-index: 0; opacity: 0.55;
  }

  .page-wrap {
    position: relative; z-index: 1;
    max-width: 1200px;
    margin: 0 auto;
    padding: 2.5rem 1.5rem 5rem;
  }

  /* ── header ── */
  .page-header {
    display: flex; align-items: flex-end; justify-content: space-between;
    flex-wrap: wrap; gap: 1rem;
    margin-bottom: 2.4rem;
    animation: fadeDown 0.5s ease both;
  }
  .page-eyebrow {
    font-size: 0.7rem; font-weight: 500;
    letter-spacing: 0.18em; text-transform: uppercase;
    color: var(--accent-amber);
    display: flex; align-items: center; gap: 0.45rem;
    margin-bottom: 0.3rem;
  }
  .page-eyebrow::before {
    content: ''; display: inline-block;
    width: 16px; height: 2px;
    background: var(--accent-amber); border-radius: 2px;
  }
  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.7rem, 3.5vw, 2.4rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-amber) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .back-btn {
    display: inline-flex; align-items: center; gap: 0.4rem;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text-sub);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.82rem; font-weight: 500;
    padding: 0.45rem 1rem; text-decoration: none;
    backdrop-filter: blur(10px);
    transition: background 0.2s, border-color 0.2s, color 0.2s, transform 0.18s;
  }
  .back-btn:hover {
    background: var(--bg-card-hover);
    border-color: rgba(255,255,255,0.14);
    color: var(--text-primary);
    transform: translateX(-2px);
  }

  /* ── section label ── */
  .section-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--text-muted); margin-bottom: 0.85rem;
  }

  /* ── summary stat cards ── */
  .stats-row {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
    gap: 0.9rem;
    margin-bottom: 2rem;
    animation: fadeUp 0.5s 0.04s ease both;
  }
  .stat-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 1.2rem 1.3rem;
    backdrop-filter: blur(14px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
    transition: transform 0.25s cubic-bezier(.22,.68,0,1.2), border-color 0.25s, box-shadow 0.25s;
  }
  .stat-card::after {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    border-radius: 2px 2px 0 0;
    background: var(--sc-accent, var(--accent-amber));
    opacity: 0.7; transition: opacity 0.2s;
  }
  .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-card), var(--sc-glow, none); }
  .stat-card:hover::after { opacity: 1; }
  .stat-card.sc-total    { --sc-accent: var(--accent-amber);  --sc-glow: 0 0 22px rgba(246,173,85,0.18); }
  .stat-card.sc-paid     { --sc-accent: var(--accent-green);  --sc-glow: 0 0 22px rgba(104,211,145,0.18); }
  .stat-card.sc-pending  { --sc-accent: var(--accent-red);    --sc-glow: 0 0 22px rgba(252,129,129,0.18); }
  .stat-card.sc-records  { --sc-accent: var(--accent-blue);   --sc-glow: 0 0 22px rgba(99,179,237,0.18); }

  .sc-icon {
    width: 34px; height: 34px; border-radius: var(--radius-sm);
    background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.06);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.95rem; color: var(--sc-accent, var(--accent-amber));
    margin-bottom: 0.85rem;
  }
  .sc-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--text-muted); margin-bottom: 0.3rem; }
  .sc-value {
    font-family: 'Syne', sans-serif;
    font-size: 1.6rem; font-weight: 800; letter-spacing: -0.03em;
    color: var(--text-primary); line-height: 1;
  }
  .sc-value .rupee { font-size: 0.6em; font-weight: 500; opacity: 0.7; vertical-align: super; margin-right: 1px; }

  /* ── glass card ── */
  .glass-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    backdrop-filter: blur(18px);
    box-shadow: var(--shadow-card);
    position: relative; overflow: hidden;
  }
  .glass-card::before {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(135deg, rgba(255,255,255,0.035) 0%, transparent 55%);
    pointer-events: none;
  }
  .glass-card-header {
    padding: 1.2rem 1.6rem;
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 0.75rem;
  }
  .card-icon {
    width: 34px; height: 34px; border-radius: var(--radius-sm);
    background: rgba(246,173,85,0.12); border: 1px solid rgba(246,173,85,0.15);
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-amber); font-size: 0.95rem;
  }
  .glass-card-header h6 {
    font-family: 'Syne', sans-serif;
    font-size: 0.92rem; font-weight: 700;
    color: var(--text-primary); margin: 0;
  }
  .glass-card-body { padding: 1.6rem; }

  /* ── form ── */
  .add-form { animation: fadeUp 0.5s 0.07s ease both; }

  .form-row {
    display: grid;
    grid-template-columns: 2fr 1fr 1.5fr 1.4fr auto;
    gap: 0.85rem;
    align-items: end;
  }
  .field-wrap { display: flex; flex-direction: column; gap: 0.3rem; }
  .field-label {
    font-size: 0.7rem; font-weight: 500;
    letter-spacing: 0.07em; text-transform: uppercase;
    color: var(--text-muted);
  }
  .form-input, .form-select {
    background: rgba(255,255,255,0.04);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem;
    padding: 0.6rem 0.85rem;
    transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
    width: 100%;
    -webkit-appearance: none; appearance: none;
  }
  .form-input::placeholder { color: var(--text-muted); }
  .form-input:focus, .form-select:focus {
    outline: none;
    background: rgba(255,255,255,0.06);
    border-color: var(--border-focus);
    box-shadow: 0 0 0 3px rgba(246,173,85,0.12);
    color: var(--text-primary);
  }
  .form-select option { background: #1a1d27; color: var(--text-primary); }
  /* select arrow */
  .select-wrap { position: relative; }
  .select-wrap::after {
    content: '\F282';
    font-family: 'bootstrap-icons';
    position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%);
    color: var(--text-muted); font-size: 0.8rem; pointer-events: none;
  }
  /* date input */
  input[type="date"]::-webkit-calendar-picker-indicator {
    filter: invert(0.5); cursor: pointer;
  }
  /* number spinner hide */
  .form-input[type="number"]::-webkit-inner-spin-button,
  .form-input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; }
  .form-input[type="number"] { -moz-appearance: textfield; }

  /* ── buttons ── */
  .btn-add {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: linear-gradient(135deg, var(--accent-amber), #c05621);
    border: none; border-radius: var(--radius-sm);
    color: #1a1207; font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem; font-weight: 600;
    padding: 0.62rem 1.3rem; cursor: pointer; white-space: nowrap;
    transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
    box-shadow: 0 4px 14px rgba(246,173,85,0.3);
  }
  .btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(246,173,85,0.42);
    filter: brightness(1.08);
  }
  .btn-add:active { transform: translateY(0); }

  .btn-pay {
    display: inline-flex; align-items: center; gap: 0.32rem;
    background: rgba(104,211,145,0.12);
    border: 1px solid rgba(104,211,145,0.25);
    border-radius: var(--radius-sm);
    color: var(--accent-green);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.76rem; font-weight: 500;
    padding: 0.36rem 0.8rem; cursor: pointer; white-space: nowrap;
    transition: background 0.2s, border-color 0.2s,
                transform 0.18s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s;
  }
  .btn-pay:hover {
    background: rgba(104,211,145,0.22);
    border-color: rgba(104,211,145,0.4);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(104,211,145,0.18);
  }

  .btn-del {
    display: inline-flex; align-items: center; gap: 0.32rem;
    background: rgba(252,129,129,0.1);
    border: 1px solid rgba(252,129,129,0.22);
    border-radius: var(--radius-sm);
    color: var(--accent-red);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.76rem; font-weight: 500;
    padding: 0.36rem 0.8rem; cursor: pointer; white-space: nowrap;
    transition: background 0.2s, border-color 0.2s,
                transform 0.18s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s;
  }
  .btn-del:hover {
    background: rgba(252,129,129,0.2);
    border-color: rgba(252,129,129,0.38);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(252,129,129,0.18);
  }

  /* ── table ── */
  .table-section { animation: fadeUp 0.5s 0.13s ease both; }

  .table-wrapper { overflow-x: auto; border-radius: var(--radius-lg); }
  .table-wrapper::-webkit-scrollbar { height: 5px; }
  .table-wrapper::-webkit-scrollbar-track { background: transparent; }
  .table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  .fees-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
  .fees-table thead tr { background: rgba(255,255,255,0.04); }
  .fees-table thead th {
    padding: 0.9rem 1rem;
    font-size: 0.68rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--text-muted); border-bottom: 1px solid var(--border);
    white-space: nowrap; text-align: left;
  }
  .fees-table thead th:first-child { padding-left: 1.4rem; }
  .fees-table thead th:last-child  { padding-right: 1.4rem; text-align: center; }

  .fees-table tbody tr {
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.18s ease;
  }
  .fees-table tbody tr:last-child { border-bottom: none; }
  .fees-table tbody tr:hover { background: rgba(255,255,255,0.03); }

  .fees-table tbody td {
    padding: 0.85rem 1rem;
    vertical-align: middle; color: var(--text-sub);
  }
  .fees-table tbody td:first-child { padding-left: 1.4rem; }
  .fees-table tbody td:last-child  { padding-right: 1.4rem; }

  /* student cell */
  .student-cell { display: flex; align-items: center; gap: 0.65rem; }
  .student-avatar {
    width: 30px; height: 30px; border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-amber), #c05621);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.72rem; font-weight: 700; color: #1a1207;
    text-transform: uppercase; flex-shrink: 0;
    border: 1px solid rgba(246,173,85,0.3);
  }
  .student-name { font-weight: 500; color: var(--text-primary); font-size: 0.875rem; }

  /* amount cell */
  .amount-cell {
    font-family: 'Syne', sans-serif;
    font-size: 0.95rem; font-weight: 700;
    color: var(--text-primary);
  }
  .amount-cell .rsym { font-size: 0.78em; font-weight: 500; opacity: 0.65; margin-right: 1px; }

  /* fee type chip */
  .type-chip {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(246,173,85,0.08);
    border: 1px solid rgba(246,173,85,0.16);
    border-radius: 50px;
    padding: 0.18rem 0.65rem;
    font-size: 0.75rem; color: var(--accent-amber);
  }

  /* date cell */
  .date-cell { font-size: 0.82rem; color: var(--text-muted); letter-spacing: 0.02em; }

  /* status badge */
  .badge-paid {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(104,211,145,0.1);
    border: 1px solid rgba(104,211,145,0.22);
    border-radius: 50px; padding: 0.2rem 0.7rem;
    font-size: 0.75rem; font-weight: 600; color: var(--accent-green);
  }
  .badge-pending {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(252,129,129,0.1);
    border: 1px solid rgba(252,129,129,0.22);
    border-radius: 50px; padding: 0.2rem 0.7rem;
    font-size: 0.75rem; font-weight: 600; color: var(--accent-red);
  }
  .badge-dot {
    width: 6px; height: 6px; border-radius: 50%;
    background: currentColor; display: inline-block;
  }

  /* action cell */
  .action-cell { display: flex; align-items: center; justify-content: center; gap: 0.4rem; flex-wrap: wrap; }

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
  @keyframes fadeDown {
    from { opacity: 0; transform: translateY(-14px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(18px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  @media (max-width: 900px) {
    .form-row { grid-template-columns: 1fr 1fr; }
  }
  @media (max-width: 600px) {
    .page-wrap { padding: 1.5rem 1rem 3.5rem; }
    .form-row { grid-template-columns: 1fr; }
    .glass-card-body { padding: 1.2rem; }
  }
</style>
</head>

<body>

<%@ include file="/WEB-INF/includes/header.jsp"%>

<div class="page-wrap">

  <!-- PAGE HEADER -->
  <div class="page-header">
    <div>
      <div class="page-eyebrow">Admin · Finance</div>
      <h1 class="page-title">Fee Management</h1>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="back-btn">
      <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
  </div>

  <!-- ═══ SUMMARY STATS ═══ -->
  <div class="section-label">Overview</div>
  <div class="stats-row">

    <div class="stat-card sc-total">
      <div class="sc-icon"><i class="bi bi-cash-stack"></i></div>
      <div class="sc-label">Total Records</div>
      <div class="sc-value"><%= fees.size() %></div>
    </div>

    <div class="stat-card sc-paid">
      <div class="sc-icon"><i class="bi bi-check-circle-fill"></i></div>
      <div class="sc-label">Collected</div>
      <div class="sc-value"><span class="rupee">₹</span><%= String.format("%,.0f", totalCollected) %></div>
    </div>

    <div class="stat-card sc-pending">
      <div class="sc-icon"><i class="bi bi-hourglass-split"></i></div>
      <div class="sc-label">Pending</div>
      <div class="sc-value"><span class="rupee">₹</span><%= String.format("%,.0f", totalPending) %></div>
    </div>

    <div class="stat-card sc-records">
      <div class="sc-icon"><i class="bi bi-people-fill"></i></div>
      <div class="sc-label">Pending Students</div>
      <div class="sc-value"><%= pendingCount %></div>
    </div>

  </div>

  <!-- ═══ ADD FEE FORM ═══ -->
  <div class="add-form" style="margin-bottom: 1.5rem;">
    <div class="section-label">Add Fee Record</div>

    <div class="glass-card">
      <div class="glass-card-header">
        <div class="card-icon"><i class="bi bi-plus-circle-fill"></i></div>
        <h6>New Fee Entry</h6>
      </div>
      <div class="glass-card-body">

        <form method="post" action="${pageContext.request.contextPath}/admin/fees">
          <input type="hidden" name="action" value="add">

          <div class="form-row">

            <div class="field-wrap">
              <label class="field-label">Student</label>
              <div class="select-wrap">
                <select name="studentId" class="form-select" required>
                  <option value="">— Select Student —</option>
                  <%
                  for (Student s : students) {
                  %>
                  <option value="<%= s.getId() %>">
                    <%= s.getRollNo() %> — <%= s.getName() %>
                  </option>
                  <%
                  }
                  %>
                </select>
              </div>
            </div>

            <div class="field-wrap">
              <label class="field-label">Amount (₹)</label>
              <input type="number" name="amount" placeholder="e.g. 25000"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Fee Type</label>
              <input type="text" name="feeType" placeholder="e.g. Tuition, Hostel"
                     class="form-input">
            </div>

            <div class="field-wrap">
              <label class="field-label">Due Date</label>
              <input type="date" name="dueDate" class="form-input">
            </div>

            <div class="field-wrap">
              <label class="field-label" style="visibility:hidden;">Add</label>
              <button type="submit" class="btn-add">
                <i class="bi bi-plus-lg"></i> Add
              </button>
            </div>

          </div>
        </form>

      </div>
    </div>
  </div>

  <div class="dash-divider"></div>

  <!-- ═══ FEES TABLE ═══ -->
  <div class="table-section">
    <div class="section-label">All Fee Records</div>

    <div class="glass-card">
      <div class="table-wrapper">
        <table class="fees-table">

          <thead>
            <tr>
              <th>Student</th>
              <th>Amount</th>
              <th>Type</th>
              <th>Due Date</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            <%
            if (!fees.isEmpty()) {
              for (FeeRecord f : fees) {
                String initials = (f.getStudentName() != null && f.getStudentName().length() > 0)
                  ? String.valueOf(f.getStudentName().charAt(0)).toUpperCase() : "S";
            %>

            <tr>

              <td>
                <div class="student-cell">
                  <div class="student-avatar"><%= initials %></div>
                  <span class="student-name"><%= f.getStudentName() %></span>
                </div>
              </td>

              <td>
                <span class="amount-cell">
                  <span class="rsym">₹</span><%= String.format("%,.0f", f.getAmount()) %>
                </span>
              </td>

              <td>
                <span class="type-chip">
                  <i class="bi bi-tag-fill" style="font-size:0.65rem;"></i>
                  <%= f.getFeeType() %>
                </span>
              </td>

              <td><span class="date-cell"><%= f.getDueDate() %></span></td>

              <td>
                <% if (f.isPaid()) { %>
                  <span class="badge-paid">
                    <span class="badge-dot"></span> Paid
                  </span>
                <% } else { %>
                  <span class="badge-pending">
                    <span class="badge-dot"></span> Pending
                  </span>
                <% } %>
              </td>

              <td>
                <div class="action-cell">

                  <% if (!f.isPaid()) { %>
                  <form method="post"
                        action="${pageContext.request.contextPath}/admin/fees"
                        style="display:inline;">
                    <input type="hidden" name="action" value="markPaid">
                    <input type="hidden" name="id" value="<%= f.getId() %>">
                    <button type="submit" class="btn-pay">
                      <i class="bi bi-check-lg"></i> Mark Paid
                    </button>
                  </form>
                  <% } %>

                  <form method="post"
                        action="${pageContext.request.contextPath}/admin/fees"
                        style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= f.getId() %>">
                    <button type="submit" class="btn-del"
                            onclick="return confirm('Delete this fee record?')">
                      <i class="bi bi-trash3-fill"></i> Delete
                    </button>
                  </form>

                </div>
              </td>

            </tr>

            <%
              }
            } else {
            %>
            <tr>
              <td colspan="6">
                <div class="empty-state">
                  <i class="bi bi-cash-coin"></i>
                  <p>No fee records found. Add one above.</p>
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

</div>

</body>
</html>
