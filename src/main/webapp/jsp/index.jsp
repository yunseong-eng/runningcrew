<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.html");
    } else {
        out.println("<p>환영합니다, " + userId + "님!</p>");
    }
%>
