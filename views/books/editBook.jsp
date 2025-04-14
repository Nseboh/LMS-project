<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String isbn = request.getParameter("isbn");
    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String title = "", authorId = "", genre = "", language = "", publisherId = "";
    int publicationYear = 0, totalCopies = 0, copiesAvailable = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // SQL query to fetch book details including publisher and copies available
        String sql = "SELECT b.title, b.author_id, b.genre, b.language, b.publication_year, b.total_copies, " +
                     "bc.copies_available, b.publisher_id " +
                     "FROM books b " +
                     "LEFT JOIN bookcopy bc ON b.isbn = bc.isbn " +
                     "WHERE b.isbn = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, isbn);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            authorId = rs.getString("author_id");
            genre = rs.getString("genre");
            language = rs.getString("language");
            publicationYear = rs.getInt("publication_year");
            totalCopies = rs.getInt("total_copies");
            copiesAvailable = rs.getInt("copies_available");
            publisherId = rs.getString("publisher_id");
        } else {
            out.println("<h2>No book found with the given ISBN.</h2>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book - <%= title %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
</head>
<body>
    <div class="modal-content">
        <h1>Edit Book</h1>
        <form id= "addUserForm"action="process_editBook.jsp" method="POST">
            <input type="hidden" name="isbn" value="<%= isbn %>">
            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" id="title" name="title" value="<%= title %>" required>
            </div>
            <div class="form-group">
                <label for="author_id">Author ID:</label>
                <input type="text" id="author_id" name="author_id" value="<%= authorId %>" required>
            </div>
            <div class="form-group">
                <label for="genre">Genre:</label>
                <input type="text" id="genre" name="genre" value="<%= genre %>" required>
            </div>
            <div class="form-group">
                <label for="language">Language:</label>
                <input type="text" id="language" name="language" value="<%= language %>" required>
            </div>
            <div class="form-group">
                <label for="publication_year">Publication Year:</label>
                <input type="number" id="publication_year" name="publication_year" value="<%= publicationYear %>" required>
            </div>
            <div class="form-group">
                <label for="total_copies">Total Copies:</label>
                <input type="number" id="total_copies" name="total_copies" value="<%= totalCopies %>" required>
            </div>
            <div class="form-group">
                <label for="copies_available">Copies Available:</label>
                <input type="number" id="copies_available" name="copies_available" value="<%= copiesAvailable %>" required>
            </div>
            <div class="form-group">
                <label for="publisher_id">Publisher ID:</label>
                <input type="text" id="publisher_id" name="publisher_id" value="<%= publisherId %>" required>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn" style="background-color:rgb(19, 175, 58);">Update Book</button>
                <button type="button" class="submit-btn" onclick="window.location.href='books.jsp'" style="background-color:rgb(201, 43, 43);">Cancel</button>
            </div>
        </form>
    </div>
</body>
</html> 