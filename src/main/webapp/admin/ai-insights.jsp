<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Student" %>
<%@ page import="ai.AcademicRiskDetector" %>
<%@ page import="java.util.List" %>

<%
    List<Object[]> atRisk = (List<Object[]>) request.getAttribute("atRisk");
    if (atRisk == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ai-insights");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>AI Insights</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">

</head>

<body>

<%@ include file="/WEB-INF/includes/header.jsp" %>

<div class="container mt-4">

<h2>AI Academic Risk Insights</h2>

<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

<div class="card">

<div class="card-body">

<p class="text-muted">
Students with low attendance or low CGPA are flagged.
</p>

<table class="table table-bordered">

<thead>
<tr>
<th>Roll No</th>
<th>Name</th>
<th>Attendance %</th>
<th>CGPA</th>
<th>Risk Level</th>
<th>Reason</th>
</tr>
</thead>

<tbody>

<% for (Object[] row : atRisk) {
    Student s = (Student) row[0];
    AcademicRiskDetector.RiskResult r = (AcademicRiskDetector.RiskResult) row[1];
%>

<tr>
<td><%= s.getRollNo() %></td>
<td><%= s.getName() %></td>
<td><%= String.format("%.1f", r.getAttendancePct()) %>%</td>
<td><%= r.getCgpa() > 0 ? String.format("%.2f", r.getCgpa()) : "N/A" %></td>

<td>
<span class="badge bg-<%= "HIGH_RISK".equals(r.getRiskLevel()) ? "danger" : "warning" %>">
<%= r.getRiskLevel() %>
</span>
</td>

<td><%= r.getReasons() %></td>

</tr>

<% } %>

</tbody>

</table>

<% if (atRisk.isEmpty()) { %>
<p class="text-success">No students at risk 🎉</p>
<% } %>

</div>

</div>

</div>

</body>
</html>