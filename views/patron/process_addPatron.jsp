<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    // Function to generate random password
    private String generatePassword() {
        return UUID.randomUUID().toString().substring(0, 8);
    }

    // Function to generate barcode
    private String generateBarcode() {
        // Generate a barcode with a maximum of 8 characters
        return "LIB" + String.format("%06d", new Random().nextInt(1000000)); // Generates a random number with leading zeros
    }
%>

<%
    String patronId = request.getParameter("patronId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");
    String address = request.getParameter("address");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String emergencyContact = request.getParameter("emergencyContact");
    String membershipType = request.getParameter("membershipType");
    String status = request.getParameter("status");

    // Generate password and barcode
    String password = generatePassword();
    String barcode = generateBarcode();
    System.out.println("Generated Barcode: " + barcode); // Log the generated barcode

    LocalDate dateJoined = LocalDate.now();
    LocalDate expirationDate = dateJoined.plusDays(365); // Calculate expiration date

    Connection conn = null;
    PreparedStatement pstmtPatron = null;
    PreparedStatement pstmtContact = null;
    PreparedStatement pstmtMembership = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Insert into patron table
        String sqlPatron = "INSERT INTO patron (patron_id, first_name, last_name, age, gender, password, barcode) VALUES (?, ?, ?, ?, ?, ?, ?)";
        pstmtPatron = conn.prepareStatement(sqlPatron);
        pstmtPatron.setString(1, patronId);
        pstmtPatron.setString(2, firstName);
        pstmtPatron.setString(3, lastName);
        pstmtPatron.setString(4, age);
        pstmtPatron.setString(5, gender);
        pstmtPatron.setString(6, password);
        pstmtPatron.setString(7, barcode);
        pstmtPatron.executeUpdate();

        // Insert into patroncontact table
        String sqlContact = "INSERT INTO patroncontact (patron_id, address, phone, email, emergency_contact) VALUES (?, ?, ?, ?, ?)";
        pstmtContact = conn.prepareStatement(sqlContact);
        pstmtContact.setString(1, patronId);
        pstmtContact.setString(2, address);
        pstmtContact.setString(3, phone);
        pstmtContact.setString(4, email);
        pstmtContact.setString(5, emergencyContact);
        pstmtContact.executeUpdate();

        // Insert into patronmembership table
        String sqlMembership = "INSERT INTO patronmembership (patron_id, membership_type, date_joined, expiration_date, status) VALUES (?, ?, ?, ?, ?)";
        pstmtMembership = conn.prepareStatement(sqlMembership);
        pstmtMembership.setString(1, patronId);
        pstmtMembership.setString(2, membershipType);
        pstmtMembership.setDate(3, java.sql.Date.valueOf(dateJoined)); // Date joined
        pstmtMembership.setDate(4, java.sql.Date.valueOf(expirationDate)); // Expiration date
        pstmtMembership.setString(5, status);
        pstmtMembership.executeUpdate();

        // Redirect to the patron list with success message
        session.setAttribute("success_message", "Patron added successfully!");
        session.setAttribute("generated_password", password);
        session.setAttribute("generated_barcode", barcode);
        response.sendRedirect("patron.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("addPatron.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("addPatron.jsp");
    } finally {
        if (pstmtPatron != null) try { pstmtPatron.close(); } catch (SQLException e) {}
        if (pstmtContact != null) try { pstmtContact.close(); } catch (SQLException e) {}
        if (pstmtMembership != null) try { pstmtMembership.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%> 