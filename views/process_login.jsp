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
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        
        String sql = "SELECT * FROM staffs WHERE email = ? AND password = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql); // Using PreparedStatement to prevent SQL injection
        pstmt.setString(1, email); // Setting the email parameter in the query
        pstmt.setString(2, password); // Setting the password parameter in the query
        
        ResultSet rs = pstmt.executeQuery();
        
        // Checking if a staff with the provided credentials exists
        if (rs.next()) {
            String role = rs.getString("role");
            String status = rs.getString("status");
            session.setAttribute("staff_id", rs.getInt("staff_id"));
            session.setAttribute("staff_email", email);
            session.setAttribute("staff_role", role);
            session.setAttribute("staff_status", status);
            
            // Redirecting users based on their role and status
            if ("Superadmin".equals(role) && "active".equals(status)) {
                response.sendRedirect("superadmin/superadminDashboard.jsp");
            } else if ("Admin".equals(role)) {
                response.sendRedirect("admin/patron/patron.jsp");
            } else {
                response.sendRedirect("login.jsp?error=Invalid role");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
        
        // Closing resources
        rs.close();
        pstmt.close();
        conn.close();
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=Database error");
    }
%> 