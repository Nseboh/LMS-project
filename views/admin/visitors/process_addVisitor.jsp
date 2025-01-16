<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String fullName = request.getParameter("fullName");
    String contactNumber = request.getParameter("contactNumber");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");
    String timeOut = request.getParameter("timeOut");
    String status = request.getParameter("status");

    // Debugging: Print the values to check if they are received correctly
    System.out.println("Full Name: " + fullName);
    System.out.println("Contact Number: " + contactNumber);
    System.out.println("Email: " + email);
    System.out.println("Gender: " + gender);
    System.out.println("Time Out: " + timeOut);
    System.out.println("Status: " + status);

    // Check for null values
    if (fullName == null || contactNumber == null || email == null || gender == null || timeOut == null || status == null) {
        session.setAttribute("error_message", "All fields are required.");
        response.sendRedirect("addVisitor.jsp");
        return; // Exit if any required field is null
    }

    // Get current date for Visit Date and current time for Time In
    LocalDate visitDate = LocalDate.now();
    LocalTime timeIn = LocalTime.now();

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Insert visitor data
        String sql = "INSERT INTO visitor (full_name, contact_number, email, gender, visit_date, time_in, time_out, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, fullName);
        pstmt.setString(2, contactNumber);
        pstmt.setString(3, email);
        pstmt.setString(4, gender);
        pstmt.setDate(5, java.sql.Date.valueOf(visitDate)); // Automatically set Visit Date
        pstmt.setTime(6, java.sql.Time.valueOf(timeIn)); // Automatically set Time In
        
        // Handle Time Out
        if (timeOut != null && !timeOut.isEmpty()) {
            pstmt.setTime(7, java.sql.Time.valueOf(timeOut)); // Manually input Time Out
        } else {
            pstmt.setNull(7, java.sql.Types.TIME); // Set Time Out to null if not provided
        }
        
        pstmt.setString(8, status);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Visitor added successfully!");
            response.sendRedirect("visitor.jsp");
        } else {
            session.setAttribute("error_message", "Failed to add visitor.");
            response.sendRedirect("addVisitor.jsp");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error adding visitor: " + e.getMessage());
        response.sendRedirect("addVisitor.jsp");
    }
%> 