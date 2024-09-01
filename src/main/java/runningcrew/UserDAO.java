package runningcrew;

import java.sql.Connection; //DB 연결
import java.sql.PreparedStatement; //SQL문 실행
import java.sql.ResultSet; //SQL쿼리 결과처리
import java.sql.SQLException; //예외처리

public class UserDAO {
    private Connection conn;

    // Connection 객체를 인자로 받는 생성자
    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    // 사용자 등록 메서드
    public boolean insertUser(UserDTO user) throws SQLException {
        String sql = "INSERT INTO users (id, password, name, email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getId());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getName());
            stmt.setString(4, user.getEmail());
            return stmt.executeUpdate() > 0; //// SQL 쿼리를 실행하고 성공하면 true를 반환
        }
    }

    // 사용자 조회 메서드 (로그인 시 사용)
    public UserDTO getUser(String id, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ? AND password = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                UserDTO user = new UserDTO();
                user.setId(rs.getString("id"));
                user.setPassword(rs.getString("password"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                return user; // 설정된 UserDTO 객체를 반환합니다.
            }
        }
        return null;
    }

    // 아이디 중복 검사 메서드
    public boolean checkId(String id) throws SQLException {
        String sql = "SELECT id FROM users WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }
}
