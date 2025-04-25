<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Takoradi Library - Publishers</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
    <script>
        function openAddPublisherModal() {
            const modal = document.getElementById('addPublisherModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/publishers/addPublisher.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddPublisherModal() {
            document.getElementById('addPublisherModal').style.display = 'none';
        }
    </script>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar" style="background-color: #070D59;">
            <div class="logo">
                <div class="logo-img">
                    <img src="<%= request.getContextPath() %>/images/TakoradiLibrary.jpeg" alt="Logo" style="border-radius: 50%; width: 40px; height: 40px;">
                </div>
                <div class="logo-text" style="color:white">Takoradi Library</div>
            </div>
            <div class="sidebar-divider"></div>
            <nav class="sidebar-nav">
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/patron/patron.jsp'">
                    <i class="fas fa-users" style="color:white"></i>
                    <span style="color:white">Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/authors/author.jsp'">
                    <i class="fas fa-pen-fancy" style="color:white"></i>
                    <span style="color:white">Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/books/books.jsp'">
                    <i class="fas fa-book" style="color:white"></i>
                    <span style="color:white">Books</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/visitors/visitor.jsp'">
                    <i class="fas fa-walking" style="color:white"></i>
                    <span style="color:white">Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/records/record.jsp'">
                    <i class="fas fa-clipboard-list" style="color:white"></i>
                    <span style="color:white">Records</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/attendance/attendance.jsp'">
                    <i class="fas fa-calendar-check" style="color:white"></i>
                    <span style="color:white">Attendance</span>
                </div>
                <div class="nav-item active" style="color: #000000; background-color: #ffffff;">
                    <i class="fas fa-building" style="color: #000000; background-color: #ffffff;"></i>
                    <span>Publishers</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/issuedBooks/lending.jsp'">
                    <i class="fas fa-book-open" style="color:white"></i>
                    <span style="color:white">Issued Books</span>
                </div>
            </nav>
            <div class="settings">
                <a href="<%= request.getContextPath() %>/views/logout.jsp">
                    <i class="fas fa-sign-out-alt" style="color:white"></i>
                    <span style="color:white">Logout</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header" style="background-color:rgb(10, 18, 121);">
                <h1>Publishers</h1>
            </header>

            

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-building" style="color:rgb(10, 18, 121);"></i>
                        <h3>Registered Publishers</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered users excluding super admins
                            int totalUsers = 0;
                            
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM publisher");
                                if (rs.next()) {
                                    totalUsers = rs.getInt("total");
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalUsers);
                        %>
                    </p>
                </div>
                
            </div>

            <!-- Users Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Publishers  Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Search Staffs" class="search-input" />
                        <button class="search-btn" onclick="searchStaffs()" style="background-color:rgb(19, 175, 58); margin-left:30px;">Search</button>
                        <button class="back-btn" onclick="resetTable()" style="background-color:rgb(201, 43, 43);">Cancel</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddPublisherModal()" class="add-new" style="background-color:rgb(10, 18, 121);">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="publishersTable">
                        <thead>
                            <tr>
                                <th>Publication Name</th>
                                <th>Phone</th>
                                <th>Email</th>
                                <th>Website</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                PreparedStatement pstmt = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

                                    // Fetch all publishers with their contact details
                                    String sql = "SELECT p.publisher_id, p.Publication_name, p.created_at, " +
                                                 "c.phone, c.email, c.website " +
                                                 "FROM publisher p " +
                                                 "LEFT JOIN publishercontact c ON p.publisher_id = c.publisher_id";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='8'>No publishers found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            int publisherId = rs.getInt("publisher_id");
                                            String PublicationName = rs.getString("Publication_name");
                                            Timestamp createdAt = rs.getTimestamp("created_at");
                                            String phone = rs.getString("phone");
                                            String email = rs.getString("email");
                                            String website = rs.getString("website");
                            %>
                            <tr>
                                <td><%= PublicationName %></td>
                                <td><%= phone != null ? phone : "N/A" %></td>
                                <td><%= email != null ? email : "N/A" %></td>
                                <td><%= website != null ? website : "N/A" %></td>
                                <td><%= createdAt != null ? createdAt.toString() : "N/A" %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editPublisher('<%= publisherId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deletePublisher('<%= publisherId %>')">
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
                                } catch (SQLException sqlEx) {
                                    sqlEx.printStackTrace();
                                    out.println("<tr><td colspan='8'>Error fetching publishers: " + sqlEx.getMessage() + "</td></tr>");
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<tr><td colspan='8'>An unexpected error occurred: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Adding Publisher -->
    <div id="addPublisherModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

<script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}

function editPublisher(id) {
    window.location.href = '<%= request.getContextPath() %>/views/publishers/editPublisher.jsp?id=' + id;
}

function deletePublisher(id) {
    if (confirm("Are you sure you want to delete this publisher?")) {
        window.location.href = '<%= request.getContextPath() %>/views/publishers/deletePublisher.jsp?id=' + id;
    }
}

function searchStaffs() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('publishersTable');
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
    const table = document.getElementById('publishersTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}
</script>
</body>
</html>
