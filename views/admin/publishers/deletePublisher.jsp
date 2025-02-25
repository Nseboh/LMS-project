<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    int publisherId = Integer.parseInt(request.getParameter("id"));

    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "DELETE FROM publisher WHERE publisher_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, publisherId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            session.setAttribute("success_message", "Publisher deleted successfully.");
        } else {
            session.setAttribute("error_message", "Error deleting publisher.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error: " + e.getMessage());
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
<a href="<%= request.getContextPath() %>/views/admin/publishers/publisher.jsp">Back to Publishers</a> 