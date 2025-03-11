<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    String issueId = request.getParameter("issue_id");
    String isbn = "";
    String patronId = "";
    String issueDate = "";
    String dueDate = "";
    String copiesIssued = "";
    String remarks = "";
    String status = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch current lending details
        String sql = "SELECT ib.isbn, ib.patron_id, ib.issue_date, ib.due_date, ib.booksissued, " +
                     "ibs.status_name, ibr.remarks_name " +
                     "FROM issuedbooks ib " +
                     "LEFT JOIN issuedbooksstatus ibs ON ib.issue_id = ibs.issue_id " +
                     "LEFT JOIN issuedbooksremarks ibr ON ib.issue_id = ibr.issue_id " +
                     "WHERE ib.issue_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(issueId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            isbn = rs.getString("isbn");
            patronId = rs.getString("patron_id");
            issueDate = rs.getString("issue_date");
            dueDate = rs.getString("due_date");
            copiesIssued = rs.getString("booksissued");
            status = rs.getString("status_name");
            remarks = rs.getString("remarks_name");
        }
    } catch (Exception e) {
        e.printStackTrace();
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Lending</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
</head>
<body>

<div class="modal-content">
        <h1>Edit Lending</h1>
        <form id= "addUserForm" action="process_editLending.jsp" method="POST">
            <input type="hidden" name="issue_id" value="<%= issueId %>">
            <div class="form-group">
                <label for="isbn">ISBN:</label>
                <input type="text" id="isbn" name="isbn" value="<%= isbn %>" required>
            </div>
            <div class="form-group">
                <label for="patron_id">Patron ID:</label>
                <input type="text" id="patron_id" name="patron_id" value="<%= patronId %>" required>
            </div>
            <div class="form-group">
                <label for="DateIssued">Issue Date:</label>
                <input type="date" id="DateIssued" name="DateIssued" value="<%= issueDate %>" required>
            </div>
            <div class="form-group">
                <label for="DateDue">Due Date:</label>
                <input type="date" id="DateDue" name="DateDue" value="<%= dueDate %>" required>
            </div>
            <div class="form-group">
                <label for="copiesIssued">Copies Issued:</label>
                <input type="number" id="copiesIssued" name="copiesIssued" value="<%= copiesIssued %>" required>
            </div>
            <div class="form-group">
                <label for="status">Status:</label>
                <select id="status" name="status" required>
                    <option value="available" <%= status.equals("available") ? "selected" : "" %>>Available</option>
                    <option value="issued" <%= status.equals("issued") ? "selected" : "" %>>Issued</option>
                </select>
            </div>
            <div class="form-group">
                <label for="remarks">Remarks:</label>
                <select id="remarks" name="remarks" required>
                    <option value="No special conditions" <%= remarks.equals("No special conditions") ? "selected" : "" %>>No Special Conditions</option>
                    <option value="Book returned late" <%= remarks.equals("Book returned late") ? "selected" : "" %>>Book Returned Late</option>
                    <option value="Book damaged" <%= remarks.equals("Book damaged") ? "selected" : "" %>>Book Damaged</option>
                    <option value="Extension granted" <%= remarks.equals("Extension granted") ? "selected" : "" %>>Extension Granted</option>
                    <option value="Reserved by another patron" <%= remarks.equals("Reserved by another patron") ? "selected" : "" %>>Reserved By Another Patron</option>
                    <option value="Book lost" <%= remarks.equals("Book lost") ? "selected" : "" %>>Book Lost</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Update Lending</button>
                <button type="button" class="submit-btn" onclick="window.location.href='lending.jsp'">Cancel</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
