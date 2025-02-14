<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String publisherId = request.getParameter("id");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Delete from publishercontact table
        String sqlContact = "DELETE FROM publishercontact WHERE publisher_id = ?";
        PreparedStatement pstmtContact = conn.prepareStatement(sqlContact);
        pstmtContact.setString(1, publisherId);
        pstmtContact.executeUpdate();

        // Delete from publisher table
        String sqlPublisher = "DELETE FROM publisher WHERE publisher_id = ?";
        PreparedStatement pstmtPublisher = conn.prepareStatement(sqlPublisher);
        pstmtPublisher.setString(1, publisherId);
        pstmtPublisher.executeUpdate();

        // After successful deletion
        session.setAttribute("success_message", "Publisher deleted successfully!");
        response.sendRedirect("publisher.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("publisher.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("publisher.jsp");
    }
%> 