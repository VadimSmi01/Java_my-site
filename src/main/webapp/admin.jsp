<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    // session — уже доступна в JSP, повторно объявлять нельзя!
    String username = (session != null) ? (String) session.getAttribute("username") : null;

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = "USER"; // роль по умолчанию

    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

        // Получаем роль текущего пользователя
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

        // Получаем список всех пользователей
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
    </tr>

<%
        while (users.next()) {
%>
    <tr>
        <td><%= users.getInt("id") %></td>
        <td><%= users.getString("username") %></td>
        <td><%= users.getString("role") %></td>
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