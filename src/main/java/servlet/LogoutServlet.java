package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Установка кодировки ответа
        resp.setContentType("text/html; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // Завершаем сессию
        }

        // Перенаправляем
        resp.sendRedirect("index.jsp");

        // Редирект
        // resp.getWriter().println("Вы успешно вышли из системы.");
    }
}