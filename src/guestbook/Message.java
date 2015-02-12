package guestbook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;


public class Message {

    private int id; //for cutting message from db
    private String userName;
    private String text;
    private Date created;

    static public ArrayList<Message> readMessages(int count, int offset) {
        try (Connection con = ConnectionProvider.getCon()) {

            PreparedStatement ps = con.prepareStatement("SELECT guestmessages.id,userName,guestmessages.text,createStamp FROM guestmessages LEFT JOIN users ON guestmessages.user_Id=users.Id ORDER BY createStamp DESC LIMIT ? OFFSET ?");
            ps.setInt(1, count);
            ps.setInt(2, offset);

            ResultSet rs = ps.executeQuery();

            ArrayList<Message> resultMessagesList = new ArrayList<>();
            while (rs.next()) {
                Message message = new Message();
                message.setUserName(rs.getString("userName"));
                message.setText(rs.getNString("text"));
                message.setCreated(rs.getTimestamp("createStamp"));
                message.setId(rs.getInt("id"));
                resultMessagesList.add(message);
            }

            return resultMessagesList;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }


    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public String getText() {
        return text;
    }



    public String getTextWithoutScriptTagsAndCR() {
        return text.replaceAll("(?i)<(/?script[^>]*)>", "&lt;$1&gt;").replaceAll("(\r\n|\n)", "<br />");
    }

    public void setText(String text) {
        this.text = text;
    }

    public void add(User u) {

        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO guestmessages (user_Id,text) VALUES(?,?)");
            ps.setInt(1, u.getId());
            ps.setString(2, this.getText());
            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public void update() {

        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("UPDATE guestmessages SET text=? WHERE id=?");
            ps.setString(1, this.getText());
            ps.setInt(2, this.getId());
            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public static Message get(String messageId) {
        Message message=null;
        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("SELECT guestmessages.id,userName,guestmessages.text,createStamp FROM guestmessages LEFT JOIN users ON guestmessages.user_Id=users.Id WHERE guestmessages.Id=?");
            ps.setInt(1, Integer.parseInt(messageId));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                message = new Message();
                message.setUserName(rs.getString("userName"));
                message.setText(rs.getNString("text"));
                message.setCreated(rs.getTimestamp("createStamp"));
                message.setId(rs.getInt("id"));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return message;
    }

    public void delete() {

        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM guestmessages WHERE id=?");
            ps.setInt(1, this.getId());
            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

}

