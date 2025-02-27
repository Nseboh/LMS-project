<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patronId = request.getParameter("patronId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");
    String address = request.getParameter("address");
    String contact = request.getParameter("contact");
    String email = request.getParameter("email");
    String emergencyContact = request.getParameter("emergencyContact");
    String membershipType = request.getParameter("membershipType");
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update patron details
        String sql = "UPDATE patron SET first_name = ?, last_name = ?, age = ?, gender = ? WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, age);
        pstmt.setString(4, gender);
        pstmt.setString(5, patronId);
        pstmt.executeUpdate();

        // Update patron contact details
        String sqlContact = "UPDATE patroncontact SET address = ?, phone = ?, email = ?, emergency_contact = ? WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlContact);
        pstmt.setString(1, address);
        pstmt.setString(2, contact);
        pstmt.setString(3, email);
        pstmt.setString(4, emergencyContact);
        pstmt.setString(5, patronId);
        pstmt.executeUpdate();

        // Update patron membership details
        String sqlMembership = "UPDATE patronmembership SET membership_type = ?, status = ? WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlMembership);
        pstmt.setString(1, membershipType);
        pstmt.setString(2, status);
        pstmt.setString(3, patronId);
        pstmt.executeUpdate();

        // Redirect to the patron list with success message
        session.setAttribute("success_message", "Patron updated successfully!");
        response.sendRedirect("patron.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editPatron.jsp?id=" + patronId);
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("editPatron.jsp?id=" + patronId);
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
