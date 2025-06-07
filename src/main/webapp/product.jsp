<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    // Устанавливаем кодировку запроса
    request.setCharacterEncoding("UTF-8");

    String username = (session != null) ? (String) session.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String productId = request.getParameter("id");

    String name = "";
    String desc = "";
    double price = 0.0;

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/my_site",
            "vadimsmirnov", "" // пароль добавь, если есть
        );

        PreparedStatement stmt = conn.prepareStatement(
            "SELECT name, description, price FROM public.products WHERE id = ?"
        );
        stmt.setInt(1, Integer.parseInt(productId));
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            desc = rs.getString("description");
            price = rs.getDouble("price");
        } else {
            out.println("<p>Товар не найден.</p>");
            rs.close();
            stmt.close();
            conn.close();
            return;
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>

<h2>Карточка товара</h2>

<h3><%= name %></h3>
<p><%= desc %></p>
<p><strong>Цена:</strong> <%= price %> ₽</p>

<p><a href="catalog.jsp">← Вернуться в каталог</a></p>