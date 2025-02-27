<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Author</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        // Client-side form validation
        function validateForm() {
            // Validate required text fields
            const requiredFields = ['authorId', 'firstName', 'lastName', 'dateOfBirth', 'nationality', 'biography', 'email'];
            for (let field of requiredFields) {
                if (document.getElementById(field).value.trim() === '') {
                    alert(field.replace(/([A-Z])/g, ' $1') + ' is required.');
                    return false;
                }
            }

            // Validate email format
            const email = document.getElementById('email').value;
            const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (!emailPattern.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }

            return true; // Allow form submission if all validations pass
        }
    </script>
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddAuthorModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Author</h1>
            <form id="addAuthorForm" action="<%= request.getContextPath() %>/views/authors/process_addAuthor.jsp" method="POST" enctype="multipart/form-data" onsubmit="return validateForm()">
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
                    <input type="url" id="website" name="website">
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Add Author</button>
                    <button type="button" class="cancel-btn" onclick="closeAddAuthorModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <%-- Display error message if present in session --%>
    <% if (session.getAttribute("error_message") != null) { %>
        <div class="alert alert-danger">
            <p><%= session.getAttribute("error_message") %></p>
            <button onclick="closeAlert()" class="close-alert">&times;</button>
        </div>
        <%-- Clear the session attribute after displaying it --%>
        <%
            session.removeAttribute("error_message");
        %>
    <% } %>
</body>
</html>