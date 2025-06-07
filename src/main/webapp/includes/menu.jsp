<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet" %>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<%
    String menuUsername = (session != null) ? (String) session.getAttribute("username") : null;
    String menuRole = "";

    if (menuUsername != null) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection menuConn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/my_site", "vadimsmirnov", "");

            PreparedStatement menuStmt = menuConn.prepareStatement("SELECT role FROM public.users WHERE username = ?");
            menuStmt.setString(1, menuUsername);
            ResultSet menuRs = menuStmt.executeQuery();

            if (menuRs.next()) {
                menuRole = menuRs.getString("role");
            }

            menuRs.close();
            menuStmt.close();
            menuConn.close();
        } catch (Exception e) {
            out.println("Ошибка в меню: " + e.getMessage());
        }
    }
%>

<nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
    <a class="navbar-brand" href="index.jsp">🏠 Главная</a>
    <div class="collapse navbar-collapse">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="catalog.jsp">🛍️ Каталог</a>
            </li>
            <% if ("ADMIN".equals(menuRole)) { %>
            <li class="nav-item">
                <a class="nav-link" href="admin.jsp">⚙️ Админка</a>
            </li>
            <% } %>
        </ul>
        <ul class="navbar-nav">
            <% if (menuUsername != null) { %>
                <li class="nav-item">
                    <span class="navbar-text mr-3">👤 <strong><%= menuUsername %></strong></span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout">🚪 Выйти</a>
                </li>
            <% } else { %>
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">Войти</a>
                </li>
            <% } %>
        </ul>
    </div>
</nav>