<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("visitorId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String contactNumber = request.getParameter("contactNumber");
    String gender = request.getParameter("gender");
    String timeOut = request.getParameter("timeOut"); // This can be null
    String timeIn = new java.sql.Time(System.currentTimeMillis()).toString(); // Automatically set current time as Time In
    String status = request.getParameter("status");
    String remarks = request.getParameter("remarks"); // New remarks field

    Connection conn = null;
    PreparedStatement pstmtVisitor = null;
    PreparedStatement pstmtVisit = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        // Check if the visitor already exists
        String sqlCheckVisitor = "SELECT COUNT(*) FROM visitor WHERE visitor_id = ?";
        pstmtVisitor = conn.prepareStatement(sqlCheckVisitor);
        pstmtVisitor.setString(1, visitorId);
        ResultSet rsCheck = pstmtVisitor.executeQuery();
        boolean visitorExists = false;
        if (rsCheck.next() && rsCheck.getInt(1) > 0) {
            visitorExists = true;
        }

        if (visitorExists) {
            // Insert visit details
            String sqlVisit = "INSERT INTO visitorvisit (visitor_id, visit_date, time_in, time_out) VALUES (?, CURDATE(), ?, ?)";
            pstmtVisit = conn.prepareStatement(sqlVisit, Statement.RETURN_GENERATED_KEYS);
            pstmtVisit.setString(1, visitorId);
            pstmtVisit.setString(2, timeIn);
            if (timeOut != null && !timeOut.isEmpty()) {
                pstmtVisit.setString(3, timeOut); // Manually input Time Out
            } else {
                pstmtVisit.setNull(3, java.sql.Types.TIME); // Set Time Out to null if not provided
            }
            pstmtVisit.executeUpdate();

            // Get the last inserted visit ID
            ResultSet generatedKeys = pstmtVisit.getGeneratedKeys();
            int lastVisitId = 0;
            if (generatedKeys.next()) {
                lastVisitId = generatedKeys.getInt(1);
            }

            // Insert status
            String sqlStatus = "INSERT INTO visitstatus (visitor_id, status, remarks) VALUES (?, ?, ?)";
            PreparedStatement pstmtStatus = conn.prepareStatement(sqlStatus);
            pstmtStatus.setString(1, visitorId); // Use the visitor ID
            pstmtStatus.setString(2, status);
            pstmtStatus.setString(3, remarks);
            pstmtStatus.executeUpdate();

            // Redirect to the visitor list with success message
            session.setAttribute("success_message", "Visitor visit recorded successfully!");
            response.sendRedirect("visitor.jsp");
        } else {
            // If the visitor does not exist, insert their details
            String sqlVisitor = "INSERT INTO visitor (visitor_id, first_name, last_name, contact_number, gender, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
            pstmtVisitor = conn.prepareStatement(sqlVisitor);
            pstmtVisitor.setString(1, visitorId);
            pstmtVisitor.setString(2, firstName);
            pstmtVisitor.setString(3, lastName);
            pstmtVisitor.setString(4, contactNumber);
            pstmtVisitor.setString(5, gender);
            pstmtVisitor.executeUpdate();

            // Insert visit details
            String sqlVisit = "INSERT INTO visitorvisit (visitor_id, visit_date, time_in, time_out) VALUES (?, CURDATE(), ?, ?)";
            pstmtVisit = conn.prepareStatement(sqlVisit, Statement.RETURN_GENERATED_KEYS);
            pstmtVisit.setString(1, visitorId);
            pstmtVisit.setString(2, timeIn);
            if (timeOut != null && !timeOut.isEmpty()) {
                pstmtVisit.setString(3, timeOut); // Manually input Time Out
            } else {
                pstmtVisit.setNull(3, java.sql.Types.TIME); // Set Time Out to null if not provided
            }
            pstmtVisit.executeUpdate();

            // Get the last inserted visit ID
            ResultSet generatedKeys = pstmtVisit.getGeneratedKeys();
            int lastVisitId = 0;
            if (generatedKeys.next()) {
                lastVisitId = generatedKeys.getInt(1);
            }

            // Insert status
            String sqlStatus = "INSERT INTO visitstatus (visitor_id, status, remarks) VALUES (?, ?, ?)";
            PreparedStatement pstmtStatus = conn.prepareStatement(sqlStatus);
            pstmtStatus.setString(1, visitorId); // Use the visitor ID
            pstmtStatus.setString(2, status);
            pstmtStatus.setString(3, remarks);
            pstmtStatus.executeUpdate();

            // Redirect to the visitor list with success message
            session.setAttribute("success_message", "Visitor added successfully!");
            response.sendRedirect("visitor.jsp");
        }

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("addVisitor.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("addVisitor.jsp");
    } finally {
        if (pstmtVisitor != null) try { pstmtVisitor.close(); } catch (SQLException e) {}
        if (pstmtVisit != null) try { pstmtVisit.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%> 