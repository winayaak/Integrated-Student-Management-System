<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>Chatbot - ISPS</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

</head>

<body>

	<%@ include file="/WEB-INF/includes/header.jsp"%>

	<div class="container mt-4">

		<h2>Student Assistant Chatbot</h2>

		<a href="dashboard.jsp" class="btn btn-secondary mb-3">Back</a>

		<div class="card">

			<div class="card-body">

				<div id="chatArea"
					style="height: 300px; overflow-y: auto; border: 1px solid #ccc; padding: 10px; margin-bottom: 10px">

					<div class="text-muted">Ask about attendance, marks, fees,
						placement, library or hostel.</div>

				</div>

				<div class="input-group">

					<input type="text" id="userInput" class="form-control"
						placeholder="Type your question..."
						onkeypress="if(event.key==='Enter') sendMessage()">

					<button class="btn btn-primary" onclick="sendMessage()">
						Send</button>

				</div>

			</div>

		</div>

	</div>

	<script>

function sendMessage(){

const input = document.getElementById("userInput");

const message = input.value.trim();

if(!message) return;

const chat = document.getElementById("chatArea");

chat.innerHTML +=
"<div class='text-end mb-2'><b>You:</b> "+message+"</div>";

input.value = "";

fetch('${pageContext.request.contextPath}/student/chatbot',{

method:"POST",

headers:{
"Content-Type":"application/x-www-form-urlencoded"
},

body:"query="+encodeURIComponent(message)

})

.then(res=>res.json())

.then(data=>{

chat.innerHTML +=
"<div class='text-start mb-2'><b>Bot:</b> "+data.response+"</div>";

chat.scrollTop = chat.scrollHeight;

});

}

</script>

</body>
</html>