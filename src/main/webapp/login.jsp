<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Вход</title>
</head>
<body>
<h2>Вход</h2>
<form method="post" action="login">
    <label for="username">Имя пользователя:</label>
    <input type="text" name="username" required>
    <br>
    <label for="password">Пароль:</label>
    <input type="password" name="password" required>
    <br>
    <button type="submit">Войти</button>
</form>
</body>
</html>