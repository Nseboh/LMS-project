<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
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
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        String sql = "INSERT INTO author (author_id, first_name, last_name, date_of_birth, nationality, biography, email, website, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, authorId);
        pstmt.setString(2, firstName);
        pstmt.setString(3, lastName);
        pstmt.setDate(4, java.sql.Date.valueOf(dateOfBirth));
        pstmt.setString(5, nationality);
        pstmt.setString(6, biography);
        pstmt.setString(7, email);
        pstmt.setString(8, website);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Author added successfully!");
        } else {
            session.setAttribute("error_message", "Failed to add author.");
        }
        response.sendRedirect("author.jsp");
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("author.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("author.jsp");
    }
%> 