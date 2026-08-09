<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.*,model.Course"%>

<%
List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Courses</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-deep:       #08090d;
    --bg-card:       rgba(255,255,255,0.04);
    --bg-card-hover: rgba(255,255,255,0.065);
    --border:        rgba(255,255,255,0.08);
    --border-focus:  rgba(104,211,145,0.5);
    --accent-green:  #68d391;
    --accent-teal:   #4fd1c5;
    --accent-blue:   #63b3ed;
    --accent-violet: #9f7aea;
    --accent-red:    #fc8181;
    --accent-amber:  #f6ad55;
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
      radial-gradient(ellipse 60% 50% at 0% 20%,   rgba(104,211,145,0.09) 0%, transparent 60%),
      radial-gradient(ellipse 50% 50% at 100% 0%,   rgba(79,209,197,0.08)  0%, transparent 55%),
      radial-gradient(ellipse 55% 40% at 40% 100%,  rgba(99,179,237,0.06)  0%, transparent 50%);
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
    color: var(--accent-green);
    display: flex; align-items: center; gap: 0.45rem;
    margin-bottom: 0.3rem;
  }
  .page-eyebrow::before {
    content: ''; display: inline-block;
    width: 16px; height: 2px;
    background: var(--accent-green); border-radius: 2px;
  }
  .page-title {
    font-family: 'Syne', sans-serif;
    font-size: clamp(1.7rem, 3.5vw, 2.4rem);
    font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
    background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-green) 100%);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  .count-badge {
    display: inline-flex; align-items: center; gap: 0.4rem;
    background: rgba(104,211,145,0.1);
    border: 1px solid rgba(104,211,145,0.22);
    color: var(--accent-green);
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

  /* ── form ── */
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
    box-shadow: 0 0 0 3px rgba(104,211,145,0.12);
    color: var(--text-primary);
  }
  /* hide number spinners */
  .form-input[type="number"]::-webkit-inner-spin-button,
  .form-input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; }
  .form-input[type="number"] { -moz-appearance: textfield; }

  /* ── buttons ── */
  .btn-add {
    display: inline-flex; align-items: center; gap: 0.5rem;
    background: linear-gradient(135deg, #48bb78, #276749);
    border: none; border-radius: var(--radius-sm);
    color: #fff; font-family: 'DM Sans', sans-serif;
    font-size: 0.875rem; font-weight: 500;
    padding: 0.6rem 1.4rem; cursor: pointer;
    transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
    box-shadow: 0 4px 14px rgba(72,187,120,0.3);
  }
  .btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(72,187,120,0.42);
    filter: brightness(1.1);
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

  .courses-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }

  .courses-table thead tr { background: rgba(255,255,255,0.04); }
  .courses-table thead th {
    padding: 0.9rem 1rem;
    font-size: 0.68rem; font-weight: 600;
    letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--text-muted);
    border-bottom: 1px solid var(--border);
    white-space: nowrap; text-align: left;
  }
  .courses-table thead th:first-child { padding-left: 1.4rem; }
  .courses-table thead th:last-child  { padding-right: 1.4rem; text-align: center; }

  .courses-table tbody tr {
    border-bottom: 1px solid rgba(255,255,255,0.04);
    transition: background 0.18s ease;
  }
  .courses-table tbody tr:last-child { border-bottom: none; }
  .courses-table tbody tr:hover { background: rgba(255,255,255,0.03); }

  .courses-table tbody td {
    padding: 0.85rem 1rem;
    vertical-align: middle; color: var(--text-sub);
  }
  .courses-table tbody td:first-child { padding-left: 1.4rem; }
  .courses-table tbody td:last-child  { padding-right: 1.4rem; text-align: center; }

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

  /* course name cell */
  .course-name-cell { display: flex; align-items: center; gap: 0.7rem; }
  .course-icon-box {
    width: 32px; height: 32px;
    border-radius: var(--radius-sm);
    background: linear-gradient(135deg, rgba(104,211,145,0.2), rgba(79,209,197,0.15));
    border: 1px solid rgba(104,211,145,0.2);
    display: flex; align-items: center; justify-content: center;
    color: var(--accent-green); font-size: 0.85rem; flex-shrink: 0;
  }
  .course-name { font-weight: 500; color: var(--text-primary); }

  /* code badge */
  .code-badge {
    display: inline-flex; align-items: center;
    background: rgba(79,209,197,0.08);
    border: 1px solid rgba(79,209,197,0.18);
    border-radius: 6px;
    padding: 0.18rem 0.6rem;
    font-size: 0.78rem; font-weight: 600;
    font-family: 'Syne', monospace;
    color: var(--accent-teal); letter-spacing: 0.05em;
  }

  /* credits badge */
  .credits-badge {
    display: inline-flex; align-items: center; gap: 0.28rem;
    background: rgba(246,173,85,0.08);
    border: 1px solid rgba(246,173,85,0.18);
    border-radius: 50px;
    padding: 0.18rem 0.65rem;
    font-size: 0.78rem; font-weight: 600;
    color: var(--accent-amber);
  }

  /* dept chip */
  .dept-chip {
    display: inline-flex; align-items: center; gap: 0.3rem;
    background: rgba(104,211,145,0.07);
    border: 1px solid rgba(104,211,145,0.14);
    border-radius: 50px;
    padding: 0.2rem 0.65rem;
    font-size: 0.75rem; color: var(--accent-green);
  }

  /* empty state */
  .empty-state {
    text-align: center; padding: 3.5rem 1rem;
    color: var(--text-muted);
  }
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
      <div class="page-eyebrow">Course Management</div>
      <h1 class="page-title">Manage Courses</h1>
    </div>
    <span class="count-badge">
      <i class="bi bi-journal-bookmark-fill"></i>
      <%= (courses != null ? courses.size() : 0) %> courses
    </span>
  </div>

  <!-- ═══ ADD COURSE FORM ═══ -->
  <div class="add-form" style="margin-bottom: 1.5rem;">
    <div class="section-label">Add New Course</div>

    <div class="glass-card">
      <div class="glass-card-header">
        <div class="card-icon"><i class="bi bi-journal-plus"></i></div>
        <h6>New Course Entry</h6>
      </div>
      <div class="glass-card-body">

        <form method="post" action="${pageContext.request.contextPath}/admin/courses">
          <input type="hidden" name="action" value="add">

          <div class="form-grid">

            <div class="field-wrap">
              <label class="field-label">Course Name</label>
              <input type="text" name="name" placeholder="e.g. Data Structures"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Course Code</label>
              <input type="text" name="code" placeholder="e.g. CS301"
                     class="form-input">
            </div>

            <div class="field-wrap">
              <label class="field-label">Credits</label>
              <input type="number" name="credits" placeholder="e.g. 4"
                     class="form-input" required>
            </div>

            <div class="field-wrap">
              <label class="field-label">Department</label>
              <input type="text" name="department" placeholder="e.g. Computer Science"
                     class="form-input">
            </div>

          </div>

          <button type="submit" class="btn-add">
            <i class="bi bi-journal-plus"></i> Add Course
          </button>
        </form>

      </div>
    </div>
  </div>

  <div class="dash-divider"></div>

  <!-- ═══ COURSES TABLE ═══ -->
  <div class="table-section">
    <div class="section-label">All Courses</div>

    <div class="glass-card">
      <div class="table-wrapper">
        <table class="courses-table">

          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Code</th>
              <th>Credits</th>
              <th>Department</th>
              <th>Action</th>
            </tr>
          </thead>

          <tbody>

            <%
            if (courses != null && !courses.isEmpty()) {
              for (Course c : courses) {
            %>

            <tr>

              <td><span class="id-pill">#<%= c.getId() %></span></td>

              <td>
                <div class="course-name-cell">
                  <div class="course-icon-box"><i class="bi bi-journal-text"></i></div>
                  <span class="course-name"><%= c.getName() %></span>
                </div>
              </td>

              <td>
                <span class="code-badge"><%= c.getCode() %></span>
              </td>

              <td>
                <span class="credits-badge">
                  <i class="bi bi-star-fill" style="font-size:0.65rem;"></i>
                  <%= c.getCredits() %> cr
                </span>
              </td>

              <td>
                <span class="dept-chip">
                  <i class="bi bi-building" style="font-size:0.7rem;"></i>
                  <%= c.getDepartment() %>
                </span>
              </td>

              <td>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/courses"
                      style="display:inline;">
                  <input type="hidden" name="action" value="delete">
                  <input type="hidden" name="id" value="<%= c.getId() %>">
                  <button type="submit" class="btn-del"
                          onclick="return confirm('Delete course <%= c.getName() %>?')">
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
                  <i class="bi bi-journal-bookmark"></i>
                  <p>No courses added yet. Add one above.</p>
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
