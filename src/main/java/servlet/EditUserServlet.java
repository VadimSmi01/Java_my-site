package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class EditUserServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/my_site";
    private static final String DB_USER = "vadimsmirnov";
    private static final String DB_PASS = "123456";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id");
        String username = req.getParameter("username");
        String role = req.getParameter("role");

        try {
            Class.forName("org.postgresql.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "UPDATE public.users SET username = ?, role = ? WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, role);
                    stmt.setInt(3, Integer.parseInt(id));
                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            resp.getWriter().println("Ошибка при обновлении: " + e.getMessage());
            return;
        }

        resp.sendRedirect("admin.jsp");
    }
}