<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("visitor_id");
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String contactNumber = request.getParameter("contact_number");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");
    String timeIn = request.getParameter("time_in");
    String timeOut = request.getParameter("time_out");
    String status = request.getParameter("status");
    String remarks = request.getParameter("remarks");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update visitor details
        String sqlVisitor = "UPDATE visitor SET first_name=?, last_name=?, contact_number=?, email=?, gender=? WHERE visitor_id=?";
        pstmt = conn.prepareStatement(sqlVisitor);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, contactNumber);
        pstmt.setString(4, email);
        pstmt.setString(5, gender);
        pstmt.setString(6, visitorId);
        pstmt.executeUpdate();

        // Update visit details if they exist
        String sqlVisit = "UPDATE visitorvisit SET time_out=? WHERE visitor_id=?";
        pstmt = conn.prepareStatement(sqlVisit);
        pstmt.setString(1, timeOut);
        pstmt.setString(2, visitorId);
        pstmt.executeUpdate();

        // Update status
        String sqlStatus = "UPDATE visitstatus SET status=?, remarks=? WHERE visitor_id=?";
        pstmt = conn.prepareStatement(sqlStatus);
        pstmt.setString(1, status);
        pstmt.setString(2, remarks);
        pstmt.setString(3, visitorId);
        pstmt.executeUpdate();

        session.setAttribute("success_message", "Visitor updated successfully!");
        response.sendRedirect("visitor.jsp");

    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error updating visitor: " + e.getMessage());
        response.sendRedirect("editVisitor.jsp?id=" + visitorId);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>