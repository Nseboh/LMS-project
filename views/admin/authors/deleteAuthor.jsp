<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String idParam = request.getParameter("id");
    int authorId = -1; // Default value for authorId

    // Check if the id parameter is present and valid
    if (idParam != null && !idParam.isEmpty()) {
        try {
            authorId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error_message", "Invalid author ID.");
            response.sendRedirect("authors.jsp");
            return; // Exit the JSP
        }
    } else {
        session.setAttribute("error_message", "Author ID is required.");
        response.sendRedirect("authors.jsp");
        return; // Exit the JSP
    }

    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "DELETE FROM author WHERE author_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, authorId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            session.setAttribute("success_message", "Author deleted successfully.");
        } else {
            session.setAttribute("error_message", "Error deleting author.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error: " + e.getMessage());
    } finally {
        if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>
<%
    // Redirect to authors.jsp to display messages
    response.sendRedirect("authors.jsp");
%> 