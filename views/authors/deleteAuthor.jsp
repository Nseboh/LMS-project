<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
    String authorId = request.getParameter("id");

    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "DELETE FROM authors WHERE author_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, authorId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            session.setAttribute("success_message", "Author deleted successfully.");
            response.sendRedirect("author.jsp");
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
