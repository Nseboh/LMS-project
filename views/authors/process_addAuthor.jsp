<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.annotation.*" %>

<%
    String authorId = request.getParameter("author_id"); // Retrieve the staff ID
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String dateOfBirth = request.getParameter("date_of_birth");
    String nationality = request.getParameter("nationality");
    String biography = request.getParameter("biography");
    String email = request.getParameter("email");
    String website = request.getParameter("website");
    String imagePath = ""; // Variable to hold the image path

    // Handle file upload
    try {
        // Ensure the request is of type multipart/form-data
        if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
            Part filePart = request.getPart("image_url"); // Retrieves <input type="file" name="image_url">
            if (filePart != null) { // Check if filePart is not null
                String fileName = filePart.getSubmittedFileName();
                String uploadPath = application.getRealPath("/") + "uploads/" + fileName; // Define your upload path
                filePart.write(uploadPath); // Save the file

                // Insert into database
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
                String sql = "INSERT INTO authors (author_id, first_name, last_name, date_of_birth, nationality, biography, email, website, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, authorId); // Set the  ID
                pstmt.setString(2, firstName);
                pstmt.setString(3, lastName);
                pstmt.setString(4, dateOfBirth);
                pstmt.setString(5, nationality);
                pstmt.setString(6, biography);
                pstmt.setString(7, email);
                pstmt.setString(8, website);
                pstmt.setString(9, "uploads/" + fileName); // Store the relative path in the database
                pstmt.executeUpdate();
                conn.close();
                response.sendRedirect("author.jsp"); // Redirect to the author list or another page
            } else {
                throw new ServletException("File part is null. Please ensure a file is selected.");
            }
        } else {
            throw new ServletException("Request is not multipart, please check your form.");
        }
    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        // Optionally, set an error message in the session to display on the form page
        session.setAttribute("error_message", "Database error: " + sqlEx.getMessage());
        response.sendRedirect("addAuthor.jsp"); // Redirect back to the form
    } catch (Exception e) {
        e.printStackTrace();
        // Optionally, set an error message in the session to display on the form page
        session.setAttribute("error_message", "Error: " + e.getMessage());
        response.sendRedirect("addAuthor.jsp"); // Redirect back to the form
    }
%> 