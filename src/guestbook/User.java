package guestbook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class User {
    private String userName,password;
    private int isadmin;
    private int id;

    public User() {
    }

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

    public int getIsadmin() {
        return isadmin;
    }

    public void setIsadmin(int isadmin) {
        this.isadmin = isadmin;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void registerUser(){
        try (Connection con=ConnectionProvider.getCon()) {
            PreparedStatement ps=con.prepareStatement("insert into users (UserName,IsAdmin,Password) values(?,?,?)", PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, this.getUserName());
            ps.setInt(2, this.getIsadmin());
            ps.setString(3,this.getPassword());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            this.setId(rs.getInt(1));


        } catch(SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean logonUser(){
        boolean status=false;
        try(Connection con=ConnectionProvider.getCon()){

            PreparedStatement ps=con.prepareStatement("SELECT * From users WHERE (UserName=?)");
            ps.setString(1, this.getUserName());

            ResultSet rs=ps.executeQuery();

            if (rs.next()) {
                if (this.getPassword().equals(rs.getString("Password"))) {
                    this.setId(rs.getInt("Id"));
                    this.setIsadmin(rs.getInt("IsAdmin"));
                    status = true;
                }
            }


        }catch(SQLException e){throw new RuntimeException(e);}

        return status;
    }

}