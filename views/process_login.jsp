<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Retrieving email and password from the request parameters
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        
        // Use a prepared statement to prevent SQL injection
        String sql = "SELECT s.staff_id, sr.role_name, ss.status " +
                     "FROM staff s " +
                     "JOIN staff_contact sc ON s.staff_id = sc.staff_id " +
                     "JOIN staffrole sr ON s.staff_id = sr.staff_id " +
                     "JOIN staff_status ss ON s.staff_id = ss.staff_id " +
                     "WHERE sc.email = ? AND s.password = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, password);
        
        ResultSet rs = pstmt.executeQuery();
        
        // Checking if a staff with the provided credentials exists
        if (rs.next()) {
            String staffId = rs.getString("staff_id");
            String role = rs.getString("role_name");
            String status = rs.getString("status");

            // Set session attributes
            session.setAttribute("staff_id", staffId);
            session.setAttribute("email", email);
            session.setAttribute("role_name", role);
            session.setAttribute("status", status);
            
            // Redirecting users based on their role and status
            if ("Superadmin".equals(role) && "active".equals(status)) {
                response.sendRedirect("superadmin/superadminDashboard.jsp");
            } else if ("Admin".equals(role) && "active".equals(status)) {
                response.sendRedirect("admin/patron/patron.jsp");
            } else {
                response.sendRedirect("login.jsp?error=Invalid role or status");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
        
        // Closing resources
        rs.close();
        pstmt.close();
        conn.close();
        
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace(); // Print the SQL exception stack trace
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("login.jsp?error=SQL Error: " + sqlEx.getMessage());
    } catch (Exception e) {
        e.printStackTrace(); // Print the general exception stack trace
        session.setAttribute("error_message", "Error: " + e.getMessage());
        response.sendRedirect("login.jsp?error=Error: " + e.getMessage());
    }
%> 