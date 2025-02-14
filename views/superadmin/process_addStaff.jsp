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

        // Debugging output
        System.out.println("Staff ID: " + staffId);
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("Gender: " + gender);
        System.out.println("Contact: " + contact);
        System.out.println("Address: " + address);
        System.out.println("Email: " + email);
        System.out.println("Role: " + role);
        System.out.println("Status: " + status);

        // Generate password
        String password = generatePassword();

        // Get current timestamp
        LocalDateTime createdAt = LocalDateTime.now();

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Check if staff ID already exists
        String checkSql = "SELECT COUNT(*) FROM staff WHERE staff_id = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, staffId);
        ResultSet checkRs = checkStmt.executeQuery();
        checkRs.next();
        int count = checkRs.getInt(1);

        if (count > 0) {
            // Handle duplicate staff ID (e.g., update existing record)
            session.setAttribute("error_message", "Staff ID already exists. Please use a different ID.");
            response.sendRedirect("addStaff.jsp");
            return;
        }

        // Insert into staff table
        String sqlStaff = "INSERT INTO staff (staff_id, first_name, last_name, gender, created_at, password) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmtStaff = conn.prepareStatement(sqlStaff, Statement.RETURN_GENERATED_KEYS);
        pstmtStaff.setString(1, staffId);
        pstmtStaff.setString(2, firstName);
        pstmtStaff.setString(3, lastName);
        pstmtStaff.setString(4, gender);
        pstmtStaff.setTimestamp(5, Timestamp.valueOf(createdAt));
        pstmtStaff.setString(6, password);
        pstmtStaff.executeUpdate();

        // Retrieve the generated staffId
        ResultSet generatedKeys = pstmtStaff.getGeneratedKeys();
        if (generatedKeys.next()) {
            staffId = generatedKeys.getString(1); // Use the existing staffId variable
        }

        // Insert into staff_contact table
        String sqlContact = "INSERT INTO staff_contact (staff_id, contact, email, address) VALUES (?, ?, ?, ?)";
        PreparedStatement pstmtContact = conn.prepareStatement(sqlContact);
        pstmtContact.setString(1, staffId);
        pstmtContact.setString(2, contact);
        pstmtContact.setString(3, email);
        pstmtContact.setString(4, address);
        pstmtContact.executeUpdate();

        // Insert into staff_status table
        String sqlStatus = "INSERT INTO staff_status (staff_id, status, updated_at) VALUES (?, ?, ?)";
        PreparedStatement pstmtStatus = conn.prepareStatement(sqlStatus);
        pstmtStatus.setString(1, staffId);
        pstmtStatus.setString(2, status);
        pstmtStatus.setTimestamp(3, Timestamp.valueOf(createdAt));
        pstmtStatus.executeUpdate();

        // Insert into staffrole table
        String sqlRole = "INSERT INTO staffrole (staff_id, role_name) VALUES (?, ?)";
        PreparedStatement pstmtRole = conn.prepareStatement(sqlRole);
        pstmtRole.setString(1, staffId);
        pstmtRole.setString(2, role);
        pstmtRole.executeUpdate();

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