<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddBookModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Book</h1>
            <form id="addBookForm" action="process_addBook.jsp" method="POST">
                <div class="form-group">
                    <label for="isbn">ISBN/ISSN:</label>
                    <input type="text" id="isbn" name="isbn" required placeholder="Enter ISBN/ISSN">
                </div>
                <div class="form-group">
                    <label for="title">Title:</label>
                    <input type="text" id="title" name="title" required placeholder="Enter Book Title">
                </div>
                <div class="form-group">
                    <label for="author_id">Author:</label>
                    <select id="author_id" name="author_id" required>
                        <option value="">Select Author</option>
                        <%
                            // Fetch authors from the database
                            String dbUrl = "jdbc:mysql://localhost:3306/lms";
                            String dbUser = "root";
                            String dbPassword = "Righteous050598$";
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT author_id, CONCAT(first_name, ' ', last_name) AS full_name FROM authors");

                                while (rs.next()) {
                                    String authorId = rs.getString("author_id");
                                    String fullName = rs.getString("full_name");
                        %>
                        <option value="<%= authorId %>"><%= fullName %></option>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="genre">Genre:</label>
                    <input type="text" id="genre" name="genre" required placeholder="Enter Genre">
                </div>
                <div class="form-group">
                    <label for="language">Language:</label>
                    <input type="text" id="language" name="language" required placeholder="Enter Language">
                </div>
                <div class="form-group">
                    <label for="publication_year">Publication Year:</label>
                    <input type="number" id="publication_year" name="publication_year" required placeholder="Enter Publication Year" min="1900" max="2100">
                </div>
                <div class="form-group">
                    <label for="total_copies">Total Copies:</label>
                    <input type="number" id="total_copies" name="total_copies" required placeholder="Enter Total Copies" min="1">
                </div>
                <div class="form-group">
                    <label for="available_copies">Available Copies:</label>
                    <input type="number" id="available_copies" name="available_copies" required placeholder="Enter Available Copies" min="0">
                </div>
                <div class="form-group">
                    <label for="publisher_id">Publisher:</label>
                    <select id="publisher_id" name="publisher_id" required>
                        <option value="">Select Publisher</option>
                        <%
                            // Fetch publishers from the database
                            try {
                                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT publisher_id, Publication_name FROM publisher");

                                while (rs.next()) {
                                    String publisherId = rs.getString("publisher_id");
                                    String publisherName = rs.getString("Publication_name");
                        %>
                        <option value="<%= publisherId %>"><%= publisherName %></option>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="cancel-btn" style="background-color:rgb(19, 175, 58); color: white;">Add Book</button>
                    <button type="button" class="cancel-btn" onclick="closeAddBookModal()" style="background-color:rgb(201, 43, 43); color: white;">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <% if (session.getAttribute("error_message") != null) { %>
        <div class="alert alert-danger">
            <p><%= session.getAttribute("error_message") %></p>
            <button onclick="closeAlert()" class="close-alert">&times;</button>
        </div>
        <%
            // Clear the session attribute after displaying it
            session.removeAttribute("error_message");
        %>
    <% } %>
</body>
</html>