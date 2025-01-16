<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String idParam = request.getParameter("id");
    int authorId = Integer.parseInt(idParam);
    String jsonResponse = "{}"; // Default empty JSON response

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM author WHERE author_id = ?");
        pstmt.setInt(1, authorId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            jsonResponse = "{"
                + "\"author_id\":\"" + rs.getInt("author_id") + "\","
                + "\"first_name\":\"" + rs.getString("first_name") + "\","
                + "\"last_name\":\"" + rs.getString("last_name") + "\","
                + "\"isbn\":\"" + rs.getString("isbn") + "\","
                + "\"nationality\":\"" + rs.getString("nationality") + "\","
                + "\"email\":\"" + rs.getString("email") + "\","
                + "\"created_at\":\"" + rs.getTimestamp("created_at") + "\""
                + "}";
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    response.getWriter().write(jsonResponse);
%> 