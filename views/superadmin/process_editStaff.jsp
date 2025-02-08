<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String staffId = request.getParameter("staff_id");
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String gender = request.getParameter("gender");
    String contact = request.getParameter("contact");
    String email = request.getParameter("email");
    String address = request.getParameter("address");
    String status = request.getParameter("status");
    String roleName = request.getParameter("role_name");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update staff table
        String sqlStaff = "UPDATE staff SET first_name = ?, last_name = ?, gender = ? WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlStaff);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, gender);
        pstmt.setString(4, staffId);
        pstmt.executeUpdate();

        // Update staff_contact table
        String sqlContact = "UPDATE staff_contact SET contact = ?, email = ?, address = ? WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlContact);
        pstmt.setString(1, contact);
        pstmt.setString(2, email);
        pstmt.setString(3, address);
        pstmt.setString(4, staffId);
        pstmt.executeUpdate();

        // Update staff_status table
        String sqlStatus = "UPDATE staff_status SET status = ? WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlStatus);
        pstmt.setString(1, status);
        pstmt.setString(2, staffId);
        pstmt.executeUpdate();

        // Update staffrole table
        String sqlRole = "UPDATE staffrole SET role_name = ? WHERE staff_id = ?";
        pstmt = conn.prepareStatement(sqlRole);
        pstmt.setString(1, roleName);
        pstmt.setString(2, staffId);
        pstmt.executeUpdate();

        // Redirect to the dashboard with a success message
        session.setAttribute("success_message", "Staff updated successfully!");
        response.sendRedirect("superadminDashboard.jsp");
    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error updating staff: " + e.getMessage());
        response.sendRedirect("editStaff.jsp?id=" + staffId);
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("editStaff.jsp?id=" + staffId);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>