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
    private Date createStamp;

    static public ArrayList<Message> readMessages(int count, int offset) {
        try (Connection con = ConnectionProvider.getCon()) {

            PreparedStatement ps = con.prepareStatement("SELECT guestmessages.id,userName,guestmessages.text,createStamp FROM guestmessages LEFT JOIN users ON guestmessages.user_Id=users.Id ORDER BY createStamp DESC LIMIT ? OFFSET ?");
            ps.setInt(1, count);
            ps.setInt(2, offset);

            ResultSet rs = ps.executeQuery();

            ArrayList<Message> resultMessagesList = new ArrayList<>();
            while (rs.next()) {
                Message oneMessage = new Message();
                oneMessage.setUserName(rs.getString("userName"));
                oneMessage.setText(rs.getNString("text"));
                oneMessage.setCreateStamp(rs.getTimestamp("createStamp"));
                oneMessage.setId(rs.getInt("id"));
                resultMessagesList.add(oneMessage);
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


    public Date getCreateStamp() {
        return createStamp;
    }

    public void setCreateStamp(Date createStamp) {
        this.createStamp = createStamp;
    }

    public String getText() {
        return text;
    }

    public String getTextWithoutScriptTags() {

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

