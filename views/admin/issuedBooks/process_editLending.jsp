<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Edit Lending</title>
</head>
<body>
<%
    // Retrieve form data
    String issueId = request.getParameter("issue_id");
    String isbn = request.getParameter("isbn");
    String patronId = request.getParameter("patron_id");
    String issueDate = request.getParameter("DateIssued");
    String dueDate = request.getParameter("DateDue");
    String copiesIssued = request.getParameter("copiesIssued");
    String remarks = request.getParameter("remarks");
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Establish a connection
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Update issuedbooks table
        String sql = "UPDATE issuedbooks SET isbn = ?, patron_id = ?, issue_date = ?, due_date = ?, booksissued = ? " +
                     "WHERE issue_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, isbn);
        pstmt.setString(2, patronId);
        pstmt.setString(3, issueDate);
        pstmt.setString(4, dueDate);
        pstmt.setInt(5, Integer.parseInt(copiesIssued));
        pstmt.setInt(6, Integer.parseInt(issueId));
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();

        // Update issuedbooksstatus table
        String statusSql = "UPDATE issuedbooksstatus SET status_name = ? WHERE issue_id = ?";
        pstmt = conn.prepareStatement(statusSql);
        pstmt.setString(1, status);
        pstmt.setInt(2, Integer.parseInt(issueId));
        pstmt.executeUpdate();
        pstmt.close();

        // Update issuedbooksremarks table
        String remarksSql = "UPDATE issuedbooksremarks SET remarks_name = ? WHERE issue_id = ?";
        pstmt = conn.prepareStatement(remarksSql);
        pstmt.setString(1, remarks);
        pstmt.setInt(2, Integer.parseInt(issueId));
        pstmt.executeUpdate();
        pstmt.close();

        // Update the number of available copies in the books table
        if ("available".equalsIgnoreCase(status)) {
            String updateCopiesSql = "UPDATE bookcopy SET copies_available = copies_available + ? WHERE isbn = ?";
            try (PreparedStatement updateCopiesStmt = conn.prepareStatement(updateCopiesSql)) {
                updateCopiesStmt.setInt(1, Integer.parseInt(copiesIssued));
                updateCopiesStmt.setString(2, isbn);
                updateCopiesStmt.executeUpdate();
            }
        } else if ("issued".equalsIgnoreCase(status)) {
            String updateCopiesSql = "UPDATE bookcopy SET copies_available = copies_available - ? WHERE isbn = ?";
            try (PreparedStatement updateCopiesStmt = conn.prepareStatement(updateCopiesSql)) {
                updateCopiesStmt.setInt(1, Integer.parseInt(copiesIssued));
                updateCopiesStmt.setString(2, isbn);
                updateCopiesStmt.executeUpdate();
            }
        }

       // Redirect to the lend list with success message
        session.setAttribute("success_message", "lending updated successfully!");
        response.sendRedirect("lending.jsp");

    }catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editLending.jsp?id=" + issueId);
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("editLending.jsp?id=" + issueId);
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
