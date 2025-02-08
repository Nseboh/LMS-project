<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String staffId = request.getParameter("id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Delete from staffrole table
        String sqlRole = "DELETE FROM staffrole WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlRole);
        pstmt.setString(1, staffId);
        pstmt.executeUpdate();

        // Delete from staff_status table
        String sqlStatus = "DELETE FROM staff_status WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlStatus);
        pstmt.setString(1, staffId);
        pstmt.executeUpdate();

        // Delete from staff_contact table
        String sqlContact = "DELETE FROM staff_contact WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlContact);
        pstmt.setString(1, staffId);
        pstmt.executeUpdate();

        // Delete from staff table
        String sqlStaff = "DELETE FROM staff WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlStaff);
        pstmt.setString(1, staffId);
        pstmt.executeUpdate();

        // Redirect to the dashboard with a success message
        session.setAttribute("delete_success_message", "Staff deleted successfully!");
        response.sendRedirect("superadminDashboard.jsp");
    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("delete_error_message", "Error deleting staff: " + e.getMessage());
        response.sendRedirect("superadminDashboard.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("delete_error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("superadminDashboard.jsp");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%> 