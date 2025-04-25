<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Takoradi Library - Issued Books</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
    <script>
        function openAddlendingModal() {
            const modal = document.getElementById('addlendingModal');
            const modalContent = document.getElementById('modalContent');
            fetch('<%= request.getContextPath() %>/views/issuedBooks/addlending.jsp')
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                    modal.style.display = 'block';
                });
        }

        function closeAddlendingModal() {
            document.getElementById('addlendingModal').style.display = 'none';
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
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/attendance/attendance.jsp'">
                    <i class="fas fa-calendar-check" style="color:white"></i>
                    <span style="color:white">Attendance</span>
                </div>
                <div class="nav-item" onclick="window.location.href='<%= request.getContextPath() %>/views/publishers/publisher.jsp'">
                    <i class="fas fa-building" style="color:white"></i>
                    <span style="color:white">Publishers</span>
                </div>
                <div class="nav-item active" style="color: #000000; background-color: #ffffff;">
                    <i class="fas fa-book-open"style="color: #000000; background-color: #ffffff;"></i>
                    <span>Issued Books</span>
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
                <h1>Issued Books</h1>
            </header>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-book" style="color:rgb(10, 18, 121);"></i>
                        <h3>Total Issued Books</h3>
                    </div>
                    <p class="stat-number">
                        <%
                            int totalBooks = 0;
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) AS total FROM issuedbooks");
                                if (rs.next()) {
                                    totalBooks = rs.getInt("total");
                                }
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            out.print(totalBooks);
                        %>
                    </p>
                </div>
                
            </div>

            <!-- Issued Books Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Issued Books Table</h2>
                    </div>
                   <div class="search-container">
                        <input type="search" id="searchInput" placeholder="Type to search" class="search-input" />
                        <button class="search-btn" onclick="searchTable()" style="background-color:rgb(19, 175, 58); margin-left:30px;">Search</button>
                        <button class="back-btn" onclick="resetTable()" style="background-color:rgb(201, 43, 43);">Cancel</button>
                    </div>
                    <div class="add-new-container">
                        <button onclick="openAddlendingModal()" class="add-new" style="background-color:rgb(10, 18, 121);">Add New</button>
                    </div>
                </div>
                <div class="table-wrapper">
                    <table id="issuedBooksTable">
                        <thead>
                            <tr>
                                <th>ISBN</th>
                                <th>Patron ID</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Copies Issued</th>
                                <th>Status</th>
                                <th>Remarks</th>
                                <th>Fine Amount</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                                    String sql = "SELECT ib.issue_id, ib.isbn, ib.patron_id, ib.issue_date, ib.due_date, ib.booksissued, " +
                                                 "ibs.status_name, ibr.remarks_name, ib.fine_amount " +
                                                 "FROM issuedbooks ib " +
                                                 "LEFT JOIN issuedbooksstatus ibs ON ib.issue_id = ibs.issue_id " +
                                                 "LEFT JOIN issuedbooksremarks ibr ON ib.issue_id = ibr.issue_id";
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery(sql);

                                    if (!rs.isBeforeFirst()) {
                                        out.println("<tr><td colspan='9'>No issued books found.</td></tr>");
                                    } else {
                                        while (rs.next()) {
                                            int issueId = rs.getInt("issue_id");
                                            String isbn = rs.getString("isbn");
                                            String patronId = rs.getString("patron_id");
                                            Date issueDate = rs.getDate("issue_date");
                                            Date dueDate = rs.getDate("due_date");
                                            int booksIssued = rs.getInt("booksissued");
                                            String statusName = rs.getString("status_name");
                                            String remarksName = rs.getString("remarks_name");
                                            double fineAmount = rs.getDouble("fine_amount");
                            %>
                            <tr>
                                <td><a href="<%= request.getContextPath() %>/views/issuedBooks/ViewBook.jsp?isbn=<%= isbn %>"><%= isbn %></td>
                                <td><a href="<%= request.getContextPath() %>/views/issuedBooks/PatronDetail.jsp?id=<%= patronId %>"><%= patronId %></td>
                                <td><%= issueDate != null ? issueDate.toString() : "N/A" %></td>
                                <td><%= dueDate != null ? dueDate.toString() : "N/A" %></td>
                                <td><%= booksIssued %></td>
                                <td><%= statusName %></td>
                                <td><%= remarksName %></td>
                                <td><%= fineAmount %></td>
                                <td>
                                    <div class="actions">
                                        <div class="tooltip">
                                            <button class="action-btn edit-btn" onclick="editBook('<%= issueId %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <span class="tooltiptext">Edit</span>
                                        </div>
                                        
                                        <div class="tooltip">
                                            <button class="action-btn delete-btn" onclick="deleteBook('<%= issueId %>')">
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
                                    out.println("<tr><td colspan='9'>Error fetching issued books: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Adding User -->
    <div id="addlendingModal" class="modal" style="display:none;">
        <div id="modalContent"></div>
    </div>

<script>
function closeAlert() {
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.style.display = 'none';
    }
}

function editBook(issueId) {
    window.location.href = '<%= request.getContextPath() %>/views/issuedBooks/editLending.jsp?issue_id=' + issueId;
}

function deleteBook(issueId) {
    if (confirm("Are you sure you want to delete this Issued book?")) {
        window.location.href = '<%= request.getContextPath() %>/views/issuedBooks/deleteLending.jsp?issue_id=' + issueId;
    }
}

function searchTable() {
    const input = document.getElementById('searchInput').value.toLowerCase();
    const table = document.getElementById('issuedBooksTable');
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
    const table = document.getElementById('issuedBooksTable');
    const tr = table.getElementsByTagName('tr');
    for (let i = 1; i < tr.length; i++) {
        tr[i].style.display = '';
    }
    document.getElementById('searchInput').value = '';
}
</script>
</body>
</html>
