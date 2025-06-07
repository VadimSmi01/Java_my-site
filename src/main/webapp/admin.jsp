<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">

    <!-- Заголовок -->
    <h2 class="mb-4">⚙️ Панель администратора</h2>

    <!-- Таблица пользователей -->
    <h4 class="mb-3">👥 Пользователи</h4>
    <table class="table table-striped table-bordered">
        <thead class="thead-light">
            <tr>
                <th>ID</th>
                <th>Имя пользователя</th>
                <th>Роль</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

                Statement userStmt = conn.createStatement();
                ResultSet userRs = userStmt.executeQuery("SELECT * FROM users");

                while (userRs.next()) {
        %>
            <tr>
                <td><%= userRs.getInt("id") %></td>
                <td><%= userRs.getString("username") %></td>
                <td><%= userRs.getString("role") %></td>
                <td>
                    <a href="edit-user.jsp?id=<%= userRs.getInt("id") %>" class="btn btn-sm btn-warning">✏️ Редактировать</a>
                    <form method="post" action="delete-user" style="display:inline;">
                        <input type="hidden" name="id" value="<%= userRs.getInt("id") %>" />
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Вы уверены, что хотите удалить пользователя?');">🗑️ Удалить</button>
                    </form>
                </td>
            </tr>
        <%
                }

                userRs.close();
                userStmt.close();
        %>
        </tbody>
    </table>

    <!-- Таблица товаров -->
    <h4 class="mt-5 mb-3">📦 Товары</h4>
    <a href="product-form.jsp" class="btn btn-success mb-3">➕ Добавить товар</a>

    <table class="table table-striped table-bordered">
        <thead class="thead-light">
            <tr>
                <th>ID</th>
                <th>Название</th>
                <th>Цена</th>
                <th>Описание</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
        <%
                Statement productStmt = conn.createStatement();
                ResultSet productRs = productStmt.executeQuery("SELECT * FROM products");

                while (productRs.next()) {
        %>
            <tr>
                <td><%= productRs.getInt("id") %></td>
                <td><%= productRs.getString("name") %></td>
                <td><%= productRs.getDouble("price") %> ₽</td>
                <td><%= productRs.getString("description") %></td>
                <td>
                    <a href="product-form.jsp?id=<%= productRs.getInt("id") %>" class="btn btn-sm btn-warning">✏️ Редактировать</a>
                    <form method="post" action="delete-product" style="display:inline;">
                        <input type="hidden" name="id" value="<%= productRs.getInt("id") %>" />
                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Вы уверены, что хотите удалить товар?');">🗑️ Удалить</button>
                    </form>
                </td>
            </tr>
        <%
                }

                productRs.close();
                productStmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Ошибка при загрузке данных: " + e.getMessage() + "</div>");
            }
        %>
        </tbody>
    </table>

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>

</div>