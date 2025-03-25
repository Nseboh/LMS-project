<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fine Updater</title>
</head>
<body>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Establish a connection
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch all overdue books
        String fetchOverdueSql = "SELECT issue_id, due_date FROM issuedbooks WHERE due_date < CURDATE()";
        pstmt = conn.prepareStatement(fetchOverdueSql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            int issueId = rs.getInt("issue_id");
            java.sql.Date dueDate = rs.getDate("due_date");

            // Calculate the fine amount
            long diffInMillies = new java.util.Date().getTime() - dueDate.getTime();
            long daysOverdue = diffInMillies / (1000 * 60 * 60 * 24);
            double fineAmount = daysOverdue * 10;

            // Update the fine amount in the database
            String updateFineSql = "UPDATE issuedbooks SET fine_amount = ? WHERE issue_id = ?";
            try (PreparedStatement updateFineStmt = conn.prepareStatement(updateFineSql)) {
                updateFineStmt.setDouble(1, fineAmount);
                updateFineStmt.setInt(2, issueId);
                updateFineStmt.executeUpdate();
            }
        }

        out.println("<h2>Fine amounts updated successfully!</h2>");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>
