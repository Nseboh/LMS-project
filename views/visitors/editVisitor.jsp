<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");
    String fullName = "";
    String contactNumber = "";
    String email = "";
    String gender = "";
    String status = "";
    LocalDate visitDate = null;
    LocalTime timeIn = null;
    LocalTime timeOut = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM visitor WHERE visitor_id = ?");
        pstmt.setString(1, visitorId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("full_name");
            contactNumber = rs.getString("contact_number");
            email = rs.getString("email");
            gender = rs.getString("gender");
            status = rs.getString("status");
            visitDate = rs.getDate("visit_date").toLocalDate();
            timeIn = rs.getTime("time_in").toLocalTime();
            timeOut = rs.getTime("time_out") != null ? rs.getTime("time_out").toLocalTime() : null; // Handle null for time_out
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
        <form id="addVisitorForm" action="<%= request.getContextPath() %>/views/visitors/process_editVisitor.jsp" method="POST">
            <input type="hidden" name="id" value="<%= visitorId %>">
            <div class="form-group">
                <label for="fullName">Full Name*</label>
                <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required>
            </div>
            <div class="form-group">
                <label for="contactNumber">Contact Number*</label>
                <input type="text" id="contactNumber" name="contactNumber" value="<%= contactNumber %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="gender">Gender*</label>
                <select id="gender" name="gender" required>
                    <option value="Male" <%= "Male".equals(gender) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equals(gender) ? "selected" : "" %>>Female</option>
                </select>
            </div>
            <div class="form-group">
                <label for="visitDate">Visit Date*</label>
                <input type="date" id="visitDate" name="visitDate" value="<%= visitDate != null ? visitDate.toString() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="timeIn">Time In*</label>
                <input type="time" id="timeIn" name="timeIn" value="<%= timeIn != null ? timeIn.toString() : "" %>" required readonly>
            </div>
            <div class="form-group">
                <label for="timeOut">Time Out (when leaving the library)</label>
                <input type="time" id="timeOut" name="timeOut" value="<%= timeOut != null ? timeOut.toString() : "" %>">
            </div>
            <div class="form-group">
                <label for="status">Status*</label>
                <select id="status" name="status" required>
                    <option value="General Inquiry" <%= "General Inquiry".equals(status) ? "selected" : "" %>>General Inquiry</option>
                    <option value="Research" <%= "Research".equals(status) ? "selected" : "" %>>Research</option>
                    <option value="Book Borrowing" <%= "Book Borrowing".equals(status) ? "selected" : "" %>>Book Borrowing</option>
                    <option value="Book Return" <%= "Book Return".equals(status) ? "selected" : "" %>>Book Return</option>
                    <option value="Event" <%= "Event".equals(status) ? "selected" : "" %>>Event</option>
                    <option value="Other" <%= "Other".equals(status) ? "selected" : "" %>>Other</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Save</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">Cancel</button>
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