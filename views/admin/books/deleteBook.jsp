<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String isbn = request.getParameter("isbn");
    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmtBookCopy = null;
    PreparedStatement pstmtBook = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        
        // Start transaction
        conn.setAutoCommit(false);

        try {
            // First delete from bookcopy table (child table)
            String sqlDeleteBookCopy = "DELETE FROM bookcopy WHERE isbn = ?";
            pstmtBookCopy = conn.prepareStatement(sqlDeleteBookCopy);
            pstmtBookCopy.setString(1, isbn);
            pstmtBookCopy.executeUpdate();

            // Then delete from books table (parent table)
            String sqlDeleteBook = "DELETE FROM books WHERE isbn = ?";
            pstmtBook = conn.prepareStatement(sqlDeleteBook);
            pstmtBook.setString(1, isbn);
            int rowsDeleted = pstmtBook.executeUpdate();

            if (rowsDeleted > 0) {
                // Commit the transaction
                conn.commit();
                session.setAttribute("success_message", "Book and its copies deleted successfully!");
            } else {
                // Rollback if no rows were deleted
                conn.rollback();
                session.setAttribute("error_message", "Error deleting book. Book may not exist.");
            }
        } catch (SQLException e) {
            // Rollback on error
            conn.rollback();
            throw e;
        }

        response.sendRedirect("books.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error deleting book: " + e.getMessage());
        response.sendRedirect("books.jsp");
    } finally {
        try {
            // Reset auto-commit to default
            if (conn != null) {
                conn.setAutoCommit(true);
            }
            
            // Close all resources
            if (pstmtBookCopy != null) pstmtBookCopy.close();
            if (pstmtBook != null) pstmtBook.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>