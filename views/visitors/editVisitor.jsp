<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");
    String firstName = "";
    String lastName = "";
    String contactNumber = "";
    String email = "";
    String gender = "";
    String status = "";
    String timeOut = "";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch visitor details
        String sql = "SELECT * FROM visitor WHERE visitor_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, visitorId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            contactNumber = rs.getString("contact_number");
            email = rs.getString("email");
            gender = rs.getString("gender");
            status = rs.getString("status");
            timeOut = rs.getTime("time_out") != null ? rs.getTime("time_out").toString() : ""; // Handle null for time_out
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Visitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">

</head>
<body>
    <div class="modal-content">
        <h1>Edit Visitor</h1>
        <% if (session.getAttribute("error_message") != null) { %>
            <div class="alert alert-danger">
                <p><%= session.getAttribute("error_message") %></p>
                <button onclick="closeAlert()" class="close-alert">&times;</button>
            </div>
            <%
                // Clear the session attribute after displaying it
                session.removeAttribute("error_message");
            %>
        <% } %>
        <form id="editVisitorForm" action="<%= request.getContextPath() %>/views/visitors/process_editVisitor.jsp" method="POST">
            <input type="hidden" name="visitorId" value="<%= visitorId %>">
            <div class="form-group">
                <label for="firstName">First Name*</label>
                <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name*</label>
                <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required>
            </div>
            <div class="form-group">
                <label for="contactNumber">Contact*</label>
                <input type="tel" id="contactNumber" name="contactNumber" value="<%= contactNumber %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="gender">Gender*</label>
                <select id="gender" name="gender" required>
                    <option value="Male" <%= gender.equals("Male") ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= gender.equals("Female") ? "selected" : "" %>>Female</option>
                    <option value="Other" <%= gender.equals("Other") ? "selected" : "" %>>Other</option>
                </select>
            </div>
            <div class="form-group">
                <label for="timeOut">Time Out (when leaving the library)</label>
                <input type="time" id="timeOut" name="timeOut" value="<%= timeOut %>">
            </div>
            <div class="form-group">
                <label for="status">Status*</label>
                <select id="status" name="status" required>
                    <option value="Pending" <%= status.equals("Pending") ? "selected" : "" %>>Pending</option>
                    <option value="Approved" <%= status.equals("Approved") ? "selected" : "" %>>Approved</option>
                    <option value="Rejected" <%= status.equals("Rejected") ? "selected" : "" %>>Rejected</option>
                    <option value="Completed" <%= status.equals("Completed") ? "selected" : "" %>>Completed</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Update Visitor</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">Cancel</button>
            </div>
        </form>
    </div>
    
</body>
</html> 