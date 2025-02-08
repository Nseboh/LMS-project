<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String staffId = request.getParameter("id");
    String firstName = "";
    String lastName = "";
    String gender = "";
    String contact = "";
    String email = "";
    String address = "";
    String status = "";
    String roleName = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch current staff details
        String sql = "SELECT s.first_name, s.last_name, s.gender, sc.contact, sc.email, sc.address, ss.status, sr.role_name " +
                     "FROM staff s " +
                     "LEFT JOIN staff_contact sc ON s.staff_id = sc.staff_id " +
                     "LEFT JOIN staff_status ss ON s.staff_id = ss.staff_id " +
                     "LEFT JOIN staffrole sr ON s.staff_id = sr.staff_id " +
                     "WHERE s.staff_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, staffId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            gender = rs.getString("gender");
            contact = rs.getString("contact");
            email = rs.getString("email");
            address = rs.getString("address");
            status = rs.getString("status");
            roleName = rs.getString("role_name");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Staff</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/superadmin.css">
</head>
<body>
    <div class="modal-content">
        <h1>Edit Staff</h1>
        <form action="<%= request.getContextPath() %>/views/superadmin/process_editStaff.jsp" method="POST">
            <input type="hidden" name="staff_id" value="<%= staffId %>">
            <div class="form-group">
                <label for="first_name">First Name*</label>
                <input type="text" id="first_name" name="first_name" value="<%= firstName %>" required>
            </div>
            <div class="form-group">
                <label for="last_name">Last Name*</label>
                <input type="text" id="last_name" name="last_name" value="<%= lastName %>" required>
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
                <label for="contact">Contact*</label>
                <input type="text" id="contact" name="contact" value="<%= contact %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="address">Address*</label>
                <input type="text" id="address" name="address" value="<%= address %>" required>
            </div>
            <div class="form-group">
                <label for="status">Status*</label>
                <select id="status" name="status" required>
                    <option value="active" <%= status.equals("active") ? "selected" : "" %>>Active</option>
                    <option value="inactive" <%= status.equals("inactive") ? "selected" : "" %>>Inactive</option>
                </select>
            </div>
            <div class="form-group">
                <label for="role_name">Role*</label>
                <select id="role_name" name="role_name" required>
                    <option value="Superadmin" <%= roleName.equals("Superadmin") ? "selected" : "" %>>Superadmin</option>
                    <option value="Admin" <%= roleName.equals("Admin") ? "selected" : "" %>>Admin</option>
                </select>
            </div>
            <button type="submit" class="submit-btn">Update Staff</button>
            <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/superadmin/superadminDashboard.jsp'">Cancel</button>
        </form>
    </div>
    <style>
/* Modal styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgb(0,0,0);
    background-color: rgba(0,0,0,0.4);
    padding-top: 60px;
}

.modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
}

/* Modal Background */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1000; /* Sit on top */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgba(0, 0, 0, 0.7); /* Dark background with opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fff; /* White background */
    margin: 10% auto; /* Centered */
    padding: 20px;
    border-radius: 8px; /* Rounded corners */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Subtle shadow */
    width: 90%; /* Responsive width */
    max-width: 500px; /* Max width */
}

/* Close Button */
.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000; /* Change color on hover */
    text-decoration: none;
    cursor: pointer;
}

/* Form Container */
.form-container {
    display: flex;
    flex-direction: column; /* Stack elements vertically */
}

/* Form Elements */
.form-group {
    margin-bottom: 15px; /* Spacing for form groups */
}

label {
    margin-bottom: 5px; /* Spacing for labels */
    font-weight: bold; /* Bold labels */
    color: #333; /* Darker text color */
}

input[type="text"],
input[type="tel"],
input[type="email"],
select {
    padding: 10px; /* Padding for inputs */
    border: 1px solid #ccc; /* Light border */
    border-radius: 4px; /* Rounded corners */
    font-size: 16px; /* Font size */
    width: 100%; /* Full width */
    transition: border-color 0.3s; /* Smooth transition */
}

input[type="text"]:focus,
input[type="tel"]:focus,
input[type="email"]:focus,
select:focus {
    border-color: #007BFF; /* Blue border on focus */
    outline: none; /* Remove outline */
}

/* Buttons */
.submit-btn {
    background-color: #007BFF; /* Primary button color */
    color: white; /* Text color */
    padding: 10px; /* Padding */
    border: none; /* No border */
    border-radius: 4px; /* Rounded corners */
    cursor: pointer; /* Pointer cursor */
    font-size: 16px; /* Font size */
    transition: background-color 0.3s; /* Smooth transition */
    margin-top: 10px; /* Spacing above button */
}

.submit-btn:hover {
    background-color: #0056b3; /* Darker blue on hover */
}

.cancel-btn {
    background-color: #ccc; /* Gray color for cancel */
    color: black; /* Text color */
    padding: 10px; /* Padding */
    border: none; /* No border */
    border-radius: 4px; /* Rounded corners */
    cursor: pointer; /* Pointer cursor */
    font-size: 16px; /* Font size */
    margin-left: 10px; /* Spacing between buttons */
    margin-top: 10px; /* Spacing above button */
}

.cancel-btn:hover {
    background-color: #aaa; /* Darker gray on hover */
}
</style>
</body>
</html> 