<!DOCTYPE HTML PUBLIC  "-//W3C//DTD HTML 4.01//EN" "www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <META http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <title></title>
    </head>
    <body>
        <%@ page import="guestbook.Message" %>
        <%@ page import="java.text.SimpleDateFormat" %>
        <%@ page import="java.util.ArrayList" %>
        <%@ page import="guestbook.User" %>
        <%  User currentUser=(User)session.getAttribute("user");
            String userName=(String)session.getAttribute("userName");
        %>
        <table>
            <tr>
                <th>
                <% if (currentUser != null) out.println(String.format("Текущий пользователь, %s", currentUser.getUserName()));
                   if ((currentUser == null)&&(userName!=null)) out.println(String.format("Неправильный логин или пароль, %s", userName));
                %>
                </th>
            </tr>
            <tr>
                <td>
                <% if (currentUser == null) { %>

                <form action="/GuestBook/LoginOrRegister" method="post">
                       <table>
                            <tr>
                                <th>Логин:</th>
                                <th><input type="text" name="userName" placeholder="Логин..." /></th>
                            </tr>
                            <tr>
                                <th>Пароль:</th>
                                <th><input type="password" name="password" placeholder="Пароль..." /></th>
                            </tr>
                            <tr>
                                <th><input type="submit" name="login" value="Логин" /></th>
                                <th><input type="submit" name="register" value="Регистрация" /></th>
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
                            <th>Пользователь</th>
                            <th>Сообщение</th>
                            <th>Дата</th>
                            <%if (currentUser.getAdmin()) {%>
                            <th>Удалить</th>
                             <%}%>
                        </tr>
                        <%int cnt=0;
                         for (Message m : messagesFromDB) {cnt++;if (cnt==11) break;%>
                            <tr><td><%=m.getUserName()%></td><td><%=m.getTextWithoutScriptTags()%></td><td><%=SimpleDateFormat.getInstance().format(m.getCreateStamp())%></td>
                            <%if (currentUser.getAdmin()) {%>
                                <td><a href="/GuestBook/DeleteMessage?messageId=<%=m.getId()%>">Удалить</a></td>
                            <%}%>
                            </tr>

                        <%}%>
                    </table>
                </td>
            </tr>
            <tr>
                <th>
                    <%if (messagesShiftValue != 0) {%>
                    <a href="/GuestBook/ShiftMessage?messagesShift=<%=(messagesShiftValue - 10)%>">Предыдущая страница</a>
                    <%} else {%>
                    Предыдущая страница
                    <%}%>



                    <%if (messagesFromDB.size() > 10) {%>
                    <a href="/GuestBook/ShiftMessage?messagesShift=<%=(messagesShiftValue + 10)%>">Следующая страница</a>
                    <%}else{%>
                    Следующая страница
                    <%}%>
                </th>
            </tr>
            <tr>
                <td>
                    <form action="/GuestBook/AddMessage" method="post">
                    Сообщение:<br/>
                    <textarea rows="9" cols="70" name="message"  placeholder="Введите сообщение..."></textarea><br/>
                    <input type="submit" name="postMessage" value="Отправить сообщение" />
                    </form>
                </td>
            </tr>
            <tr>
                <td>
                    <form action="/GuestBook/Exit" method="post">
                        <input type="submit" name="exit" value="Выход" />
                    </form>
                </td>
            </tr>
            <%}%>

        </table>
    </body>
</html>
