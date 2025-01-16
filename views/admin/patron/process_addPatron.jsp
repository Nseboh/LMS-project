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
    try {
        // Get form data
        String patronId = request.getParameter("patronId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");
        String emergencyContact = request.getParameter("emergencyContact");
        String membershipType = request.getParameter("membershipType");
        String gender = request.getParameter("gender");
        String status = request.getParameter("status");
        String age = request.getParameter("age");

        // Generate password and barcode
        String password = generatePassword();
        String barcode = generateBarcode();
        System.out.println("Generated Barcode: " + barcode); // Log the generated barcode

        // Calculate expiry date (365 days from now)
        LocalDate dateJoined = LocalDate.now();
        LocalDate expirationDate = dateJoined.plusDays(365);

        // Database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Check if the patron ID already exists
        PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM patron WHERE patron_id = ?");
        checkStmt.setString(1, patronId);
        ResultSet rs = checkStmt.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        if (count > 0) {
            session.setAttribute("error_message", "Patron ID already exists. Please use a different ID.");
            response.sendRedirect("addPatron.jsp");
            return;
        }

        // Insert user data
        String sql = "INSERT INTO patron (patron_id, first_name, last_name, email, address, " +
                     "contact, emergency_contact, membership_type, gender, status, password, barcode, " +
                     "date_joined, expiration_date, age) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, patronId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setString(4, email);
        pstmt.setString(5, address);
        pstmt.setString(6, contact);
        pstmt.setString(7, emergencyContact);
        pstmt.setString(8, membershipType);
        pstmt.setString(9, gender);
        pstmt.setString(10, status);
        pstmt.setString(11, password);
        pstmt.setString(12, barcode);
        pstmt.setDate(13, java.sql.Date.valueOf(dateJoined));
        pstmt.setDate(14, java.sql.Date.valueOf(expirationDate));
        pstmt.setString(15, age);

        pstmt.executeUpdate();

        // After successful addition
        session.setAttribute("success_message", "patron added successfully!");
        session.setAttribute("generated_password", password);
        session.setAttribute("generated_barcode", barcode);
        response.sendRedirect("patron.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("addPatron.jsp");
    } catch (Exception e) {
        // On error
        e.printStackTrace();
        session.setAttribute("error_message", e.getMessage());
        response.sendRedirect("addPatron.jsp");
    }
%> 