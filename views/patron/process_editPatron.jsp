<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patronId = request.getParameter("id");
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

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Update patron data
        String sql = "UPDATE patron SET first_name = ?, last_name = ?, email = ?, contact = ?, address = ?, " +
                     "emergency_contact = ?, membership_type = ?, gender = ?, status = ?, age = ? WHERE patron_id = ?";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, contact);
        pstmt.setString(5, address);
        pstmt.setString(6, emergencyContact);
        pstmt.setString(7, membershipType);
        pstmt.setString(8, gender);
        pstmt.setString(9, status);
        pstmt.setString(10, age);
        pstmt.setString(11, patronId);

        pstmt.executeUpdate();

        // After successful update
        session.setAttribute("success_message", "Patron updated successfully!");
        response.sendRedirect("patron.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", e.getMessage());
        response.sendRedirect("editPatron.jsp?id=" + patronId); // Redirect back to edit page with error
    }
%>
