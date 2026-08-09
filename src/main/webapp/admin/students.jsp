<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.Student"%>
<%@ page import="java.util.List"%>

<%
List<Student> students = (List<Student>) request.getAttribute("students");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Students</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:        #08090d;
    --bg-mid:         #0e1018;
    --bg-card:        rgba(255,255,255,0.04);
    --bg-card-hover:  rgba(255,255,255,0.065);
    --border:         rgba(255,255,255,0.08);
    --border-focus:   rgba(99,179,237,0.5);
    --accent-blue:    #63b3ed;
    --accent-violet:  #9f7aea;
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

  /* mesh + grain */
  body::before {
    content: '';
    position: fixed; inset: 0;
    background:
      radial-gradient(ellipse 65% 45% at 5% 0%,   rgba(99,179,237,0.09) 0%, transparent 60%),
      radial-gradient(ellipse 50% 55% at 95% 15%,  rgba(159,122,234,0.08) 0%, transparent 55%),
      radial-gradient(ellipse 55% 35% at 50% 105%, rgba(104,211,145,0.06) 0%, transparent 50%);
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

  /* ── PAGE HEADER ── */
  .page-header {
    display: flex; align-items: flex-end; justify-content: space-between;
    flex-wrap: wrap; gap: 1rem;
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
    font-size: clamp(1.7rem, 3.5vw, 2.4rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-blue) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .student-count-badge {
    display: inline-flex; align-items: center; gap: 0.4rem;
    background: rgba(99,179,237,0.1);
    border: 1px solid rgba(99,179,237,0.2);
    color: var(--accent-blue);
    font-size: 0.78rem; font-weight: 500;
    padding: 0.35rem 0.8rem;
    border-radius: 50px;
    backdrop-filter: blur(8px);
  }

  /* ── SECTION LABEL ── */
  .section-label {
    font-size: 0.68rem; font-weight: 500;
    letter-spacing: 0.16em; text-transform: uppercase;
    color: var(--text-muted); margin-bottom: 0.85rem;
  }

  /* ── GLASS CARD ── */
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
  .glass-card-header .card-icon {
    width: 34px; height: 34px;
    border-radius: var(--radius-sm);
    background: rgba(104,211,145,0.12);
    border: 1px solid rgba(104,211,145,0.15);
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-green); font-size: 0.95rem;
  }
  .glass-card-header h6 {
    font-family: 'Syne', sans-serif;
    font-size: 0.92rem; font-weight: 700;
    color: var(--text-primary); margin: 0;
  }
  .glass-card-body { padding: 1.6rem; }

  /* ── ADD FORM ── */
  .add-form { animation: fadeUp 0.5s 0.05s ease both; }

  .form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
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
    background: rgba(255,255,255,0.04) !important;
    border: 1px solid var(--border) !important;
    border-radius: var(--radius-sm) !important;
    color: var(--text-primary) !important;
    font-family: 'DM Sans', sans-serif !important;
    font-size: 0.875rem !important;
    padding: 0.6rem 0.85rem !important;
    transition: border-color 0.2s ease, box-shadow 0.2s ease, background 0.2s ease !important;
  }
  .form-input::placeholder { color: var(--text-muted) !important; }
  .form-input:focus {
    outline: none !important;
    background: rgba(255,255,255,0.06) !important;
    border-color: var(--border-focus) !important;
    box-shadow: 0 0 0 3px rgba(99,179,237,0.12) !important;
    color: var(--text-primary) !important;
  }

  /* ── BUTTONS ── */
  .btn-add {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: linear-gradient(135deg, #48bb78, #38a169);
    border: none; border-radius: var(--radius-sm);
    color: #fff; font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem; font-weight: 500;
    padding: 0.6rem 1.4rem;
    cursor: pointer;
    transition: transform 0.2s cubic-bezier(.22,.68,0,1.2),
                box-shadow 0.2s ease, filter 0.2s ease;
    box-shadow: 0 4px 14px rgba(72,187,120,0.3);
  }
  .btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(72,187,120,0.42);
    filter: brightness(1.08);
  }
  .btn-add:active { transform: translateY(0); }

  .btn-update {
    display: inline-flex; align-items: center; gap: 0.35rem;
    background: rgba(99,179,237,0.12);
    border: 1px solid rgba(99,179,237,0.25);
    border-radius: var(--radius-sm);
    color: var(--accent-blue);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.78rem; font-weight: 500;
    padding: 0.38rem 0.85rem;
    cursor: pointer; white-space: nowrap;
    transition: background 0.2s, border-color 0.2s, transform 0.18s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s;
  }
  .btn-update:hover {
    background: rgba(99,179,237,0.2);
    border-color: rgba(99,179,237,0.4);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(99,179,237,0.2);
  }

  .btn-del {
    display: inline-flex; align-items: center; gap: 0.35rem;
    background: rgba(252,129,129,0.1);
    border: 1px solid rgba(252,129,129,0.22);
    border-radius: var(--radius-sm);
    color: var(--accent-red);
    font-family: 'DM Sans', sans-serif;
    font-size: 0.78rem; font-weight: 500;
    padding: 0.38rem 0.85rem;
    cursor: pointer; white-space: nowrap;
    transition: background 0.2s, border-color 0.2s, transform 0.18s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s;
  }
  .btn-del:hover {
    background: rgba(252,129,129,0.2);
    border-color: rgba(252,129,129,0.38);
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(252,129,129,0.18);
  }

  /* ── TABLE ── */
  .table-section { animation: fadeUp 0.5s 0.12s ease both; }

  .table-wrapper {
    overflow-x: auto;
    border-radius: var(--radius-lg);
  }
  .table-wrapper::-webkit-scrollbar { height: 5px; }
  .table-wrapper::-webkit-scrollbar-track { background: transparent; }
  .table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  .students-table {
    width: 100%; border-collapse: collapse;
    font-size: 0.875rem;
  }

  .students-table thead tr {
    background: rgba(255,255,255,0.04);
  }
  .students-table thead th {
    padding: 0.9rem 1rem;
    font-size: 0.68rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--text-muted);
    border-bottom: 1px solid var(--border);
    white-space: nowrap;
  }
  .students-table thead th:first-child { padding-left: 1.4rem; border-radius: var(--radius-md) 0 0 0; }
  .students-table thead th:last-child  { padding-right: 1.4rem; border-radius: 0 var(--radius-md) 0 0; }

  .students-table tbody tr {
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.18s ease;
  }
  .students-table tbody tr:last-child { border-bottom: none; }
  .students-table tbody tr:hover { background: rgba(255,255,255,0.03); }

  .students-table tbody td {
    padding: 0.65rem 1rem;
    vertical-align: middle;
    color: var(--text-sub);
  }
  .students-table tbody td:first-child { padding-left: 1.4rem; }
  .students-table tbody td:last-child  { padding-right: 1.4rem; }

  /* ID cell pill */
  .id-pill {
    display: inline-flex; align-items: center;
    background: rgba(255,255,255,0.05);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.2rem 0.55rem;
    font-size: 0.75rem; font-weight: 600;
    font-family: 'Syne', monospace;
    color: var(--text-muted);
    letter-spacing: 0.04em;
  }

  /* Inline table inputs */
  .table-input {
    background: rgba(255,255,255,0.04) !important;
    border: 1px solid transparent !important;
    border-radius: var(--radius-sm) !important;
    color: var(--text-primary) !important;
    font-family: 'DM Sans', sans-serif !important;
    font-size: 0.85rem !important;
    padding: 0.38rem 0.65rem !important;
    width: 100%; min-width: 110px;
    transition: border-color 0.18s ease, background 0.18s ease, box-shadow 0.18s ease !important;
  }
  .table-input:focus {
    outline: none !important;
    background: rgba(255,255,255,0.07) !important;
    border-color: rgba(99,179,237,0.4) !important;
    box-shadow: 0 0 0 2px rgba(99,179,237,0.1) !important;
  }
  tr:hover .table-input {
    border-color: rgba(255,255,255,0.08) !important;
  }

  .action-cell { display: flex; gap: 0.45rem; align-items: center; }

  /* Empty state */
  .empty-state {
    text-align: center; padding: 3.5rem 1rem;
    color: var(--text-muted);
  }
  .empty-state i { font-size: 2.5rem; opacity: 0.3; display: block; margin-bottom: 0.75rem; }
  .empty-state p { font-size: 0.88rem; }

  /* ── ANIMATIONS ── */
  @keyframes fadeDown {
    from { opacity: 0; transform: translateY(-14px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(18px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  /* ── SCROLLBAR ── */
  ::-webkit-scrollbar { width: 6px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

  /* ── RESPONSIVE ── */
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
      <div class="page-eyebrow">Student Management</div>
      <h1 class="page-title">Manage Students</h1>
    </div>
    <span class="student-count-badge">
      <i class="bi bi-people-fill"></i>
      <%= students != null ? students.size() : 0 %> enrolled
    </span>
  </div>

  <!-- ═══════════════ ADD FORM ═══════════════ -->
  <div class="add-form mb-4">
    <div class="section-label">Add New Student</div>

    <div class="glass-card">
      <div class="glass-card-header">
        <div class="card-icon"><i class="bi bi-person-plus-fill"></i></div>
        <h6>New Enrollment</h6>
      </div>
      <div class="glass-card-body">

        <form method="post">
          <input type="hidden" name="action" value="add">

          <div class="form-grid">

            <div class="field-wrap">
              <label class="field-label">Username</label>
              <input name="username" placeholder="e.g. john_doe"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Password</label>
              <input name="password" placeholder="Set password" type="password"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Full Name</label>
              <input name="name" placeholder="e.g. John Doe"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Email</label>
              <input name="email" placeholder="john@example.com" type="email"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Course ID</label>
              <input name="courseId" placeholder="e.g. 101"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Roll No</label>
              <input name="rollNo" placeholder="e.g. CS2024001"
                     class="form-input" required>
            </div>

          </div>

          <button class="btn-add" type="submit">
            <i class="bi bi-person-plus-fill"></i> Add Student
          </button>
        </form>

      </div>
    </div>
  </div>

  <!-- ═══════════════ TABLE ═══════════════ -->
  <div class="table-section">
    <div class="section-label">All Students</div>

    <div class="glass-card">
      <div class="table-wrapper">
        <table class="students-table">

          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>Roll No</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            <%
            if (students != null && !students.isEmpty()) {
              for (Student s : students) {
            %>

            <tr>

              <form method="post">

                <td>
                  <span class="id-pill">#<%= s.getId() %></span>
                  <input type="hidden" name="id" value="<%= s.getId() %>">
                </td>

                <td>
                  <input name="name" value="<%= s.getName() %>" class="table-input">
                </td>

                <td>
                  <input name="email" value="<%= s.getEmail() %>" class="table-input">
                </td>

                <td>
                  <input name="rollNo" value="<%= s.getRollNo() %>" class="table-input">
                </td>

                <td>
                  <input type="hidden" name="courseId" value="<%= s.getCourseId() %>">
                  <input type="hidden" name="semester" value="<%= s.getSemester() %>">

                  <div class="action-cell">
                    <button name="action" value="update" class="btn-update">
                      <i class="bi bi-pencil-fill"></i> Update
                    </button>
                    <button name="action" value="delete" class="btn-del"
                            onclick="return confirm('Delete this student?')">
                      <i class="bi bi-trash3-fill"></i> Delete
                    </button>
                  </div>
                </td>

              </form>

            </tr>

            <%
              }
            } else {
            %>
            <tr>
              <td colspan="5">
                <div class="empty-state">
                  <i class="bi bi-people"></i>
                  <p>No students enrolled yet. Add one above.</p>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
