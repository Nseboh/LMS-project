<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Takoradi Library - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
    
    <script>
        function openAddUserModal() {
            const modal = document.getElementById('addUserModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/superadmin/addStaff.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddUserModal() {
            document.getElementById('addUserModal').style.display = 'none';
        }

        function showModal(message) {
            const modal = document.getElementById('successModal');
            const modalMessage = document.getElementById('modalMessage');
            modalMessage.innerText = message;
            modal.style.display = 'block';
        }

        function closeModal() {
            document.getElementById('successModal').style.display = 'none';
        }

        function openModal(message, password) {
            const modal = document.getElementById('successModal');
            const modalMessage = document.getElementById('modalMessage');
            const modalPassword = document.getElementById('passwordMessage');
            modalMessage.innerText = message;
            modalPassword.innerText = password;
            modal.style.display = 'block';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
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
                <div class="logo-text" style="color: white;">Takoradi Library</div>
            </div>
            <div class="sidebar-divider"></div>
            <nav class="sidebar-nav">
                <div class="nav-item active" style="color: #000000; background-color: #ffffff;">
                    <i class="fas fa-users" style="color: #000000;"></i>
                    <span>Staff</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/patron/patron.jsp'">
                    <i class="fas fa-users" style="color:white"></i>
                    <span style="color:white">Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/authors/author.jsp'">
                    <i class="fas fa-pen-fancy" style="color:white"></i>
                    <span style="color:white">Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/books/books.jsp'">
                    <i class="fas fa-book" style="color:white"></i>
                    <span style="color:white">Books</span>
                </div>
                <div class="nav-item"  onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">
                    <i class="fas fa-walking" style="color:white"></i>
                    <span style="color:white">Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/records/record.jsp'">
                    <i class="fas fa-clipboard-list" style="color:white"></i>
                    <span style="color:white" style="color:white">Records</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/attendance/attendance.jsp'">
                    <i class="fas fa-calendar-check" style="color:white"></i>
                    <span style="color:white">Attendance</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/publishers/publisher.jsp'">
                    <i class="fas fa-building" style="color:white"></i>
                    <span style="color:white">Publishers</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/issuedBooks/lending.jsp'">
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
                <h1>Staff</h1>
            </header>

            <!-- Success Message -->
            <% if (session.getAttribute("success_message") != null) { %>
                <div class="alert alert-success">
                    <p><%= session.getAttribute("success_message") %></p>
                    <p>Generated Password: <%= session.getAttribute("generated_password") %></p>
                    <button onclick="closeAlert()" class="close-alert">&times;</button>
                </div>
                
                <%
                    // Clear the session attributes
                    session.removeAttribute("success_message");
                    session.removeAttribute("generated_password");
                %>
            <% } %>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus" style="color:rgb(10, 18, 121);"></i>
                        <h3>Registered Staff</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered Staff
                            int totalUsers = 0;
                            int maleUsers = 0;
                            int femaleUsers = 0;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM staff");
                                if (rs.next()) {
                                    totalUsers = rs.getInt("total");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS male FROM staff WHERE gender = 'Male'");
                                if (rs.next()) {
                                    maleUsers = rs.getInt("Male");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS female FROM staff WHERE gender = 'Female'");
                                if (rs.next()) {
                                    femaleUsers = rs.getInt("Female");
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalUsers);
                        %>
                    </p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
<<<<<<< HEAD
=======
                        <i class="fas fa-clock" style="color:rgb(10, 18, 121);"></i>
                        <h3>Expired</h3>
                    </div>
                    <p class="stat-number"><%= expiredUsers %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
>>>>>>> c14cda1afc916844b2cae7947702a41da15cee12
                        <i class="fas fa-male" style="color:rgb(10, 18, 121);"></i>
                        <h3>Male</h3>
                    </div>
                    <p class="stat-number"><%= maleUsers %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-female" style="color:rgb(10, 18, 121);"></i>
                        <h3>Female</h3>
                    </div>
                    <p class="stat-number"><%= femaleUsers %></p>
                </div>
            </div>

            <!-- Users Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Staffs Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Search Staff" class="search-input" />
                        <button class="search-btn" onclick="searchStaffs()" style="background-color:rgb(19, 175, 58); margin-left:30px;">Search</button>
                        <button class="back-btn" onclick="resetTable()" style="background-color:rgb(201, 43, 43);">Cancel</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddUserModal()" class="add-new" style="background-color:rgb(10, 18, 121);">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>Staff ID</th>
                                <th>Name</th>
                                <th>Gender</th>
                                <th>Contact</th>
                                <th>Email</th>
                                <th>Address</th>
                                <th>Status</th>
                                <th>Role</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // Database connection
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    stmt = conn.createStatement();
                                    String sql = "SELECT s.staff_id, CONCAT(s.first_name, ' ', s.last_name) AS full_name, s.gender, sc.contact, sc.email, sc.address, ss.status, sr.role_name, s.created_at, s.password " +
                                                 "FROM staff s " +
                                                 "LEFT JOIN staff_contact sc ON s.staff_id = sc.staff_id " +
                                                 "LEFT JOIN staff_status ss ON s.staff_id = ss.staff_id " +
                                                 "LEFT JOIN staffrole sr ON s.staff_id = sr.staff_id";
                                    rs = stmt.executeQuery(sql);

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='11'>No staff found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String staffId = rs.getString("staff_id");
                                            String fullName = rs.getString("full_name");
                                            String gender = rs.getString("gender");
                                            String contact = rs.getString("contact");
                                            String email = rs.getString("email");
                                            String address = rs.getString("address");
                                            String status = rs.getString("status");
                                            String roleName = rs.getString("role_name");
                                            Timestamp createdAt = rs.getTimestamp("created_at");
                            %>
                            <tr>
                                <td><%= staffId %></td>
                                <td><%= fullName %></td>
                                <td><%= gender %></td>
                                <td><%= contact %></td>
                                <td><%= email %></td>
                                <td><%= address %></td>
                                <td><%= status %></td>
                                <td><%= roleName %></td>
                                <td><%= createdAt != null ? createdAt.toString() : "N/A" %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn view-btn" onclick="viewPassword('<%= rs.getString("password") %>')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <span class="tooltiptext">View</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editUser('<%= staffId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteUser('<%= staffId %>')">
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
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                    out.println("<tr><td colspan='11'>Error fetching staffs: " + e.getMessage() + "</td></tr>");
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Success and Error Messages -->
    <%
        String deleteSuccessMessage = (String) session.getAttribute("delete_success_message");
        String deleteErrorMessage = (String) session.getAttribute("delete_error_message");

        if (deleteSuccessMessage != null) {
    %>
        <script>
            showModal("<%= deleteSuccessMessage %>");
        </script>
    <%
            session.removeAttribute("delete_success_message");
        }
        if (deleteErrorMessage != null) {
    %>
        <script>
            showModal("<%= deleteErrorMessage %>");
        </script>
    <%
            session.removeAttribute("delete_error_message");
        }
    %>

    <!-- Modal for Adding User -->
    <div id="addUserModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

    <!-- Modal for Displaying Password -->
    <div id="passwordModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closePasswordModal()">&times;</span>
            <h2>Password</h2>
            <p id="passwordMessage"></p>
        </div>
    </div>

    <!-- Modal for Success Message -->
    <div id="successModal" class="modal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2><i class="fas fa-check-circle"></i> Success</h2>
            <p id="modalMessage"></p>
        </div>
    </div>

<script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}

function editUser(id) {
    window.location.href = '<%= request.getContextPath() %>/views/superadmin/editStaff.jsp?id=' + id;
}

function deleteUser(id) {
    if (confirm("Are you sure you want to delete this staff?")) {
        window.location.href = '<%= request.getContextPath() %>/views/superadmin/deleteStaff.jsp?id=' + id;
    }
}

function searchStaffs() {
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

function viewPassword(password) {
    const modal = document.getElementById('passwordModal');
    const passwordMessage = document.getElementById('passwordMessage');
    passwordMessage.innerText = password;
    modal.style.display = 'block';
}

// Close the modal when clicking outside of it
window.onclick = function(event) {
    const modal = document.getElementById('passwordModal');
    if (event.target == modal) {
        closePasswordModal();
    }
}
</script>
</body>
</html>
