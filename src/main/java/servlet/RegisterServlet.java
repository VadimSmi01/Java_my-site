package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class RegisterServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/my_site";
    private static final String DB_USER = "vadimsmirnov";
    private static final String DB_PASS = "123456"; //

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Устанавливаем корректную кодировку для ответа
        resp.setContentType("text/html; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            // Загружаем драйвер
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "INSERT INTO users (username, password) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    stmt.executeUpdate();

                    // Редиректить:
                    // resp.sendRedirect("index.jsp");

                    // Сообщение
                    resp.getWriter().println("Добро пожаловать, " + username + "! Регистрация успешна.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Ошибка при регистрации: " + e.getMessage());
        }
    }
}