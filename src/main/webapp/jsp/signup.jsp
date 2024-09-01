<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.sql.*, runningcrew.UserDAO, runningcrew.UserDTO" %>

<%
    Connection conn = null;

    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    String message = "";
    boolean isSignupSuccess = false;

    if (id != null && password != null && name != null && email != null) {
        try {
            // JDBC 드라이버 로드 및 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");

            UserDAO dao = new UserDAO(conn);
            UserDTO user = new UserDTO();
            user.setId(id);
            user.setPassword(password);
            user.setName(name);
            user.setEmail(email);

            if (dao.checkId(id)) {
                message = "중복된 아이디입니다.";
            } else if (dao.insertUser(user)) {
                isSignupSuccess = true;
                message = "회원가입이 성공적으로 완료되었습니다.";
            } else {
                message = "회원가입에 실패하였습니다.";
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "시스템 오류가 발생했습니다.";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "중복된 아이디입니다.";
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    } else {
        message = "모든 정보를 입력하세요.";
    }

    // 성공 여부에 따라 response에 메시지 전달
    response.setContentType("text/plain");
    response.getWriter().write(isSignupSuccess ? "success" : message);
%>
