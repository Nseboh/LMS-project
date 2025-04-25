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
    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
   
    <script>
        function openAddPatronModal() {
            const modal = document.getElementById('addPatronModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/patron/addPatron.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddPatronModal() {
            document.getElementById('addPatronModal').style.display = 'none';
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
                <div class="nav-item"  onclick="window.location.href='<%= request.getContextPath() %>/views/superadmin/superadminDashboard.jsp'">
                    <i class="fas fa-users" style="color:white"></i>
                    <span style="color:white">Staff</span>
                </div>
                <div class="nav-item active" style="color: #000000; background-color: #ffffff;">
                    <i class="fas fa-users" style="color: #000000; background-color: #ffffff;"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/authors/author.jsp'">
                    <i class="fas fa-pen-fancy" style="color:white"></i>
                    <span style="color:white">Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/books/books.jsp'">
                    <i class="fas fa-book" style="color:white"></i>
                    <span style="color:white">Books</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">
                    <i class="fas fa-walking" style="color:white"></i>
                    <span style="color:white">Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/records/record.jsp'">
                    <i class="fas fa-clipboard-list" style="color:white"></i>
                    <span style="color:white">Records</span>
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
                <h1>Patrons</h1>
            </header>

            <!-- Success Message -->
            <% if (session.getAttribute("success_message") != null) { %>
                <div class="alert alert-success">
                    <p><%= session.getAttribute("success_message") %></p>
                    <p>Generated Password: <%= session.getAttribute("generated_password") %></p>
                    <p>Barcode: <%= session.getAttribute("generated_barcode") %></p>
                    <div class="barcode-container">
                        <svg id="barcode"></svg>
                    </div>
                    <button onclick="closeAlert()" class="close-alert">&times;</button>
                </div>
                <script>
                    // Generate barcode
                    JsBarcode("#barcode", "<%= session.getAttribute("generated_barcode") %>", {
                        format: "CODE128",
                        width: 2,
                        height: 100,
                        displayValue: true
                    });
                </script>
                <%
                    // Clear the session attributes
                    session.removeAttribute("success_message");
                    session.removeAttribute("generated_password");
                    session.removeAttribute("generated_barcode");
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
                            int expiredUsers = 0;
                            int maleUsers = 0;
                            int femaleUsers = 0;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM patron");
                                if (rs.next()) {
                                    totalUsers = rs.getInt("total");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS expired FROM patronmembership WHERE expiration_date < CURDATE()");
                                if (rs.next()) {
                                    expiredUsers = rs.getInt("expired");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS male_count FROM patron WHERE gender = 'Male'");
                                if (rs.next()) {
                                    maleUsers = rs.getInt("male_count");
                                }
                                rs = stmt.executeQuery("SELECT COUNT(*) AS female_count FROM patron WHERE gender = 'Female'");
                                if (rs.next()) {
                                    femaleUsers = rs.getInt("female_count");
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
                        <i class="fas fa-clock" style="color:rgb(10, 18, 121);"></i>
                        <h3>Expired</h3>
                    </div>
                    <p class="stat-number"><%= expiredUsers %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
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
                        <h2>Patron Table</h2>
                    </div>
                   <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()" style="background-color:rgb(19, 175, 58); margin-left:30px;">Search</button>
                        <button class="back-btn" onclick="resetTable()" style="background-color:rgb(201, 43, 43);">Cancel</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddPatronModal()" class="add-new" style="background-color:rgb(10, 18, 121);">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="patronTable">
                        <thead>
                            <tr>
                                <th>Patron ID</th>
                                <th>Name</th>
                                <th>Date Joined</th>
                                <th>Expiration Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    String sql = "SELECT p.patron_id, p.first_name, p.last_name, pm.date_joined, pm.expiration_date, pm.status, p.barcode, pc.phone " +
                                                 "FROM patron p " +
                                                 "LEFT JOIN patronmembership pm ON p.patron_id = pm.patron_id " +
                                                 "LEFT JOIN patroncontact pc ON p.patron_id = pc.patron_id";
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery(sql);

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='10'>No patrons found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String patronId = rs.getString("patron_id");
                                            String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                                            Date dateJoined = rs.getDate("date_joined");
                                            Date expirationDate = rs.getDate("expiration_date");
                                            String status = rs.getString("status");
                                            String contact = rs.getString("phone");
                                            String barcode = rs.getString("barcode");

                                            // Calculate days left
                                            long daysLeft = (expirationDate != null) ? ChronoUnit.DAYS.between(LocalDate.now(), expirationDate.toLocalDate()) : -1;
                            %>
                            <tr>
                                <td><%= patronId %></td>
                                <td><a href="<%= request.getContextPath() %>/views/patron/patronDetails.jsp?id=<%= patronId %>"><%= fullName %></a></td>
                                <td><%= dateJoined != null ? dateJoined.toString() : "N/A" %></td>
                                <td><%= expirationDate != null ? expirationDate.toString() : "N/A" %></td>
                                <td><%= status %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn view-btn" onclick="viewPatron('<%= patronId %>', '<%= fullName %>', '<%= contact %>', '<%= barcode %>')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <span class="tooltiptext">View</span>
                                        </div>
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editPatron('<%= patronId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deletePatron('<%= patronId %>')">
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
                                    out.println("<tr><td colspan='10'>Error fetching patrons: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Viewing User Details -->
    <div id="viewPatronModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2 id="modalLibraryName">JE.Library</h2>
            <p id="modalUserName"></p>
            <p id="modalUserContact"></p>
            <p id="modalUserBarcode"></p>
            <div class="barcode-container">
                <svg id="modalBarcode"></svg>
            </div>
        </div>
    </div>

    <!-- Modal for Adding User -->
    <div id="addPatronModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

<script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}

function viewPatron(patronId, fullName, contact, barcode) {
    document.getElementById('modalUserName').innerText = "User: " + fullName;
    document.getElementById('modalUserContact').innerText = "Contact: " + contact;
    document.getElementById('modalUserBarcode').innerText = "Barcode: " + barcode;
    JsBarcode("#modalBarcode", barcode, {
        format: "CODE128",
        width: 2,
        height: 100,
        displayValue: true
    });
    document.getElementById('viewPatronModal').style.display = 'block';
}

function closeModal() {
    document.getElementById('viewPatronModal').style.display = 'none';
}

function editPatron(id) {
    window.location.href = '<%= request.getContextPath() %>/views/patron/editPatron.jsp?id=' + id;
}

function deletePatron(id) {
    if (confirm("Are you sure you want to delete this patron?")) {
        window.location.href = '<%= request.getContextPath() %>/views/patron/deletePatron.jsp?id=' + id;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('patronTable');
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
    const table = document.getElementById('patronTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}
</script>
</body>
</html>
