<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">
    <%
        String userId = request.getParameter("id");

        if (userId == null) {
    %>
        <div class="alert alert-warning">ID пользователя не указан.</div>
    <%
        } else {
            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(userId));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
    %>

        <h2 class="mb-4">✏️ Редактировать пользователя</h2>

        <form method="post" action="edit-user">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>" />

            <div class="form-group">
                <label>Имя пользователя</label>
                <input type="text" name="username" class="form-control" value="<%= rs.getString("username") %>" required />
            </div>

            <div class="form-group">
                <label>Роль</label>
                <select name="role" class="form-control" required>
                    <option value="USER" <%= "USER".equals(rs.getString("role")) ? "selected" : "" %>>USER</option>
                    <option value="ADMIN" <%= "ADMIN".equals(rs.getString("role")) ? "selected" : "" %>>ADMIN</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">💾 Сохранить</button>
            <a href="admin.jsp" class="btn btn-secondary">⬅️ Отмена</a>
        </form>

    <%
                } else {
    %>
        <div class="alert alert-danger">Пользователь с ID <%= userId %> не найден.</div>
    <%
                }

                rs.close();
                stmt.close();
                conn.close();

            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Ошибка при загрузке пользователя: " + e.getMessage() + "</div>");
            }
        }
    %>

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>

</div>