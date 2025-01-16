<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    // Function to generate random password
    private String generatePassword() {
        return UUID.randomUUID().toString().substring(0, 8);
    }
%>
<%
    try {
        // Get form data
        String staffId = request.getParameter("staffId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        

        // Generate password and barcode
        String password = generatePassword();
        

        // Calculate expiry date (365 days from now)
        LocalDate createdAt = LocalDate.now();

        // Database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Insert user data
        String sql = "INSERT INTO staffs (staff_id, first_name, last_name, gender, contact, address, email, " +
                     "password,created_at, role, " +
                     " status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, staffId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setString(4, gender);
        pstmt.setString(5, contact);
        pstmt.setString(6, address);
        pstmt.setString(7, email);
        pstmt.setString(8, password);
        pstmt.setDate(9, java.sql.Date.valueOf(createdAt));
        pstmt.setString(10, role);
        pstmt.setString(11, status);

        pstmt.executeUpdate();

        // After successful addition
        session.setAttribute("success_message", "Staff added successfully!");
        session.setAttribute("generated_password", password);
        response.sendRedirect("superadminDashboard.jsp");

    } catch (Exception e) {
        // On error
        session.setAttribute("error_message", e.getMessage());
        response.sendRedirect("addStaff.jsp");
    }
%> 