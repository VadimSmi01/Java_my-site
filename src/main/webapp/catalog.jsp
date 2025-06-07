<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">
    <h2 class="mb-4">🛍️ Каталог товаров</h2>

    <div class="row">
    <%
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM products");

            while (rs.next()) {
                String imageUrl = rs.getString("image_url");
    %>
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
                    <img src="<%= imageUrl %>" class="card-img-top" alt="Product Image" style="max-height: 250px; object-fit: contain;">
                <% } else { %>
                    <div style="width:100%; height:250px; background:#f8f9fa; display:flex; align-items:center; justify-content:center; color:#ccc;">
                        No Image
                    </div>
                <% } %>
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= rs.getString("name") %></h5>
                    <p class="card-text mb-2">Цена: <strong><%= rs.getDouble("price") %> ₽</strong></p>
                    <p class="card-text text-muted mb-4"><%= rs.getString("description") %></p>
                    <a href="product.jsp?id=<%= rs.getInt("id") %>" class="btn btn-info mt-auto">Подробнее</a>
                </div>
            </div>
        </div>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Ошибка при загрузке каталога: " + e.getMessage() + "</div>");
        }
    %>
    </div>

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>
</div>