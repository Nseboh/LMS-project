<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    String isbn = request.getParameter("isbn");
    if (isbn == null) {
        out.println("<h2>No ISBN provided.</h2>");
        return; // Exit if no ISBN is provided
    }

    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Debugging output
        System.out.println("Fetching details for ISBN: " + isbn);

        // SQL query to fetch book details
        String sql = "SELECT b.isbn, b.title, b.author_id, b.genre, b.language, b.publication_year, b.total_copies, " +
                     "bc.copies_available, bc.status, p.Publication_name AS Publication_name, " +
                     "CONCAT(a.first_name, ' ', a.last_name) AS author_name " +
                     "FROM books b " +
                     "LEFT JOIN bookcopy bc ON b.isbn = bc.isbn " +
                     "LEFT JOIN authors a ON b.author_id = a.author_id " +
                     "LEFT JOIN publisher p ON b.publisher_id = p.publisher_id " +
                     "WHERE b.isbn = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String title = rs.getString("title");
            String authorName = rs.getString("author_name");
            String genre = rs.getString("genre");
            String language = rs.getString("language");
            int publicationYear = rs.getInt("publication_year");
            int totalCopies = rs.getInt("total_copies");
            int copiesAvailable = rs.getInt("copies_available");
            String status = rs.getString("status");
            String publisherName = rs.getString("Publication_name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Details - <%= title %></title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .book-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px;
            text-align: center;
            transition: transform 0.2s;
        }
        .book-card:hover {
            transform: scale(1.02);
        }
        .book-card h2 {
            margin: 10px 0;
            font-size: 2em;
            color: #333;
        }
        .book-card p {
            font-size: 16px;
            color: #555;
            margin: 10px 0;
        }
        .close-button {
            margin-top: 20px;
            padding: 12px 24px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 16px;
        }
        .close-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="book-card">
    <h2><%= title %></h2>
    <p><strong>ISBN/ISSN:</strong> <%= isbn %></p>
    <p><strong>Author:</strong> <%= authorName != null ? authorName : "N/A" %></p>
    <p><strong>Publisher:</strong> <%= publisherName != null ? publisherName : "N/A" %></p>
    <p><strong>Genre:</strong> <%= genre != null ? genre : "N/A" %></p>
    <p><strong>Language:</strong> <%= language != null ? language : "N/A" %></p>
    <p><strong>Publication Year:</strong> <%= publicationYear %></p>
    <p><strong>Total Copies:</strong> <%= totalCopies %></p>
    <p><strong>Copies Available:</strong> <%= copiesAvailable %></p>
    <p><strong>Status:</strong> <%= status != null ? status : "N/A" %></p>
    <button class="close-button" onclick="window.location.href='lending.jsp'">Back to lending</button>
</div>

</body>
</html>
<%
        } else {
            out.println("<h2>No book found with the given ISBN.</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error fetching book details: " + e.getMessage() + "</h2>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
