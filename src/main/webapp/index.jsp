<%@ page contentType="text/html; charset=UTF-8" %>

<jsp:include page="includes/menu.jsp" />

<%
    String username = (session != null) ? (String) session.getAttribute("username") : null;
%>

<div class="container mt-5">

    <!-- Заголовок -->
    <div class="text-center mb-5">
        <h1 class="display-4">Добро пожаловать на сайт!</h1>
    </div>

    <!-- Сообщение о пользователе -->
    <% if (username != null) { %>
        <div class="alert alert-success text-center">
            Вы вошли как <strong><%= username %></strong> 🎉
        </div>
    <% } else { %>
        <div class="alert alert-info text-center">
            Вы не авторизованы. Пожалуйста, <a href="login.jsp" class="alert-link">войдите</a> или <a href="register.jsp" class="alert-link">зарегистрируйтесь</a>.
        </div>
    <% } %>

    <!-- Основные кнопки -->
    <div class="d-flex justify-content-center mt-4 flex-wrap">
        <a href="catalog.jsp" class="btn btn-primary btn-lg m-2">🛍️ Перейти в каталог товаров</a>
        <% if (username != null) { %>
            <a href="logout" class="btn btn-secondary btn-lg m-2">🚪 Выйти из системы</a>
        <% } else { %>
            <a href="login.jsp" class="btn btn-success btn-lg m-2">🔐 Войти</a>
            <a href="register.jsp" class="btn btn-warning btn-lg m-2">📝 Регистрация</a>
        <% } %>
    </div>

    <!-- Дополнительно -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>

</div>