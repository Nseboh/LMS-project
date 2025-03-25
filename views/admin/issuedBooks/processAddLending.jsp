<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Lending</title>
    <script>
        // Set the lending date to today's date
        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('lendingDate').value = today;
        };
    </script>
</head>
<body>
<%
    // Retrieve form data
    String isbn = request.getParameter("isbn");
    String patronId = request.getParameter("patron_id");
    String issueDate = request.getParameter("DateIssued");
    String dueDate = request.getParameter("DateDue");
    String copiesIssued = request.getParameter("copiesIssued");
    String remarks = request.getParameter("remarks");
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet generatedKeys = null;

    try {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Establish a connection
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Insert into issuedbooks table
        String sql = "INSERT INTO issuedbooks (isbn, patron_id, issue_date, due_date, booksissued, fine_amount) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, isbn);
        pstmt.setString(2, patronId);
        pstmt.setString(3, issueDate);
        pstmt.setString(4, dueDate);
        pstmt.setInt(5, Integer.parseInt(copiesIssued));
        pstmt.setDouble(6, fineAmount);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // Retrieve the generated issue_id
            generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int issueId = generatedKeys.getInt(1);

                // Insert into issuedbooksstatus table
                String statusSql = "INSERT INTO issuedbooksstatus (issue_id, status_name) VALUES (?, ?)";
                try (PreparedStatement statusStmt = conn.prepareStatement(statusSql)) {
                    statusStmt.setInt(1, issueId);
                    statusStmt.setString(2, status);
                    statusStmt.executeUpdate();
                }

                // Insert into issuedbooksremarks table
                String remarksSql = "INSERT INTO issuedbooksremarks (issue_id, remarks_name) VALUES (?, ?)";
                try (PreparedStatement remarksStmt = conn.prepareStatement(remarksSql)) {
                    remarksStmt.setInt(1, issueId);
                    remarksStmt.setString(2, remarks);
                    remarksStmt.executeUpdate();
                }

                // Update the number of available copies in the books table
                if ("issued".equalsIgnoreCase(status)) {
                    String updateCopiesSql = "UPDATE bookcopy SET copies_available = copies_available - ? WHERE isbn = ?";
                    try (PreparedStatement updateCopiesStmt = conn.prepareStatement(updateCopiesSql)) {
                        updateCopiesStmt.setInt(1, Integer.parseInt(copiesIssued));
                        updateCopiesStmt.setString(2, isbn);
                        updateCopiesStmt.executeUpdate();
                    }
                }

                // Redirect to the patron list with success message
                session.setAttribute("success_message", "Book Lended successfully!");
                response.sendRedirect("lending.jsp");
            }
        } else {
            out.println("<h2>Error: Unable to add lending record.</h2>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        try {
            if (generatedKeys != null) generatedKeys.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
    
</body>
</html> 