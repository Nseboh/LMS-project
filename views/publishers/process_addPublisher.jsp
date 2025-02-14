<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    try {
        // Get form data
        String publicationName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String website = request.getParameter("website");

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Insert into publishers table
        String sqlPublisher = "INSERT INTO publisher (Publication_name, created_at) VALUES (?, ?)";
        PreparedStatement pstmtPublisher = conn.prepareStatement(sqlPublisher, Statement.RETURN_GENERATED_KEYS);
        pstmtPublisher.setString(1, publicationName);
        pstmtPublisher.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
        pstmtPublisher.executeUpdate();

        // Retrieve the generated publisher_id
        ResultSet generatedKeys = pstmtPublisher.getGeneratedKeys();
        String publisherId = null;
        if (generatedKeys.next()) {
            publisherId = generatedKeys.getString(1); // Assuming publisher_id is the first column
        }

        // Insert into publishercontact table
        String sqlContact = "INSERT INTO publishercontact (publisher_id, phone, email, website) VALUES (?, ?, ?, ?)";
        PreparedStatement pstmtContact = conn.prepareStatement(sqlContact);
        pstmtContact.setString(1, publisherId);
        pstmtContact.setString(2, phone);
        pstmtContact.setString(3, email);
        pstmtContact.setString(4, website);
        pstmtContact.executeUpdate();

        // After successful addition
        session.setAttribute("success_message", "Publisher added successfully!");
        response.sendRedirect("publisher.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("addPublisher.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("addPublisher.jsp");
    }
%> 