<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String staffId = request.getParameter("id");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String contact = request.getParameter("contact");
    String address = request.getParameter("address");
    String email = request.getParameter("email");
    String gender = request.getParameter("gender");
    String role = request.getParameter("role");
    String status = request.getParameter("status");

    if (staffId == null || staffId.isEmpty()) {
        session.setAttribute("error_message", "Staff ID cannot be null.");
        response.sendRedirect("editStaff.jsp?id=" + staffId); // Redirect back to edit page with error
        return; // Exit the JSP
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Update staff data
        String sql = "UPDATE staffs SET first_name = ?, last_name = ?, contact = ?, address = ?, " +
                     "email = ?, gender = ?, role = ?, status = ? WHERE staff_id = ?";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, contact);
        pstmt.setString(4, address);
        pstmt.setString(5, email);
        pstmt.setString(6, gender);
        pstmt.setString(7, role);
        pstmt.setString(8, status); // Ensure this is a string
        pstmt.setString(9, staffId);

        pstmt.executeUpdate();

        // After successful update
        session.setAttribute("success_message", "Staff updated successfully!");
        response.sendRedirect("superadminDashboard.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", e.getMessage());
        response.sendRedirect("editStaff.jsp?id=" + staffId); // Redirect back to edit page with error
    }
%>