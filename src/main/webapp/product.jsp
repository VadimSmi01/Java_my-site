<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">
    <%
        String productId = request.getParameter("id");
        if (productId == null) {
    %>
        <div class="alert alert-warning">ID товара не указан.</div>
    <%
        } else {
            try {
                Class.forName("org.postgresql.Driver");
                Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM products WHERE id = ?");
                stmt.setInt(1, Integer.parseInt(productId));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
    %>
        <div class="card shadow p-4">
            <h2 class="card-title mb-4">🛒 <%= rs.getString("name") %></h2>
            <p class="card-text mb-2"><strong>Цена:</strong> <%= rs.getDouble("price") %> ₽</p>
            <p class="card-text mb-4"><strong>Описание:</strong> <%= rs.getString("description") %></p>
            <a href="catalog.jsp" class="btn btn-secondary">⬅️ Вернуться в каталог</a>
        </div>
    <%
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

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>
</div>