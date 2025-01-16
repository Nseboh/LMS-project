<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Attendance</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        /* Modal Content Styles */
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%; /* Adjusted width for better fit */
            max-width: 500px; /* Max width for larger screens */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Subtle shadow */
        }

        /* Form Container */
        .form-container {
            display: flex;
            flex-direction: column; /* Stack elements vertically */
            gap: 15px; /* Space between form elements */
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
        input[type="date"],
        input[type="time"],
        textarea {
            padding: 10px; /* Padding for inputs */
            border: 1px solid #ccc; /* Light border */
            border-radius: 4px; /* Rounded corners */
            font-size: 16px; /* Font size */
            width: 100%; /* Full width */
            transition: border-color 0.3s; /* Smooth transition */
        }

        input[type="text"]:focus,
        input[type="date"]:focus,
        input[type="time"]:focus,
        textarea:focus {
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
    <script>
        function closeAddUserModal() {
            document.getElementById('addUserModal').style.display = 'none';
        }

        // Automatically fill the patron ID when the barcode is scanned
        function handleBarcodeInput(event) {
            const scanIdInput = document.getElementById('scanId');
            scanIdInput.value = event.target.value; // Set the scanned value
        }
    </script>
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddUserModal()">&times;</span>
        <div class="form-container">
            <h1>Add New Attendance</h1>
            <form id="addAttendanceForm" action="<%= request.getContextPath() %>/views/admin/attendance/process_addAttendance.jsp" method="POST">
                <div class="form-group">
                    <label for="scanId">Scan ID*</label>
                    <input type="text" id="scanId" name="scanId" placeholder="Scan Patron Barcode" oninput="handleBarcodeInput(event)" required>
                </div>
                <div class="form-group">
                    <label for="visitDate">Visit Date*</label>
                    <input type="date" id="visitDate" name="visitDate" value="<%= LocalDate.now() %>" required readonly>
                </div>
                <div class="form-group">
                    <label for="visitTimeIn">Time In*</label>
                    <input type="time" id="visitTimeIn" name="visitTimeIn" value="<%= LocalTime.now().toString().substring(0, 5) %>" required readonly>
                </div>
                <div class="form-group">
                    <label for="visitTimeOut">Time Out*</label>
                    <input type="time" id="visitTimeOut" name="visitTimeOut" value="18:00" required>
                </div>
                <div class="form-group">
                    <label for="remarks">Remarks*</label>
                    <textarea id="remarks" name="remarks" rows="4" placeholder="Enter any remarks..." required></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Submit</button>
                    <button type="button" class="cancel-btn" onclick="closeAddUserModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
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
</body>
</html> 