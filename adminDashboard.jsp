<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JE.Library - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <i class="fas fa-book-reader logo-icon"></i>
                <div class="logo-text">JE.Library</div>
            </div>
            <div class="sidebar-divider"></div>
            
            <nav class="sidebar-nav">
                <div class="nav-item active">
                    <i class="fas fa-users"></i>
                    <span>Clients</span>
                </div>
                <div class="nav-item" onclick="window.location.href='authors.jsp'">
                    <i class="fas fa-pen-fancy"></i>
                    <span>Authors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='books.jsp'">
                    <i class="fas fa-book"></i>
                    <span>Books</span>
                </div>
                <div class="nav-item" onclick="window.location.href='visitors.jsp'">
                    <i class="fas fa-walking"></i>
                    <span>Visitors</span>
                </div>
                <div class="nav-item" onclick="window.location.href='records.jsp'">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Records</span>
                </div>
                <div class="nav-item" onclick="window.location.href='attendance.jsp'">
                    <i class="fas fa-calendar-check"></i>
                    <span>Attendance</span>
                </div>
                <div class="nav-item" onclick="window.location.href='publishers.jsp'">
                    <i class="fas fa-building"></i>
                    <span>Publishers</span>
                </div>
                <div class="nav-item" onclick="window.location.href='issuedBooks.jsp'">
                    <i class="fas fa-book-open"></i>
                    <span>Issued Books</span>
                </div>
            </nav>
            
            <div class="settings">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <header class="header">
                <h1>Clients</h1>
            </header>

            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-user-plus"></i>
                        <h3>Register Clients</h3>
                    </div>
                    <p class="stat-number">0</p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-clock"></i>
                        <h3>Expired</h3>
                    </div>
                    <p class="stat-number">0</p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-male"></i>
                        <h3>Male</h3>
                    </div>
                    <p class="stat-number">0</p>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <i class="fas fa-female"></i>
                        <h3>Female</h3>
                    </div>
                    <p class="stat-number">0</p>
                </div>
            </div>

            <!-- Clients Table Section -->
            <div class="clients-table">
                <div class="table-header-container">
                    <div class="table-title">
                        <h2>Clients Table</h2>
                    </div>
                    <div class="search-container">
                        <input type="search" placeholder="Type to search" class="search-input" />
                    </div>
                    <div class="add-new-container">
                        <button class="add-new">Add New</button>
                    </div>
                </div>
                
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>NAME</th>
                            <th>GENDER</th>
                            <th>CONTACT</th>
                            <th>ADDRESS</th>
                            <th>ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>001</td>
                            <td>Emmanuel Ajigawe Atio</td>
                            <td>Male</td>
                            <td>0541457539</td>
                            <td>PIPEANO</td>
                            <td class="actions">
                                <i class="fas fa-eye"></i>
                                <i class="fas fa-edit"></i>
                                <i class="fas fa-trash-alt"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
