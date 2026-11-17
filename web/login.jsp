
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Login - Sistema Grupo Stellar</title>

    <style>

        /* ==========================================
           CONFIGURACIÓN GENERAL
           ========================================== */

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;

            min-height: 100vh;

            display: flex;
            justify-content: center;
            align-items: center;

            padding: 20px;

            /*
             * FONDO FUTURISTA DEL LOGIN
             */

            background-image:
                linear-gradient(
                    rgba(2, 15, 30, 0.68),
                    rgba(2, 15, 30, 0.78)
                ),
                url("${pageContext.request.contextPath}/img/fondo-login.jpg");

            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }


        /* ==========================================
           CONTENEDOR DEL LOGIN
           ========================================== */

        .login {
            width: 100%;
            max-width: 430px;

            background: rgba(255, 255, 255, 0.97);

            padding: 40px 35px;

            border-radius: 20px;

            box-shadow:
                0 20px 60px
                rgba(0, 0, 0, 0.50);

            border: 1px solid rgba(255, 255, 255, 0.7);

            animation: aparecer 0.6s ease;
        }


        /* ==========================================
           ANIMACIÓN
           ========================================== */

        @keyframes aparecer {

            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }

        }


        /* ==========================================
           LOGO GRUPO STELLAR
           ========================================== */

        .logo {
            display: flex;

            justify-content: center;
            align-items: center;

            margin-bottom: 22px;
        }

        .logo-imagen {
            width: 155px;
            height: 155px;

            object-fit: contain;

            border-radius: 12px;

            display: block;
        }


        /* ==========================================
           TÍTULO
           ========================================== */

        h1 {
            text-align: center;

            margin: 0;

            font-size: 27px;

            color: #082f49;

            font-weight: bold;
        }

        .subtitulo {
            text-align: center;

            color: #64748b;

            margin-top: 10px;
            margin-bottom: 30px;

            font-size: 14px;
        }


        /* ==========================================
           ETIQUETAS
           ========================================== */

        label {
            display: block;

            font-weight: bold;

            margin-top: 17px;
            margin-bottom: 8px;

            color: #334155;

            font-size: 14px;
        }


        /* ==========================================
           CAMPOS DE TEXTO
           ========================================== */

        input {
            width: 100%;

            padding: 13px 14px;

            border: 1px solid #cbd5e1;

            border-radius: 8px;

            font-size: 15px;

            background-color: #f8fafc;

            color: #0f172a;

            transition: 0.2s;
        }

        input:focus {
            outline: none;

            border-color: #0891b2;

            background-color: white;

            box-shadow:
                0 0 0 3px
                rgba(8, 145, 178, 0.12);
        }

        input::placeholder {
            color: #94a3b8;
        }


        /* ==========================================
           BOTÓN INICIAR SESIÓN
           ========================================== */

        .boton {
            width: 100%;

            margin-top: 28px;

            padding: 14px;

            background:
                linear-gradient(
                    135deg,
                    #075985,
                    #0891b2
                );

            color: white;

            border: none;

            border-radius: 8px;

            font-size: 16px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.25s;
        }

        .boton:hover {
            background:
                linear-gradient(
                    135deg,
                    #0c4a6e,
                    #0e7490
                );

            transform: translateY(-1px);

            box-shadow:
                0 6px 15px
                rgba(8, 145, 178, 0.25);
        }

        .boton:active {
            transform: translateY(0);
        }


        /* ==========================================
           MENSAJE DE ERROR
           ========================================== */

        .error {
            background-color: #fef2f2;

            color: #b91c1c;

            padding: 12px;

            border-radius: 8px;

            text-align: center;

            margin-bottom: 18px;

            border: 1px solid #fecaca;

            font-size: 13px;

            font-weight: bold;
        }


        /* ==========================================
           PIE DE PÁGINA
           ========================================== */

        .footer {
            text-align: center;

            margin-top: 28px;

            padding-top: 20px;

            border-top: 1px solid #e2e8f0;

            color: #94a3b8;

            font-size: 13px;
        }


        /* ==========================================
           RESPONSIVE
           ========================================== */

        @media (max-width: 480px) {

            body {
                padding: 15px;
            }

            .login {
                padding: 30px 22px;
            }

            .logo-imagen {
                width: 125px;
                height: 125px;
            }

            h1 {
                font-size: 23px;
            }

        }

    </style>

</head>

<body>

<div class="login">


    <!-- ==========================================
         LOGO GRUPO STELLAR
         ========================================== -->

    <div class="logo">

        <img
            src="${pageContext.request.contextPath}/img/logo-stellar.jpg"
            alt="Logo Grupo Stellar"
            class="logo-imagen"
        >

    </div>


    <!-- ==========================================
         TÍTULO
         ========================================== -->

    <h1>
        Sistema Grupo Stellar
    </h1>

    <p class="subtitulo">
        Gestión de clientes y cobranzas
    </p>


    <!-- ==========================================
         MENSAJE DE ERROR
         ========================================== -->

    <%
        if (error != null) {
    %>

        <div class="error">

            ❌ <%= error %>

        </div>

    <%
        }
    %>


    <!-- ==========================================
         FORMULARIO DE LOGIN
         ========================================== -->

    <form
        action="LoginServlet"
        method="POST"
    >

        <!-- USUARIO -->

        <label for="usuario">
            Usuario
        </label>

        <input
            type="text"
            id="usuario"
            name="usuario"
            placeholder="Ingrese su usuario"
            autocomplete="username"
            required
        >


        <!-- CONTRASEÑA -->

        <label for="password">
            Contraseña
        </label>

        <input
            type="password"
            id="password"
            name="password"
            placeholder="Ingrese su contraseña"
            autocomplete="current-password"
            required
        >


        <!-- BOTÓN -->

        <button
            type="submit"
            class="boton"
        >

            🔐 Iniciar Sesión

        </button>

    </form>


    <!-- ==========================================
         FOOTER
         ========================================== -->

    <div class="footer">

        Sistema Grupo Stellar

        <br>

        <span>
            🌐 Conectando tu mundo
        </span>

    </div>


</div>

</body>

</html>