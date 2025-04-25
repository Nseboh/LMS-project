<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patronId = request.getParameter("id");
    String fullName = "";
    String contactNumber = "";
    String address = "";
    String gender = "";
    Date dateJoined = null;
    Date expirationDate = null;
    String status = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Fetch patron details
        String sql = "SELECT p.patron_id, p.first_name, p.last_name, pc.address, pc.phone AS contact, " +
                     "pm.date_joined, pm.expiration_date, pm.status, p.gender " +
                     "FROM patron p " +
                     "LEFT JOIN patroncontact pc ON p.patron_id = pc.patron_id " +
                     "LEFT JOIN patronmembership pm ON p.patron_id = pm.patron_id " +
                     "WHERE p.patron_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, patronId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            fullName = rs.getString("first_name") + " " + rs.getString("last_name");
            contactNumber = rs.getString("contact");
            address = rs.getString("address");
            gender = rs.getString("gender");
            dateJoined = rs.getDate("date_joined");
            expirationDate = rs.getDate("expiration_date");
            status = rs.getString("status");
        } else {
            session.setAttribute("error_message", "Patron not found.");
            response.sendRedirect("patron.jsp");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("error_message", "Error fetching patron details: " + e.getMessage());
        response.sendRedirect("patron.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("patron.jsp");
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
    <title>Patron Details</title>
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
        <h1>Patron Details</h1>
        <div class="patron-details">
            <p><strong>Full Name:</strong> <%= fullName %></p>
            <p><strong>Contact Number:</strong> <%= contactNumber %></p>
            <p><strong>Address:</strong> <%= address %></p>
            <p><strong>Gender:</strong> <%= gender %></p>
            <p><strong>Date Joined:</strong> <%= dateJoined != null ? dateJoined.toString() : "N/A" %></p>
            <p><strong>Expiration Date:</strong> <%= expirationDate != null ? expirationDate.toString() : "N/A" %></p>
            <p><strong>Status:</strong> <%= status %></p>
        </div>
        <button onclick="window.location.href='lending.jsp'" class="cancel-btn" style="background-color:rgb(201, 43, 43);">Back</button>
    </div>
</body>
</html>