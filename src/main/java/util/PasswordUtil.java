package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

	// Hash password using SHA-256 (simpler than BCrypt, good enough for this
	// project)
	public static String hash(String plainPassword) {
		if (plainPassword == null)
			return null;
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] bytes = md.digest(plainPassword.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : bytes) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			throw new RuntimeException("SHA-256 not available", e);
		}
	}

	// Compare plain password with stored hash
	public static boolean verify(String plainPassword, String hashedPassword) {
		if (plainPassword == null || hashedPassword == null)
			return false;
		return hash(plainPassword).equals(hashedPassword);
	}
}