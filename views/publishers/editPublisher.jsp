<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String publisherId = request.getParameter("id");
    String publicationName = "";
    String phone = "";
    String email = "";
    String website = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Fetch publisher details
        PreparedStatement pstmt = conn.prepareStatement("SELECT p.Publication_name, c.phone, c.email, c.website FROM publisher p LEFT JOIN publishercontact c ON p.publisher_id = c.publisher_id WHERE p.publisher_id = ?");
        pstmt.setString(1, publisherId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            publicationName = rs.getString("Publication_name");
            phone = rs.getString("phone");
            email = rs.getString("email");
            website = rs.getString("website");
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
    <title>Edit Publisher</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
</head>
<body>
    <div class="modal-content">
        <h1>Edit Publisher</h1>
        <form id="editPublisherForm" action="<%= request.getContextPath() %>/views/publishers/process_editPublisher.jsp" method="POST">
            <input type="hidden" name="publisher_id" value="<%= publisherId %>">
            <div class="form-group">
                <label for="name">Publication Name*</label>
                <input type="text" id="name" name="name" value="<%= publicationName %>" required>
            </div>
            <div class="form-group">
                <label for="phone">Phone*</label>
                <input type="tel" id="phone" name="phone" value="<%= phone %>" pattern="[0-9]{10}" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="website">Website</label>
                <input type="text" id="website" name="website" value="<%= website %>">
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Save</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='publisher.jsp'">Cancel</button>
            </div>
        </form>
    </div>
</body>
</html> 