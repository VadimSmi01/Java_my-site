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
%>

<h2>Каталог товаров</h2>
<p>Добро пожаловать, <strong><%= username %></strong></p>

<%
    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/my_site",
            "vadimsmirnov", ""  // пароль если есть — добавь
        );

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM public.products");

        while (rs.next()) {
            int pid = rs.getInt("id");
            String name = rs.getString("name");
            String desc = rs.getString("description");
            double price = rs.getDouble("price");
%>
    <div style="border:1px solid #ccc; padding:10px; margin:10px;">
        <h3><a href="product.jsp?id=<%= pid %>"><%= name %></a></h3>
        <p><%= desc %></p>
        <p><strong>Цена:</strong> <%= price %> ₽</p>
    </div>
<%
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>