<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");
    String fullName = request.getParameter("fullName");
    String contactNumber = request.getParameter("contactNumber");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");
    String status = request.getParameter("status");
    String timeOut = request.getParameter("timeOut");

    // Debugging: Print received parameters
    System.out.println("Visitor ID: " + visitorId);
    System.out.println("Full Name: " + fullName);
    System.out.println("Contact Number: " + contactNumber);
    System.out.println("Email: " + email);
    System.out.println("Gender: " + gender);
    System.out.println("Status: " + status);
    System.out.println("Time Out: " + timeOut);

    try {
        // Validate required fields
        if (visitorId == null || fullName == null || contactNumber == null || email == null || gender == null || status == null) {
            session.setAttribute("error_message", "All fields except Time Out are required.");
            response.sendRedirect("editVisitor.jsp?id=" + visitorId);
            return;
        }

        // Validate Time Out format
        if (timeOut != null && !timeOut.isEmpty()) {
            if (!timeOut.matches("^([01]?[0-9]|2[0-3]):[0-5][0-9]$")) {
                session.setAttribute("error_message", "Invalid time format for Time Out. Please use HH:MM.");
                response.sendRedirect("editVisitor.jsp?id=" + visitorId);
                return;
            }
            timeOut += ":00"; // Append seconds if the input is in HH:MM format
        }

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Check if visitor exists
        String checkSql = "SELECT visitor_id FROM visitor WHERE visitor_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, visitorId);
        ResultSet rs = checkStmt.executeQuery();
        if (!rs.next()) {
            session.setAttribute("error_message", "Visitor not found.");
            response.sendRedirect("editVisitor.jsp?id=" + visitorId);
            return;
        }

        // Update visitor record
        String sql = "UPDATE visitor SET full_name=?, contact_number=?, email=?, gender=?, status=?, time_out=? WHERE visitor_id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName);
        pstmt.setString(2, contactNumber);
        pstmt.setString(3, email);
        pstmt.setString(4, gender);
        pstmt.setString(5, status);

        // Handle Time Out
        if (timeOut != null && !timeOut.isEmpty()) {
            pstmt.setTime(6, java.sql.Time.valueOf(timeOut));
        } else {
            pstmt.setNull(6, java.sql.Types.TIME);
        }

        pstmt.setString(7, visitorId);

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Visitor updated successfully!");
            response.sendRedirect("visitor.jsp");
        } else {
            session.setAttribute("error_message", "No changes made to the visitor.");
            response.sendRedirect("editVisitor.jsp?id=" + visitorId);
        }
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editVisitor.jsp?id=" + visitorId);
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred while updating the visitor.");
        response.sendRedirect("editVisitor.jsp?id=" + visitorId);
    }
%>
