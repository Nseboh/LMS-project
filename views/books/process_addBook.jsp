<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String title = request.getParameter("title");
    String authorId = request.getParameter("authorId");
    String publisherId = request.getParameter("publisherId");
    String isbn = request.getParameter("isbn");
    String publicationYear = request.getParameter("publicationYear");
    String edition = request.getParameter("edition");
    String totalCopies = request.getParameter("totalCopies");
    String copiesAvailable = request.getParameter("copiesAvailable");
    String status = request.getParameter("status");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        String sql = "INSERT INTO book (title, author_id, publisher_id, isbn, publication_year, edition, total_copies, copies_available, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, authorId);
        pstmt.setString(3, publisherId);
        pstmt.setString(4, isbn);
        pstmt.setInt(5, Integer.parseInt(publicationYear));
        pstmt.setString(6, edition);
        pstmt.setInt(7, Integer.parseInt(totalCopies));
        pstmt.setInt(8, Integer.parseInt(copiesAvailable));
        pstmt.setString(9, status);

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Book added successfully!");
        } else {
            session.setAttribute("error_message", "Failed to add book.");
        }
        response.sendRedirect("books.jsp");
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("books.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("books.jsp");
    }
%> 