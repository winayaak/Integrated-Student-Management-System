package chatbot;

import java.util.Locale;

public class RuleBasedChatbot {

	public static String respond(String userInput) {

		if (userInput == null || userInput.trim().isEmpty()) {
			return "Please type your question. I can help with attendance, marks, fees, placement, library, and hostel.";
		}

		String input = userInput.trim().toLowerCase(Locale.ENGLISH);

		if (input.contains("attendance")) {
			return "You can check your attendance from the dashboard or attendance page.";
		}

		if (input.contains("marks") || input.contains("cgpa")) {
			return "You can check your marks and CGPA from the marks section.";
		}

		if (input.contains("fee")) {
			return "Check your fee status under the fees section.";
		}

		if (input.contains("placement") || input.contains("company")) {
			return "Go to the placement section to apply for companies.";
		}

		if (input.contains("library") || input.contains("book")) {
			return "Your issued books are available in the library section.";
		}

		if (input.contains("hostel") || input.contains("room")) {
			return "Hostel allocation details are available in the hostel section.";
		}

		if (input.contains("hello") || input.contains("hi")) {
			return "Hello! How can I assist you today?";
		}

		return "I'm not sure about that. Try asking about attendance, marks, fees, placement, library, or hostel.";
	}
}