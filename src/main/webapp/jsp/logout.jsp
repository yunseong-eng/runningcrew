<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션을 무효화하여 로그아웃 처리
    session.invalidate();

    // 로그아웃 후 메인 페이지 또는 로그인 페이지로 리다이렉트
    response.sendRedirect("../project/login.html");
%>
