<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String patronId = request.getParameter("patronId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String gender = request.getParameter("gender");
    String address = request.getParameter("address");
    String contact = request.getParameter("contact");
    String status = request.getParameter("status");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        conn.setAutoCommit(false); // Start transaction

        // Get current status and expiration date
        String checkStatus = "SELECT status, expiration_date FROM patronmembership WHERE patron_id = ?";
        pstmt = conn.prepareStatement(checkStatus);
        pstmt.setString(1, patronId);
        rs = pstmt.executeQuery();
        
        String currentStatus = "";
        Date currentExpiration = null;
        if (rs.next()) {
            currentStatus = rs.getString("status");
            currentExpiration = rs.getDate("expiration_date");
        }

        // Update patron details
        String sql = "UPDATE patron SET first_name = ?, last_name = ?, gender = ? WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, gender);
        pstmt.setString(4, patronId);
        int patronUpdate = pstmt.executeUpdate();
        System.out.println("Patron update rows affected: " + patronUpdate);

        // Update patron contact details
        String sqlContact = "UPDATE patroncontact SET address = ?, phone = ? WHERE patron_id = ?";
        pstmt = conn.prepareStatement(sqlContact);
        pstmt.setString(1, address);
        pstmt.setString(2, contact);
        pstmt.setString(3, patronId);
        int contactUpdate = pstmt.executeUpdate();
        System.out.println("Contact update rows affected: " + contactUpdate);

        // Handle membership status and renewal
        String sqlMembership;
        if (currentStatus.equals("Expired") && status.equals("Active")) {
            // If renewing from expired to active, extend expiration date by 3 months
            sqlMembership = "UPDATE patronmembership SET status = ?, expiration_date = DATE_ADD(IFNULL(expiration_date, CURDATE()), INTERVAL 3 MONTH) WHERE patron_id = ?";
        } else {
            sqlMembership = "UPDATE patronmembership SET status = ? WHERE patron_id = ?";
        }
        
        pstmt = conn.prepareStatement(sqlMembership);
        pstmt.setString(1, status);
        pstmt.setString(2, patronId);
        int membershipUpdate = pstmt.executeUpdate();
        System.out.println("Membership update rows affected: " + membershipUpdate);

        conn.commit(); // Commit transaction
        session.setAttribute("success_message", "Patron updated successfully!");
        response.sendRedirect("patron.jsp");

    } catch (SQLException sqlEx) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        sqlEx.printStackTrace();
        session.setAttribute("error_message", "SQL Error: " + sqlEx.getMessage());
        response.sendRedirect("editPatron.jsp?id=" + patronId);
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
        session.setAttribute("error_message", "An unexpected error occurred: " + e.getMessage());
        response.sendRedirect("editPatron.jsp?id=" + patronId);
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
