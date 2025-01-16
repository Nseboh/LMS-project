<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Visitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddVisitorModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Visitor</h1>
            <form id="addVisitorForm" action="<%= request.getContextPath() %>/views/visitors/process_addVisitor.jsp" method="POST">
                <div class="form-group">
                    <label for="fullName">Full Name*</label>
                    <input type="text" id="fullName" name="fullName" required>
                </div>
                <div class="form-group">
                    <label for="contactNumber">Contact Number*</label>
                    <input type="text" id="contactNumber" name="contactNumber" required>
                </div>
                <div class="form-group">
                    <label for="email">Email*</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="gender">Gender*</label>
                    <select id="gender" name="gender" required>
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="timeOut">Time Out (when leaving the library)</label>
                    <input type="time" id="timeOut" name="timeOut">
                </div>
                <div class="form-group">
                    <label for="status">Status*</label>
                    <select id="status" name="status" required>
                        <option value="General Inquiry">General Inquiry</option>
                        <option value="Research">Research</option>
                        <option value="Book Borrowing">Book Borrowing</option>
                        <option value="Book Return">Book Return</option>
                        <option value="Event">Event</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Visitor</button>
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
</body>
</html> 