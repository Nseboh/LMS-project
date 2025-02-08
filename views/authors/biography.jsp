<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    String authorId = request.getParameter("author_id");
    String authorName = "";
    String authorBiography = "";
    String dateOfBirth = "";
    String nationality = "";
    String email = "";
    String website = "";
    String imagePath = ""; // Variable to hold the image path
    List<String> books = new ArrayList<>(); // List to hold book titles

    if (authorId != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

            // Fetch author details including additional fields
            PreparedStatement pstmt = conn.prepareStatement("SELECT first_name, last_name, biography, date_of_birth, nationality, email, website, image_path FROM authors WHERE author_id = ?");
            pstmt.setString(1, authorId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                authorName = rs.getString("first_name") + " " + rs.getString("last_name");
                authorBiography = rs.getString("biography");
                dateOfBirth = rs.getString("date_of_birth");
                nationality = rs.getString("nationality");
                email = rs.getString("email");
                website = rs.getString("website");
                imagePath = rs.getString("image_path"); // Fetch the image path
            }

            // Fetch books written by the author
            pstmt = conn.prepareStatement("SELECT title FROM books WHERE author_id = ?");
            pstmt.setString(1, authorId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                books.add(rs.getString("title")); // Add book titles to the list
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Author Biography</title>
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
        .author-card {
            background: white;
            padding: 30px; /* Increased padding */
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px; /* Increased max width */
            text-align: center;
            transition: transform 0.2s;
        }
        .author-card:hover {
            transform: scale(1.02);
        }
        .author-card img {
            width: 150px; /* Increased image size */
            height: 150px; /* Increased image size */
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 10px;
        }
        .author-card h2 {
            margin: 10px 0;
            font-size: 2em; /* Increased font size */
            color: #333;
        }
        .author-card p {
            font-size: 16px; /* Increased font size */
            color: #555;
            margin: 10px 0;
        }
        .author-card a {
            color: #007BFF;
            text-decoration: none;
        }
        .author-card a:hover {
            text-decoration: underline;
        }
        .close-button {
            margin-top: 20px;
            padding: 12px 24px; /* Increased padding */
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 16px; /* Increased font size */
        }
        .close-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="author-card">
    <img src="<%= imagePath %>" alt="Author Image">
    <h2><%= authorName %></h2>
    <p><strong>Date of Birth:</strong> <%= dateOfBirth %></p>
    <p><strong>Nationality:</strong> <%= nationality %></p>
    <p><strong>Email:</strong> <a href="mailto:<%= email %>"><%= email %></a></p>
    <p><strong>Website:</strong> <a href="<%= website %>" target="_blank"><%= website %></a></p>
    <hr>
    <p><strong>Biography:</strong> <%= authorBiography %></p>
    <p><strong>Books Written:</strong></p>
    <ul>
        <% for (String book : books) { %>
            <li><%= book %></li>
        <% } %>
    </ul>
    <button class="close-button" onclick="window.location.href='author.jsp'">Close</button>
</div>

</body>
</html>
