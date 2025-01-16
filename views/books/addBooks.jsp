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
            <form id="addBookForm" action="<%= request.getContextPath() %>/views/books/process_addBook.jsp" method="POST">
                <div class="form-group">
                    <label for="title">Title*</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-group">
                    <label for="authorId">Author*</label>
                    <select id="authorId" name="authorId" required>
                        <option value="">Select Author</option>
                        <%
                            // Fetch authors from the database
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT author_id, CONCAT(first_name, ' ', last_name) AS full_name FROM author");

                                while (rs.next()) {
                                    String authorId = rs.getString("author_id");
                                    String fullName = rs.getString("full_name");
                        %>
                        <option value="<%= authorId %>"><%= fullName %></option>
                        <%
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="publisherId">Publisher*</label>
                    <select id="publisherId" name="publisherId" required>
                        <option value="">Select Publisher</option>
                        <%
                            // Fetch publishers from the database
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT publisher_id, name FROM publisher");

                                while (rs.next()) {
                                    String publisherId = rs.getString("publisher_id");
                                    String publisherName = rs.getString("name");
                        %>
                        <option value="<%= publisherId %>"><%= publisherName %></option>
                        <%
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="isbn">ISBN*</label>
                    <input type="text" id="isbn" name="isbn" required>
                </div>
                <div class="form-group">
                    <label for="publicationYear">Publication Year*</label>
                    <input type="number" id="publicationYear" name="publicationYear" min="1900" max="2100" required>
                </div>
                <div class="form-group">
                    <label for="edition">Edition</label>
                    <input type="text" id="edition" name="edition">
                </div>
                <div class="form-group">
                    <label for="totalCopies">Total Copies*</label>
                    <input type="number" id="totalCopies" name="totalCopies" required min="1">
                </div>
                <div class="form-group">
                    <label for="copiesAvailable">Copies Available*</label>
                    <input type="number" id="copiesAvailable" name="copiesAvailable" required min="0">
                </div>
                <div class="form-group">
                    <label for="status">Status*</label>
                    <select id="status" name="status" required>
                        <option value="">Select Status</option>
                        <option value="active">Active</option>
                        <option value="archived">Archived</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Book</button>
                    <button type="button" class="cancel-btn" onclick="closeAddBookModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>