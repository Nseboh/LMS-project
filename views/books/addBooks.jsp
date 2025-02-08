<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .navbar {
            background-color: #007BFF;
            padding: 10px;
            color: white;
            text-align: center;
        }
        .navbar a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
        }
        .form-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            max-width: 900px;
            margin: auto;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }
        label {
            font-weight: bold;
            margin-bottom: 5px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .status-group {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .buttons {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .cancel-btn {
            background: #ccc;
        }
        .add-btn {
            background: purple;
            color: white;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h1>Add New Book</h1>
    <form id="addBookForm" action="<%= request.getContextPath() %>/views/books/process_addBook.jsp" method="POST">
        <div class="form-group">
            <label>Book Title *</label>
            <input type="text" name="title" required placeholder="Book name here">
        </div>
        <div class="form-group">
            <label>Author(s) *</label>
            <select name="authorId" required>
                <option value="">Select from list</option>
                <%
                    // Fetch authors from the database
                    String dbURL = "jdbc:mysql://localhost:3306/lms";
                    String dbUser = "root";
                    String dbPassword = "Righteous050598$"; // Updated database password

                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                        stmt = conn.createStatement();
                        String sql = "SELECT author_id, CONCAT(first_name, ' ', last_name) AS full_name FROM author";
                        rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            String authorId = rs.getString("author_id");
                            String fullName = rs.getString("full_name");
                %>
                <option value="<%= authorId %>"><%= fullName %></option>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                    }
                %>
            </select>
        </div>
        <div class="form-group">
            <label>ISBN/ISSN *</label>
            <input type="text" name="isbn" required placeholder="Enter ISBN/ISSN">
        </div>
        <div class="form-group">
            <label>Genre/Category *</label>
            <select name="genre" required>
                <option value="">Choose a Category</option>
                <option value="Fiction">Fiction</option>
                <option value="Non-Fiction">Non-Fiction</option>
                <option value="Science">Science</option>
                <option value="Romance">Romance</option>
                <option value="History">History</option>
                <option value="Fantasy">Fantasy</option>
                <option value="Biography">Biography</option>
                <option value="Design">Design</option>
            </select>
        </div>
        <div class="form-group">
            <label>Language *</label>
            <select name="language" required>
                <option value="">Select from list</option>
                <option value="English">English</option>
                <option value="Tamil">Tamil</option>
                <option value="Hindi">Hindi</option>
                <option value="Spanish">Spanish</option>
            </select>
        </div>
        <div class="form-group">
            <label>Available Copies *</label>
            <input type="number" name="availableCopies" required placeholder="Enter available copies">
        </div>
        <div class="form-group">
            <label>Total Copies *</label>
            <input type="number" name="totalCopies" required placeholder="Enter no of Copies">
        </div>
        <div class="form-group">
            <label>Floor *</label>
            <select name="floor" required>
                <option value="">Select from list</option>
                <!-- Add floor options as needed -->
            </select>
        </div>
        <div class="form-group">
            <label>Shelf/Location Code</label>
            <input type="text" name="shelfLocation" placeholder="Enter shelf location code">
        </div>
        <div class="form-group">
            <label>Total no of Pages *</label>
            <input type="number" name="totalPages" required placeholder="10 to 10,000">
        </div>
        <div class="form-group">
            <label>Status *</label>
            <div class="status-group">
                <label><input type="radio" name="status" value="Available" required> Available</label>
                <label><input type="radio" name="status" value="Reserved"> Reserved</label>
                <label><input type="radio" name="status" value="Out of Stock"> Out of Stock</label>
            </div>
        </div>
        <div class="form-group">
            <label>File Attachment</label>
            <div class="file-upload">
                <button type="button">Choose a file</button>
            </div>
        </div>
        <h2>Features Information</h2>
        <div class="form-group">
            <label>Book Features *</label>
            <select name="bookFeatures" required>
                <option>Select from list</option>
                <option value="Hardcover">Hardcover</option>
                <option value="Paperback">Paperback</option>
                <option value="E-book">E-book</option>
            </select>
        </div>
        <div class="form-group">
            <label>Book Volume</label>
            <select name="bookVolume">
                <option>Select from list</option>
            </select>
        </div>
        <div class="form-group">
            <label>Published Year</label>
            <input type="text" name="publishedYear" placeholder="YYYY">
        </div>
        <div class="form-group">
            <label>QR Code Generation</label>
            <input type="text" name="qrCode" value="Random Generated QR" readonly>
        </div>
        <div class="form-group">
            <label>Book Published Date</label>
            <input type="date" name="bookPublishedDate">
        </div>
        <div class="form-group">
            <label>Moral of the Book *</label>
            <input type="text" name="moralOfTheBook" required placeholder="Book name here">
        </div>
        <div class="buttons">
            <button type="button" class="cancel-btn" onclick="window.location.href='books.jsp'">Cancel</button>
            <button type="submit" class="add-btn">Add Book</button>
        </div>
    </form>
</div>

</body>
</html>