<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeParseException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String attendanceId = request.getParameter("id");
    String patronId = "";
    String fullName = "";
    String visitDate = "";
    String timeIn = "";
    String timeOut = "";
    String remarks = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        // Retrieve attendance record based on attendance_id
        String sql = "SELECT a.patron_id, p.first_name, p.last_name, a.visit_date, a.visit_time_in, a.visit_time_out, a.remarks " +
                     "FROM attendances a JOIN patron p ON a.patron_id = p.patron_id WHERE a.attendance_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, attendanceId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            patronId = rs.getString("patron_id");
            fullName = rs.getString("first_name") + " " + rs.getString("last_name");
            visitDate = rs.getDate("visit_date").toString();
            timeIn = rs.getTime("visit_time_in").toString();
            timeOut = rs.getTime("visit_time_out") != null ? rs.getTime("visit_time_out").toString() : "";
            remarks = rs.getString("remarks");
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
    <title>Edit Attendance</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <h1>Edit Attendance</h1>
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
        <form id="editAttendanceForm" action="<%= request.getContextPath() %>/views/admin/attendance/process_editAttendance.jsp" method="POST">
            <input type="hidden" name="attendanceId" value="<%= attendanceId %>">
            <div class="form-group">
                <label for="visitDate">Visit Date*</label>
                <input type="date" id="visitDate" name="visitDate" value="<%= visitDate %>" required>
            </div>
            <div class="form-group">
                <label for="timeIn">Time In*</label>
                <input type="time" id="timeIn" name="timeIn" value="<%= timeIn %>" required>
            </div>
            <div class="form-group">
                <label for="timeOut">Time Out (when leaving the library)</label>
                <input type="time" id="timeOut" name="timeOut" value="<%= timeOut %>">
            </div>
            <div class="form-group">
                <label for="remarks">Remarks*</label>
                <textarea id="remarks" name="remarks" rows="4" required><%= remarks %></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Save</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/admin/attendance/attendance.jsp'">Cancel</button>
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