package guestbook;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by Asus on 09.02.15.
 */
public class Message {

    private int messageId; //for cutting message from db
    private String userName;
    private String message;
    private Date messageTimeStamp;


    public Message() {
    }

    static public Message[] readMessagesFromDB(int countPerPage,int offSet)
    {
        try (Connection con=ConnectionProvider.getCon()) {

            PreparedStatement ps=con.prepareStatement("SELECT message_Id,UserName,Message,MessageDateTime FROM guestmessages LEFT JOIN users ON guestmessages.User_Id=users.Id order by MessageDateTime desc limit ? offset ?");
            ps.setInt(1, countPerPage);
            ps.setInt(2, offSet);

            ResultSet rs=ps.executeQuery();

            ArrayList<Message> resultMessagesList = new ArrayList<Message>();
            while(rs.next())
            {
                Message oneMessage=new Message();
                oneMessage.setUserName(rs.getString("UserName"));
                oneMessage.setMessage(rs.getNString("Message"));
                oneMessage.setMessageTimeStamp(rs.getTimestamp("MessageDateTime"));
                oneMessage.setMessageId(rs.getInt("message_id"));
                resultMessagesList.add(oneMessage);
            }

            return (resultMessagesList.toArray(new Message[resultMessagesList.size()]));

        } catch(SQLException e) {
            throw new RuntimeException(e);
        }


    }


    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }



    public Date getMessageTimeStamp() {
        return messageTimeStamp;
    }

    public void setMessageTimeStamp(Date messageTimeStamp) {
        this.messageTimeStamp = messageTimeStamp;
    }

    public String getMessage() {
        return message;
    }

    public String getMessageWithoutScriptTags() {

        return message.replaceAll("(?i)<(/?script[^>]*)>", "&lt;$1&gt;").replaceAll("(\r\n|\n)", "<br />");
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void addMessageToDB(User u) {

        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO guestmessages (User_Id,Message) VALUES(?,?)");
            ps.setInt(1, u.getId());
            ps.setString(2, this.getMessage());
            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public void deleteMessageFromDB() {

        try (Connection con = ConnectionProvider.getCon()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM guestmessages WHERE message_id=?");
            ps.setInt(1, this.getMessageId());
            ps.executeUpdate();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

}

