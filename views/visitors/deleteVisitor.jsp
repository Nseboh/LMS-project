<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Delete visitor from visitorvisit table
        String sqlVisit = "DELETE FROM visitorvisit WHERE visitor_id = ?";
        pstmt = conn.prepareStatement(sqlVisit);
        pstmt.setString(1, visitorId);
        pstmt.executeUpdate();

        // Delete visitor from visitstatus table
        String sqlStatus = "DELETE FROM visitstatus WHERE visit_id IN (SELECT visit_id FROM visitorvisit WHERE visitor_id = ?)";
        pstmt = conn.prepareStatement(sqlStatus);
        pstmt.setString(1, visitorId);
        pstmt.executeUpdate();

        // Delete visitor from visitor table
        String sqlVisitor = "DELETE FROM visitor WHERE visitor_id = ?";
        pstmt = conn.prepareStatement(sqlVisitor);
        pstmt.setString(1, visitorId);
        pstmt.executeUpdate();

        // Redirect to the visitor list with success message
        session.setAttribute("success_message", "Visitor deleted successfully!");
        response.sendRedirect("visitor.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("visitor.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("visitor.jsp");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%> 