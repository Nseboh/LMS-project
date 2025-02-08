<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    try {
        // Get form data
        String title = request.getParameter("title");
        String authorId = request.getParameter("authorId");
        String publisherId = request.getParameter("publisherId");
        String isbn = request.getParameter("isbn");
        String publicationYear = request.getParameter("publicationYear");
        String edition = request.getParameter("edition");
        int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));
        int copiesAvailable = Integer.parseInt(request.getParameter("copiesAvailable"));
        String status = request.getParameter("status");

        // Database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Insert book data
        String sql = "INSERT INTO book (title, author_id, publisher_id, isbn, publication_year, edition, total_copies, copies_available, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, authorId);
        pstmt.setString(3, publisherId);
        pstmt.setString(4, isbn);
        pstmt.setString(5, publicationYear);
        pstmt.setString(6, edition);
        pstmt.setInt(7, totalCopies);
        pstmt.setInt(8, copiesAvailable);
        pstmt.setString(9, status);

        pstmt.executeUpdate();

        // After successful addition
        session.setAttribute("success_message", "Book added successfully!");
        response.sendRedirect("books.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", e.getMessage());
        response.sendRedirect("addBooks.jsp");
    }
%> 