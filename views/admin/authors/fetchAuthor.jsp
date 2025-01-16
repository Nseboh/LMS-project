<%@ page import="java.sql.*" %>
<%@ page contentType="application/json" %>

<%
    response.setContentType("application/json");
    StringBuilder jsonData = new StringBuilder();
    jsonData.append("[");
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lms", "root", "Righteous050598$");
        
        String sql = "SELECT * FROM author ORDER BY created_at DESC";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        
        boolean first = true;
        while (rs.next()) {
            if (!first) jsonData.append(",");
            first = false;
            
            jsonData.append("{")
                   .append("\"id\":\"").append(rs.getInt("author_id")).append("\",")
                   .append("\"name\":\"").append(rs.getString("first_name") + " " + rs.getString("last_name")).append("\",")
                   .append("\"isbn\":\"").append(rs.getString("isbn")).append("\",")
                   .append("\"nationality\":\"").append(rs.getString("nationality")).append("\",")
                   .append("\"email\":\"").append(rs.getString("email")).append("\",")
                   .append("\"created_at\":\"").append(rs.getString("created_at")).append("\",");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    jsonData.append("]");
    out.println(jsonData.toString());
%>  