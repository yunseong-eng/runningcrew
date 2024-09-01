package runningcrew;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe"; // DB URL
    private static final String USER = "hr"; // DB 사용자명
    private static final String PASSWORD = "hr"; // DB 비밀번호
    private static final String DRIVER_CLASS = "oracle.jdbc.driver.OracleDriver"; // Oracle JDBC 드라이버

    public BoardDAO() {
        try {
            // JDBC 드라이버 로드
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("JDBC 드라이버를 찾을 수 없습니다.");
        }
    }

    // 사용자 ID로 이름을 조회하는 메서드
    private String getUserNameById(String id) {
        String name = null;
        String sql = "SELECT name FROM users WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("getUserNameById 메서드에서 오류 발생: " + e.getMessage());
        }

        return name;
    }

    // 게시글 등록 메서드
    public boolean insertBoard(BoardDTO dto) throws SQLException {
        String sql = "INSERT INTO board (id, name, phone_number, location, logtime) " +
                     "VALUES (?, ?, ?, ?, SYSDATE)";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            // ID로 이름을 가져옵니다.
            String userName = getUserNameById(dto.getId());

            pstmt.setString(1, dto.getId());
            pstmt.setString(2, userName); // 가져온 이름을 사용
            pstmt.setString(3, dto.getPhoneNumber());
            pstmt.setString(4, dto.getLocation());

            return pstmt.executeUpdate() > 0;
        }
    }

    // 게시판 목록을 가져오는 메서드
    public List<BoardDTO> getBoardList() throws SQLException {
        List<BoardDTO> list = new ArrayList<>();
        String sql = "SELECT seq, id, name, phone_number, location, logtime FROM board ORDER BY seq DESC";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                BoardDTO dto = new BoardDTO();
                dto.setSeq(rs.getInt("seq"));
                dto.setId(rs.getString("id"));
                dto.setName(rs.getString("name"));
                dto.setPhoneNumber(rs.getString("phone_number"));
                dto.setLocation(rs.getString("location"));
                dto.setLogtime(rs.getTimestamp("logtime"));
                list.add(dto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("getBoardList 메서드에서 오류 발생: " + e.getMessage());
        }

        return list;
    }

    // 특정 게시글 조회 메서드 (예: 상세보기)
    public BoardDTO getBoard(int seq) throws SQLException {
        String sql = "SELECT seq, id, name, phone_number, location, logtime FROM board WHERE seq = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, seq);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BoardDTO dto = new BoardDTO();
                    dto.setSeq(rs.getInt("seq"));
                    dto.setId(rs.getString("id"));
                    dto.setName(rs.getString("name"));
                    dto.setPhoneNumber(rs.getString("phone_number"));
                    dto.setLocation(rs.getString("location"));
                    dto.setLogtime(rs.getTimestamp("logtime"));
                    return dto;
                }
            }
        }

        return null;
    }
}
