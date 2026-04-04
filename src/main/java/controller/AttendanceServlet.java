package controller;

import model.AttendanceDAO;
import model.Student;
import model.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty/attendance")
public class AttendanceServlet extends HttpServlet {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/faculty/attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String date = req.getParameter("date");

            // Get all students
            List<Student> students = studentDAO.findAll();

            for (Student s : students) {

                // Read each student's status
                String status = req.getParameter("status_" + s.getId());

                if (status != null && !status.isEmpty()) {
                    attendanceDAO.markAttendance(
                            s.getId(),
                            courseId,
                            date,
                            status
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error saving attendance", e);
        }

        // Redirect back
        resp.sendRedirect(req.getContextPath() + "/faculty/attendance");
    }
}