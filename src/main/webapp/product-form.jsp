<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String username = (session != null) ? (String) session.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = "USER";

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/my_site",
            "vadimsmirnov", ""
        );

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

        String idParam = request.getParameter("id");
        String name = "";
        String desc = "";
        double price = 0.0;

        if (idParam != null) {
            PreparedStatement stmt = conn.prepareStatement("SELECT name, description, price FROM public.products WHERE id = ?");
            stmt.setInt(1, Integer.parseInt(idParam));
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                desc = rs.getString("description");
                price = rs.getDouble("price");
            }

            rs.close();
            stmt.close();
        }

        conn.close();
    } catch (Exception e) {
        out.println("Ошибка: " + e.getMessage());
    }
%>

<h2><%= (request.getParameter("id") == null ? "Добавить новый товар" : "Редактировать товар") %></h2>

<form method="post" action="<%= (request.getParameter("id") == null ? "create-product" : "edit-product") %>">
    <% if (request.getParameter("id") != null) { %>
        <input type="hidden" name="id" value="<%= request.getParameter("id") %>">
    <% } %>

    <label>Название:</label><br>
    <input type="text" name="name" value="<%= name %>" required><br><br>

    <label>Описание:</label><br>
    <textarea name="description" rows="4" cols="50"><%= desc %></textarea><br><br>

    <label>Цена:</label><br>
    <input type="number" step="0.01" name="price" value="<%= price %>" required><br><br>

    <button type="submit">Сохранить</button>
</form>