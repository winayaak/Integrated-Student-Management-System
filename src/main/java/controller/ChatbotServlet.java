package controller;

import chatbot.RuleBasedChatbot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/student/chatbot")
public class ChatbotServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setContentType("application/json");
		resp.setCharacterEncoding("UTF-8");

		String query = req.getParameter("query");
		String response = RuleBasedChatbot.respond(query);

		PrintWriter out = resp.getWriter();
		out.print("{\"response\":\"" + escape(response) + "\"}");
	}

	private String escape(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
	}
}