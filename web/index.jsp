<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<%@ page import="guestbook.Message" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="userBean" class="guestbook.User" scope="session"/>
<table>
    <tr>
        <% if (userBean.getId() != 0) out.println(String.format("Текущий пользователь, %s", userBean.getUserName()));
        else if (userBean.getUserName() != null)
            out.println(String.format("Неправильный логин или пароль, %s", userBean.getUserName()));
        %>
    </tr>
    <tr>
        <% if (userBean.getId() == 0) { %>
        <form action="LoginOrRegister" method="post">
            <tr>
                <th>Логин:</th>
                <th><input type="text" name="userName" value="Логин..." onclick="this.value=''"/></th>
            </tr>
            <tr>
                <th>Пароль:</th>
                <th><input type="password" name="password"/></th>
            </tr>
            <tr>
                <th><input type="submit" name="login" value="Логин"/></th>
                <th><% if (userBean.getUserName() != null) {%><input type="submit" name="register"
                                                                     value="Регистрация" <%}%></th>
            </tr>
        </form>
        <%}%>
    </tr>
    <tr>
            <% if (userBean.getId() != 0) {
            String messagesShift=request.getParameter("messagesShift");
            int messagesShiftValue=0;
            if (messagesShift!=null) messagesShiftValue=Integer.parseInt(messagesShift);
            Message[] messagesFromDB = Message.readMessagesFromDB(11, messagesShiftValue);
        %>
        <table border="1">
            <%if (userBean.getIsadmin() == 1) {%>
            <tr>
                <th>Пользователь</th>
                <th>Сообщение</th>
                <th>Дата</th>
                <th>Удалить</th>
            </tr>
            <%} else {%>
            <tr>
                <th>Пользователь</th>
                <th>Сообщение</th>
                <th>Дата</th>
            </tr>

            <%
                }
                for (Message m : messagesFromDB) {
                    out.print(String.format("<tr><td>%s</td><td>%s</td><td>%s</td>", m.getUserName(), m.getMessageWithoutScriptTags(), SimpleDateFormat.getInstance().format(m.getMessageTimeStamp())));
                    if (userBean.getIsadmin() == 1)
                        out.print(String.format("<td><a href=\"DeleteMessage?messageId=%d\">Удалить</a></td>", m.getMessageId()));
                    out.println("</tr>");
                }
            %>
        </table>
    <tr>
        <th width="50%">
            <%
                if (messagesShiftValue != 0)
                    out.print(String.format("<a href=\"ShiftMessage?messagesShift=%d\">Предыдущая страница</a>", messagesShiftValue - 10));
                else out.print("Предыдущая страница");
            %>
        </th>
        <th width="50%">
            <%
                if (messagesFromDB.length > 10)
                    out.print(String.format("<a href=\"ShiftMessage?messagesShift=%d\">Следующая страница</a>", messagesShiftValue + 10));
                else out.print("Следующая страница");
            %>
        </th>
    </tr>
    <form action="AddMessage" method="post">
        Сообщение:<br/>
        <textarea rows="9" cols="70" name="message"></textarea><br/>
        <input type="submit" name="postMessage" value="Отправить сообщение"/>
    </form>
    <%}%>
    </tr>
</table>
</body>
</html>
