package guestbook;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet(name = "ServletDispatcher")
public class ServletDispatcher extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();
        User currentUser = (User) request.getSession().getAttribute("user");

        if (uri.endsWith("/LoginOrRegister")) {
            String loginClicked = request.getParameter("login");
            String userName = request.getParameter("userName");
            String password = request.getParameter("password");
            if (userName != null) request.getSession().setAttribute("userName", userName);
            if (currentUser == null) {
                if (loginClicked != null) userLogin(request, userName, password);
                else userRegister(request, userName, password);
            }
        } else if (uri.endsWith("/AddMessage"))
            addMessage(request, currentUser);
        else if (uri.endsWith("/DeleteMessage"))
            deleteMessage(request, currentUser);
        else if (uri.endsWith("/Exit")){
            request.getSession().setAttribute("user", null);
            request.getSession().setAttribute("userName", null);
        }



        if ((uri.endsWith("/GuestBook"))||(uri.endsWith("/ShiftMessage")))
        {
            RequestDispatcher rd = request.getRequestDispatcher("/index.jsp");
            rd.forward(request, response);
        } else response.sendRedirect("/GuestBook");

    }

    private void userRegister(HttpServletRequest request, String userName, String password) {
        if ((userName != null) && (!userName.isEmpty()) && (password != null) && (!password.isEmpty())) {
            User u = User.register(userName, password);
            if (u != null) request.getSession().setAttribute("user", u);
        }
    }

    private void userLogin(HttpServletRequest request, String userName, String password) {
        if ((userName != null) && (!userName.isEmpty()) && (password != null) && (!password.isEmpty())) {
            User u = User.get(userName);
            if ((u != null) && u.getPassword().equals(password))
                request.getSession().setAttribute("user", u);
        }
    }

    private void addMessage(HttpServletRequest request, User currentUser) {
        if (currentUser != null) {
            String stringMessage = request.getParameter("message");
            if ((stringMessage != null) && (!stringMessage.isEmpty())) {
                Message newMessage = new Message();
                newMessage.setText(stringMessage);
                newMessage.add(currentUser);
            }

        }
    }

    private void deleteMessage(HttpServletRequest request, User currentUser) {
        if ((currentUser != null) && (currentUser.getAdmin())) {
            String messageId = request.getParameter("messageId");
            if (messageId != null) {
                Message newMessage = new Message();
                newMessage.setId(Integer.parseInt(messageId));
                newMessage.delete();
            }
        } //else response.sendError(404);
    }
}






