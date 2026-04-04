package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import model.UserDAO;

@WebListener
public class DbInitListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent sce) {

		UserDAO userDAO = new UserDAO();

		// Create default users if they don't exist
		if (!userDAO.usernameExists("admin")) {
			userDAO.register("admin", "admin123", "ADMIN");
			System.out.println("Default ADMIN created");
		}

		if (!userDAO.usernameExists("faculty")) {
			userDAO.register("faculty", "faculty123", "FACULTY");
			System.out.println("Default FACULTY created");
		}

		if (!userDAO.usernameExists("student")) {
			userDAO.register("student", "student123", "STUDENT");
			System.out.println("Default STUDENT created");
		}

		System.out.println("ISMS Database Initialization Complete");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// Nothing needed here
	}
}