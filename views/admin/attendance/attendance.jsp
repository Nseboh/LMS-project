<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Attendance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        function openAddUserModal() {
            const modal = document.getElementById('addUserModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/admin/attendance/addAttendance.jsp')
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/patron/patron.jsp'">
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
                <div class="nav-item active">
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
                <h1>Attendance</h1>
            </header>

            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Total Attendance</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered users excluding super admins
                            int totalUsers = 0;
                            
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM attendances");
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

            <!-- Attendance Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Attendance Records</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                     <!-- Attendance Form -->
                    <div class="add-new-container">
                        <button onclick="openAddUserModal()" class="add-new">Add New </button>
                        <button class="search-btn" onclick="moveAllAttendance()">Move All Attendance</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>PATRON NAME</th>
                                <th>VISIT DATE</th>
                                <th>TIME IN</th>
                                <th>TIME OUT</th>
                                <th>REMARKS</th>
                                <th>ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Fetch attendance records from the database 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT a.attendance_id, p.first_name, p.last_name, a.visit_date, a.visit_time_in, a.visit_time_out, a.remarks " +
                                                                     "FROM attendances a JOIN patron p ON a.patron_id = p.patron_id");
                                                                    // Execute a SQL query to retrieve attendance records by joining the 'attendances' table (aliased as 'a') 
                                                                    // with the 'patron' table (aliased as 'p') on the patron_id field. This query fetches the attendance ID, 
                                                                    // patron's first and last names, visit date, time in, time out, and remarks for each attendance record.

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='7'>No attendance records found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            String attendanceId = rs.getString("attendance_id");
                                            String patronName = rs.getString("first_name") + " " + rs.getString("last_name");
                                            Date visitDate = rs.getDate("visit_date");
                                            Time visitTimeIn = rs.getTime("visit_time_in");
                                            Time visitTimeOut = rs.getTime("visit_time_out");
                                            String remarks = rs.getString("remarks");
                            %>
                            <tr>
                                <td><%= attendanceId %></td>
                                <td><%= patronName %></td>
                                <td><%= visitDate %></td>
                                <td><%= visitTimeIn %></td>
                                <td><%= visitTimeOut != null ? visitTimeOut : "N/A" %></td>
                                <td><%= remarks != null ? remarks : "N/A" %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editUser('<%= attendanceId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteUser('<%= attendanceId %>')">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                            <span class="tooltiptext">Delete</span>
                                        </div>
                                        <div class="tooltip">
                                            <button class="action-btn move-btn" onclick="moveAttendance('<%= attendanceId %>')">
                                                <i class="fas fa-arrow-right"></i>
                                            </button>
                                            <span class="tooltiptext">Move</span>
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
                                    out.println("<tr><td colspan='7'>Error fetching attendance records: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div> 
        </main>
    </div>
    <!-- Modal for Adding Attendance -->
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
                window.location.href = '<%= request.getContextPath() %>/views/admin/attendance/editAttendance.jsp?id=' + id;
            }

            function deleteUser(id) {
                if (confirm("Are you sure you want to delete this attendance record?")) {
                    window.location.href = '<%= request.getContextPath() %>/views/admin/attendance/deleteAttendance.jsp?id=' + id;
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

            function moveAllAttendance() {
                // Redirect to the process_moveAttendance.jsp to move all records
                if (confirm("Are you sure you want to move all attendance records? This action cannot be undone.")) {
                    window.location.href = '<%= request.getContextPath() %>/views/admin/attendance/process_moveAttendance.jsp';
                }
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
    </div>
</body>
</html>