<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    String username = (session != null) ? (String) session.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = "USER";

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

        // Получаем роль
        PreparedStatement roleStmt = conn.prepareStatement("SELECT role FROM public.users WHERE username = ?");
        roleStmt.setString(1, username);
        ResultSet roleRs = roleStmt.executeQuery();
        if (roleRs.next()) {
            role = roleRs.getString("role");
        }
        roleRs.close();
        roleStmt.close();

        if (!"ADMIN".equals(role)) {
            out.println("<p>Доступ запрещён. Только для администратора.</p>");
            conn.close();
            return;
        }

        // Получаем пользователей
        Statement userStmt = conn.createStatement();
        ResultSet users = userStmt.executeQuery("SELECT id, username, role FROM public.users");

%>

<h2>Панель администратора</h2>
<p>Добро пожаловать, <strong><%= username %></strong> (роль: <%= role %>)</p>

<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Имя пользователя</th>
        <th>Роль</th>
        <th>Действия</th>
    </tr>

<%
        while (users.next()) {
            int uid = users.getInt("id");
            String uname = users.getString("username");
            String urole = users.getString("role");

            // не разрешаем удалять самого себя
            boolean isSelf = uname.equals(username);
%>
    <tr>
        <td><%= uid %></td>
        <td><%= uname %></td>
        <td><%= urole %></td>
        <td>
            <% if (!isSelf) { %>
                <form method="post" action="delete-user" style="display:inline;" onsubmit="return confirm('Удалить пользователя <%= uname %>?');">
                    <input type="hidden" name="id" value="<%= uid %>">
                    <button type="submit">Удалить</button>
                </form>
            <% } else { %>
                <i>Нельзя удалить себя</i>
            <% } %>
        </td>
    </tr>
<%
        }

        users.close();
        userStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>
</table>