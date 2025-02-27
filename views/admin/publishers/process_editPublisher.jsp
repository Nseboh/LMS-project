<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    try {
        // Get form data
        String publisherId = request.getParameter("publisher_id");
        String publicationName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String website = request.getParameter("website");

        // Database connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update publisher details
        String sqlPublisher = "UPDATE publisher SET Publication_name = ? WHERE publisher_id = ?";
        PreparedStatement pstmtPublisher = conn.prepareStatement(sqlPublisher);
        pstmtPublisher.setString(1, publicationName);
        pstmtPublisher.setString(2, publisherId);
        pstmtPublisher.executeUpdate();

        // Update publisher contact details
        String sqlContact = "UPDATE publishercontact SET phone = ?, email = ?, website = ? WHERE publisher_id = ?";
        PreparedStatement pstmtContact = conn.prepareStatement(sqlContact);
        pstmtContact.setString(1, phone);
        pstmtContact.setString(2, email);
        pstmtContact.setString(3, website);
        pstmtContact.setString(4, publisherId);
        pstmtContact.executeUpdate();

        // After successful update
        session.setAttribute("success_message", "Publisher updated successfully!");
        response.sendRedirect("publisher.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editPublisher.jsp?id=" + request.getParameter("publisher_id"));
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("editPublisher.jsp?id=" + request.getParameter("publisher_id"));
    }
%> 