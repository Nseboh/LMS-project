<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Books</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
    <script>
        function openAddUserModal() {
            const modal = document.getElementById('addUserModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/books/addBooks.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddUserModal() {
            document.getElementById('addUserModal').style.display = 'none';
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/superadmin/superadminDashboard.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Staffs</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/patron/patron.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/authors/author.jsp'">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item active">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">
                    <i class="fas fa-walking"></i>
                    <span>Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/records/record.jsp'">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Records</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/attendance/attendance.jsp'">
                    <i class="fas fa-calendar-check"></i>
                    <span>Attendance</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/publishers/publisher.jsp'">
                    <i class="fas fa-building"></i>
                    <span>Publishers</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/issuedBooks/lending.jsp'">
                    <i class="fas fa-book-open"></i>
                    <span>Issued Books</span>
                </div>
            </nav>
            <div class="settings">
                <a href="<%= request.getContextPath() %>/views/logout.jsp">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
                <h1>Books</h1>
            </header>

           

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Registered Books</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered users excluding super admins
                            int totalBooks = 0;
                            
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM book");
                                if (rs.next()) {
                                    totalBooks = rs.getInt("total");
                                }
                                
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalBooks);
                        %>
                    </p>
                </div>
                
            </div>

            <!-- Users Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Books Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddUserModal()" class="add-new">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="booksTable">
                        <thead>
                            <tr>
                                <th>Book ID</th>
                                <th>Book Title</th>
                                <th>Author(s)</th>
                                <th>Genre/Category</th>
                                <th>Language</th>
                                <th>Total Copies</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Fetch books from the database
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT b.book_id, b.title, a.first_name, a.last_name, p.name AS publisher_name, b.isbn, b.publication_year, b.edition, b.total_copies, b.copies_available, b.status FROM book b LEFT JOIN author a ON b.author_id = a.author_id LEFT JOIN publisher  p ON b.publisher_id = p.publisher_id");

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='11'>No books found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String bookId = rs.getString("book_id");
                                            String title = rs.getString("title");
                                            String authorName = rs.getString("first_name") + " " + rs.getString("last_name");
                                            String publisherName = rs.getString("publisher_name");
                                            String isbn = rs.getString("isbn");
                                            String publicationYear = rs.getString("publication_year");
                                            String edition = rs.getString("edition");
                                            int totalCopies = rs.getInt("total_copies");
                                            int copiesAvailable = rs.getInt("copies_available");
                                            String status = rs.getString("status");
                            %>
                            <tr>
                                <td><%= bookId %></td>
                                <td><%= title %></td>
                                <td><%= authorName %></td>
                                <td><%= isbn %></td>
                                <td><%= publisherName %></td>
                                <td><%= publicationYear %></td>
                                <td><%= edition %></td>
                                <td><%= totalCopies %></td>
                                <td><%= copiesAvailable %></td>
                                <td><%= status %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editUser('<%= bookId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteUser('<%= bookId %>')">
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
                                    out.println("<tr><td colspan='11'>Error fetching books: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Adding book -->
    <div id="addUserModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

<script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}


function editPatron(id) {
    window.location.href = '<%= request.getContextPath() %>/views/books/editBooks.jsp?id=' + id;
}

function deletePatron(id) {
    if (confirm("Are you sure you want to delete this book?")) {
        window.location.href = '<%= request.getContextPath() %>/views/books/deleteBooks.jsp?id=' + id;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('bookTable');
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
    const table = document.getElementById('bookTable');
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
</style>
</body>
</html>
