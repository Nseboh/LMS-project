<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patronId = request.getParameter("id");
    String firstName = "";
    String lastName = "";
    String address = "";
    String email = "";
    String contact = "";
    String emergencyContact = "";
    String membershipType = "";
    String gender = "";
    String status = "";
    String age = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch patron details
        String sql = "SELECT p.first_name, p.last_name, p.age, p.gender, pc.address, pc.phone, pc.email, pc.emergency_contact, pm.membership_type, pm.status " +
                     "FROM patron p " +
                     "LEFT JOIN patroncontact pc ON p.patron_id = pc.patron_id " +
                     "LEFT JOIN patronmembership pm ON p.patron_id = pm.patron_id " +
                     "WHERE p.patron_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, patronId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            age = rs.getString("age");
            gender = rs.getString("gender");
            address = rs.getString("address");
            contact = rs.getString("phone");
            email = rs.getString("email");
            emergencyContact = rs.getString("emergency_contact");
            membershipType = rs.getString("membership_type");
            status = rs.getString("status");
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
    <title>Edit Patron</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <h1>Edit Patron</h1>
        <form  id="addUserForm" action="<%= request.getContextPath() %>/views/patron/process_editPatron.jsp" method="POST">
            <input type="hidden" name="patronId" value="<%= patronId %>">
            <div class="form-group">
                <label for="firstName">First Name*</label>
                <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name*</label>
                <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required>
            </div>
            <div class="form-group">
                <label for="age">Age*</label>
                <input type="text" id="age" name="age" value="<%= age %>" required>
            </div>
            <div class="form-group">
                <label for="gender">Gender*</label>
                <select id="gender" name="gender" required>
                    <option value="Male" <%= gender.equals("Male") ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= gender.equals("Female") ? "selected" : "" %>>Female</option>
                </select>
            </div>
            <div class="form-group">
                <label for="address">Address*</label>
                <input type="text" id="address" name="address" value="<%= address %>" required>
            </div>
            <div class="form-group">
                <label for="contact">Contact*</label>
                <input type="tel" id="contact" name="contact" value="<%= contact %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="emergencyContact">Emergency Contact*</label>
                <input type="tel" id="emergencyContact" name="emergencyContact" value="<%= emergencyContact %>" required>
            </div>
            <div class="form-group">
                <label for="membershipType">Membership Type*</label>
                <select id="membershipType" name="membershipType" required>
                    <option value="Standard" <%= membershipType.equals("Standard") ? "selected" : "" %>>Standard</option>
                    <option value="Premium" <%= membershipType.equals("Premium") ? "selected" : "" %>>Premium</option>
                    <option value="VIP" <%= membershipType.equals("VIP") ? "selected" : "" %>>VIP</option>
                </select>
            </div>
            <div class="form-group">
                <label for="status">Status*</label>
                <select id="status" name="status" required>
                    <option value="Active" <%= status.equals("Active") ? "selected" : "" %>>Active</option>
                    <option value="Inactive" <%= status.equals("Inactive") ? "selected" : "" %>>Inactive</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Update Patron</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/patron/patron.jsp'">Cancel</button>
            </div>
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