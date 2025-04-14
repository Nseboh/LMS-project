<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        // Client-side form validation
        function validateForm() {
            // Validate staff ID format
            const staffId = document.getElementById('staffId').value;
            const staffIdPattern = /^STF-\d{7}$/;
            if (!staffIdPattern.test(staffId)) {
                alert('Staff ID must be in the format STF-XXXXXXX, where X is a digit.');
                return false;
            }

            // Additional validations can be added here

            return true; // Allow form submission if all validations pass
        }
    </script>
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddUserModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Staff</h1>
            <form id="addUserForm" action="<%= request.getContextPath() %>/views/superadmin/process_addStaff.jsp" method="POST" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="staffId">Staff ID*</label>
                    <input type="text" id="staffId" name="staffId" required>
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
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="contact">Contact*</label>
                    <input type="text" id="contact" name="contact" required>
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
                    <label for="role">Role*</label>
                    <select id="role" name="role" required>
                        <option value="Superadmin">Superadmin</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="cancel-btn" style="background-color:rgb(19, 175, 58); color:white;">Add Staff</button>
                    <button type="button" class="cancel-btn" onclick="closeAddUserModal()" style="background-color:rgb(201, 43, 43); color:white;">Cancel</button>
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