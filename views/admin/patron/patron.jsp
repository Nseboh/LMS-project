<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
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
       <div class="sidebar">
            <div class="logo">
                <div class="logo-img">
                    <img src="<%= request.getContextPath() %>/images/img%201.jpeg" alt="Logo" style="border-radius: 50%; width: 40px; height: 40px;">
                </div>
                <div class="logo-text">JE.Library</div>
            </div>
            <div class="sidebar-divider"></div>
            <nav class="sidebar-nav">
                <div class="nav-item active">
                    <i class="fas fa-users"></i>
                    <span>Patrons</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/authors/authors.jsp'">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/books/books.jsp'">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/visitors/visitor.jsp'">
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
                <a href="<%= request.getContextPath() %>/views/logout.jsp">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
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
                        <i class="fas fa-user-plus"></i>
                        <h3>Registered Patrons</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered users excluding super admins
                            int totalUsers = 0;
                            int expiredUsers = 0;
                            int maleUsers = 0;
                            int femaleUsers = 0;
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                
                                // Count total patrons
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM patron");
                                if (rs.next()) {
                                    totalUsers = rs.getInt("total");
                                }

                                // Count expired patrons
                                rs = stmt.executeQuery("SELECT COUNT(*) AS expired FROM patron WHERE expiration_date < CURDATE()");
                                if (rs.next()) {
                                    expiredUsers = rs.getInt("expired");
                                }

                                // Count male patrons
                                rs = stmt.executeQuery("SELECT COUNT(*) AS male FROM patron WHERE gender = 'Male'");
                                if (rs.next()) {
                                    maleUsers = rs.getInt("male");
                                }

                                // Count female patrons
                                rs = stmt.executeQuery("SELECT COUNT(*) AS female FROM patron WHERE gender = 'Female'");
                                if (rs.next()) {
                                    femaleUsers = rs.getInt("female");
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
                        <i class="fas fa-clock"></i>
                        <h3>Expired</h3>
                    </div>
                    <p class="stat-number"><%= expiredUsers %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-male"></i>
                        <h3>Male</h3>
                    </div>
                    <p class="stat-number"><%= maleUsers %></p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-female"></i>
                        <h3>Female</h3>
                    </div>
                    <p class="stat-number"><%= femaleUsers %></p>
                </div>
            </div>

            <!-- Users Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>patron Table</h2>
                    </div>
                   <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddPatronModal()" class="add-new">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="patronsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>NAME</th>
                                <th>EMAIL</th>
                                <th>CONTACT</th>
                                <th>ADDRESS</th>
                                <th>MEMBERSHIP TYPE</th>
                                <th>UNIQUE CODE</th>
                                <th>GENDER</th>
                                <th>DATE JOINED</th>
                                <th>DAYS LEFT</th>
                                <th>STATUS</th>
                                <th>ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Fetch patron from the database 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT * FROM patron");

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='9'>No patron found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String id = rs.getString("patron_id");
                                            String name = rs.getString("first_name") + " " + rs.getString("last_name");
                                            String email = rs.getString("email");
                                            String contact = rs.getString("contact");
                                            String address = rs.getString("address");
                                            String membershipType = rs.getString("membership_type");
                                            String barcode = rs.getString("barcode");
                                            String gender = rs.getString("gender");
                                            Date dateJoined = rs.getDate("date_Joined");
                                            Date expirationDate = rs.getDate("expiration_date");
                                            String status = rs.getString("status");

                                            // Calculate days left, handle null expiryDate
                                            long daysLeft = (expirationDate != null) ? ChronoUnit.DAYS.between(LocalDate.now(), expirationDate.toLocalDate()) : -1;
                            %>
                            <tr>
                                <td><%= id %></td>
                                <td><%= name %></td>
                                <td><%= email %></td>
                                <td><%= contact %></td>
                                <td><%= address %></td>
                                <td><%= membershipType %></td>
                                <td><%= barcode %></td>
                                <td><%= gender %></td>
                                <td><%= dateJoined %></td>
                                <td><%= (daysLeft >= 0) ? daysLeft + " days" : "N/A" %></td>
                                <td><%= status %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn view-btn" onclick="viewPatron('<%= id %>', '<%= name %>', '<%= contact %>', '<%= barcode %>')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <span class="tooltiptext">View</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editPatron('<%= id %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                    
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deletePatron('<%= id %>')">
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
                                    out.println("<tr><td colspan='9'>Error fetching patrons: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Viewing Patron Details -->
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

    <!-- Modal for Adding Patron -->
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

function viewPatron(id, name, contact, barcode) {
    document.getElementById('modalUserName').innerText = "User: " + name;
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
    window.location.href = '<%= request.getContextPath() %>/views/admin/patron/editPatron.jsp?id=' + id;
}

function deletePatron(id) {
    if (confirm("Are you sure you want to delete this patron?")) {
        window.location.href = '<%= request.getContextPath() %>/views/admin/patron/deletePatron.jsp?id=' + id;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('patronsTable');
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
    const table = document.getElementById('patronsTable');
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
</body>
</html>
