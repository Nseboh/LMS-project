<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Visitors Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">   
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">    
 
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
    <script>
        function openAddUserModal() {
            const modal = document.getElementById('addUserModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/visitors/addVisitor.jsp')
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
                <div class="nav-item"  onclick="window.location.href='<%= request.getContextPath() %>/views/superadmin/superadminDashboard.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Staff</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/patron/patron.jsp'">
                    <i class="fas fa-users"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/authors/authors.jsp'">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/books/books.jsp'">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </div>
                <div class="nav-item active">
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
                <h1>Visitors</h1>
            </header>


            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Total Visitors</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered visitors
                            int totalVisitors = 0;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM visitor");
                                if (rs.next()) {
                                    totalVisitors = rs.getInt("total");
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalVisitors);
                        %>
                    </p>
                </div>
            </div>

            <!-- Visitors Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Visitors Table</h2>
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
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Created At</th>                                
                                <th>Time In</th>
                                <th>Time Out</th>
                                <th>Status</th>
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

                                    // Fetch all visitors with their visit details and status
                                    String sql = "SELECT v.visitor_id, v.first_name, v.last_name, v.created_at, " +
                                                 "vv.time_in, vv.time_out, vs.status " +
                                                 "FROM visitor v " +
                                                 "LEFT JOIN visitorvisit vv ON v.visitor_id = vv.visitor_id " +
                                                 "LEFT JOIN visitstatus vs ON v.visitor_id = vs.visitor_id";
                                    pstmt = conn.prepareStatement(sql);
                                    rs = pstmt.executeQuery();

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='10'>No visitors found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String visitorId = rs.getString("visitor_id");
                                            String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                                            Timestamp createdAt = rs.getTimestamp("created_at");
                                            Time timeIn = rs.getTime("time_in");
                                            Time timeOut = rs.getTime("time_out");
                                            String status = rs.getString("status");
                                %>
                                <tr>
                                    <td><%= visitorId %></td>
                                    <td><a href="<%= request.getContextPath() %>/views/visitors/visitorDetails.jsp?id=<%= visitorId %>"><%= fullName %></a></td>
                                    <td><%= createdAt != null ? createdAt.toString() : "N/A" %></td>
                                    <td><%= timeIn != null ? timeIn.toString() : "N/A" %></td>
                                    <td><%= timeOut != null ? timeOut.toString() : "N/A" %></td>
                                    <td><%= status != null ? status : "N/A" %></td>
                                    <td>
                                        <div class="actions">
                                            <div class="tooltip">
                                                <button class="action-btn edit-btn" onclick="editUser('<%= visitorId %>')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <span class="tooltiptext">Edit</span>
                                            </div>
                                            
                                            <div class="tooltip">
                                                <button class="action-btn delete-btn" onclick="deleteUser('<%= visitorId %>')">
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
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<tr><td colspan='10'>Error fetching visitors: " + e.getMessage() + "</td></tr>");
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
    

    <!-- Modal for Adding User -->
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

function editUser(id) {
    window.location.href = '<%= request.getContextPath() %>/views/visitors/editVisitor.jsp?id=' + id;
}

function deleteUser(id) {
    if (confirm("Are you sure you want to delete this visitor?")) {
        window.location.href = '<%= request.getContextPath() %>/views/visitors/deleteVisitor.jsp?id=' + id;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('usersTable');
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
    const table = document.getElementById('usersTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}
</script>
</body>
</html>
