package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

	// Change these if needed (XAMPP MariaDB defaults shown)
	private static final String URL = "jdbc:mysql://localhost:3306/isms?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	private static final String USER = "root";
	private static final String PASSWORD = ""; // XAMPP default is empty

	static {
		try {
			// MySQL Connector/J driver
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new RuntimeException("MySQL JDBC Driver not found. Put mysql-connector JAR in WEB-INF/lib.", e);
		}
	}

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(URL, USER, PASSWORD);
	}
}