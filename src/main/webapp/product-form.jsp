<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">
    <%
        String productId = request.getParameter("id");
        String name = "";
        double price = 0.0;
        String description = "";

        if (productId != null) {
            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(productId));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    name = rs.getString("name");
                    price = rs.getDouble("price");
                    description = rs.getString("description");
                } else {
    %>
        <div class="alert alert-danger">Товар с ID <%= productId %> не найден.</div>
    <%
                }

                rs.close();
                stmt.close();
                conn.close();

            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Ошибка при загрузке товара: " + e.getMessage() + "</div>");
            }
        }
    %>

    <h2 class="mb-4"><%= (productId == null ? "➕ Добавить новый товар" : "✏️ Редактировать товар") %></h2>

    <form method="post" action="<%= (productId == null ? "create-product" : "edit-product") %>">
        <% if (productId != null) { %>
            <input type="hidden" name="id" value="<%= productId %>" />
        <% } %>

        <div class="form-group">
            <label>Название товара</label>
            <input type="text" name="name" class="form-control" value="<%= name %>" required />
        </div>

        <div class="form-group">
            <label>Цена (₽)</label>
            <input type="number" step="0.01" name="price" class="form-control" value="<%= price %>" required />
        </div>

        <div class="form-group">
            <label>Описание</label>
            <textarea name="description" class="form-control" rows="4" required><%= description %></textarea>
        </div>

        <button type="submit" class="btn btn-primary">💾 Сохранить</button>
        <a href="admin.jsp" class="btn btn-secondary">⬅️ Отмена</a>
    </form>

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>

</div>