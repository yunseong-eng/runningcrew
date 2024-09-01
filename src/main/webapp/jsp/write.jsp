<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
    <style>
        /* 스타일 설정은 기존과 동일 */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        .write-background {
            background-image: url('../image/board.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .write-background::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.8);
            z-index: -1;
        }

        .centered-form {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            position: relative;
            z-index: 1;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 1rem;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 0.5rem;
        }

        input {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn-submit {
            background-color: #345159;
            color: white;
            border: none;
            padding: 0.5rem;
            width: 100%;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            background-color: #FF895A;
        }

        .link-group {
            text-align: center;
            margin-top: 20px;
        }

        .link-group a {
            color: #007BFF;
            text-decoration: none;
        }

        .link-group a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body class="write-background">
    <%
		// 클라이언트로부터 전달받은 데이터의 인코딩을 UTF-8로 설정합니다.
		request.setCharacterEncoding("UTF-8");
        // 세션에서 userId를 가져옵니다.
        String userId = (String) session.getAttribute("userId");

        // 로그인 상태를 확인합니다.
        if (userId == null || userId.isEmpty()) {
            // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
            response.sendRedirect("../project/login.html");
            return;
        }

        // 폼이 제출된 경우 데이터베이스에 저장
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String phoneNumber = request.getParameter("phoneNumber");
            String location = request.getParameter("location");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // JDBC 드라이버 로드 및 데이터베이스 연결
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");

                String sql = "INSERT INTO board (id, name, phone_number, location, logtime) VALUES (?, (SELECT name FROM users WHERE id = ?), ?, ?, SYSDATE)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userId);
                pstmt.setString(2, userId); // DB에서 사용자 이름을 조회하여 삽입
                pstmt.setString(3, phoneNumber);
                pstmt.setString(4, location);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    // 글 작성에 성공한 경우 board.jsp로 이동
                    response.sendRedirect("board.jsp");
                } else {
                    out.println("<script>alert('글 작성에 실패했습니다. 다시 시도해 주세요.'); history.back();</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('오류가 발생했습니다.'); history.back();</script>");
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>
    <div class="centered-form">
        <h1>Thanks joining crew</h1>
        <form id="writeForm" method="post">
            <div class="input-group">
                <label for="phoneNumber">핸드폰 번호 :</label>
                <input type="text" id="phoneNumber" name="phoneNumber" required>
            </div>
            <div class="input-group">
                <label for="location">사는 지역 :</label>
                <input type="text" id="location" name="location" required>
            </div>
            <button type="submit" class="btn-submit">정보 저장을 완료합니다.</button>
        </form>
        <div class="link-group">
            <a href="../project/index.html">메인화면으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
