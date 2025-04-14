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
            const requiredFields = ['authorId', 'firstName', 'lastName', 'dateOfBirth', 'nationality', 'biography'];
            for (let field of requiredFields) {
                const input = document.getElementById(field);
                if (!input || input.value.trim() === '') {
                    alert(field.replace(/([A-Z])/g, ' $1') + ' is required.');
                    return false;
                }
            }

            // Validate author ID format (optional)
            const authorId = document.getElementById('authorId').value.trim();
            if (!authorId.match(/^AUTH[0-9]{4}$/)) {
                alert('Author ID must be in format AUTH followed by 4 digits (e.g., AUTH0001)');
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
            <form id="addAuthorForm" action="<%= request.getContextPath() %>/views/authors/process_addAuthor.jsp" method="POST" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="authorId">Author ID* (Format: AUTH0001)</label>
                    <input type="text" id="authorId" name="author_id" pattern="AUTH[0-9]{4}" required>
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
                    <label for="website">Website (Optional)</label>
                    <input type="url" id="website" name="website">
                </div>
                <div class="form-actions">
                    <button type="submit" class="cancel-btn" style="background-color:rgb(19, 175, 58); color: white;">Add Author</button>
                    <button type="button" class="cancel-btn" onclick="closeAddAuthorModal()" style="background-color:rgb(201, 43, 43); color: white;">Cancel</button>
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