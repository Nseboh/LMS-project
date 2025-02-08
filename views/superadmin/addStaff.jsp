<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddUserModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Staff</h1>
            <form id="addUserForm" action="<%= request.getContextPath() %>/views/superadmin/process_addStaff.jsp" method="POST">
                <div class="form-group">
                    <label for="staff_id">Staff ID*</label>
                    <input type="text" id="staff_id" name="staff_id" required>
                </div>
                <div class="form-group">
                    <label for="first_name">First Name*</label>
                    <input type="text" id="first_name" name="first_name" required>
                </div>
                <div class="form-group">
                    <label for="last_name">Last Name*</label>
                    <input type="text" id="last_name" name="last_name" required>
                </div>
                <div class="form-group">
                    <label for="gender">Gender*</label>
                    <select id="gender" name="gender" required>
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Others">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="contact">Contact*</label>
                    <input type="tel" id="contact" name="contact" pattern="[0-9]{10}" required>
                </div>
                <div class="form-group">
                    <label for="email">Email*</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="address">Address*</label>
                    <input type="text" id="address" name="address" required>
                </div>
                <div class="form-group">
                    <label for="status">Status*</label>
                    <select id="status" name="status" required>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="role_name">Role*</label>
                    <select id="role_name" name="role_name" required>
                        <option value="">Select Role</option>
                        <option value="Superadmin">Superadmin</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Staff</button>
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