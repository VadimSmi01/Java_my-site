<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("id");
    String username = "";
    String role = "";

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/my_site",
            "vadimsmirnov",
            ""  // ← пароль добавь, если есть
        );

        PreparedStatement stmt = conn.prepareStatement(
            "SELECT username, role FROM public.users WHERE id = ?"
        );
        stmt.setInt(1, Integer.parseInt(userId));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            role = rs.getString("role");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>

<h2>Редактирование пользователя</h2>

<form method="post" action="edit-user">
    <input type="hidden" name="id" value="<%= userId %>">

    <label>Имя пользователя:</label><br>
    <input type="text" name="username" value="<%= username %>" required><br><br>

    <label>Роль:</label><br>
    <select name="role">
        <option value="USER" <%= "USER".equals(role) ? "selected" : "" %>>USER</option>
        <option value="ADMIN" <%= "ADMIN".equals(role) ? "selected" : "" %>>ADMIN</option>
    </select><br><br>

    <button type="submit">Сохранить изменения</button>
</form>