<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session.invalidate();
    // Redirect to the login page or home page
    response.sendRedirect("login.jsp"); // Change to your login page
%> 