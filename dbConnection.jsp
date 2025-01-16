<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Database connection details
    String dbURL = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection connection = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        throw new SQLException("JDBC Driver not found", e);
    } catch (SQLException e) {
        e.printStackTrace();
        throw new SQLException("Unable to connect to database", e);
    }
%> 