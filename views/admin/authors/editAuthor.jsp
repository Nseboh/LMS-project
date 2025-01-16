<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Author</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/authors.css">
    <script>
        function closeEditAuthorModal() {
            document.getElementById('editAuthorModal').style.display = 'none';
        }

        function fetchAuthorData(id) {
            fetch('<%= request.getContextPath() %>/views/admin/authors/getAuthor.jsp?id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('editAuthorId').value = data.author_id;
                    document.getElementById('editFirstName').value = data.first_name;
                    document.getElementById('editLastName').value = data.last_name;
                    document.getElementById('editISBN').value = data.isbn;
                    document.getElementById('editNationality').value = data.nationality;
                    document.getElementById('editEmail').value = data.email;
                    document.getElementById('editCreatedAt').value = data.created_at;

                    document.getElementById('editAuthorModal').style.display = 'block';
                });
        }
    </script>
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeEditAuthorModal()">&times;</span>
        <div class="form-container">
            <h1>Edit Author</h1>
            <form id="editAuthorForm" action="<%= request.getContextPath() %>/views/admin/authors/process_editAuthor.jsp" method="POST">
                <div class="form-group">
                    <label for="editAuthorId">Author ID*</label>
                    <input type="text" id="editAuthorId" name="author_id" required>
                </div>
                <div class="form-group">
                    <label for="editFirstName">First Name*</label>
                    <input type="text" id="editFirstName" name="first_name" required>
                </div>
                <div class="form-group">
                    <label for="editLastName">Last Name*</label>
                    <input type="text" id="editLastName" name="last_name" required>
                </div>
                <div class="form-group">
                    <label for="editISBN">ISBN*</label>
                    <input type="text" id="editISBN" name="isbn" required>
                </div>
                <div class="form-group">
                    <label for="editNationality">Nationality*</label>
                    <input type="text" id="editNationality" name="nationality" required>
                </div>
                <div class="form-group">
                    <label for="editEmail">Email*</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editCreatedAt">Created At*</label>
                    <input type="text" id="editCreatedAt" name="created_at" readonly>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Save Changes</button>
                    <button type="button" class="cancel-btn" onclick="closeEditAuthorModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <div class="logout" onclick="window.location.href='<%= request.getContextPath() %>/login.jsp'">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
    </div>
</body>
</html> 