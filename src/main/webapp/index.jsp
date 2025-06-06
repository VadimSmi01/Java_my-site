<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    String username = (session != null) ? (String) session.getAttribute("username") : null;
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Главная</title>
</head>
<body>

<h2>Главная страница</h2>

<% if (username != null) { %>
    <p>Вы вошли как <strong><%= username %></strong></p>
    <a href="logout">Выйти</a>
<% } else { %>
    <p>Вы не вошли в систему.</p>
    <a href="login.jsp">Войти</a> | <a href="register.jsp">Регистрация</a>
<% } %>

</body>
</html>