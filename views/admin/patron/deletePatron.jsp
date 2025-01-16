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
        preparedStatement.setString(1, patronId); // Set patronId as a string

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            session.setAttribute("success_message", "Patron deleted successfully.");
        } else {
            session.setAttribute("error_message", "Error deleting patron.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error: " + e.getMessage());
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
<a href="<%= request.getContextPath() %>/views/admin/patron/patron.jsp">Back to Patrons</a> 