<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    String authorId = request.getParameter("author_id");
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String dateOfBirth = request.getParameter("date_of_birth");
    String nationality = request.getParameter("nationality");
    String biography = request.getParameter("biography");
    String email = request.getParameter("email");
    String website = request.getParameter("website");

    try {
        // Insert into database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        String sql = "INSERT INTO authors (author_id, first_name, last_name, date_of_birth, nationality, biography, email, website, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, authorId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setString(4, dateOfBirth);
        pstmt.setString(5, nationality);
        pstmt.setString(6, biography);
        pstmt.setString(7, email);
        pstmt.setString(8, website);
        pstmt.executeUpdate();
        conn.close();
        response.sendRedirect("author.jsp"); // Redirect to the author list or another page
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "Database error: " + sqlEx.getMessage());
        response.sendRedirect("addAuthor.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error: " + e.getMessage());
        response.sendRedirect("addAuthor.jsp");
    }
%>