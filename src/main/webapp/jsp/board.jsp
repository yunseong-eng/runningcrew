<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="runningcrew.BoardDTO" %>
<%@ page import="runningcrew.BoardDAO" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f4f4;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background-color: #333; /* index.html의 상단 색상과 동일하게 설정 */
            color: white;
            padding: 20px;
            text-align: center;
        }

        h2 {
            margin: 0;
            font-size: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #333; /* 제목 색상과 동일하게 설정 */
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e9e9e9;
        }

        .link-group {
            text-align: center;
            margin-top: 20px;
        }

        .link-group a {
            color: #007BFF;
            text-decoration: none;
            font-weight: bold;
        }

        .link-group a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>회원정보</h2>
    </div>
    <div class="container">
        <%
            // 데이터베이스에서 게시판 목록을 가져오는 로직
            BoardDAO dao = new BoardDAO();
            List<BoardDTO> boardList = dao.getBoardList();

            if (boardList != null && !boardList.isEmpty()) {
                // 날짜 형식 포맷터
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        %>
        <table>
            <tr>
                <th>글번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>핸드폰 번호</th>
                <th>사는 지역</th>
                <th>작성 날짜</th>
            </tr>
            <%
                for (BoardDTO board : boardList) {
                    Timestamp logtime = board.getLogtime();
                    String formattedLogtime = (logtime != null) ? sdf.format(logtime) : "";
            %>
            <tr>
                <td><%= board.getSeq() %></td>
                <td><%= board.getId() %></td>
                <td><%= board.getName() %></td>
                <td><%= board.getPhoneNumber() %></td>
                <td><%= board.getLocation() %></td>
                <td><%= formattedLogtime %></td>
            </tr>
            <%
                }
            %>
        </table>
        <%
            } else {
                out.println("<p>게시판에 글이 없습니다.</p>");
            }
        %>
        <div class="link-group">
            <a href="../project/index.html">메인화면으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
