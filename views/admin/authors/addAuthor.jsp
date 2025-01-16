<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Author</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/authors.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddUserModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Author</h1>
            <form id="addUserForm" action="<%= request.getContextPath() %>/views/admin/authors/process_addAuthor.jsp" method="POST">
                <div class="form-group">
                    <label for="author_id">Author ID*</label>
                    <input type="text" id="author_id" name="author_id" required>
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
                    <label for="isbn">ISBN*</label>
                    <input type="text" id="isbn" name="isbn" required>
                </div>
                <div class="form-group">
                    <label for="nationality">Nationality*</label>
                    <input type="text" id="nationality" name="nationality" required>
                </div>
                <div class="form-group">
                    <label for="email">Email*</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="created_at">Created At*</label>
                    <input type="text" id="created_at" name="created_at" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %>" readonly>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Author</button>
                    <button type="button" class="cancel-btn" onclick="closeAddUserModal()">Cancel</button>
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
    <div class="logout" onclick="window.location.href='<%= request.getContextPath() %>/login.jsp'">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
    </div>
</body>
</html>