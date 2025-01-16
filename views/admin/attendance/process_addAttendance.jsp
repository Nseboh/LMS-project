<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String scanId = request.getParameter("scanId");
    String visitDate = request.getParameter("visitDate");
    String visitTimeIn = request.getParameter("visitTimeIn");
    String visitTimeOut = request.getParameter("visitTimeOut");
    String remarks = request.getParameter("remarks");

    try {
        // Validate required fields
        if (scanId == null || scanId.isEmpty() || visitDate == null || visitTimeIn == null || remarks == null || remarks.isEmpty() || visitTimeOut == null) {
            session.setAttribute("error_message", "Scan ID, Visit Date, Time In, Time Out, and Remarks are required.");
            response.sendRedirect("addAttendance.jsp");
            return;
        }

        // Validate date format
        LocalDate sqlVisitDate;
        try {
            sqlVisitDate = LocalDate.parse(visitDate); // Validate date
        } catch (DateTimeParseException e) {
            session.setAttribute("error_message", "Invalid date format. Please use YYYY-MM-DD.");
            response.sendRedirect("addAttendance.jsp");
            return;
        }

        // Validate time format
        LocalTime sqlVisitTimeIn;
        try {
            sqlVisitTimeIn = LocalTime.parse(visitTimeIn); // Validate time
        } catch (DateTimeParseException e) {
            session.setAttribute("error_message", "Invalid time format for Time In. Please use HH:MM.");
            response.sendRedirect("addAttendance.jsp");
            return;
        }

        LocalTime sqlVisitTimeOut = null;
        if (visitTimeOut != null && !visitTimeOut.isEmpty()) {
            try {
                sqlVisitTimeOut = LocalTime.parse(visitTimeOut); // Validate time
            } catch (DateTimeParseException e) {
                session.setAttribute("error_message", "Invalid time format for Time Out. Please use HH:MM.");
                response.sendRedirect("addAttendance.jsp");
                return;
            }
        }

        // Establish database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Retrieve patron ID
        String patronId = null;
        String patronName = null;

        String patronQuery = "SELECT patron_id, first_name, last_name FROM patron WHERE barcode = ?";
        PreparedStatement patronStmt = conn.prepareStatement(patronQuery);
        patronStmt.setString(1, scanId);
        ResultSet patronRs = patronStmt.executeQuery();

        if (patronRs.next()) {
            patronId = patronRs.getString("patron_id");
            patronName = patronRs.getString("first_name") + " " + patronRs.getString("last_name");
        } else {
            session.setAttribute("error_message", "Patron not found.");
            response.sendRedirect("addAttendance.jsp");
            return;
        }

        // Insert attendance record
        String sql = "INSERT INTO attendances (patron_id, visit_date, visit_time_in, visit_time_out, remarks) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, patronId);
        pstmt.setDate(2, java.sql.Date.valueOf(sqlVisitDate));
        pstmt.setTime(3, java.sql.Time.valueOf(sqlVisitTimeIn));

        if (sqlVisitTimeOut != null) {
            pstmt.setTime(4, java.sql.Time.valueOf(sqlVisitTimeOut)); // Validate Time Out
        } else {
            pstmt.setNull(4, java.sql.Types.TIME); // Allow null for Time Out
        }

        pstmt.setString(5, remarks);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Attendance recorded successfully for " + patronName + "!");
            session.setAttribute("patron_name", patronName); // Store patron name in session
            response.sendRedirect("attendance.jsp");
        } else {
            session.setAttribute("error_message", "Failed to record attendance.");
            response.sendRedirect("addAttendance.jsp");
        }
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace(); // Print SQL exception details
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("addAttendance.jsp");
    } catch (Exception e) {
        e.printStackTrace(); // Print general exception details
        session.setAttribute("error_message", "Error recording attendance: " + e.getMessage());
        response.sendRedirect("addAttendance.jsp");
    }
%>
