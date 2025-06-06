package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class DeleteUserServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/my_site";
    private static final String DB_USER = "vadimsmirnov";
    private static final String DB_PASS = "123456";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Установка кодировки
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");

        // Проверка: админ ли пользователь (дополнительно можно внедрить)
        HttpSession session = req.getSession(false);
        String currentUser = (session != null) ? (String) session.getAttribute("username") : null;

        if (currentUser == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("org.postgresql.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // Не даём удалить самого себя
                PreparedStatement findUserStmt = conn.prepareStatement("SELECT username FROM public.users WHERE id = ?");
                findUserStmt.setInt(1, Integer.parseInt(idParam));
                ResultSet rs = findUserStmt.executeQuery();
                if (rs.next()) {
                    String toDelete = rs.getString("username");
                    if (toDelete.equals(currentUser)) {
                        resp.getWriter().println("Нельзя удалить себя.");
                        return;
                    }
                }

                PreparedStatement stmt = conn.prepareStatement("DELETE FROM public.users WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(idParam));
                stmt.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Ошибка при удалении: " + e.getMessage());
            return;
        }

        // После удаления — редирект обратно
        resp.sendRedirect("admin.jsp");
    }
}