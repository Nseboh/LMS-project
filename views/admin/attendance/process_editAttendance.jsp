<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String attendanceId = request.getParameter("attendanceId");
    String visitDate = request.getParameter("visitDate");
    String timeIn = request.getParameter("timeIn");
    String timeOut = request.getParameter("timeOut");
    String remarks = request.getParameter("remarks");

    try {
        // Debugging: Print the values received
        System.out.println("Attendance ID: " + attendanceId);
        System.out.println("Visit Date: " + visitDate);
        System.out.println("Time In: " + timeIn);
        System.out.println("Time Out: " + timeOut);
        System.out.println("Remarks: " + remarks);

        // Validate required fields
        if (attendanceId == null || visitDate == null || timeIn == null || timeOut ==null || remarks == null || visitDate.isEmpty() || timeIn.isEmpty() || remarks.isEmpty() || timeOut.isEmpty()) {
            session.setAttribute("error_message", "All fields are required.");
            response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
            return;
        }

        // Validate date format
        LocalDate sqlVisitDate;
        try {
            sqlVisitDate = LocalDate.parse(visitDate); // Validate date
        } catch (DateTimeParseException e) {
            session.setAttribute("error_message", "Invalid date format. Please use YYYY-MM-DD.");
            response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
            return;
        }

        // Validate time format
        LocalTime sqlVisitTimeIn;
        try {
            sqlVisitTimeIn = LocalTime.parse(timeIn); // Validate time
        } catch (DateTimeParseException e) {
            session.setAttribute("error_message", "Invalid time format for Time In. Please use HH:MM.");
            response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
            return;
        }

        LocalTime sqlVisitTimeOut = null;
        if (timeOut != null && !timeOut.isEmpty()) {
            try {
                sqlVisitTimeOut = LocalTime.parse(timeOut); // Validate time
            } catch (DateTimeParseException e) {
                session.setAttribute("error_message", "Invalid time format for Time Out. Please use HH:MM.");
                response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
                return;
            }
        }

        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update attendance record
        String sql = "UPDATE attendances SET visit_date = ?, visit_time_in = ?, visit_time_out = ?, remarks = ? WHERE attendance_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setDate(1, java.sql.Date.valueOf(sqlVisitDate));
        pstmt.setTime(2, java.sql.Time.valueOf(sqlVisitTimeIn));

        if (sqlVisitTimeOut != null) {
            pstmt.setTime(3, java.sql.Time.valueOf(sqlVisitTimeOut)); // Validate Time Out
        } else {
            pstmt.setNull(3, java.sql.Types.TIME); // Allow null for Time Out
        }

        pstmt.setString(4, remarks);
        pstmt.setInt(5, Integer.parseInt(attendanceId));

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Attendance updated successfully!");
        } else {
            session.setAttribute("error_message", "Failed to update attendance.");
        }
        response.sendRedirect("attendance.jsp");
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace(); // Print SQL exception details
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
    } catch (Exception e) {
        e.printStackTrace(); // Print general exception details
        session.setAttribute("error_message", "Error updating attendance: " + e.getMessage());
        response.sendRedirect("editAttendance.jsp?id=" + attendanceId);
    }
%> 