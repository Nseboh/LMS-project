<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String authorId = request.getParameter("author_id");
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String isbn = request.getParameter("isbn");
    String nationality = request.getParameter("nationality");
    String email = request.getParameter("email");

    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$"; // Updated database password

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "UPDATE author SET first_name=?, last_name=?, isbn=?, nationality=?, email=? WHERE author_id=?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, firstName);
        preparedStatement.setString(2, lastName);
        preparedStatement.setString(3, isbn);
        preparedStatement.setString(4, nationality);
        preparedStatement.setString(5, email);
        preparedStatement.setInt(6, Integer.parseInt(authorId));

        int rowsUpdated = preparedStatement.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("success_message", "Author updated successfully.");
        } else {
            session.setAttribute("error_message", "Error updating author.");
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