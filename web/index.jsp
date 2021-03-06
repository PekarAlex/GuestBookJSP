<!DOCTYPE HTML PUBLIC  "-//W3C//DTD HTML 4.01//EN" "www.w3.org/TR/html4/strict.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="guestbook.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    </head>
    <body>
        <table>
            <tr>
                <th class="Head1Col">
                    <c:if test="${not empty user}"> Current user, ${user.getUserName()}</c:if>
                    <c:if test="${(empty user) && (not empty userName)}"> Incorrect login or password, ${userName}</c:if>
                </th>
                <c:if test="${not empty user}">
                <th class="Head2Col">
                    <form action="${pageContext.request.contextPath}/GuestBook/Exit" method="post">
                        <input type="submit" name="exit" value="Logoff" />
                    </form>
                </th>
                </c:if>
            </tr>
            <tr>
                <td>
                <c:if test="${empty user}">
                <form action="${pageContext.request.contextPath}/GuestBook/LoginOrRegister" method="post">
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
                </c:if>
                </td>
            </tr>

            <c:if test="${not empty user}">
            <%
                String messagesShift=request.getParameter("messagesShift");
                int messagesShiftValue=0;
                if (messagesShift!=null) messagesShiftValue=Integer.parseInt(messagesShift);
                ArrayList<Message> messagesFromDB = Message.readMessages(11, messagesShiftValue);
                pageContext.setAttribute("messagesFromDB", messagesFromDB);
            %>
            <tr>
                <td>
                    <table border="1">
                        <tr>
                            <th class="MessageFixedCol">User</th>
                            <th class="MessageFloatCol">Message</th>
                            <th class="MessageFixedCol">Date &amp; Time</th>
                            <c:if test="${user.getAdmin()}">
                            <th class="MessageFixedCol">Delete</th>
                            <th class="MessageFixedCol">Edit</th>
                            </c:if>
                        </tr>

                        <c:forEach items="${messagesFromDB}" var="m"  begin="0" end="9">
                            <tr><td>${m.getUserName()}</td><td class="MessageTextWrap">${m.getTextWithoutScriptTagsAndCR()}</td><td><fmt:formatDate  pattern="yyyy-MM-dd HH:mm" value="${m.getCreated()}"/></td>
                            <c:if test="${user.getAdmin()}">
                                <td class="MessageTextCenter"><a href="${pageContext.request.contextPath}/GuestBook/DeleteMessage?messageId=${m.getId()}"  onclick="return confirmDelete()">Delete</a></td>
                                <td class="MessageTextCenter"><a href="${pageContext.request.contextPath}/GuestBook/EditMessage?messageId=${m.getId()}">Edit</a></td>
                            </c:if>
                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>
            <tr>
                <th class="Navigation">
                    <c:choose>
                        <c:when test="${(not empty param.messagesShift)&&(param.messagesShift != 0)}">
                            <a href="${pageContext.request.contextPath}/GuestBook?messagesShift=${param.messagesShift - 10}"><img src="${pageContext.request.contextPath}/images/arrowLeft.png" border="0" alt="Previous page"/></a>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/arrowLeft.png" border="0" alt="Previous page"/>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${messagesFromDB.size() > 10}">
                            <a href="${pageContext.request.contextPath}/GuestBook?messagesShift=${param.messagesShift + 10}"><img src="${pageContext.request.contextPath}/images/arrowRight.png" border="0" alt="Next page"/></a>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/arrowRight.png" border="0" alt="Next page"/>
                        </c:otherwise>
                    </c:choose>
                </th>
            </tr>
            <tr>
                <td>
                    <form action="${pageContext.request.contextPath}/GuestBook/AddMessage" method="post">
                    Message: <span  class="AttentionText">${AttentionMessage}</span><br/>
                    <textarea rows="9"  name="message">${editingMessage.getText()}</textarea><br/>
                    <input type="hidden" name="messageId" value="${editingMessage.getId()}"/>
                    <input type="submit" name="postMessage" value="Post message" />
                    </form>
                </td>
            </tr>
            </c:if>


        </table>

        <c:if test="${not empty AttentionMessage}">
            <script type="text/javascript" language="JavaScript">
                window.scrollTo(0,document.body.scrollHeight);
            </script>
        </c:if>

    </body>
</html>
