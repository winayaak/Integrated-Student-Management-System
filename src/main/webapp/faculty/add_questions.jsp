<%@ page import="java.util.*,model.ExamDAO,model.Exam"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Question — ISPS</title>

<link
	href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
	rel="stylesheet">

<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--bg-deep: #08090d;
	--bg-card: rgba(255, 255, 255, 0.04);
	--bg-card-hover: rgba(255, 255, 255, 0.065);
	--border: rgba(255, 255, 255, 0.08);
	--border-focus: rgba(104, 211, 145, 0.5);
	--accent-green: #68d391;
	--accent-blue: #63b3ed;
	--accent-violet: #9f7aea;
	--accent-red: #fc8181;
	--accent-amber: #f6ad55;
	--accent-teal: #4fd1c5;
	--text-primary: #f0f4f8;
	--text-sub: #a0aec0;
	--text-muted: #4a5568;
	--radius-lg: 18px;
	--radius-md: 12px;
	--radius-sm: 8px;
	--shadow-card: 0 8px 32px rgba(0, 0, 0, 0.5);
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
	position: fixed;
	inset: 0;
	background: radial-gradient(ellipse 60% 50% at 0% 5%, rgba(104, 211, 145, 0.09)
		0%, transparent 60%),
		radial-gradient(ellipse 50% 55% at 100% 10%, rgba(99, 179, 237, 0.08)
		0%, transparent 55%),
		radial-gradient(ellipse 55% 40% at 50% 100%, rgba(159, 122, 234, 0.06)
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
	max-width: 700px;
	margin: 0 auto;
	padding: 2.5rem 1.5rem 5rem;
}

/* ── page header ── */
.page-header {
	margin-bottom: 2.4rem;
	animation: fadeDown 0.5s ease both;
}

.page-eyebrow {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.18em;
	text-transform: uppercase;
	color: var(--accent-green);
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
	background: var(--accent-green);
	border-radius: 2px;
}

.page-title {
	font-family: 'Syne', sans-serif;
	font-size: clamp(1.8rem, 3.5vw, 2.5rem);
	font-weight: 800;
	letter-spacing: -0.03em;
	line-height: 1.1;
	background: linear-gradient(130deg, #f0f4f8 30%, var(--accent-green)
		100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
}

.page-sub {
	margin-top: 0.4rem;
	font-size: 0.875rem;
	color: var(--text-muted);
	font-weight: 300;
}

/* ── section label ── */
.section-label {
	font-size: 0.68rem;
	font-weight: 500;
	letter-spacing: 0.16em;
	text-transform: uppercase;
	color: var(--text-muted);
	margin-bottom: 0.85rem;
}

/* ── glass card ── */
.glass-card {
	background: var(--bg-card);
	border: 1px solid var(--border);
	border-radius: var(--radius-lg);
	backdrop-filter: blur(18px);
	box-shadow: var(--shadow-card);
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.5s 0.06s ease both;
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
}

.gc-icon {
	width: 34px;
	height: 34px;
	border-radius: var(--radius-sm);
	background: rgba(104, 211, 145, 0.12);
	border: 1px solid rgba(104, 211, 145, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--accent-green);
	font-size: 0.95rem;
	flex-shrink: 0;
}

.gc-header h6 {
	font-family: 'Syne', sans-serif;
	font-size: 0.92rem;
	font-weight: 700;
	color: var(--text-primary);
	margin: 0;
}

.gc-body {
	padding: 1.8rem;
}

/* ── fields ── */
.field-wrap {
	display: flex;
	flex-direction: column;
	gap: 0.3rem;
	margin-bottom: 1rem;
}

.field-label {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.07em;
	text-transform: uppercase;
	color: var(--text-muted);
}

.form-input, .form-select-styled {
	background: rgba(255, 255, 255, 0.04);
	border: 1px solid var(--border);
	border-radius: var(--radius-sm);
	color: var(--text-primary);
	font-family: 'DM Sans', sans-serif;
	font-size: 0.875rem;
	padding: 0.65rem 0.9rem;
	width: 100%;
	transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
	-webkit-appearance: none;
	appearance: none;
}

.form-input::placeholder {
	color: var(--text-muted);
}

.form-input:focus, .form-select-styled:focus {
	outline: none;
	background: rgba(255, 255, 255, 0.06);
	border-color: var(--border-focus);
	box-shadow: 0 0 0 3px rgba(104, 211, 145, 0.12);
	color: var(--text-primary);
}

.form-select-styled option {
	background: #1a1d27;
	color: var(--text-primary);
}

.select-wrap {
	position: relative;
}

.select-wrap::after {
	content: '\F282';
	font-family: 'bootstrap-icons';
	position: absolute;
	right: 0.75rem;
	top: 50%;
	transform: translateY(-50%);
	color: var(--text-muted);
	font-size: 0.8rem;
	pointer-events: none;
}

/* ── divider ── */
.inner-divider {
	height: 1px;
	background: linear-gradient(90deg, transparent, var(--border),
		transparent);
	margin: 1.4rem 0;
}

/* ── options grid ── */
.options-label {
	font-size: 0.7rem;
	font-weight: 500;
	letter-spacing: 0.07em;
	text-transform: uppercase;
	color: var(--text-muted);
	margin-bottom: 0.75rem;
}

.options-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 0.75rem;
	margin-bottom: 1rem;
}

.option-field {
	display: flex;
	flex-direction: column;
	gap: 0.3rem;
}

.option-field-label {
	font-size: 0.68rem;
	font-weight: 600;
	letter-spacing: 0.05em;
	text-transform: uppercase;
}

.opt-a .option-field-label {
	color: var(--accent-blue);
}

.opt-b .option-field-label {
	color: var(--accent-violet);
}

.opt-c .option-field-label {
	color: var(--accent-amber);
}

.opt-d .option-field-label {
	color: var(--accent-red);
}

.opt-a .form-input:focus {
	border-color: rgba(99, 179, 237, 0.45);
	box-shadow: 0 0 0 3px rgba(99, 179, 237, 0.10);
}

.opt-b .form-input:focus {
	border-color: rgba(159, 122, 234, 0.45);
	box-shadow: 0 0 0 3px rgba(159, 122, 234, 0.10);
}

.opt-c .form-input:focus {
	border-color: rgba(246, 173, 85, 0.45);
	box-shadow: 0 0 0 3px rgba(246, 173, 85, 0.10);
}

.opt-d .form-input:focus {
	border-color: rgba(252, 129, 129, 0.45);
	box-shadow: 0 0 0 3px rgba(252, 129, 129, 0.10);
}

/* ── correct answer selector ── */
.answer-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 0.6rem;
	margin-top: 0.5rem;
}
/* Hide the real select visually but keep it in DOM for form submission */
#correct_answer_select {
	display: none;
}

.answer-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.35rem;
	padding: 0.55rem 0.5rem;
	border-radius: var(--radius-sm);
	border: 1px solid var(--border);
	background: rgba(255, 255, 255, 0.04);
	color: var(--text-muted);
	font-family: 'Syne', sans-serif;
	font-size: 0.82rem;
	font-weight: 700;
	cursor: pointer;
	transition: background 0.18s, border-color 0.18s, color 0.18s, transform
		0.18s cubic-bezier(.22, .68, 0, 1.2), box-shadow 0.18s;
}

.answer-btn:hover {
	background: rgba(255, 255, 255, 0.07);
	color: var(--text-primary);
	transform: translateY(-1px);
}

.answer-btn.selected-a {
	background: rgba(99, 179, 237, 0.15);
	border-color: rgba(99, 179, 237, 0.35);
	color: var(--accent-blue);
	box-shadow: 0 4px 12px rgba(99, 179, 237, 0.15);
}

.answer-btn.selected-b {
	background: rgba(159, 122, 234, 0.15);
	border-color: rgba(159, 122, 234, 0.35);
	color: var(--accent-violet);
	box-shadow: 0 4px 12px rgba(159, 122, 234, 0.15);
}

.answer-btn.selected-c {
	background: rgba(246, 173, 85, 0.15);
	border-color: rgba(246, 173, 85, 0.35);
	color: var(--accent-amber);
	box-shadow: 0 4px 12px rgba(246, 173, 85, 0.15);
}

.answer-btn.selected-d {
	background: rgba(252, 129, 129, 0.15);
	border-color: rgba(252, 129, 129, 0.35);
	color: var(--accent-red);
	box-shadow: 0 4px 12px rgba(252, 129, 129, 0.15);
}

/* ── submit button ── */
.btn-submit {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background: linear-gradient(135deg, #48bb78, #276749);
	border: none;
	border-radius: var(--radius-sm);
	color: #fff;
	font-family: 'DM Sans', sans-serif;
	font-size: 0.9rem;
	font-weight: 500;
	padding: 0.7rem 1.8rem;
	cursor: pointer;
	margin-top: 1.4rem;
	transition: transform 0.2s cubic-bezier(.22, .68, 0, 1.2), box-shadow
		0.2s, filter 0.2s;
	box-shadow: 0 4px 16px rgba(72, 187, 120, 0.3);
	width: 100%;
	justify-content: center;
}

.btn-submit:hover {
	transform: translateY(-2px);
	filter: brightness(1.1);
	box-shadow: 0 6px 22px rgba(72, 187, 120, 0.42);
}

.btn-submit:active {
	transform: translateY(0);
}

/* ── progress indicator ── */
.progress-steps {
	display: flex;
	align-items: center;
	gap: 0;
	margin-bottom: 2rem;
	animation: fadeDown 0.5s 0.08s ease both;
}

.step {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	font-size: 0.75rem;
	color: var(--text-muted);
}

.step-num {
	width: 24px;
	height: 24px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.06);
	border: 1px solid var(--border);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 0.7rem;
	font-weight: 700;
	font-family: 'Syne', sans-serif;
}

.step.active .step-num {
	background: rgba(104, 211, 145, 0.15);
	border-color: rgba(104, 211, 145, 0.35);
	color: var(--accent-green);
}

.step.active {
	color: var(--text-sub);
}

.step-line {
	flex: 1;
	height: 1px;
	margin: 0 0.75rem;
	background: var(--border);
	max-width: 60px;
}

/* animations */
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

@media ( max-width : 560px) {
	.page-wrap {
		padding: 1.5rem 1rem 3.5rem;
	}
	.options-grid {
		grid-template-columns: 1fr;
	}
	.answer-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.gc-body {
		padding: 1.2rem;
	}
}
</style>
</head>

<body>

	<%
	/* ── session + DAO logic (unchanged) ── */
	HttpSession sessionObj = request.getSession(false);
	Integer facultyId = null;
	if (sessionObj != null) {
		facultyId = (Integer) sessionObj.getAttribute("userId");
	}
	if (facultyId == null) {
		facultyId = 1;
	}
	ExamDAO dao = new ExamDAO();
	List<Exam> exams = dao.getExamsByFaculty(facultyId);
	%>

	<div class="page-wrap">

		<!-- PAGE HEADER -->
		<div class="page-header">
			<div class="page-eyebrow">Faculty · Question Bank</div>
			<h1 class="page-title">Add Question</h1>
			<p class="page-sub">Add a new MCQ question to one of your
				scheduled exams.</p>
		</div>

		<!-- step indicator -->
		<div class="progress-steps">
			<div class="step active">
				<div class="step-num">1</div>
				Select Exam
			</div>
			<div class="step-line"></div>
			<div class="step active">
				<div class="step-num">2</div>
				Write Question
			</div>
			<div class="step-line"></div>
			<div class="step active">
				<div class="step-num">3</div>
				Add Options
			</div>
			<div class="step-line"></div>
			<div class="step active">
				<div class="step-num">4</div>
				Set Answer
			</div>
		</div>

		<div class="section-label">Question Details</div>

		<div class="glass-card">
			<div class="gc-header">
				<div class="gc-icon">
					<i class="bi bi-patch-plus-fill"></i>
				</div>
				<h6>New MCQ Question</h6>
			</div>

			<div class="gc-body">

				<form action="addQuestion" method="post" id="questionForm">

					<!-- ── 1. exam select ── -->
					<div class="field-wrap">
						<label class="field-label">Exam</label>
						<div class="select-wrap">
							<select name="exam_id" class="form-select-styled" required>
								<%
								for (Exam e : exams) {
								%>
								<option value="<%=e.getId()%>"><%=e.getTitle()%></option>
								<%
								}
								%>
							</select>
						</div>
					</div>

					<!-- ── 2. question text ── -->
					<div class="field-wrap">
						<label class="field-label">Question</label> <input type="text"
							name="question" class="form-input"
							placeholder="e.g. What is the time complexity of binary search?"
							required>
					</div>

					<div class="inner-divider"></div>

					<!-- ── 3. options ── -->
					<div class="options-label">Answer Options</div>
					<div class="options-grid">

						<div class="option-field opt-a">
							<label class="option-field-label">Option A</label> <input
								type="text" name="option_a" class="form-input"
								placeholder="First option" required>
						</div>

						<div class="option-field opt-b">
							<label class="option-field-label">Option B</label> <input
								type="text" name="option_b" class="form-input"
								placeholder="Second option" required>
						</div>

						<div class="option-field opt-c">
							<label class="option-field-label">Option C</label> <input
								type="text" name="option_c" class="form-input"
								placeholder="Third option" required>
						</div>

						<div class="option-field opt-d">
							<label class="option-field-label">Option D</label> <input
								type="text" name="option_d" class="form-input"
								placeholder="Fourth option" required>
						</div>

					</div>

					<div class="inner-divider"></div>

					<!-- ── 4. correct answer ── -->
					<div class="field-wrap" style="margin-bottom: 0;">
						<label class="field-label">Correct Answer</label>

						<%-- Real select — name unchanged, hidden, driven by buttons below --%>
						<select name="correct_answer" id="correct_answer_select">
							<option value="A">A</option>
							<option value="B">B</option>
							<option value="C">C</option>
							<option value="D">D</option>
						</select>

						<div class="answer-grid">
							<button type="button" class="answer-btn selected-a" id="ans-A"
								onclick="selectAnswer('A')">
								<i class="bi bi-check-circle-fill" style="font-size: 0.8rem;"></i>
								Option A
							</button>
							<button type="button" class="answer-btn" id="ans-B"
								onclick="selectAnswer('B')">
								<i class="bi bi-circle" style="font-size: 0.8rem;"></i> Option B
							</button>
							<button type="button" class="answer-btn" id="ans-C"
								onclick="selectAnswer('C')">
								<i class="bi bi-circle" style="font-size: 0.8rem;"></i> Option C
							</button>
							<button type="button" class="answer-btn" id="ans-D"
								onclick="selectAnswer('D')">
								<i class="bi bi-circle" style="font-size: 0.8rem;"></i> Option D
							</button>
						</div>
					</div>

					<button type="submit" class="btn-submit">
						<i class="bi bi-patch-plus-fill"></i> Add Question
					</button>

				</form>
			</div>
		</div>

	</div>

	<script>
		var colorMap = {
			A : 'selected-a',
			B : 'selected-b',
			C : 'selected-c',
			D : 'selected-d'
		};

		function selectAnswer(val) {
			/* update hidden select — name unchanged for backend */
			document.getElementById('correct_answer_select').value = val;

			/* reset all buttons */
			[ 'A', 'B', 'C', 'D' ]
					.forEach(function(opt) {
						var btn = document.getElementById('ans-' + opt);
						btn.className = 'answer-btn';
						btn.innerHTML = '<i class="bi bi-circle" style="font-size:0.8rem;"></i> Option '
								+ opt;
					});

			/* activate selected */
			var active = document.getElementById('ans-' + val);
			active.classList.add(colorMap[val]);
			active.innerHTML = '<i class="bi bi-check-circle-fill" style="font-size:0.8rem;"></i> Option '
					+ val;
		}

		/* init — A is correct by default */
		selectAnswer('A');
	</script>

</body>
</html>
