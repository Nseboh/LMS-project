<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %> <!-- Add this import for SQL classes -->
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Authors</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/authors.css"> <!-- Link to authors.css -->
    <script>
        function openAddAuthorModal() {
            const modal = document.getElementById('addAuthorModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/admin/authors/addAuthor.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddUserModal() {
            document.getElementById('addAuthorModal').style.display = 'none';
        }

        function editAuthor(id) {
            // Fetch existing author data (you can use AJAX to get this data)
            fetch('<%= request.getContextPath() %>/views/admin/authors/getAuthor.jsp?id=' + id)
                .then(response => response.json())
                .then(data => {
                    // Populate the modal fields with the existing data
                    document.getElementById('editAuthorId').value = data.author_id;
                    document.getElementById('editFirstName').value = data.first_name;
                    document.getElementById('editLastName').value = data.last_name;
                    document.getElementById('editEmail').value = data.email;
                    document.getElementById('editContact').value = data.contact;
                    document.getElementById('editNationality').value = data.nationality;
                    document.getElementById('editISBN').value = data.isbn;

                    // Show the modal
                    document.getElementById('editAuthorModal').style.display = 'block';
                });
        }

        function closeEditAuthorModal() {
            document.getElementById('editAuthorModal').style.display = 'none';
        }
    </script>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <div class="logo-img">
                    <img src="<%= request.getContextPath() %>/images/img%201.jpeg" alt="Logo" style="border-radius: 50%; width: 40px; height: 40px;">
                </div>
                <div class="logo-text">JE.Library</div>
            </div>
            <div class="sidebar-divider"></div>
            <nav class="sidebar-nav">
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/patron/patron.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item active">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/books/books.jsp'">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </div>
                <div class="nav-item"  onclick="window.location.href='<%= request.getContextPath() %>/views/admin/visitors/visitor.jsp'">
                    <i class="fas fa-walking"></i>
                    <span>Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/records/record.jsp'">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Records</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/attendance/attendance.jsp'">
                    <i class="fas fa-calendar-check"></i>
                    <span>Attendance</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/publishers/publisher.jsp'">
                    <i class="fas fa-building"></i>
                    <span>Publishers</span>
                </div>
                <div class="nav-item" onclick="window.location.href='issuedBooks.jsp'">
                    <i class="fas fa-book-open"></i>
                    <span>Issued Books</span>
                </div>
            </nav>
            <div class="settings">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
                <h1>Authors</h1>
            </header>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Register Authors</h3>
                    </div>
                    <p class="stat-number">
                    <%
                            // Fetch total registered authors excluding super admins
                            int totalAuthors = 0;
                            int maleAuthors = 0;
                            int femaleAuthors = 0;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM author");
                                if (rs.next()) {
                                    totalAuthors = rs.getInt("total");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS male FROM author WHERE gender = 'male'");
                                if (rs.next()) {
                                    maleAuthors = rs.getInt("male");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS female FROM author WHERE gender = 'female'");
                                if (rs.next()) {
                                    femaleAuthors = rs.getInt("female");
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalAuthors);
                        %>
                    </p>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-male"></i>
                        <h3>Male</h3>
                    </div>
                    <p class="stat-number"><%= maleAuthors %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-female"></i>
                        <h3>Female</h3>
                    </div>
                    <p class="stat-number"><%= femaleAuthors %></p>
                </div>
            </div>

            <!-- Authors Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Authors Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddAuthorModal()" class="add-new">Add New</button>
                    </div>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>AUTHOR ID</th>
                            <th>NAME</th>
                            <th>ISBN</th>
                            <th>NATIONALITY</th>
                            <th>EMAIL</th>
                            <th>CREATED AT</th>
                            <th>ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
                            <% 
                                // Fetch authors from the database 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT * FROM author");

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='7'>No author found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String authorId = rs.getString("author_id");
                                            String name = rs.getString("first_name") + " " + rs.getString("last_name");
                                            String isbn = rs.getString("isbn");
                                            String nationality = rs.getString("nationality");
                                            String email = rs.getString("email");
                                            java.sql.Date createdAt = rs.getDate("created_at"); // Specify java.sql.Date
                            %>
                            <tr>
                                <td><%= authorId %></td>
                                <td><%= name %></td>
                                <td><%= isbn %></td>
                                <td><%= nationality %></td>
                                <td><%= email %></td>
                                <td><%= createdAt %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editAuthor('<%= authorId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteAuthor('<%= authorId %>')">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                            <span class="tooltiptext">Delete</span>
                                    </div>
                                        </div>
                                        
                                </td>
                            </tr>
                            <% 
                                        }
                                    }
                                    conn.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<tr><td colspan='7'>Error fetching author: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    
                </table>
            </div>
        </main>
    </div>
    <!-- Modal for Adding User -->
    <div id="addAuthorModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>
    <!-- Modal for Editing Author -->
    <div id="editAuthorModal" class="modal" style="display:none;">
        <div id="modalContent" class="modal-content">
            <span class="close" onclick="closeEditAuthorModal()">&times;</span>
            <h1>Edit Author</h1>
            <form id="editAuthorForm" action="<%= request.getContextPath() %>/views/admin/authors/process_editAuthor.jsp" method="POST">
                <input type="hidden" name="author_id" id="editAuthorId">
                <div class="form-group">
                    <label for="editFirstName">First Name*</label>
                    <input type="text" id="editFirstName" name="first_name" required>
                </div>
                <div class="form-group">
                    <label for="editLastName">Last Name*</label>
                    <input type="text" id="editLastName" name="last_name" required>
                </div>
                <div class="form-group">
                    <label for="editEmail">Email*</label>
                    <input type="email" id="editEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="editNationality">Nationality*</label>
                    <input type="text" id="editNationality" name="nationality" required>
                </div>
                <div class="form-group">
                    <label for="editISBN">ISBN*</label>
                    <input type="text" id="editISBN" name="isbn" required>
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
    <script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}

function editAuthor(id) {
    // Fetch existing author data (you can use AJAX to get this data)
    fetch('<%= request.getContextPath() %>/views/authors/getAuthor.jsp?id=' + id)
        .then(response => response.json())
        .then(data => {
            // Populate the modal fields with the existing data
            document.getElementById('editAuthorId').value = data.author_id;
            document.getElementById('editFirstName').value = data.first_name;
            document.getElementById('editLastName').value = data.last_name;
            document.getElementById('editEmail').value = data.email;
            document.getElementById('editNationality').value = data.nationality;
            document.getElementById('editISBN').value = data.isbn;
            document.getElementById('editCreatedAt').value = data.created_at;

            // Show the modal
            document.getElementById('editAuthorModal').style.display = 'block';
        });
}

function deleteAuthor(id) {
    if (confirm("Are you sure you want to delete this author?")) {
        window.location.href = '<%= request.getContextPath() %>/views/admin/authors/deleteAuthor.jsp?id=' + id;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('authorTable');
    const tr = table.getElementsByTagName('tr');

    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = 'none';
        const td = tr[i].getElementsByTagName('td');
        for (let j = 0; j < td.length; j++) {
            if (td[j]) {
                if (td[j].innerHTML.toLowerCase().indexOf(input) > -1) {
                    tr[i].style.display = '';
                    break;
                }
            }
        }
    }
}

function resetTable() {
    const table = document.getElementById('authorTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}
</script>
<style>
/* Modal styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0,0.4);
    padding-top: 60px;
}

.modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* Modal Background */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1000; /* Sit on top */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgba(0, 0, 0, 0.7); /* Dark background with opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fff; /* White background */
    margin: 10% auto; /* Centered */
    padding: 20px;
    border-radius: 8px; /* Rounded corners */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Subtle shadow */
    width: 90%; /* Responsive width */
    max-width: 500px; /* Max width */
}

/* Close Button */
.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000; /* Change color on hover */
    text-decoration: none;
    cursor: pointer;
}

/* Form Container */
.form-container {
    display: flex;
    flex-direction: column; /* Stack elements vertically */
}

/* Form Elements */
.form-group {
    margin-bottom: 15px; /* Spacing for form groups */
}

label {
    margin-bottom: 5px; /* Spacing for labels */
    font-weight: bold; /* Bold labels */
    color: #333; /* Darker text color */
}

input[type="text"],
input[type="tel"],
input[type="email"],
select {
    padding: 10px; /* Padding for inputs */
    border: 1px solid #ccc; /* Light border */
    border-radius: 4px; /* Rounded corners */
    font-size: 16px; /* Font size */
    width: 100%; /* Full width */
    transition: border-color 0.3s; /* Smooth transition */
}

input[type="text"]:focus,
input[type="tel"]:focus,
input[type="email"]:focus,
select:focus {
    border-color: #007BFF; /* Blue border on focus */
    outline: none; /* Remove outline */
}

/* Buttons */
.submit-btn {
    background-color: #007BFF; /* Primary button color */
    color: white; /* Text color */
    padding: 10px; /* Padding */
    border: none; /* No border */
    border-radius: 4px; /* Rounded corners */
    cursor: pointer; /* Pointer cursor */
    font-size: 16px; /* Font size */
    transition: background-color 0.3s; /* Smooth transition */
    margin-top: 10px; /* Spacing above button */
}

.submit-btn:hover {
    background-color: #0056b3; /* Darker blue on hover */
}

.cancel-btn {
    background-color: #ccc; /* Gray color for cancel */
    color: black; /* Text color */
    padding: 10px; /* Padding */
    border: none; /* No border */
    border-radius: 4px; /* Rounded corners */
    cursor: pointer; /* Pointer cursor */
    font-size: 16px; /* Font size */
    margin-left: 10px; /* Spacing between buttons */
    margin-top: 10px; /* Spacing above button */
}

.cancel-btn:hover {
    background-color: #aaa; /* Darker gray on hover */
}
/* Button Styles */
    .search-btn, .back-btn {
        background-color: #007BFF; /* Primary button color */
        color: white; /* Text color */
        padding: 10px 15px; /* Padding */
        border: none; /* No border */
        border-radius: 4px; /* Rounded corners */
        cursor: pointer; /* Pointer cursor */
        font-size: 16px; /* Font size */
        transition: background-color 0.3s; /* Smooth transition */
        margin-top: 10px; /* Spacing above button */
        margin-right: 10px; /* Spacing between buttons */
    }

    .search-btn:hover, .back-btn:hover {
        background-color: #0056b3; /* Darker blue on hover */
    }

    .search-btn:focus, .back-btn:focus {
        outline: none; /* Remove outline */
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); /* Add shadow on focus */
    }
    .tooltip {
        position: relative;
        display: inline-block;
        cursor: pointer;
    }

    .tooltip .tooltiptext {
        visibility: hidden;
        width: 120px;
        background-color: black;
        color: #fff;
        text-align: center;
        border-radius: 6px;
        padding: 5px;
        position: absolute;
        z-index: 1;
        bottom: 125%; /* Position above the button */
        left: 50%;
        margin-left: -60px; /* Center the tooltip */
        opacity: 0; /* Hidden by default */
        transition: opacity 0.3s; /* Fade effect */
    }

    .tooltip:hover .tooltiptext {
        visibility: visible;
        opacity: 1; /* Show the tooltip */
    }
</style>
<%
    String successMessage = (String) session.getAttribute("success_message");
    String errorMessage = (String) session.getAttribute("error_message");
    if (successMessage != null) {
        out.println("<div class='alert alert-success'>" + successMessage + "</div>");
        session.removeAttribute("success_message");
    }
    if (errorMessage != null) {
        out.println("<div class='alert alert-danger'>" + errorMessage + "</div>");
        session.removeAttribute("error_message");
    }
%>
<% if (session.getAttribute("success_message") != null) { %>
    <div class="alert alert-success">
        <p><%= session.getAttribute("success_message") %></p>
        <button onclick="closeAlert()" class="close-alert">&times;</button>
    </div>
    <%
        session.removeAttribute("success_message");
    %>
<% } %>

<% if (session.getAttribute("error_message") != null) { %>
    <div class="alert alert-danger">
        <p><%= session.getAttribute("error_message") %></p>
        <button onclick="closeAlert()" class="close-alert">&times;</button>
    </div>
    <%
        session.removeAttribute("error_message");
    %>
<% } %>
</body>
</html>


