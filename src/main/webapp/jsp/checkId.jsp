<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %> 
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.DriverManager, java.sql.SQLException" %>
<%@ page import="runningcrew.UserDAO" %>

<%
    Connection conn = null;

    String id = request.getParameter("id");
    String result = "available";

    if (id != null && !id.isEmpty()) {
        try {
            // JDBC 드라이버 로드 및 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");

            UserDAO dao = new UserDAO(conn);
            if (dao.checkId(id)) {
                result = "exists";
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            result = "error";
        } catch (SQLException e) {
            e.printStackTrace();
            result = "error";
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }

    response.getWriter().write(result);
%>
