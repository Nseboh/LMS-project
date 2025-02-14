<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String isbn = request.getParameter("isbn");
    String title = request.getParameter("title");
    String authorId = request.getParameter("author_id");
    String genre = request.getParameter("genre");
    String language = request.getParameter("language");
    int publicationYear = Integer.parseInt(request.getParameter("publication_year"));
    int totalCopies = Integer.parseInt(request.getParameter("total_copies"));
    int copiesAvailable = Integer.parseInt(request.getParameter("copies_available"));
    String publisherId = request.getParameter("publisher_id");

    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // SQL query to update book details
        String sql = "UPDATE books SET title = ?, author_id = ?, genre = ?, language = ?, publication_year = ?, total_copies = ?, publisher_id = ? WHERE isbn = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, authorId);
        pstmt.setString(3, genre);
        pstmt.setString(4, language);
        pstmt.setInt(5, publicationYear);
        pstmt.setInt(6, totalCopies);
        pstmt.setString(7, publisherId);
        pstmt.setString(8, isbn);

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Book updated successfully!");
        } else {
            session.setAttribute("error_message", "Error updating book.");
        }
        response.sendRedirect("books.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error updating book: " + e.getMessage());
        response.sendRedirect("editBook.jsp?isbn=" + isbn);
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%> 