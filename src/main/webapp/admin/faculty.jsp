<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Faculty"%>

<%
List<Faculty> faculty = (List<Faculty>) request.getAttribute("faculty");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Faculty</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:        #08090d;
    --bg-card:        rgba(255,255,255,0.04);
    --bg-card-hover:  rgba(255,255,255,0.065);
    --border:         rgba(255,255,255,0.08);
    --border-focus:   rgba(159,122,234,0.5);
    --accent-violet:  #9f7aea;
    --accent-blue:    #63b3ed;
    --accent-green:   #68d391;
    --accent-red:     #fc8181;
    --accent-amber:   #f6ad55;
    --text-primary:   #f0f4f8;
    --text-sub:       #a0aec0;
    --text-muted:     #4a5568;
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
      radial-gradient(ellipse 60% 50% at 0% 10%,   rgba(159,122,234,0.10) 0%, transparent 60%),
      radial-gradient(ellipse 50% 55% at 100% 5%,  rgba(99,179,237,0.08)  0%, transparent 55%),
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
    max-width: 1200px;
    margin: 0 auto;
    padding: 2.5rem 1.5rem 5rem;
  }

  /* ── page header ── */
  .page-header {
    display: flex; align-items: flex-end; justify-content: space-between;
    flex-wrap: wrap; gap: 1rem;
    margin-bottom: 2.4rem;
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
    font-size: clamp(1.7rem, 3.5vw, 2.4rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-violet) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .count-badge {
    display: inline-flex; align-items: center; gap: 0.4rem;
    background: rgba(159,122,234,0.1);
    border: 1px solid rgba(159,122,234,0.22);
    color: var(--accent-violet);
    font-size: 0.78rem; font-weight: 500;
    padding: 0.35rem 0.8rem; border-radius: 50px;
    backdrop-filter: blur(8px);
  }

  /* ── section label ── */
  .section-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--text-muted); margin-bottom: 0.85rem;
  }

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
    width: 34px; height: 34px;
    border-radius: var(--radius-sm);
    background: rgba(159,122,234,0.12);
    border: 1px solid rgba(159,122,234,0.15);
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-violet); font-size: 0.95rem;
  }
  .glass-card-header h6 {
    font-family: 'Syne', sans-serif;
    font-size: 0.92rem; font-weight: 700;
    color: var(--text-primary); margin: 0;
  }
  .glass-card-body { padding: 1.6rem; }

  /* ── add form ── */
  .add-form { animation: fadeUp 0.5s 0.05s ease both; }

  .form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
    gap: 0.85rem;
    margin-bottom: 1.1rem;
  }
  .field-wrap { display: flex; flex-direction: column; gap: 0.3rem; }
  .field-label {
    font-size: 0.7rem; font-weight: 500;
    letter-spacing: 0.07em; text-transform: uppercase;
    color: var(--text-muted);
  }
  .form-input {
    background: rgba(255,255,255,0.04);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem;
    padding: 0.6rem 0.85rem;
    transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
    width: 100%;
  }
  .form-input::placeholder { color: var(--text-muted); }
  .form-input:focus {
    outline: none;
    background: rgba(255,255,255,0.06);
    border-color: var(--border-focus);
    box-shadow: 0 0 0 3px rgba(159,122,234,0.12);
    color: var(--text-primary);
  }

  /* ── buttons ── */
  .btn-add {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: linear-gradient(135deg, var(--accent-violet), #6b46c1);
    border: none; border-radius: var(--radius-sm);
    color: #fff; font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem; font-weight: 500;
    padding: 0.6rem 1.4rem; cursor: pointer;
    transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
    box-shadow: 0 4px 14px rgba(159,122,234,0.32);
  }
  .btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(159,122,234,0.45);
    filter: brightness(1.08);
  }
  .btn-add:active { transform: translateY(0); }

  .btn-del {
    display: inline-flex; align-items: center; gap: 0.35rem;
    background: rgba(252,129,129,0.1);
    border: 1px solid rgba(252,129,129,0.22);
    border-radius: var(--radius-sm);
    color: var(--accent-red);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.78rem; font-weight: 500;
    padding: 0.38rem 0.85rem; cursor: pointer; white-space: nowrap;
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
  .table-section { animation: fadeUp 0.5s 0.12s ease both; }

  .table-wrapper { overflow-x: auto; border-radius: var(--radius-lg); }
  .table-wrapper::-webkit-scrollbar { height: 5px; }
  .table-wrapper::-webkit-scrollbar-track { background: transparent; }
  .table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  .faculty-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }

  .faculty-table thead tr { background: rgba(255,255,255,0.04); }
  .faculty-table thead th {
    padding: 0.9rem 1rem;
    font-size: 0.68rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--text-muted);
    border-bottom: 1px solid var(--border);
    white-space: nowrap; text-align: left;
  }
  .faculty-table thead th:first-child { padding-left: 1.4rem; }
  .faculty-table thead th:last-child  { padding-right: 1.4rem; text-align: center; }

  .faculty-table tbody tr {
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.18s ease;
  }
  .faculty-table tbody tr:last-child { border-bottom: none; }
  .faculty-table tbody tr:hover { background: rgba(255,255,255,0.03); }

  .faculty-table tbody td {
    padding: 0.8rem 1rem;
    vertical-align: middle; color: var(--text-sub);
  }
  .faculty-table tbody td:first-child { padding-left: 1.4rem; }
  .faculty-table tbody td:last-child  { padding-right: 1.4rem; text-align: center; }

  /* id pill */
  .id-pill {
    display: inline-flex; align-items: center;
    background: rgba(255,255,255,0.05);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.2rem 0.55rem;
    font-size: 0.75rem; font-weight: 600;
    font-family: 'Syne', monospace;
    color: var(--text-muted); letter-spacing: 0.04em;
  }

  /* faculty avatar */
  .faculty-name-cell { display: flex; align-items: center; gap: 0.7rem; }
  .faculty-avatar {
    width: 32px; height: 32px; border-radius: 50%;
    background: linear-gradient(135deg, var(--accent-violet), #6b46c1);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.75rem; font-weight: 700; color: #fff;
    text-transform: uppercase; flex-shrink: 0;
    border: 1px solid rgba(159,122,234,0.3);
  }
  .faculty-name { font-weight: 500; color: var(--text-primary); }

  /* dept chip */
  .dept-chip {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(159,122,234,0.08);
    border: 1px solid rgba(159,122,234,0.15);
    border-radius: 50px;
    padding: 0.2rem 0.65rem;
    font-size: 0.75rem; color: var(--accent-violet);
  }

  /* phone cell */
  .phone-cell { font-size: 0.82rem; color: var(--text-muted); letter-spacing: 0.03em; }

  /* empty state */
  .empty-state {
    text-align: center; padding: 3.5rem 1rem;
    color: var(--text-muted);
  }
  .empty-state i { font-size: 2.5rem; opacity: 0.3; display: block; margin-bottom: 0.75rem; }
  .empty-state p { font-size: 0.88rem; }

  /* ── divider ── */
  .dash-divider {
    height: 1px;
    background: linear-gradient(90deg, transparent, var(--border), transparent);
    margin: 2rem 0;
  }

  /* ── animations ── */
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

  @media (max-width: 768px) {
    .page-wrap { padding: 1.5rem 1rem 3.5rem; }
    .form-grid { grid-template-columns: 1fr 1fr; }
    .glass-card-body { padding: 1.2rem; }
  }
  @media (max-width: 480px) {
    .form-grid { grid-template-columns: 1fr; }
  }
</style>
</head>

<body>

<div class="page-wrap">

  <!-- PAGE HEADER -->
  <div class="page-header">
    <div>
      <div class="page-eyebrow">Faculty Management</div>
      <h1 class="page-title">Manage Faculty</h1>
    </div>
    <span class="count-badge">
      <i class="bi bi-person-workspace"></i>
      <%= (faculty != null ? faculty.size() : 0) %> members
    </span>
  </div>

  <!-- ═══ ADD FACULTY FORM ═══ -->
  <div class="add-form" style="margin-bottom: 1.5rem;">
    <div class="section-label">Add New Faculty</div>

    <div class="glass-card">
      <div class="glass-card-header">
        <div class="card-icon"><i class="bi bi-person-plus-fill"></i></div>
        <h6>New Faculty Member</h6>
      </div>
      <div class="glass-card-body">

        <form method="post" action="${pageContext.request.contextPath}/admin/faculty">
          <input type="hidden" name="action" value="add">

          <div class="form-grid">

            <div class="field-wrap">
              <label class="field-label">Username</label>
              <input type="text" name="username" placeholder="e.g. prof_sharma"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Full Name</label>
              <input type="text" name="name" placeholder="e.g. Dr. Sharma"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Email</label>
              <input type="email" name="email" placeholder="faculty@college.edu"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Department</label>
              <input type="text" name="department" placeholder="e.g. Computer Science"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Phone</label>
              <input type="text" name="phone" placeholder="e.g. 9876543210"
                     class="form-input">
            </div>

          </div>

          <button type="submit" class="btn-add">
            <i class="bi bi-person-plus-fill"></i> Add Faculty
          </button>
        </form>

      </div>
    </div>
  </div>

  <div class="dash-divider"></div>

  <!-- ═══ FACULTY TABLE ═══ -->
  <div class="table-section">
    <div class="section-label">All Faculty Members</div>

    <div class="glass-card">
      <div class="table-wrapper">
        <table class="faculty-table">

          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>Department</th>
              <th>Phone</th>
              <th>Action</th>
            </tr>
          </thead>

          <tbody>

            <%
            if (faculty != null && !faculty.isEmpty()) {
              for (Faculty f : faculty) {
                String initials = (f.getName() != null && f.getName().length() > 0)
                  ? String.valueOf(f.getName().charAt(0)).toUpperCase() : "F";
            %>

            <tr>

              <td><span class="id-pill">#<%= f.getId() %></span></td>

              <td>
                <div class="faculty-name-cell">
                  <div class="faculty-avatar"><%= initials %></div>
                  <span class="faculty-name"><%= f.getName() %></span>
                </div>
              </td>

              <td><%= f.getEmail() %></td>

              <td>
                <span class="dept-chip">
                  <i class="bi bi-mortarboard-fill" style="font-size:0.7rem;"></i>
                  <%= f.getDepartment() %>
                </span>
              </td>

              <td><span class="phone-cell"><%= f.getPhone() %></span></td>

              <td>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/faculty"
                      style="display:inline;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id" value="<%= f.getId() %>">
                  <button type="submit" class="btn-del"
                          onclick="return confirm('Remove <%= f.getName() %> from faculty?')">
                    <i class="bi bi-trash3-fill"></i> Delete
                  </button>
                </form>
              </td>

            </tr>

            <%
              }
            } else {
            %>
            <tr>
              <td colspan="6">
                <div class="empty-state">
                  <i class="bi bi-person-workspace"></i>
                  <p>No faculty members added yet. Add one above.</p>
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
