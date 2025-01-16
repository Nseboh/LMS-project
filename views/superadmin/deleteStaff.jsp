<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int staffId = Integer.parseInt(request.getParameter("id"));

    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "DELETE FROM staffs WHERE staff_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, staffId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Staff deleted successfully.</p>");
        } else {
            out.println("<p>Error deleting staff.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
<a href="superadminDashboard.jsp">Back to Dashboard</a> 