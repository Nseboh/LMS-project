<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Visitor</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script>
        function checkVisitorId() {
            const visitorId = document.getElementById('visitorId').value;
            if (visitorId) {
                fetch(`<%= request.getContextPath() %>/views/visitors/getVisitorDetails.jsp?id=${visitorId}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data) {
                            document.getElementById('firstName').value = data.firstName;
                            document.getElementById('lastName').value = data.lastName;
                            document.getElementById('contactNumber').value = data.contactNumber;
                            document.getElementById('email').value = data.email;
                            document.getElementById('gender').value = data.gender;
                            document.getElementById('status').value = data.status;
                            document.getElementById('timeOut').value = data.timeOut; // Optional
                        } else {
                            // Clear fields if visitor not found
                            document.getElementById('firstName').value = '';
                            document.getElementById('lastName').value = '';
                            document.getElementById('contactNumber').value = '';
                            document.getElementById('email').value = '';
                            document.getElementById('gender').value = 'Male'; // Default
                            document.getElementById('status').value = 'Pending'; // Default
                            document.getElementById('timeOut').value = ''; // Clear time out
                        }
                    })
                    .catch(error => console.error('Error fetching visitor details:', error));
            }
        }
    </script>
</head>
<body>
    <div class="modal-content">
        <h1>Add Visitor</h1>
        <form id="addVisitorForm" action="<%= request.getContextPath() %>/views/visitors/process_addVisitor.jsp" method="POST">
            <div class="form-group">
                <label for="visitorId">Visitor ID*</label>
                <input type="text" id="visitorId" name="visitorId" required onblur="checkVisitorId()">
            </div>
            <div class="form-group">
                <label for="firstName">First Name*</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name*</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            <div class="form-group">
                <label for="contactNumber">Contact*</label>
                <input type="tel" id="contactNumber" name="contactNumber" required>
            </div>
            <div class="form-group">
                <label for="email">Email*</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="gender">Gender*</label>
                <select id="gender" name="gender" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="form-group">
                <label for="timeOut">Time Out (optional)</label>
                <input type="time" id="timeOut" name="timeOut">
            </div>
            <div class="form-group">
                <label for="status">Status*</label>
                <select id="status" name="status" required>
                    <option value="Pending">Pending</option>
                    <option value="Approved">Approved</option>
                    <option value="Rejected">Rejected</option>
                    <option value="Completed">Completed</option>
                </select>
            </div>
            <div class="form-group">
                <label for="remarks">Remarks (optional)</label>
                <input type="text" id="remarks" name="remarks" maxlength="255">
            </div>
            <div class="form-actions">
                <button type="submit" class="submit-btn">Add Visitor</button>
                <button type="button" class="cancel-btn" onclick="closeAddVisitorModal()">Cancel</button>
            </div>
        </form>
    </div>
</body>
</html> 