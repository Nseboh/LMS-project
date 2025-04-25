<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String visitorId = request.getParameter("id");
    String jsonResponse = "{}"; // Default response

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");

        String sql = "SELECT first_name, last_name, contact_number, gender, status, time_out FROM visitor WHERE visitor_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, visitorId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            jsonResponse = String.format(
                "{\"firstName\":\"%s\", \"lastName\":\"%s\", \"contactNumber\":\"%s\", \"gender\":\"%s\", \"status\":\"%s\", \"timeOut\":\"%s\"}",
                rs.getString("first_name"),
                rs.getString("last_name"),
                rs.getString("contact_number"),
                rs.getString("gender"),
                rs.getString("status"),
                rs.getTime("time_out") != null ? rs.getTime("time_out").toString() : null
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }

    response.getWriter().write(jsonResponse);
%> 