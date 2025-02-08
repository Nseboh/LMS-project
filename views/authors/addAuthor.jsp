<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Author</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddAuthorModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Author</h1>
            <form id="addAuthorForm" action="<%= request.getContextPath() %>/views/authors/process_addAuthor.jsp" method="POST" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="authorId">Author ID*</label>
                    <input type="text" id="authorId" name="author_id" required>
                </div>
                <div class="form-group">
                    <label for="firstName">First Name*</label>
                    <input type="text" id="firstName" name="first_name" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name*</label>
                    <input type="text" id="lastName" name="last_name" required>
                </div>
                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth*</label>
                    <input type="date" id="dateOfBirth" name="date_of_birth" required>
                </div>
                <div class="form-group">
                    <label for="nationality">Nationality*</label>
                    <input type="text" id="nationality" name="nationality" required>
                </div>
                <div class="form-group">
                    <label for="biography">Biography*</label>
                    <textarea id="biography" name="biography" rows="4" required></textarea>
                </div>
                <div class="form-group">
                    <label for="email">Email*</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="website">Website</label>
                    <input type="text" id="website" name="website">
                </div>
                <div class="form-group">
                    <label for="image_url">Author Photo</label>
                    <input type="file" id="image_url" name="image_url" accept="image/*" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Author</button>
                    <button type="button" class="cancel-btn" onclick="closeAddAuthorModal()">Cancel</button>
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