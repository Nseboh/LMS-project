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

        String sql = "UPDATE author SET first_name=?, last_name=?, date_of_birth=?, nationality=?, biography=?, email=?, website=? WHERE author_id=?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setDate(3, java.sql.Date.valueOf(dateOfBirth));
        pstmt.setString(4, nationality);
        pstmt.setString(5, biography);
        pstmt.setString(6, email);
        pstmt.setString(7, website);
        pstmt.setString(8, authorId);

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Author updated successfully!");
        } else {
            session.setAttribute("error_message", "Failed to update author.");
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