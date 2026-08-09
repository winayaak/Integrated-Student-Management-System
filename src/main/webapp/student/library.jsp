<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="model.User"%>
<%@ page import="model.Student"%>
<%@ page import="model.StudentDAO"%>
<%@ page import="model.BookDAO"%>
<%@ page import="java.util.List"%>

<%
User user = (User) session.getAttribute("user");

Student student = null;
List<BookDAO.LibraryRecord> issued = null;

if (user != null) {
	StudentDAO studentDAO = new StudentDAO();
	student = studentDAO.findByUserId(user.getId());

	if (student != null) {
		BookDAO bookDAO = new BookDAO();
		issued = bookDAO.getIssuedByStudent(student.getId());
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Library — ISMS</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--bg: #08090d;
	--bg-card: rgba(255, 255, 255, 0.04);
	--bg-hover: rgba(255, 255, 255, 0.07);
	--border: rgba(255, 255, 255, 0.08);
	--blue: #63b3ed;
	--violet: #9f7aea;
	--green: #68d391;
	--amber: #f6ad55;
	--red: #fc8181;
	--teal: #4fd1c5;
	--text: #f0f4f8;
	--sub: #a0aec0;
	--muted: #4a5568;
	--r-lg: 18px;
	--r-md: 12px;
	--r-sm: 8px;
	--shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
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
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 50% at 5% 0%, rgba(99, 179, 237, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 55% at 98% 8%, rgba(79, 209, 197, 0.07) 0%,
		transparent 55%),
		radial-gradient(ellipse 55% 40% at 50% 100%, rgba(104, 211, 145, 0.06)
		0%, transparent 50%);
	pointer-events: none;
	z-index: 0;
}

body::after {
	content: '';
	position: fixed;
	inset: 0;
	background-image:
		url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
	pointer-events: none;
	z-index: 0;
	opacity: 0.55;
}

.page-wrap {
	position: relative;
	z-index: 1;
	max-width: 900px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 5rem;
}

/* ── page header ── */
.page-header {
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 1rem;
	margin-bottom: 2.5rem;
	animation: fadeDown 0.5s ease both;
}

.page-eyebrow {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--teal);
	display: flex;
	align-items: center;
	gap: 0.45rem;
	margin-bottom: 0.3rem;
}

.page-eyebrow::before {
	content: '';
	display: inline-block;
	width: 16px;
	height: 2px;
	background: var(--teal);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--teal) 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.back-btn {
	display: inline-flex;
	align-items: center;
	gap: 0.4rem;
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	color: var(--sub);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	font-weight: 500;
	padding: 0.45rem 1rem;
	text-decoration: none;
	backdrop-filter: blur(10px);
	transition: background 0.2s, color 0.2s, transform 0.18s;
}

.back-btn:hover {
	background: var(--bg-hover);
	color: var(--text);
	transform: translateX(-2px);
}

/* ── section label ── */
.sec-label {
	font-size: 0.68rem;
	font-weight: 500;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--muted);
	margin-bottom: 0.85rem;
}

/* ── stat cards ── */
.stat-row {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
	gap: 1rem;
	margin-bottom: 2rem;
	animation: fadeUp 0.5s 0.05s ease both;
}

.stat-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-md);
	padding: 1.2rem 1.3rem;
	backdrop-filter: blur(14px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	transition: transform 0.25s cubic-bezier(.22, .68, 0, 1.2), border-color
		0.25s;
	cursor: default;
}

.stat-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	border-radius: 2px 2px 0 0;
	background: var(--sc-a, var(--teal));
	opacity: 0.7;
	transition: opacity 0.2s;
}

.stat-card:hover {
	transform: translateY(-3px);
}

.stat-card:hover::after {
	opacity: 1;
}

.sc-1 {
	--sc-a: var(--teal);
}

.sc-2 {
	--sc-a: var(--blue);
}

.sc-3 {
	--sc-a: var(--amber);
}

.sc-icon {
	width: 32px;
	height: 32px;
	border-radius: var(--r-sm);
	background: rgba(255, 255, 255, 0.06);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.9rem;
	color: var(--sc-a, var(--teal));
	margin-bottom: 0.8rem;
}

.sc-label {
	font-size: 0.68rem;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: var(--muted);
	margin-bottom: 0.25rem;
}

.sc-value {
	font-family: 'Syne', sans-serif;
	font-size: 1.55rem;
	font-weight: 800;
	letter-spacing: -0.03em;
	color: var(--text);
}

/* ── glass card ── */
.glass-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--r-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s 0.1s ease both;
}

.glass-card::before {
	content: '';
	position: absolute;
	inset: 0;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.035) 0%,
		transparent 55%);
	pointer-events: none;
}

.gc-header {
	padding: 1.2rem 1.6rem;
	border-bottom: 1px solid var(--border);
	display: flex;
	align-items: center;
	gap: 0.75rem;
	justify-content: space-between;
	flex-wrap: wrap;
}

.gc-header-left {
	display: flex;
	align-items: center;
	gap: 0.75rem;
}

.gc-icon {
	width: 34px;
	height: 34px;
	border-radius: var(--r-sm);
	background: rgba(79, 209, 197, 0.12);
	border: 1px solid rgba(79, 209, 197, 0.18);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--teal);
	font-size: 0.95rem;
	flex-shrink: 0;
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text);
	margin: 0;
}

.count-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.35rem;
	background: rgba(79, 209, 197, 0.1);
	border: 1px solid rgba(79, 209, 197, 0.2);
	color: var(--teal);
	font-size: 0.75rem;
	font-weight: 500;
	padding: 0.28rem 0.7rem;
	border-radius: 50px;
}

/* ── search box ── */
.search-wrap {
	position: relative;
}

.search-wrap i {
	position: absolute;
	left: 0.75rem;
	top: 50%;
	transform: translateY(-50%);
	color: var(--muted);
	font-size: 0.85rem;
	pointer-events: none;
}

.search-input {
	background: rgba(255, 255, 255, 0.05);
	border: 1px solid var(--border);
	border-radius: var(--r-sm);
	color: var(--text);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.82rem;
	padding: 0.45rem 0.85rem 0.45rem 2.1rem;
	width: 200px;
	transition: border-color 0.2s, box-shadow 0.2s;
}

.search-input::placeholder {
	color: var(--muted);
}

.search-input:focus {
	outline: none;
	border-color: rgba(79, 209, 197, 0.4);
	box-shadow: 0 0 0 3px rgba(79, 209, 197, 0.08);
}

/* ── book cards grid ── */
.books-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
	gap: 1rem;
	padding: 1.5rem;
}

.book-card {
	background: rgba(255, 255, 255, 0.03);
	border: 1px solid var(--border);
	border-radius: var(--r-md);
	padding: 1.2rem 1.3rem;
	display: flex;
	align-items: flex-start;
	gap: 1rem;
	transition: background 0.2s, border-color 0.2s, transform 0.22s
		cubic-bezier(.22, .68, 0, 1.2);
	position: relative;
	overflow: hidden;
}

.book-card::after {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 2px;
	background: linear-gradient(90deg, var(--teal), var(--blue));
	border-radius: 2px 2px 0 0;
	opacity: 0;
	transition: opacity 0.2s;
}

.book-card:hover {
	background: rgba(255, 255, 255, 0.055);
	border-color: rgba(255, 255, 255, 0.13);
	transform: translateY(-3px);
}

.book-card:hover::after {
	opacity: 1;
}

.book-icon-box {
	width: 44px;
	height: 54px;
	border-radius: var(--r-sm);
	flex-shrink: 0;
	background: linear-gradient(135deg, rgba(79, 209, 197, 0.18),
		rgba(99, 179, 237, 0.12));
	border: 1px solid rgba(79, 209, 197, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.3rem;
	color: var(--teal);
	position: relative;
	overflow: hidden;
}

.book-icon-box::before {
	content: '';
	position: absolute;
	left: 0;
	top: 0;
	bottom: 0;
	width: 4px;
	background: linear-gradient(180deg, var(--teal), var(--blue));
	border-radius: 2px 0 0 2px;
}

.book-info {
	flex: 1;
	min-width: 0;
}

.book-title {
	font-family: 'Syne', sans-serif;
	font-size: 0.9rem;
	font-weight: 700;
	color: var(--text);
	line-height: 1.3;
	margin-bottom: 0.5rem;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.book-meta {
	display: flex;
	flex-direction: column;
	gap: 0.3rem;
}

.book-meta-row {
	display: flex;
	align-items: center;
	gap: 0.4rem;
	font-size: 0.75rem;
	color: var(--muted);
}

.book-meta-row i {
	font-size: 0.7rem;
	color: var(--teal);
	flex-shrink: 0;
}

/* due status */
.due-badge {
	display: inline-flex;
	align-items: center;
	gap: 0.28rem;
	border-radius: 50px;
	padding: 0.18rem 0.6rem;
	font-size: 0.7rem;
	font-weight: 600;
	margin-top: 0.5rem;
}

.due-ok {
	background: rgba(104, 211, 145, 0.1);
	border: 1px solid rgba(104, 211, 145, 0.22);
	color: var(--green);
}

.due-warning {
	background: rgba(246, 173, 85, 0.1);
	border: 1px solid rgba(246, 173, 85, 0.22);
	color: var(--amber);
}

.due-dot {
	width: 5px;
	height: 5px;
	border-radius: 50%;
	background: currentColor;
}

/* ── empty state ── */
.empty-state {
	text-align: center;
	padding: 4rem 1rem;
	color: var(--muted);
}

.empty-state i {
	font-size: 3rem;
	opacity: 0.22;
	display: block;
	margin-bottom: 1rem;
}

.empty-state h4 {
	font-family: 'Syne', sans-serif;
	font-size: 1.05rem;
	font-weight: 700;
	color: var(--sub);
	margin-bottom: 0.35rem;
}

.empty-state p {
	font-size: 0.875rem;
}

/* ── not found ── */
.not-found-card {
	background: rgba(252, 129, 129, 0.08);
	border: 1px solid rgba(252, 129, 129, 0.2);
	border-radius: var(--r-md);
	padding: 1.2rem 1.4rem;
	display: flex;
	align-items: center;
	gap: 0.75rem;
	font-size: 0.875rem;
	color: var(--red);
	animation: fadeUp 0.5s ease both;
}

.dash-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 2rem 0;
}

@
keyframes fadeDown {from { opacity:0;
	transform: translateY(-14px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
@
keyframes fadeUp {from { opacity:0;
	transform: translateY(18px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
::-webkit-scrollbar {
	width: 6px;
}

::-webkit-scrollbar-track {
	background: transparent;
}

::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.1);
	border-radius: 3px;
}

@media ( max-width : 640px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.stat-row {
		grid-template-columns: repeat(3, 1fr);
	}
	.books-grid {
		grid-template-columns: 1fr;
		padding: 1rem;
	}
	.page-header {
		flex-direction: column;
		align-items: flex-start;
	}
	.search-input {
		width: 150px;
	}
	.gc-header {
		flex-direction: column;
		align-items: flex-start;
		gap: 0.6rem;
	}
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="page-wrap">

		<!-- PAGE HEADER -->
		<div class="page-header">
			<div>
				<div class="page-eyebrow">Student · Library</div>
				<h1 class="page-title">My Library</h1>
			</div>
			<a href="dashboard.jsp" class="back-btn"> <i
				class="bi bi-arrow-left"></i> Back
			</a>
		</div>

		<%
		if (student != null) {

			int issuedCount = (issued != null) ? issued.size() : 0;
		%>

		<!-- STAT CARDS -->
		<div class="sec-label">Overview</div>
		<div class="stat-row">

			<div class="stat-card sc-1">
				<div class="sc-icon">
					<i class="bi bi-book-half"></i>
				</div>
				<div class="sc-label">Books Issued</div>
				<div class="sc-value"><%=issuedCount%></div>
			</div>

			<div class="stat-card sc-2">
				<div class="sc-icon">
					<i class="bi bi-bookmark-check-fill"></i>
				</div>
				<div class="sc-label">Currently Active</div>
				<div class="sc-value"><%=issuedCount%></div>
			</div>

			<div class="stat-card sc-3">
				<div class="sc-icon">
					<i class="bi bi-arrow-return-left"></i>
				</div>
				<div class="sc-label">Due Soon</div>
				<div class="sc-value">—</div>
			</div>

		</div>

		<div class="dash-divider"></div>

		<!-- ISSUED BOOKS -->
		<div class="sec-label">Issued Books</div>

		<div class="glass-card">

			<div class="gc-header">
				<div class="gc-header-left">
					<div class="gc-icon">
						<i class="bi bi-book-half"></i>
					</div>
					<h6>Books Currently Issued to Me</h6>
				</div>
				<div
					style="display: flex; align-items: center; gap: 0.6rem; flex-wrap: wrap;">
					<span class="count-badge"> <i class="bi bi-journals"></i> <%=issuedCount%>
						book<%=issuedCount != 1 ? "s" : ""%>
					</span>
					<div class="search-wrap">
						<i class="bi bi-search"></i> <input type="text"
							class="search-input" id="searchInput" placeholder="Search books…"
							oninput="filterBooks()">
					</div>
				</div>
			</div>

			<%
			if (issued != null && !issued.isEmpty()) {
			%>

			<div class="books-grid" id="booksGrid">

				<%
				int bookIdx = 0;
				for (BookDAO.LibraryRecord lr : issued) {
					bookIdx++;
					String initials = (lr.getTitle() != null && lr.getTitle().length() > 0)
					? String.valueOf(lr.getTitle().charAt(0)).toUpperCase()
					: "B";
				%>

				<div class="book-card"
					data-title="<%=lr.getTitle().toLowerCase()%>">

					<div class="book-icon-box">
						<i class="bi bi-book-fill"></i>
					</div>

					<div class="book-info">
						<div class="book-title" title="<%=lr.getTitle()%>"><%=lr.getTitle()%></div>
						<div class="book-meta">
							<div class="book-meta-row">
								<i class="bi bi-calendar3"></i> Issued:
								<%=lr.getIssueDate()%>
							</div>
							<div class="book-meta-row">
								<i class="bi bi-hash"></i> Book #<%=bookIdx%>
							</div>
						</div>
						<span class="due-badge due-ok"> <span class="due-dot"></span>
							Active
						</span>
					</div>

				</div>

				<%
				}
				%>

			</div>

			<%
			} else {
			%>

			<div class="empty-state">
				<i class="bi bi-book"></i>
				<h4>No books issued</h4>
				<p>
					You currently have no books issued from the library.<br>Visit
					the library to borrow books.
				</p>
			</div>

			<%
			}
			%>

		</div>

		<%
		} else {
		%>

		<div class="not-found-card">
			<i class="bi bi-exclamation-triangle-fill"></i> Student profile not
			found. Please contact the administration.
		</div>

		<%
		}
		%>

	</div>

	<script>
		/* ── live search filter ── */
		function filterBooks() {
			var q = document.getElementById('searchInput').value.toLowerCase();
			var cards = document.querySelectorAll('.book-card');
			cards.forEach(function(c) {
				var title = c.getAttribute('data-title') || '';
				c.style.display = title.indexOf(q) > -1 ? '' : 'none';
			});
		}
	</script>

</body>
</html>
