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

        // Проверяем роль
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

        // === Список пользователей ===
        Statement userStmt = conn.createStatement();
        ResultSet users = userStmt.executeQuery("SELECT id, username, role FROM public.users");
%>

<h2>Панель администратора</h2>
<p>Добро пожаловать, <strong><%= username %></strong> (роль: <%= role %>)</p>

<h3>Пользователи</h3>

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
            boolean isSelf = uname.equals(username);
%>
    <tr>
        <td><%= uid %></td>
        <td><%= uname %></td>
        <td><%= urole %></td>
        <td>
            <!-- Редактировать -->
            <form method="get" action="edit-user.jsp" style="display:inline;">
                <input type="hidden" name="id" value="<%= uid %>">
                <button type="submit">Редактировать</button>
            </form>

            <!-- Удалить -->
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

        // === Список товаров ===
        Statement prodStmt = conn.createStatement();
        ResultSet prods = prodStmt.executeQuery("SELECT id, name, price FROM public.products");
%>
</table>

<h3>Управление товарами</h3>

<p><a href="product-form.jsp">➕ Добавить новый товар</a></p>

<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Название</th>
        <th>Цена</th>
        <th>Действия</th>
    </tr>

<%
        while (prods.next()) {
            int pid = prods.getInt("id");
            String pname = prods.getString("name");
            double pprice = prods.getDouble("price");
%>
    <tr>
        <td><%= pid %></td>
        <td><%= pname %></td>
        <td><%= pprice %> ₽</td>
        <td>
            <!-- Редактировать -->
            <form method="get" action="product-form.jsp" style="display:inline;">
                <input type="hidden" name="id" value="<%= pid %>">
                <button type="submit">Редактировать</button>
            </form>

            <!-- Удалить -->
            <form method="post" action="delete-product" style="display:inline;" onsubmit="return confirm('Удалить товар <%= pname %>?');">
                <input type="hidden" name="id" value="<%= pid %>">
                <button type="submit">Удалить</button>
            </form>
        </td>
    </tr>
<%
        }

        prods.close();
        prodStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>
</table>