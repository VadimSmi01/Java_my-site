<%@ page contentType="text/html; charset=UTF-8" %>

<jsp:include page="includes/menu.jsp" />

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">

            <!-- Заголовок формы -->
            <h2 class="text-center mb-4">🔐 Вход в систему</h2>

            <!-- Форма входа -->
            <form method="post" action="login">
                <div class="form-group">
                    <label for="username">Имя пользователя</label>
                    <input type="text" name="username" id="username" class="form-control" required />
                </div>

                <div class="form-group">
                    <label for="password">Пароль</label>
                    <input type="password" name="password" id="password" class="form-control" required />
                </div>

                <button type="submit" class="btn btn-primary btn-block">Войти</button>
            </form>

            <!-- Дополнительные ссылки -->
            <div class="text-center mt-3">
                <p>Нет аккаунта? <a href="register.jsp">Зарегистрируйтесь</a></p>
            </div>

        </div>
    </div>

    <!-- Футер -->
    <footer class="mt-5 text-center text-muted">
        &copy; Все права защищены.
    </footer>
</div>