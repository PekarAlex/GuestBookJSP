<!DOCTYPE HTML PUBLIC  "-//W3C//DTD HTML 4.01//EN" "www.w3.org/TR/html4/strict.dtd">
<%@ page import="guestbook.Message" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="guestbook.User" %>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <META http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
        <script type="text/javascript" language="JavaScript">
            function confirmDelete(){
                return confirm("Are you sure want to delete message?");
            }
        </script>
        <link rel="stylesheet" type="text/css" href="GuestBook.css"/>
        <title></title>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    </head>
    <body>
        <%  User currentUser=(User)session.getAttribute("user");
            String userName=(String)session.getAttribute("userName");
        %>
        <table>
            <tr>
                <th class="Head1Col">
                <% if (currentUser != null) out.println(String.format("Current user, %s", currentUser.getUserName()));
                   if ((currentUser == null)&&(userName!=null)) out.println(String.format("Incorrect login or password, %s", userName));
                %>
                </th>
                <% if (currentUser != null) {%>
                <th class="Head2Col">
                    <form action="/GuestBook/Exit" method="post">
                        <input type="submit" name="exit" value="Logoff" />
                    </form>
                </th>
                <%}%>
            </tr>
            <tr>
                <td>
                <% if (currentUser == null) { %>

                <form action="/GuestBook/LoginOrRegister" method="post">
                       <table>
                            <tr>
                                <th class="Logon1Col">Login:</th>
                                <th class="Logon2Col"><input type="text" name="userName" placeholder="Login..." /></th>
                            </tr>
                            <tr>
                                <th class="Logon1Col">Password:</th>
                                <th class="Logon2Col"><input type="password" name="password" placeholder="Password..." /></th>
                            </tr>
                            <tr>
                                <th class="Logon1Col"><input type="submit" name="login" value="Login" /></th>
                                <th class="Logon2Col"><input type="submit" name="register" value="Register" /></th>
                            </tr>
                        </table>
                </form>

                <%}%>
                </td>
            </tr>

            <% if (currentUser != null) {
                String messagesShift=request.getParameter("messagesShift");
                int messagesShiftValue=0;
                if (messagesShift!=null) messagesShiftValue=Integer.parseInt(messagesShift);
                 ArrayList<Message> messagesFromDB = Message.readMessages(11, messagesShiftValue);
            %>
            <tr>
                <td>
                    <table border="1">
                        <tr>
                            <th class="MessageFixedCol">User</th>
                            <th class="MessageFloatCol">Message</th>
                            <th class="MessageFixedCol">Date &amp; Time</th>
                            <%if (currentUser.getAdmin()) {%>
                            <th class="MessageFixedCol">Delete</th>
                            <th class="MessageFixedCol">Edit</th>
                             <%}%>
                        </tr>
                        <%int cnt=0;
                         for (Message m : messagesFromDB) {cnt++;if (cnt==11) break;%>
                            <tr><td><%=m.getUserName()%></td><td class="MessageTextWrap"><%=m.getTextWithoutScriptTagsAndCR()%></td><td><%=SimpleDateFormat.getInstance().format(m.getCreated())%></td>
                            <%if (currentUser.getAdmin()) {%>
                                <td class="MessageTextCenter"><a href="/GuestBook/DeleteMessage?messageId=<%=m.getId()%>"  onclick="return confirmDelete()">Delete</a></td>
                                <td class="MessageTextCenter"><a href="/GuestBook/EditMessage?messageId=<%=m.getId()%>">Edit</a></td>
                            <%}%>
                            </tr>

                        <%}%>
                    </table>
                </td>
            </tr>
            <tr>
                <th class="Navigation">
                    <%if (messagesShiftValue != 0) {%>
                    <a href="/GuestBook?messagesShift=<%=(messagesShiftValue - 10)%>"><img src="/images/arrowLeft.png" border="0" alt="Previous page"/></a>
                    <%} else {%>
                    <img src="/images/arrowLeft.png" border="0" alt="Previous page"/>
                    <%}%>
                    <%if (messagesFromDB.size() > 10) {%>
                    <a href="/GuestBook?messagesShift=<%=(messagesShiftValue + 10)%>"><img src="/images/arrowRight.png" border="0" alt="Next page"/></a>
                    <%}else{%>
                    <img src="/images/arrowRight.png" border="0" alt="Next page"/>
                    <%}%>
                </th>
            </tr>
            <tr>
                <td>
                    <form action="/GuestBook/AddMessage" method="post">
                    <%String attention=(String)session.getAttribute("AttentionMessage"); if (attention==null) attention="";%>
                    Message: <span  class="AttentionText"><%=attention%></span><br/>
                    <textarea rows="9"  name="message"></textarea><br/>
                    <%
                        Message ms=(Message)session.getAttribute("editingMessage");
                        String editingMessage="";
                        if (ms!=null) editingMessage=Integer.toString(ms.getId());
                    %>
                    <input type="hidden" name="messageId" value="<%=editingMessage%>">
                    <input type="submit" name="postMessage" value="Post message" />
                    </form>
                </td>
            </tr>
            <%}%>

        </table>
    </body>
</html>
