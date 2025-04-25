<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Patron</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddPatronModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Patron</h1>
            <form id="addUserForm" action="<%= request.getContextPath() %>/views/patron/process_addPatron.jsp" method="POST">
                <div class="form-group">
                    <label for="patronId">Patron ID*</label>
                    <input type="text" id="patronId" name="patronId" required>
                </div>
                <div class="form-group">
                    <label for="firstName">First Name*</label>
                    <input type="text" id="firstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name*</label>
                    <input type="text" id="lastName" name="lastName" required>
                </div>
                <div class="form-group">
                    <label for="gender">Gender*</label>
                    <select id="gender" name="gender" required>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="address">Address*</label>
                    <input type="text" id="address" name="address" required>
                </div>
                <div class="form-group">
                    <label for="phone">Phone*</label>
                    <input type="tel" id="phone" name="phone" pattern="[0-9]{10}" required>
                </div>
                <div class="form-group">
                    <label for="dateJoined">Date Joined*</label>
                    <input type="date" id="dateJoined" name="dateJoined" required>
                </div>
                <div class="form-group">
                    <label for="status">Status*</label>
                    <select id="status" name="status" required>
                        <option value="Active">Active</option>
                        <option value="Expired">Expired</option>
                        <option value="Canceled">Canceled</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="cancel-btn" style="background-color:rgb(19, 175, 58); color: white;">Add Patron</button>
                    <button type="button" class="cancel-btn" onclick="closeAddPatronModal()" style="background-color:rgb(201, 43, 43); color:white;">Cancel</button>
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