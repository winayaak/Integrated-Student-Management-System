<%@ page import="java.sql.*"%>
<%@ page import="util.DBConnection"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hostel Allocation — ISMS</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --bg:          #08090d;
  --bg-sidebar:  #0c0d14;
  --bg-card:     rgba(255,255,255,0.04);
  --bg-hover:    rgba(255,255,255,0.07);
  --border:      rgba(255,255,255,0.08);
  --border-focus:rgba(79,209,197,0.5);
  --blue:        #63b3ed;
  --violet:      #9f7aea;
  --green:       #68d391;
  --amber:       #f6ad55;
  --red:         #fc8181;
  --teal:        #4fd1c5;
  --text:        #f0f4f8;
  --sub:         #a0aec0;
  --muted:       #4a5568;
  --sidebar-w:   240px;
  --r-lg:        18px;
  --r-md:        12px;
  --r-sm:        8px;
  --shadow:      0 8px 32px rgba(0,0,0,0.5);
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
    radial-gradient(ellipse 60% 50% at 5%  0%,   rgba(79,209,197,0.09)  0%, transparent 60%),
    radial-gradient(ellipse 50% 55% at 98% 8%,   rgba(99,179,237,0.08)  0%, transparent 55%),
    radial-gradient(ellipse 55% 40% at 50% 100%, rgba(104,211,145,0.06) 0%, transparent 50%);
  pointer-events: none; z-index: 0;
}
body::after {
  content: '';
  position: fixed; inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
  pointer-events: none; z-index: 0; opacity: 0.55;
}

/* ══ LAYOUT ══ */
.layout { display: flex; min-height: 100vh; position: relative; z-index: 1; }

/* ══ SIDEBAR ══ */
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
  width: 36px; height: 36px; border-radius: var(--r-sm);
  background: linear-gradient(135deg, var(--teal), var(--blue));
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem; color: #fff; flex-shrink: 0;
}
.brand-text {
  font-family: 'Syne', sans-serif;
  font-size: 1rem; font-weight: 800; letter-spacing: -0.02em;
  color: var(--text); line-height: 1.15;
}
.brand-sub { font-size: 0.65rem; color: var(--muted); letter-spacing: 0.06em; }
.nav-section-label {
  font-size: 0.62rem; font-weight: 600;
  letter-spacing: 0.14em; text-transform: uppercase;
  color: var(--muted); padding: 0 0.5rem; margin-bottom: 0.5rem;
}
.nav-list { list-style: none; display: flex; flex-direction: column; gap: 0.18rem; }
.nav-item a {
  display: flex; align-items: center; gap: 0.7rem;
  padding: 0.58rem 0.75rem; border-radius: var(--r-sm);
  text-decoration: none; color: var(--sub);
  font-size: 0.875rem; font-weight: 400;
  transition: background 0.18s, color 0.18s, transform 0.18s;
  position: relative;
}
.nav-item a:hover { background: rgba(255,255,255,0.06); color: var(--text); transform: translateX(2px); }
.nav-item.active a {
  background: rgba(79,209,197,0.1); color: var(--teal); font-weight: 500;
  border: 1px solid rgba(79,209,197,0.15);
}
.nav-item.active a::before {
  content: ''; position: absolute; left: 0; top: 20%; bottom: 20%;
  width: 3px; border-radius: 0 3px 3px 0; background: var(--teal);
}
.nav-icon { font-size: 1rem; flex-shrink: 0; width: 18px; text-align: center; }
.sidebar-spacer { flex: 1; min-height: 1rem; }
.logout-item a {
  display: flex; align-items: center; gap: 0.7rem;
  padding: 0.58rem 0.75rem; border-radius: var(--r-sm);
  text-decoration: none; color: var(--red);
  font-size: 0.875rem; opacity: 0.75;
  transition: background 0.18s, opacity 0.18s;
}
.logout-item a:hover { background: rgba(252,129,129,0.08); opacity: 1; }

/* ══ MAIN ══ */
.main { flex: 1; padding: 2.5rem 2rem 5rem; overflow-x: hidden; }

/* ── page header ── */
.page-header {
  display: flex; align-items: flex-end; justify-content: space-between;
  flex-wrap: wrap; gap: 1rem; margin-bottom: 2.5rem;
  animation: fadeDown 0.5s ease both;
}
.page-eyebrow {
  font-size: 0.7rem; font-weight: 500;
  letter-spacing: 0.18em; text-transform: uppercase;
  color: var(--teal);
  display: flex; align-items: center; gap: 0.45rem; margin-bottom: 0.3rem;
}
.page-eyebrow::before {
  content: ''; display: inline-block; width: 16px; height: 2px;
  background: var(--teal); border-radius: 2px;
}
.page-title {
  font-family: 'Syne', sans-serif;
  font-size: clamp(1.7rem, 3vw, 2.4rem);
  font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
  background: linear-gradient(130deg, #f0f4f8 30%, var(--teal) 100%);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  background-clip: text;
}
.page-sub { margin-top: 0.4rem; font-size: 0.875rem; color: var(--muted); font-weight: 300; }

/* ── section label ── */
.sec-label {
  font-size: 0.68rem; font-weight: 500;
  letter-spacing: 0.16em; text-transform: uppercase;
  color: var(--muted); margin-bottom: 0.85rem;
}

/* ── glass card ── */
.glass-card {
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-lg); backdrop-filter: blur(18px);
  box-shadow: var(--shadow); position: relative; overflow: hidden;
  margin-bottom: 1.5rem;
}
.glass-card::before {
  content: ''; position: absolute; inset: 0;
  background: linear-gradient(135deg, rgba(255,255,255,0.035) 0%, transparent 55%);
  pointer-events: none;
}
.gc-header {
  padding: 1.2rem 1.6rem; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; gap: 0.75rem;
}
.gc-icon {
  width: 34px; height: 34px; border-radius: var(--r-sm);
  display: flex; align-items: center; justify-content: center;
  font-size: 0.95rem; flex-shrink: 0;
}
.gc-icon.teal   { background: rgba(79,209,197,0.12);  border: 1px solid rgba(79,209,197,0.18);  color: var(--teal); }
.gc-icon.violet { background: rgba(159,122,234,0.12); border: 1px solid rgba(159,122,234,0.18); color: var(--violet); }
.gc-header h6 { font-family: 'Syne', sans-serif; font-size: 0.92rem; font-weight: 700; color: var(--text); margin: 0; }
.gc-body { padding: 1.6rem; }

/* ── form ── */
.alloc-form { animation: fadeUp 0.5s 0.06s ease both; }

.form-grid {
  display: grid; grid-template-columns: 1fr 1fr;
  gap: 1rem; margin-bottom: 1.2rem;
}
.field-wrap { display: flex; flex-direction: column; gap: 0.3rem; }
.field-label {
  font-size: 0.7rem; font-weight: 500;
  letter-spacing: 0.07em; text-transform: uppercase; color: var(--muted);
}
.form-select-styled {
  background: rgba(255,255,255,0.04); border: 1px solid var(--border);
  border-radius: var(--r-sm); color: var(--text);
  font-family: 'DM Sans', sans-serif; font-size: 0.875rem;
  padding: 0.65rem 2.4rem 0.65rem 0.9rem; width: 100%;
  transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
  -webkit-appearance: none; appearance: none; cursor: pointer;
}
.form-select-styled:focus {
  outline: none; background: rgba(255,255,255,0.06);
  border-color: var(--border-focus);
  box-shadow: 0 0 0 3px rgba(79,209,197,0.12); color: var(--text);
}
.form-select-styled option { background: #1a1d27; color: var(--text); }
.select-wrap { position: relative; }
.select-wrap::after {
  content: '\F282'; font-family: 'bootstrap-icons';
  position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%);
  color: var(--muted); font-size: 0.8rem; pointer-events: none;
}

.btn-allocate {
  display: inline-flex; align-items: center; gap: 0.5rem;
  background: linear-gradient(135deg, var(--teal), #2c7a7b);
  border: none; border-radius: var(--r-sm); color: #fff;
  font-family: 'DM Sans', sans-serif; font-size: 0.9rem; font-weight: 500;
  padding: 0.68rem 1.8rem; cursor: pointer; width: 100%; justify-content: center;
  transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
  box-shadow: 0 4px 16px rgba(79,209,197,0.3);
}
.btn-allocate:hover {
  transform: translateY(-2px); filter: brightness(1.1);
  box-shadow: 0 6px 22px rgba(79,209,197,0.42);
}
.btn-allocate:active { transform: translateY(0); }

/* ── allocations table ── */
.table-section { animation: fadeUp 0.5s 0.12s ease both; }

.table-wrapper { overflow-x: auto; }
.table-wrapper::-webkit-scrollbar { height: 5px; }
.table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

.alloc-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.alloc-table thead tr { background: rgba(255,255,255,0.04); }
.alloc-table thead th {
  padding: 0.9rem 1rem; font-size: 0.67rem; font-weight: 600;
  letter-spacing: 0.1em; text-transform: uppercase;
  color: var(--muted); border-bottom: 1px solid var(--border);
  text-align: left; white-space: nowrap;
}
.alloc-table thead th:first-child { padding-left: 1.4rem; }
.alloc-table thead th:last-child  { padding-right: 1.4rem; }
.alloc-table tbody tr {
  border-bottom: 1px solid rgba(255,255,255,0.04);
  transition: background 0.18s;
}
.alloc-table tbody tr:last-child { border-bottom: none; }
.alloc-table tbody tr:hover { background: rgba(255,255,255,0.03); }
.alloc-table tbody td {
  padding: 0.85rem 1rem; vertical-align: middle; color: var(--sub);
}
.alloc-table tbody td:first-child { padding-left: 1.4rem; }
.alloc-table tbody td:last-child  { padding-right: 1.4rem; }

/* student cell */
.student-cell { display: flex; align-items: center; gap: 0.65rem; }
.student-avatar {
  width: 30px; height: 30px; border-radius: 50%; flex-shrink: 0;
  background: linear-gradient(135deg, var(--teal), var(--blue));
  display: flex; align-items: center; justify-content: center;
  font-size: 0.72rem; font-weight: 700; color: #fff;
  text-transform: uppercase; border: 1px solid rgba(79,209,197,0.3);
}
.student-name { font-weight: 500; color: var(--text); }

/* room badge */
.room-badge {
  display: inline-flex; align-items: center; gap: 0.28rem;
  background: rgba(79,209,197,0.08); border: 1px solid rgba(79,209,197,0.18);
  border-radius: 6px; padding: 0.18rem 0.6rem;
  font-size: 0.78rem; font-weight: 700; color: var(--teal);
  font-family: 'Syne', monospace; letter-spacing: 0.04em;
}

/* block chip */
.block-chip {
  display: inline-flex; align-items: center; gap: 0.3rem;
  background: rgba(99,179,237,0.08); border: 1px solid rgba(99,179,237,0.18);
  border-radius: 50px; padding: 0.2rem 0.65rem;
  font-size: 0.75rem; font-weight: 600; color: var(--blue);
}

/* date cell */
.date-cell { font-size: 0.8rem; color: var(--muted); }

/* status */
.alloc-status {
  display: inline-flex; align-items: center; gap: 0.28rem;
  background: rgba(104,211,145,0.1); border: 1px solid rgba(104,211,145,0.22);
  border-radius: 50px; padding: 0.2rem 0.65rem;
  font-size: 0.73rem; font-weight: 600; color: var(--green);
}
.alloc-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

/* empty state */
.empty-state { text-align: center; padding: 3.5rem 1rem; color: var(--muted); }
.empty-state i { font-size: 2.5rem; opacity: 0.25; display: block; margin-bottom: 0.75rem; }
.empty-state p { font-size: 0.88rem; }

/* divider */
.dash-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--border), transparent);
  margin: 2rem 0;
}

@keyframes fadeDown { from { opacity:0; transform:translateY(-14px); } to { opacity:1; transform:translateY(0); } }
@keyframes fadeUp   { from { opacity:0; transform:translateY(18px);  } to { opacity:1; transform:translateY(0); } }

::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

@media (max-width: 900px) {
  .sidebar { display: none; }
  .main { padding: 1.5rem 1rem 3.5rem; }
}
@media (max-width: 600px) {
  .form-grid { grid-template-columns: 1fr; }
  .gc-body { padding: 1.2rem; }
  .page-header { flex-direction: column; align-items: flex-start; }
}
</style>
</head>
<body>

<%
/* ── DB queries (unchanged) ── */
Connection conn = DBConnection.getConnection();
Statement st    = conn.createStatement();
ResultSet rs    = st.executeQuery("SELECT id,name FROM students");
%>

<div class="layout">

  <!-- ══════════ SIDEBAR ══════════ -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="brand-icon"><i class="bi bi-mortarboard-fill"></i></div>
      <div>
        <div class="brand-text">ISMS</div>
        <div class="brand-sub">Admin Panel</div>
      </div>
    </div>

    <div class="nav-section-label">Navigation</div>
    <ul class="nav-list">
      <li class="nav-item">
        <a href="dashboard.jsp">
          <span class="nav-icon"><i class="bi bi-grid-1x2-fill"></i></span> Dashboard
        </a>
      </li>
      <li class="nav-item">
        <a href="placement">
          <span class="nav-icon"><i class="bi bi-briefcase-fill"></i></span> Placement
        </a>
      </li>
      <li class="nav-item active">
        <a href="hostel">
          <span class="nav-icon"><i class="bi bi-building"></i></span> Hostel
        </a>
      </li>
    </ul>

    <div class="sidebar-spacer"></div>
    <ul class="nav-list">
      <li class="logout-item">
        <a href="../logout">
          <span class="nav-icon"><i class="bi bi-box-arrow-left"></i></span> Logout
        </a>
      </li>
    </ul>
  </aside>

  <!-- ══════════ MAIN ══════════ -->
  <main class="main">

    <!-- PAGE HEADER -->
    <div class="page-header">
      <div>
        <div class="page-eyebrow">Admin · Accommodation</div>
        <h1 class="page-title">Hostel Room Allocation</h1>
        <p class="page-sub">Assign students to hostel rooms and manage current allocations.</p>
      </div>
    </div>

    <!-- ═══ ALLOCATE FORM ═══ -->
    <div class="alloc-form">
      <div class="sec-label">New Allocation</div>
      <div class="glass-card">
        <div class="gc-header">
          <div class="gc-icon teal"><i class="bi bi-person-plus-fill"></i></div>
          <h6>Assign Room to Student</h6>
        </div>
        <div class="gc-body">
          <form method="post">

            <div class="form-grid">

              <div class="field-wrap">
                <label class="field-label">Select Student</label>
                <div class="select-wrap">
                  <select name="studentId" class="form-select-styled">
                    <%
                    while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                    <%
                    }
                    %>
                  </select>
                </div>
              </div>

              <div class="field-wrap">
                <label class="field-label">Select Room</label>
                <div class="select-wrap">
                  <%
                  ResultSet r = st.executeQuery("SELECT id,room_no,block FROM hostel_rooms");
                  %>
                  <select name="roomId" class="form-select-styled">
                    <%
                    while (r.next()) {
                    %>
                    <option value="<%= r.getInt("id") %>">
                      Room <%= r.getString("room_no") %> — Block <%= r.getString("block") %>
                    </option>
                    <%
                    }
                    %>
                  </select>
                </div>
              </div>

            </div>

            <button type="submit" class="btn-allocate">
              <i class="bi bi-building-add"></i> Allocate Room
            </button>

          </form>
        </div>
      </div>
    </div>

    <div class="dash-divider"></div>

    <!-- ═══ CURRENT ALLOCATIONS TABLE ═══ -->
    <div class="table-section">
      <div class="sec-label">Current Allocations</div>

      <div class="glass-card">
        <div class="gc-header">
          <div class="gc-icon violet"><i class="bi bi-list-check"></i></div>
          <h6>All Hostel Allocations</h6>
        </div>

        <div class="table-wrapper">
          <table class="alloc-table">

            <thead>
              <tr>
                <th>Student</th>
                <th>Room</th>
                <th>Block</th>
                <th>Allocated Date</th>
                <th>Status</th>
              </tr>
            </thead>

            <tbody>
              <%
              ResultSet data = st.executeQuery(
                "SELECT s.name, r.room_no, r.block, h.allocated_date " +
                "FROM hostel h " +
                "JOIN students s ON h.student_id = s.id " +
                "JOIN hostel_rooms r ON h.room_id = r.id"
              );

              boolean hasRows = false;
              while (data.next()) {
                hasRows = true;
                String sName   = data.getString("name");
                String initials = (sName != null && sName.length() > 0)
                  ? String.valueOf(sName.charAt(0)).toUpperCase() : "S";
              %>

              <tr>

                <td>
                  <div class="student-cell">
                    <div class="student-avatar"><%= initials %></div>
                    <span class="student-name"><%= sName %></span>
                  </div>
                </td>

                <td>
                  <span class="room-badge">
                    <i class="bi bi-door-open-fill" style="font-size:0.65rem;"></i>
                    <%= data.getString("room_no") %>
                  </span>
                </td>

                <td>
                  <span class="block-chip">
                    <i class="bi bi-building" style="font-size:0.68rem;"></i>
                    Block <%= data.getString("block") %>
                  </span>
                </td>

                <td>
                  <span class="date-cell">
                    <i class="bi bi-calendar3" style="margin-right:4px;opacity:0.5;"></i>
                    <%= data.getString("allocated_date") %>
                  </span>
                </td>

                <td>
                  <span class="alloc-status">
                    <span class="alloc-dot"></span> Active
                  </span>
                </td>

              </tr>

              <%
              }
              if (!hasRows) {
              %>
              <tr>
                <td colspan="5">
                  <div class="empty-state">
                    <i class="bi bi-building-x"></i>
                    <p>No allocations yet. Use the form above to assign rooms.</p>
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
