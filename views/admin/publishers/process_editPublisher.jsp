<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String publisherId = request.getParameter("publisher_id");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String website = request.getParameter("website");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        String sql = "UPDATE publisher SET name=?, address=?, phone=?, email=?, website=? WHERE publisher_id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, address);
        pstmt.setString(3, phone);
        pstmt.setString(4, email);
        pstmt.setString(5, website);
        pstmt.setInt(6, Integer.parseInt(publisherId));

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Publisher updated successfully!");
        } else {
            session.setAttribute("error_message", "Failed to update publisher.");
        }
        response.sendRedirect("publisher.jsp");
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("publisher.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("publisher.jsp");
    }
%> 