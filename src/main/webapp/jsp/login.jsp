<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, runningcrew.UserDAO, runningcrew.UserDTO" %>

<%
    Connection conn = null;
    String id = request.getParameter("id");
    String password = request.getParameter("password");

    String message = "";
    boolean isLoginSuccess = false;

    if (id != null && password != null) {
        try {
            // JDBC 드라이버 로드 및 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");

            UserDAO dao = new UserDAO(conn);
            UserDTO user = dao.getUser(id, password);

            if (user != null) {
                isLoginSuccess = true;
                session.setAttribute("userId", user.getId());  // 로그인 성공 시 세션에 사용자 ID 저장
                
                // HTML을 출력하지 않고 단순히 "success" 문자열만 출력
                out.print("success");
                return;  // 응답을 끝냄
            } else {
                message = "로그인 실패! 아이디 또는 비밀번호를 확인하세요.";
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "시스템 오류가 발생했습니다.";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "로그인 오류가 발생했습니다.";
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    } else {
        message = "아이디와 비밀번호를 입력하세요.";
    }

    // 성공하지 못했을 경우 에러 메시지 출력
    response.setContentType("text/plain");
    response.getWriter().write(message);
%>
