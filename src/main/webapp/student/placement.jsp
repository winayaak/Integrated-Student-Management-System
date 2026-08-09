<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.PlacementDAO"%>
<%@ page import="model.Student"%>
<%@ page import="model.User"%>
<%@ page import="java.util.List"%>

<%
Student student = (Student) request.getAttribute("student");

/* If servlet did not send student, take it from session */
if (student == null) {
	User u = (User) session.getAttribute("user");
	if (u != null) {
		student = new Student();
		student.setId(u.getId());
		student.setName(u.getUsername());
	}
}

List<PlacementDAO.Company> companies = (List<PlacementDAO.Company>) request.getAttribute("companies");
List<PlacementDAO.PlacementRecord> applications = (List<PlacementDAO.PlacementRecord>) request
		.getAttribute("applications");

if (companies == null)
	companies = java.util.Collections.emptyList();

if (applications == null)
	applications = java.util.Collections.emptyList();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Placement — ISMS</title>

<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

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
  --pink:     #f687b3;
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

.page-wrap {
  position: relative; z-index: 1;
  max-width: 1100px; margin: 0 auto;
  padding: 2.5rem 1.5rem 5rem;
}

/* ── page header ── */
.page-header {
  display: flex; align-items: flex-end; justify-content: space-between;
  flex-wrap: wrap; gap: 1rem; margin-bottom: 2.5rem;
  animation: fadeDown 0.5s ease both;
}
.page-eyebrow {
  font-size: 0.7rem; font-weight: 500;
  letter-spacing: 0.18em; text-transform: uppercase;
  color: var(--pink);
  display: flex; align-items: center; gap: 0.45rem; margin-bottom: 0.3rem;
}
.page-eyebrow::before {
  content: ''; display: inline-block; width: 16px; height: 2px;
  background: var(--pink); border-radius: 2px;
}
.page-title {
  font-family: 'Syne', sans-serif;
  font-size: clamp(1.8rem, 3.5vw, 2.5rem);
  font-weight: 800; letter-spacing: -0.03em; line-height: 1.1;
  background: linear-gradient(130deg, #f0f4f8 30%, var(--pink) 100%);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  background-clip: text;
}
.back-btn {
  display: inline-flex; align-items: center; gap: 0.4rem;
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-sm); color: var(--sub);
  font-family: 'DM Sans', sans-serif; font-size: 0.82rem; font-weight: 500;
  padding: 0.45rem 1rem; text-decoration: none; backdrop-filter: blur(10px);
  transition: background 0.2s, color 0.2s, transform 0.18s;
}
.back-btn:hover { background: var(--bg-hover); color: var(--text); transform: translateX(-2px); }

/* ── section label ── */
.sec-label {
  font-size: 0.68rem; font-weight: 500;
  letter-spacing: 0.16em; text-transform: uppercase;
  color: var(--muted); margin-bottom: 0.85rem;
}

/* ── stat cards ── */
.stat-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
  gap: 1rem; margin-bottom: 2rem;
  animation: fadeUp 0.5s 0.05s ease both;
}
.stat-card {
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--r-md); padding: 1.2rem 1.3rem;
  backdrop-filter: blur(14px); box-shadow: var(--shadow);
  position: relative; overflow: hidden;
  transition: transform 0.25s cubic-bezier(.22,.68,0,1.2), border-color 0.25s;
  cursor: default;
}
.stat-card::after {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px;
  border-radius: 2px 2px 0 0; background: var(--sc-a, var(--pink)); opacity: 0.7;
  transition: opacity 0.2s;
}
.stat-card:hover { transform: translateY(-3px); }
.stat-card:hover::after { opacity: 1; }
.sc-1 { --sc-a: var(--pink); }
.sc-2 { --sc-a: var(--green); }
.sc-3 { --sc-a: var(--amber); }
.sc-4 { --sc-a: var(--blue); }
.sc-icon {
  width: 32px; height: 32px; border-radius: var(--r-sm);
  background: rgba(255,255,255,0.06);
  display: flex; align-items: center; justify-content: center;
  font-size: 0.9rem; color: var(--sc-a, var(--pink)); margin-bottom: 0.8rem;
}
.sc-label { font-size: 0.68rem; text-transform: uppercase; letter-spacing: 0.08em; color: var(--muted); margin-bottom: 0.25rem; }
.sc-value { font-family: 'Syne', sans-serif; font-size: 1.55rem; font-weight: 800; letter-spacing: -0.03em; color: var(--text); }

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
.gc-icon.pink   { background: rgba(246,135,179,0.12); border: 1px solid rgba(246,135,179,0.18); color: var(--pink); }
.gc-icon.violet { background: rgba(159,122,234,0.12); border: 1px solid rgba(159,122,234,0.18); color: var(--violet); }
.gc-header h6 { font-family: 'Syne', sans-serif; font-size: 0.92rem; font-weight: 700; color: var(--text); margin: 0; }
.gc-body { padding: 1.6rem; }

/* ── apply form ── */
.apply-form { animation: fadeUp 0.5s 0.07s ease both; }

.field-wrap { display: flex; flex-direction: column; gap: 0.3rem; margin-bottom: 1rem; }
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
  -webkit-appearance: none; appearance: none;
  cursor: pointer;
}
.form-select-styled:focus {
  outline: none; background: rgba(255,255,255,0.06);
  border-color: rgba(246,135,179,0.45);
  box-shadow: 0 0 0 3px rgba(246,135,179,0.1); color: var(--text);
}
.form-select-styled option { background: #1a1d27; color: var(--text); }
.select-wrap { position: relative; }
.select-wrap::after {
  content: '\F282'; font-family: 'bootstrap-icons';
  position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%);
  color: var(--muted); font-size: 0.8rem; pointer-events: none;
}

.btn-apply {
  display: inline-flex; align-items: center; gap: 0.5rem;
  background: linear-gradient(135deg, var(--pink), #c05a85);
  border: none; border-radius: var(--r-sm); color: #fff;
  font-family: 'DM Sans', sans-serif; font-size: 0.9rem; font-weight: 500;
  padding: 0.65rem 1.6rem; cursor: pointer;
  transition: transform 0.2s cubic-bezier(.22,.68,0,1.2), box-shadow 0.2s, filter 0.2s;
  box-shadow: 0 4px 16px rgba(246,135,179,0.3);
}
.btn-apply:hover {
  transform: translateY(-2px); filter: brightness(1.1);
  box-shadow: 0 6px 22px rgba(246,135,179,0.44);
}
.btn-apply:active { transform: translateY(0); }

/* ── company chips in select preview ── */
.company-count-badge {
  display: inline-flex; align-items: center; gap: 0.35rem;
  background: rgba(246,135,179,0.1); border: 1px solid rgba(246,135,179,0.2);
  color: var(--pink); font-size: 0.75rem; font-weight: 500;
  padding: 0.28rem 0.7rem; border-radius: 50px; margin-left: auto;
}

/* ── applications table ── */
.table-section { animation: fadeUp 0.5s 0.12s ease both; }

.table-wrapper { overflow-x: auto; }
.table-wrapper::-webkit-scrollbar { height: 5px; }
.table-wrapper::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 3px; }

.apps-table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
.apps-table thead tr { background: rgba(255,255,255,0.04); }
.apps-table thead th {
  padding: 0.9rem 1rem; font-size: 0.67rem; font-weight: 600;
  letter-spacing: 0.1em; text-transform: uppercase;
  color: var(--muted); border-bottom: 1px solid var(--border);
  text-align: left; white-space: nowrap;
}
.apps-table thead th:first-child { padding-left: 1.4rem; }
.apps-table thead th:last-child  { padding-right: 1.4rem; }
.apps-table tbody tr {
  border-bottom: 1px solid rgba(255,255,255,0.04);
  transition: background 0.18s;
}
.apps-table tbody tr:last-child { border-bottom: none; }
.apps-table tbody tr:hover { background: rgba(255,255,255,0.03); }
.apps-table tbody td {
  padding: 0.9rem 1rem; vertical-align: middle; color: var(--sub);
}
.apps-table tbody td:first-child { padding-left: 1.4rem; }
.apps-table tbody td:last-child  { padding-right: 1.4rem; }

/* company name cell */
.company-cell { display: flex; align-items: center; gap: 0.65rem; }
.company-avatar {
  width: 32px; height: 32px; border-radius: var(--r-sm); flex-shrink: 0;
  background: linear-gradient(135deg, rgba(246,135,179,0.2), rgba(159,122,234,0.15));
  border: 1px solid rgba(246,135,179,0.2);
  display: flex; align-items: center; justify-content: center;
  color: var(--pink); font-size: 0.85rem;
}
.company-name { font-weight: 500; color: var(--text); }

/* status badge */
.status-badge {
  display: inline-flex; align-items: center; gap: 0.3rem;
  border-radius: 50px; padding: 0.22rem 0.7rem;
  font-size: 0.73rem; font-weight: 600;
}
.status-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.sb-applied  { background: rgba(246,173,85,0.1);  border: 1px solid rgba(246,173,85,0.22);  color: var(--amber); }
.sb-selected { background: rgba(104,211,145,0.1); border: 1px solid rgba(104,211,145,0.22); color: var(--green); }
.sb-rejected { background: rgba(252,129,129,0.1); border: 1px solid rgba(252,129,129,0.22); color: var(--red); }
.sb-default  { background: rgba(255,255,255,0.05); border: 1px solid var(--border); color: var(--muted); }

/* package badge */
.pkg-badge {
  display: inline-flex; align-items: center; gap: 0.28rem;
  background: rgba(246,173,85,0.08); border: 1px solid rgba(246,173,85,0.18);
  border-radius: 50px; padding: 0.2rem 0.65rem;
  font-size: 0.78rem; font-weight: 600; color: var(--amber);
  font-family: 'Syne', sans-serif;
}

/* date cell */
.date-cell { font-size: 0.8rem; color: var(--muted); }

/* empty state */
.empty-state { text-align: center; padding: 3.5rem 1rem; color: var(--muted); }
.empty-state i { font-size: 2.5rem; opacity: 0.25; display: block; margin-bottom: 0.75rem; }
.empty-state h4 { font-family: 'Syne', sans-serif; font-size: 1rem; font-weight: 700; color: var(--sub); margin-bottom: 0.35rem; }
.empty-state p { font-size: 0.875rem; }

/* student not found */
.not-found-card {
  background: rgba(252,129,129,0.08); border: 1px solid rgba(252,129,129,0.2);
  border-radius: var(--r-md); padding: 1.2rem 1.4rem;
  display: flex; align-items: center; gap: 0.75rem;
  font-size: 0.875rem; color: var(--red);
}

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

@media (max-width: 640px) {
  .page-wrap { padding: 1.5rem 1rem 3.5rem; }
  .stat-row  { grid-template-columns: 1fr 1fr; }
  .page-header { flex-direction: column; align-items: flex-start; }
}
</style>
</head>
<body>

<%@ include file="/WEB-INF/includes/header.jsp"%>

<div class="page-wrap">

  <!-- PAGE HEADER -->
  <div class="page-header">
    <div>
      <div class="page-eyebrow">Student · Career</div>
      <h1 class="page-title">Placement</h1>
    </div>
    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="back-btn">
      <i class="bi bi-arrow-left"></i> Back
    </a>
  </div>

  <%
  if (student != null) {
  %>

  <!-- ═══ STAT CARDS ═══ -->
  <div class="sec-label">Overview</div>
  <div class="stat-row">

    <div class="stat-card sc-1">
      <div class="sc-icon"><i class="bi bi-building-fill"></i></div>
      <div class="sc-label">Companies</div>
      <div class="sc-value"><%= companies.size() %></div>
    </div>

    <div class="stat-card sc-2">
      <div class="sc-icon"><i class="bi bi-send-fill"></i></div>
      <div class="sc-label">Applied</div>
      <div class="sc-value"><%= applications.size() %></div>
    </div>

    <div class="stat-card sc-3">
      <div class="sc-icon"><i class="bi bi-check-circle-fill"></i></div>
      <div class="sc-label">Selected</div>
      <%
        int selCount = 0;
        for (PlacementDAO.PlacementRecord pr : applications) {
          if ("SELECTED".equalsIgnoreCase(pr.getStatus())) selCount++;
        }
      %>
      <div class="sc-value"><%= selCount %></div>
    </div>

    <div class="stat-card sc-4">
      <div class="sc-icon"><i class="bi bi-hourglass-split"></i></div>
      <div class="sc-label">Pending</div>
      <%
        int pendCount = 0;
        for (PlacementDAO.PlacementRecord pr2 : applications) {
          if ("APPLIED".equalsIgnoreCase(pr2.getStatus())) pendCount++;
        }
      %>
      <div class="sc-value"><%= pendCount %></div>
    </div>

  </div>

  <div class="dash-divider"></div>

  <!-- ═══ APPLY FORM ═══ -->
  <div class="apply-form">
    <div class="sec-label">Apply for a Company</div>

    <div class="glass-card">
      <div class="gc-header">
        <div class="gc-icon pink"><i class="bi bi-building-add"></i></div>
        <h6>Submit Application</h6>
        <span class="company-count-badge">
          <i class="bi bi-building-fill"></i>
          <%= companies.size() %> active drive<%= companies.size() != 1 ? "s" : "" %>
        </span>
      </div>
      <div class="gc-body">
        <form method="post" action="${pageContext.request.contextPath}/student/placement">
          <input type="hidden" name="action" value="apply">

          <div class="field-wrap">
            <label class="field-label">Select Company</label>
            <div class="select-wrap">
              <select name="companyId" class="form-select-styled" required>
                <option value="">— Choose a company —</option>
                <%
                for (PlacementDAO.Company c : companies) {
                %>
                <option value="<%= c.getId() %>">
                  <%= c.getName() %> &nbsp;(<%=c.getPackageAmt() / 100000%> LPA)
                </option>
                <%
                }
                %>
              </select>
            </div>
          </div>

          <button type="submit" class="btn-apply">
            <i class="bi bi-send-fill"></i> Apply Now
          </button>
        </form>
      </div>
    </div>
  </div>

  <div class="dash-divider"></div>

  <!-- ═══ APPLICATIONS TABLE ═══ -->
  <div class="table-section">
    <div class="sec-label">My Applications</div>

    <div class="glass-card">
      <div class="gc-header">
        <div class="gc-icon violet"><i class="bi bi-list-check"></i></div>
        <h6>Application History</h6>
        <span style="margin-left:auto; font-size:0.75rem; color:var(--muted);">
          <%= applications.size() %> total
        </span>
      </div>

      <div class="table-wrapper">
        <table class="apps-table">

          <thead>
            <tr>
              <th>Company</th>
              <th>Status</th>
              <th>Package</th>
              <th>Applied Date</th>
            </tr>
          </thead>

          <tbody>
            <%
            if (!applications.isEmpty()) {
              for (PlacementDAO.PlacementRecord p : applications) {
                String st = p.getStatus() != null ? p.getStatus().toUpperCase() : "";
                String sbClass = "sb-default";
                if ("SELECTED".equals(st))  sbClass = "sb-selected";
                else if ("REJECTED".equals(st)) sbClass = "sb-rejected";
                else if ("APPLIED".equals(st))  sbClass = "sb-applied";
                String initials = (p.getCompanyName() != null && p.getCompanyName().length() > 0)
                  ? String.valueOf(p.getCompanyName().charAt(0)).toUpperCase() : "C";
            %>
            <tr>

              <td>
                <div class="company-cell">
                  <div class="company-avatar"><i class="bi bi-building"></i></div>
                  <span class="company-name"><%= p.getCompanyName() %></span>
                </div>
              </td>

              <td>
                <span class="status-badge <%= sbClass %>">
                  <span class="status-dot"></span>
                  <%= p.getStatus() %>
                </span>
              </td>

              <td>
                <span class="pkg-badge">
                  <i class="bi bi-star-fill" style="font-size:0.62rem;"></i>
                  <%= p.getPackageAmt() / 100000 %> LPA
                </span>
              </td>

              <td>
                <span class="date-cell">
                  <i class="bi bi-calendar3" style="margin-right:5px;opacity:0.5;"></i>
                  <%= p.getAppliedDate() %>
                </span>
              </td>

            </tr>
            <%
              }
            } else {
            %>
            <tr>
              <td colspan="4">
                <div class="empty-state">
                  <i class="bi bi-briefcase"></i>
                  <h4>No applications yet</h4>
                  <p>Use the form above to apply to a company drive.</p>
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

  <%
  } else {
  %>

  <div class="not-found-card">
    <i class="bi bi-exclamation-triangle-fill"></i>
    Student profile not found. Please contact the administration.
  </div>

  <%
  }
  %>

</div>

</body>
</html>
