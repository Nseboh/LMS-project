<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String patronId = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Delete patron from patronmembership table
        String sqlMembership = "DELETE FROM patronmembership WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlMembership);
        pstmt.setString(1, patronId);
        pstmt.executeUpdate();

        // Delete patron from patroncontact table
        String sqlContact = "DELETE FROM patroncontact WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlContact);
        pstmt.setString(1, patronId);
        pstmt.executeUpdate();

        // Delete patron from patron table
        String sqlPatron = "DELETE FROM patron WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlPatron);
        pstmt.setString(1, patronId);
        pstmt.executeUpdate();

        // Redirect to the patron list with success message
        session.setAttribute("success_message", "Patron deleted successfully!");
        response.sendRedirect("patron.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("patron.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("patron.jsp");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%> 