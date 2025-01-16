<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Get form data
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

        // Insert author data
        String sql = "INSERT INTO author (author_id, first_name, last_name, isbn, nationality, email) VALUES (?, ?, ?, ?, ?, ?, NOW())";
        
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, authorId);
        preparedStatement.setString(2, firstName);
        preparedStatement.setString(3, lastName);
        preparedStatement.setString(4, isbn);
        preparedStatement.setString(5, nationality);
        preparedStatement.setString(6, email);

        int rowsInserted = preparedStatement.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("success_message", "Author added successfully!");
        } else {
            session.setAttribute("error_message", "Error adding author.");
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