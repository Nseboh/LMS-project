<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Authors</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
    <script>
        function openAddAuthorModal() {
            const modal = document.getElementById('addAuthorModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/authors/addAuthor.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddAuthorModal() {
            document.getElementById('addAuthorModal').style.display = 'none';
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
                    <span>Staff</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/patron/patron.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item active">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/books/books.jsp'">
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
                <h1>Authors</h1>
            </header>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-pen-fancy"></i>
                        <h3>Registered Authors</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered authors
                            int totalAuthors = 0;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM authors");
                                if (rs.next()) {
                                    totalAuthors = rs.getInt("total");
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalAuthors);
                        %>
                    </p>
                </div>
            </div>

            <!-- Authors Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Authors Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Search Authors" class="search-input" />
                        <button class="search-btn" onclick="searchAuthors()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddAuthorModal()" class="add-new">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="authorsTable">
                        <thead>
                            <tr>
                                <th>Author ID</th>
                                <th>Name</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Fetch authors from the database
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT * FROM authors");

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='8'>No authors found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String authorId = rs.getString("author_id");
                                            String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                                            String biography = rs.getString("biography");
                            %>
                            <tr>
                                <td><%= authorId %></td>
                                <td><a href="biography.jsp?author_id=<%= authorId %>"><%= fullName %></a></td>
                                <td><%= rs.getDate("created_at") %></td>
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
                                    out.println("<tr><td colspan='8'>Error fetching authors: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Adding Author -->
    <div id="addAuthorModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

    <!-- Modal for Author Biography -->
    <div id="biographyModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeBiographyModal()">&times;</span>
            <div id="modalContent"></div>
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
    window.location.href = '<%= request.getContextPath() %>/views/authors/editAuthor.jsp?id=' + id;
}

function deleteAuthor(id) {
    if (confirm("Are you sure you want to delete this author?")) {
        window.location.href = '<%= request.getContextPath() %>/views/authors/deleteAuthor.jsp?id=' + id;
    }
}

function searchAuthors() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('authorsTable');
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
    const table = document.getElementById('authorsTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}

function fetchBiography(authorId) {
    fetch('biography.jsp?author_id=' + authorId)
        .then(response => response.text())
        .then(data => {
            // Assuming the biography.jsp returns the full HTML content
            document.getElementById('modalContent').innerHTML = data;
            document.getElementById('biographyModal').style.display = 'block';
        })
        .catch(error => console.error('Error fetching biography:', error));
}

function closeBiographyModal() {
    document.getElementById('biographyModal').style.display = 'none';
}
</script>
</body>
</html>
