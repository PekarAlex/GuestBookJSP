package guestbook;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;



@WebServlet(name = "ServletDispatcher")
public class ServletDispatcher extends  HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();
        User currentUser=(User)request.getSession().getAttribute("userBean");

        if (uri.startsWith("/LoginOrRegister"))
        {
            //Login, Register logic
            if (currentUser.getId()==0)
            {
                String userName=request.getParameter("userName");
                String password=request.getParameter("password");
                currentUser.setUserName(userName);
                currentUser.setPassword(password);
                String n=request.getParameter("login");
                if ((userName!=null)&&(!userName.isEmpty())&&(password!=null)&&(!password.isEmpty())) {

                    if (n != null) currentUser.logonUser();
                    else currentUser.registerUser();
                }
            }
        } else
        if (uri.startsWith("/AddMessage")) {
            if (currentUser.getId() != 0) {
                String stringMessage = request.getParameter("message");
                if ((stringMessage != null) && (!stringMessage.isEmpty())) {
                    Message newMessage = new Message();
                    newMessage.setMessage(stringMessage);
                    newMessage.addMessageToDB(currentUser);
                }

            }
        } else
        if (uri.startsWith("/DeleteMessage")) {
            if ((currentUser.getId() != 0) && (currentUser.getIsadmin() == 1)) {
                String messageId = request.getParameter("messageId");
                if (messageId != null) {
                    Message newMessage = new Message();
                    newMessage.setMessageId(Integer.parseInt(messageId));
                    newMessage.deleteMessageFromDB();
                }
            } //else response.sendError(404);
        }


        RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.forward(request, response);



    }


}



