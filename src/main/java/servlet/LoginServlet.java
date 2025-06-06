package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class LoginServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/my_site";
    private static final String DB_USER = "vadimsmirnov";
    private static final String DB_PASS = "123456";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Устанавливаем кодировку запроса и ответа
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            // Подключаем драйвер PostgreSQL
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        // Успешный вход: сохраняем в сессию и редиректим
                        HttpSession session = req.getSession();
                        session.setAttribute("username", username);
                        resp.sendRedirect("index.jsp");
                    } else {
                        // Неверные данные
                        resp.getWriter().println("Неверное имя пользователя или пароль.");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Ошибка: " + e.getMessage());
        }
    }
}