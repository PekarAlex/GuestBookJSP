package guestbook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class User {
    private String userName, password;
    private Boolean admin;
    private int id;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String username) {
        this.userName = username;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Boolean getAdmin() {
        return admin;
    }

    public void setAdmin(Boolean admin) {
        this.admin = admin;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public static User register(String userName, String password) {
        User u;
        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO users (userName,admin,password) VALUES(?,?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, userName);
            ps.setBoolean(2, false);
            ps.setString(3, password);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            u = new User();
            u.setUserName(userName);
            u.setPassword(password);
            u.setAdmin(false);
            u.setId(rs.getInt(1));
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return u;
    }

    public static User get(String userName) {
        User u = null;
        try (Connection con = ConnectionProvider.getCon()) {

            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE (userName=?)");
            ps.setString(1, userName);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = new User();
                u.setUserName(userName);
                u.setPassword(rs.getString("password"));
                u.setAdmin(rs.getBoolean("admin"));
                u.setId(rs.getInt("id"));
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return u;
    }


}