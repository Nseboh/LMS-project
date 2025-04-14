<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Takoradi Library - Attendance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
    <script>
        function openAddAttendanceModal() {
            const modal = document.getElementById('addAttendanceModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/attendance/addAttendance.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddAttendanceModal() {
            document.getElementById('addAttendanceModal').style.display = 'none';
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/superadmin/superadminDashboard.jsp'">
                    <i class="fas fa-users" style="color:white;"></i>
                    <span style="color:white">Staff</span>
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">
                    <i class="fas fa-walking" style="color:white"></i>
                    <span style="color:white">Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/records/record.jsp'">
                    <i class="fas fa-clipboard-list" style="color:white"></i>
                    <span style="color:white">Records</span>
                </div>
                <div class="nav-item active" style="color: #000000; background-color: #ffffff;">
                    <i class="fas fa-calendar-check" style="color: #000000; background-color: #ffffff;"></i>
                    <span>Attendance</span>
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
                <h1>Attendance</h1>
            </header>

            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus" style="color:rgb(10, 18, 121);"></i>
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
                        <button class="search-btn" onclick="searchTable()" style="background-color:rgb(19, 175, 58); margin-left:30px;">Search</button>
                        <button class="back-btn" onclick="resetTable()" style="background-color:rgb(201, 43, 43);">Back</button>
                    </div>
                     <!-- Attendance Form -->
                    <div class="add-new-container">
                        <button onclick="openAddAttendanceModal()" class="add-new" style="background-color:rgb(10, 18, 121);">Add New </button>
                        <button class="search-btn" onclick="moveAllAttendance()" style="background-color:rgb(193, 202, 68); color: black;">Move</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="attendanceTable">
                        <thead>
                            <tr>
                                <th>Patron Name</th>
                                <th>Visit Date</th>
                                <th>Time In</th>
                                <th>Time Out</th>
                                <th>Remarks</th>
                                <th>Action</th>
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
                                <td><%= patronName %></td>
                                <td><%= visitDate %></td>
                                <td><%= visitTimeIn %></td>
                                <td><%= visitTimeOut != null ? visitTimeOut : "N/A" %></td>
                                <td><%= remarks != null ? remarks : "N/A" %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editAttendance('<%= attendanceId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteAttendance('<%= attendanceId %>')">
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
            <div id="addAttendanceModal" class="modal" style="display:none;">
                <div id="modalContent"></div>
            </div>   

            

<script>
            function closeAlert() {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.style.display = 'none';
                }
            }

            function editAttendance(id) {
                window.location.href = '<%= request.getContextPath() %>/views/attendance/editAttendance.jsp?id=' + id;
            }

            function deleteAttendance(id) {
                if (confirm("Are you sure you want to delete this attendance record?")) {
                    window.location.href = '<%= request.getContextPath() %>/views/attendance/deleteAttendance.jsp?id=' + id;
                }
            }

            function searchTable() {
                const input = document.getElementById('searchInput').value.toLowerCase();
                const table = document.getElementById('attendanceTable');
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
                const table = document.getElementById('attendanceTable');
                const tr = table.getElementsByTagName('tr');
                for (let i = 1; i < tr.length; i++) {
                    tr[i].style.display = '';
                }
                document.getElementById('searchInput').value = '';
            }

            function moveAllAttendance() {
                // Redirect to the process_moveAttendance.jsp to move all records
                if (confirm("Are you sure you want to move all attendance records? This action cannot be undone.")) {
                    window.location.href = '<%= request.getContextPath() %>/views/attendance/process_moveAttendance.jsp';
                }
            }
</script>
</body>
</html>