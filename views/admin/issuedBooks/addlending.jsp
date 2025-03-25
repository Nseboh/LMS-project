<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lended Books</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="modal-content">
        <span class="close" onclick="closeAddlendingModal()">&times;</span>
        <div class="form-container">
            <h1>Lended Book</h1>
            <form id="addlendingForm" action="processAddLending.jsp" method="POST">
                <div class="form-group">
                    <label for="isbn">ISBN/ISSN:</label>
                    <input type="text" id="isbn" name="isbn" required placeholder="Enter ISBN/ISSN">
                </div>
                <div class="form-group">
                    <label for="patron_id">Patron:</label>
                    <select id="patron_id" name="patron_id" required>
                        <option value="">Select Patron</option>
                        <%
                            // Fetch patrons from the database
                            String dbUrl = "jdbc:mysql://localhost:3306/lms";
                            String dbUser = "root";
                            String dbPassword = "Righteous050598$";
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT patron_id, CONCAT(first_name, ' ', last_name) AS full_name FROM patron");

                                while (rs.next()) {
                                    String patronId = rs.getString("patron_id");
                                    String fullName = rs.getString("full_name");
                        %>
                        <option value="<%= patronId %>"><%= fullName %></option>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="DateIssued">Date Issued:</label>
                    <input type="date" id="DateIssued" name="DateIssued" value="<%= LocalDate.now() %>" required readonly>
                </div>
                <div class="form-group">
                    <label for="DateDue">Date Due:</label>
                    <input type="date" id="DateDue" name="DateDue" required>
                </div>
                <div class="form-group">
                    <label for="copiesIssued">Copies Issued:</label>
                    <input type="number" id="copiesIssued" name="copiesIssued" required placeholder="Enter number of copies">
                </div>
                <div class="form-group">
                    <label for="remarks">Remarks:</label>
                    <select id="remarks" name="remarks" required>
                        <option value="No special conditions">No Special Conditions</option>
                        <option value="Book returned late">Book Returned Late</option>
                        <option value="Book damaged">Book Damaged</option>
                        <option value="Extension granted">Extension Granted</option>
                        <option value="Reserved by another patron">Reserved By Another Patron</option>
                        <option value="Book lost">Book Lost</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status" required>
                        <option value="available">Available</option>
                        <option value="issued">Issued</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="submit-btn">Lend Book</button>
                    <button type="button" class="cancel-btn" onclick="closeAddlendingModal()">Cancel</button>
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