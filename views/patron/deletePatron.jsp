<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
     String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        session.setAttribute("error_message", "Invalid patron ID.");
        response.sendRedirect("patron.jsp");
        return;
    }

    String patronId = idParam; // No need to parse as int since patron_id is now varchar


    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "DELETE FROM patron WHERE patron_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, patronId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Patron deleted successfully.</p>");
        } else {
            out.println("<p>Error deleting patron.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
<a href="patron.jsp">Back to Dashboard</a> 