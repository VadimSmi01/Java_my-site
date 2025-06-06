<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Регистрация</title></head>
<body>
    <h2>Регистрация</h2>
    <form action="register" method="post">
        <label>Логин: <input type="text" name="username" required /></label><br/>
        <label>Пароль: <input type="password" name="password" required /></label><br/>
        <button type="submit">Зарегистрироваться</button>
    </form>
</body>
</html>
