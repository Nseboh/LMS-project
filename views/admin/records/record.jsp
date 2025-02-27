<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Records</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/authors/author.jsp'">
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
                <div class="nav-item active">
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
                <h1>Records</h1>
            </header>

            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-clipboard-listx"></i>
                        <h3>Total Records</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            // Fetch total registered records excluding super admins
                            int totalRecords = 0;
                            
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM record");
                                if (rs.next()) {
                                    totalRecords = rs.getInt("total");
                                }
                                
                                
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalRecords);
                        %>
                    </p>
                </div>
            </div>

            <!-- Attendance Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Records</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()">Search</button>
                        <button class="back-btn" onclick="resetTable()">Back</button>
                    </div>
                     
                </div>
                <div class="table-wrapper">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>PATRON NAME</th>
                                <th>VISIT DATE</th>
                                <th>TIME IN</th>
                                <th>TIME OUT</th>
                                <th>REMARKS</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Fetch records from the database 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT r.record_id, p.first_name, p.last_name, r.visit_date, r.visit_time_in, r.visit_time_out, r.remarks " +
                                                                     "FROM record r JOIN patron p ON r.patron_id = p.patron_id");

                                if (!rs.isBeforeFirst()) {
                                    out.println("<tr><td colspan='6'>No records found.</td></tr>");
                                } else {
                                    while (rs.next()) {
                                        String recordId = rs.getString("record_id");
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
                        </tr>
                        <% 
                                    }
                                }
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                                out.println("<tr><td colspan='6'>Error fetching records: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
    
</body>
</html>