<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");
    String dbUrl = "jdbc:mysql://localhost:3306/lms";
    String dbUser = "root";
    String dbPassword = "Righteous050598$";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        
        // Start transaction
        conn.setAutoCommit(false);

        try {
            // First delete from visitstatus table
            String sqlStatus = "DELETE FROM visitstatus WHERE visitor_id = ?";
            pstmt = conn.prepareStatement(sqlStatus);
            pstmt.setString(1, visitorId);
            pstmt.executeUpdate();

            // Then delete from visitorvisit table
            String sqlVisit = "DELETE FROM visitorvisit WHERE visitor_id = ?";
            pstmt = conn.prepareStatement(sqlVisit);
            pstmt.setString(1, visitorId);
            pstmt.executeUpdate();

            // Finally delete from visitor table
            String sqlVisitor = "DELETE FROM visitor WHERE visitor_id = ?";
            pstmt = conn.prepareStatement(sqlVisitor);
            pstmt.setString(1, visitorId);
            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
                // Commit the transaction if successful
                conn.commit();
                session.setAttribute("success_message", "Visitor deleted successfully!");
            } else {
                // Rollback if no rows were deleted
                conn.rollback();
                session.setAttribute("error_message", "Error deleting visitor. Visitor may not exist.");
            }
        } catch (SQLException e) {
            // Rollback on error
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        }

        response.sendRedirect("visitor.jsp");

    } catch (SQLException sqlEx) {
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("visitor.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred.");
        response.sendRedirect("visitor.jsp");
    } finally {
        try {
            // Reset auto-commit to default
            if (conn != null) {
                conn.setAutoCommit(true);
            }
            
            // Close all resources
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>