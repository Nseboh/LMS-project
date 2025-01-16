<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Database connection details
    String DB_URL = "jdbc:mysql://localhost:3306/lms";
    String USER = "root";
    String PASSWORD = "Righteous050598$";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);

        // Move all records from attendances to records
        String moveSql = "INSERT INTO record (patron_id, visit_date, visit_time_in, visit_time_out, remarks) " +
                         "SELECT patron_id, visit_date, visit_time_in, visit_time_out, remarks FROM attendances";

        PreparedStatement moveStmt = conn.prepareStatement(moveSql);
        int rowsMoved = moveStmt.executeUpdate();

        // Delete all records from the attendance table
        String deleteSql = "DELETE FROM attendances";
        PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
        deleteStmt.executeUpdate();

        System.out.println(rowsMoved + " records moved to the records table.");

        conn.close();
        session.setAttribute("success_message", "All attendance records moved successfully!");
        response.sendRedirect("attendance.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error moving attendance records: " + e.getMessage());
        response.sendRedirect("attendance.jsp");
    }
%>