<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Publisher</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddPublisherModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Publisher</h1>
            <form id="addPublisherForm" action="<%= request.getContextPath() %>/views/publishers/process_addPublisher.jsp" method="POST">
                <div class="form-group">
                    <label for="name">Publication Name*</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="phone">Phone*</label>
                    <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" required>
                </div>
                <div class="form-group">
                    <label for="email">Email*</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="website">Website</label>
                    <input type="text" id="website" name="website">
                </div>
                <div class="form-actions">
                    <button type="submit" class="cancel-btn" style="background-color:rgb(19, 175, 58); color: white;">Add Publisher</button>
                    <button type="button" class="cancel-btn" onclick="closeAddPublisherModal()" style="background-color:rgb(201, 43, 43); color: white;">Cancel</button>
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