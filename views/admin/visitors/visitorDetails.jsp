<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visitor Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Full height for centering */
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px; /* Space below the heading */
        }
        .patron-details {
            background: white;
            padding: 20px; /* Adjusted padding */
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px; /* Space below the details */
        }
        .patron-details p {
            margin: 10px 0;
            font-size: 16px;
            color: #555;
        }
        .patron-details strong {
            color: #333;
        }
        .cancel-btn {
            display: block;
            width: auto; /* Change to auto for a smaller button */
            padding: 10px 20px; /* Adjust padding for a smaller button */
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            margin: 0 auto; /* Center the button */
        }
        .cancel-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Visitor Details</h1>
        <%
            String visitorId = request.getParameter("id");
            String firstName = "";
            String lastName = "";
            String contactNumber = "";
            String gender = "";
            String createdAt = "";
            String visitDate = "";
            String timeIn = "";
            String timeOut = "";
            String status = "";

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

                // Fetch visitor details
                String sqlVisitor = "SELECT * FROM visitor WHERE visitor_id = ?";
                pstmt = conn.prepareStatement(sqlVisitor);
                pstmt.setString(1, visitorId);
                ResultSet rsVisitor = pstmt.executeQuery();

                if (rsVisitor.next()) {
                    firstName = rsVisitor.getString("first_name");
                    lastName = rsVisitor.getString("last_name");
                    contactNumber = rsVisitor.getString("contact_number");
                    gender = rsVisitor.getString("gender");
                    createdAt = rsVisitor.getTimestamp("created_at").toString();
                }

                // Fetch visit details
                String sqlVisit = "SELECT * FROM visitorvisit WHERE visitor_id = ?";
                pstmt = conn.prepareStatement(sqlVisit);
                pstmt.setString(1, visitorId);
                ResultSet rsVisit = pstmt.executeQuery();

                if (rsVisit.next()) {
                    visitDate = rsVisit.getDate("visit_date").toString();
                    timeIn = rsVisit.getTime("time_in").toString();
                    timeOut = rsVisit.getTime("time_out") != null ? rsVisit.getTime("time_out").toString() : "N/A";
                }

                // Fetch visit status
                String sqlStatus = "SELECT * FROM visitstatus WHERE visit_id = (SELECT visit_id FROM visitorvisit WHERE visitor_id = ? ORDER BY visit_date DESC LIMIT 1)";
                pstmt = conn.prepareStatement(sqlStatus);
                pstmt.setString(1, visitorId);
                ResultSet rsStatus = pstmt.executeQuery();

                if (rsStatus.next()) {
                    status = rsStatus.getString("status");
                }

                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

        <div class="visitor-info">
            <h2>Visitor Information</h2>
            <p><strong>Full Name:</strong> <%= firstName + " " + lastName %></p>
            <p><strong>Contact Number:</strong> <%= contactNumber %></p>
            <p><strong>Gender:</strong> <%= gender %></p>
            <p><strong>Created At:</strong> <%= createdAt %></p>
        </div>

        <div class="actions">
            <button class="cancel-btn" onclick="window.location.href='<%= request.getContextPath() %>/views/visitors/visitor.jsp'">Back to Visitors</button>
        </div>
    </div>
</body>
</html> 