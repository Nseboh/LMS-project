<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Retrieve form data
    String isbn = request.getParameter("isbn");
    String title = request.getParameter("title");
    String authorId = request.getParameter("author_id");
    String genre = request.getParameter("genre");
    String language = request.getParameter("language");
    int publicationYear = Integer.parseInt(request.getParameter("publication_year"));
    int totalCopies = Integer.parseInt(request.getParameter("total_copies"));
    int copiesAvailable = Integer.parseInt(request.getParameter("available_copies"));
    String publisherId = request.getParameter("publisher_id");
    String status = "Available"; // Default status for new book copies

    // Database connection parameters
    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmtBooks = null;
    PreparedStatement pstmtBookCopy = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // SQL query to insert a new book into the books table
        String sqlBooks = "INSERT INTO books (isbn, title, author_id, genre, language, publication_year, total_copies, publisher_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmtBooks = conn.prepareStatement(sqlBooks);
        pstmtBooks.setString(1, isbn);
        pstmtBooks.setString(2, title);
        pstmtBooks.setString(3, authorId);
        pstmtBooks.setString(4, genre);
        pstmtBooks.setString(5, language);
        pstmtBooks.setInt(6, publicationYear);
        pstmtBooks.setInt(7, totalCopies);
        pstmtBooks.setString(8, publisherId);
        
        // Execute the update for books table
        pstmtBooks.executeUpdate();

        // SQL query to insert a new book copy into the bookcopy table
        String sqlBookCopy = "INSERT INTO bookcopy (isbn, copies_available, status) VALUES (?, ?, ?)";
        pstmtBookCopy = conn.prepareStatement(sqlBookCopy);
        pstmtBookCopy.setString(1, isbn);
        pstmtBookCopy.setInt(2, copiesAvailable);
        pstmtBookCopy.setString(3, status);
        
        // Execute the update for bookcopy table
        pstmtBookCopy.executeUpdate();

        // After successful addition
        session.setAttribute("success_message", "Book added successfully!");
        response.sendRedirect("books.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error adding book: " + e.getMessage());
        response.sendRedirect("addBooks.jsp");
    } finally {
        // Close resources
        try {
            if (pstmtBooks != null) pstmtBooks.close();
            if (pstmtBookCopy != null) pstmtBookCopy.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>