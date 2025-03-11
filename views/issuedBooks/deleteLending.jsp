<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Lending</title>
</head>
<body>
<%
    String issueId = request.getParameter("issue_id");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Delete from issuedbooksstatus
        String statusSql = "DELETE FROM issuedbooksstatus WHERE issue_id = ?";
        pstmt = conn.prepareStatement(statusSql);
        pstmt.setInt(1, Integer.parseInt(issueId));
        pstmt.executeUpdate();
        pstmt.close();

        // Delete from issuedbooksremarks
        String remarksSql = "DELETE FROM issuedbooksremarks WHERE issue_id = ?";
        pstmt = conn.prepareStatement(remarksSql);
        pstmt.setInt(1, Integer.parseInt(issueId));
        pstmt.executeUpdate();
        pstmt.close();

        // Delete from issuedbooks
        String sql = "DELETE FROM issuedbooks WHERE issue_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(issueId));
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<h2>Lending record deleted successfully!</h2>");
        } else {
            out.println("<h2>Error: Unable to delete lending record.</h2>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<button onclick="window.location.href='<%= request.getContextPath() %>/views/issuedBooks/lending.jsp'">Back to Lending</button>
</body>
</html>
