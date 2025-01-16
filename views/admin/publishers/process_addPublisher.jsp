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

        String sql = "INSERT INTO publisher (publisher_id, name, address, phone, email, website) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(publisherId));
        pstmt.setString(2, name);
        pstmt.setString(3, address);
        pstmt.setString(4, phone);
        pstmt.setString(5, email);
        pstmt.setString(6, website);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Publisher added successfully!");
        } else {
            session.setAttribute("error_message", "Failed to add publisher.");
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