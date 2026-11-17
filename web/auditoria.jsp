
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="modelo.Auditoria" %>
<%@ page import="java.util.List" %>

<%
    List<Auditoria> auditorias =
            (List<Auditoria>) request.getAttribute("auditorias");

    String buscarActual =
            (String) request.getAttribute("buscarActual");

    String moduloActual =
            (String) request.getAttribute("moduloActual");

    String accionActual =
            (String) request.getAttribute("accionActual");

    if (buscarActual == null) {
        buscarActual = "";
    }

    if (moduloActual == null) {
        moduloActual = "";
    }

    if (accionActual == null) {
        accionActual = "";
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Historial y Auditoría | Grupo Stellar</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">

    <style>

        .auditoria-contenedor {
            padding: 25px;
        }

        .auditoria-encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .auditoria-encabezado h1 {
            margin: 0;
            color: #1e293b;
            font-size: 27px;
        }

        .auditoria-encabezado p {
            margin-top: 8px;
            color: #64748b;
        }

        .auditoria-tarjeta {
            background: #ffffff;
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 4px 15px rgba(15, 23, 42, 0.06);
            margin-bottom: 22px;
        }

        .auditoria-filtros {
            display: grid;
            grid-template-columns:
                minmax(180px, 2fr)
                minmax(150px, 1fr)
                minmax(150px, 1fr)
                auto;
            gap: 12px;
            align-items: end;
        }

        .campo-filtro {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .campo-filtro label {
            font-size: 13px;
            font-weight: bold;
            color: #475569;
        }

        .campo-filtro input,
        .campo-filtro select {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            background: #ffffff;
        }

        .campo-filtro input:focus,
        .campo-filtro select:focus {
            border-color: #2563eb;
        }

        .btn-filtrar {
            padding: 11px 18px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: #ffffff;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
        }

        .btn-filtrar:hover {
            background: #1d4ed8;
        }

        .btn-limpiar {
            display: inline-block;
            margin-top: 12px;
            padding: 9px 14px;
            border-radius: 8px;
            background: #e2e8f0;
            color: #334155;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .auditoria-tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        .auditoria-tabla {
            width: 100%;
            min-width: 900px;
            border-collapse: collapse;
            font-size: 13px;
        }

        .auditoria-tabla thead {
            background: #0f172a;
            color: #ffffff;
        }

        .auditoria-tabla th {
            padding: 14px 12px;
            text-align: left;
            white-space: nowrap;
        }

        .auditoria-tabla td {
            padding: 13px 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            vertical-align: top;
        }

        .auditoria-tabla tbody tr:hover {
            background: #f8fafc;
        }

        .badge-modulo,
        .badge-accion {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            white-space: nowrap;
        }

        .badge-modulo {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .badge-accion {
            background: #dcfce7;
            color: #166534;
        }

        .descripcion-auditoria {
            max-width: 350px;
            line-height: 1.5;
        }

        .sin-registros {
            text-align: center;
            padding: 35px !important;
            color: #64748b !important;
        }

        .contador-registros {
            margin-bottom: 15px;
            color: #64748b;
            font-size: 14px;
        }

        @media (max-width: 900px) {

            .auditoria-contenedor {
                padding: 15px;
            }

            .auditoria-filtros {
                grid-template-columns: 1fr;
            }

            .auditoria-encabezado h1 {
                font-size: 22px;
            }
        }

    </style>

</head>

<body>

    <div class="sistema">

        <jsp:include page="menu.jsp"/>

        <main class="contenido">

            <div class="auditoria-contenedor">

                <div class="auditoria-encabezado">

                    <div>

                        <h1>🛡️ Historial y Auditoría</h1>

                        <p>
                            Registro de las acciones realizadas
                            en el sistema Grupo Stellar.
                        </p>

                    </div>

                </div>

                <!-- FILTROS -->

                <div class="auditoria-tarjeta">

                    <form method="GET"
                          action="${pageContext.request.contextPath}/AuditoriaServlet">

                        <div class="auditoria-filtros">

                            <div class="campo-filtro">

                                <label for="buscar">
                                    Buscar
                                </label>

                                <input
                                    type="text"
                                    id="buscar"
                                    name="buscar"
                                    placeholder="Módulo, acción o descripción..."
                                    value="<%= buscarActual %>"
                                >

                            </div>

                            <div class="campo-filtro">

                                <label for="modulo">
                                    Módulo
                                </label>

                                <select id="modulo"
                                        name="modulo">

                                    <option value="">
                                        Todos los módulos
                                    </option>

                                    <option value="CLIENTES"
                                        <%= "CLIENTES".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Clientes
                                    </option>

                                    <option value="PAGOS"
                                        <%= "PAGOS".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Pagos
                                    </option>

                                    <option value="CUOTAS"
                                        <%= "CUOTAS".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Cuotas
                                    </option>

                                    <option value="PLANES"
                                        <%= "PLANES".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Planes
                                    </option>

                                    <option value="COBRANZAS"
                                        <%= "COBRANZAS".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Cobranzas
                                    </option>

                                    <option value="USUARIOS"
                                        <%= "USUARIOS".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Usuarios
                                    </option>

                                    <option value="SISTEMA"
                                        <%= "SISTEMA".equals(moduloActual)
                                                ? "selected" : "" %>>
                                        Sistema
                                    </option>

                                </select>

                            </div>

                            <div class="campo-filtro">

                                <label for="accion">
                                    Acción
                                </label>

                                <select id="accion"
                                        name="accion">

                                    <option value="">
                                        Todas las acciones
                                    </option>

                                    <option value="REGISTRAR"
                                        <%= "REGISTRAR".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Registrar
                                    </option>

                                    <option value="ACTUALIZAR"
                                        <%= "ACTUALIZAR".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Actualizar
                                    </option>

                                    <option value="ELIMINAR"
                                        <%= "ELIMINAR".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Eliminar
                                    </option>

                                    <option value="ANULAR"
                                        <%= "ANULAR".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Anular
                                    </option>

                                    <option value="LOGIN"
                                        <%= "LOGIN".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Inicio de sesión
                                    </option>

                                    <option value="LOGOUT"
                                        <%= "LOGOUT".equals(accionActual)
                                                ? "selected" : "" %>>
                                        Cierre de sesión
                                    </option>

                                </select>

                            </div>

                            <div>

                                <button type="submit"
                                        class="btn-filtrar">

                                    🔍 Filtrar

                                </button>

                            </div>

                        </div>

                        <a href="${pageContext.request.contextPath}/AuditoriaServlet"
                           class="btn-limpiar">

                            ↺ Limpiar filtros

                        </a>

                    </form>

                </div>

                <!-- TABLA DE AUDITORÍA -->

                <div class="auditoria-tarjeta">

                    <div class="contador-registros">

                        <strong>
                            Historial de actividades
                        </strong>

                        <%
                            int cantidadRegistros = 0;

                            if (auditorias != null) {
                                cantidadRegistros = auditorias.size();
                            }
                        %>

                        <span>
                            — <%= cantidadRegistros %> registro(s)
                        </span>

                    </div>

                    <div class="auditoria-tabla-contenedor">

                        <table class="auditoria-tabla">

                            <thead>

                                <tr>

                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Módulo</th>
                                    <th>Acción</th>
                                    <th>ID Registro</th>
                                    <th>Descripción</th>
                                    <th>Fecha y hora</th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    if (auditorias != null
                                            && !auditorias.isEmpty()) {

                                        for (Auditoria auditoria : auditorias) {
                                %>

                                <tr>

                                    <td>
                                        <%= auditoria.getIdAuditoria() %>
                                    </td>

                                    <td>
                                        Usuario #<%= auditoria.getIdUsuario() %>
                                    </td>

                                    <td>

                                        <span class="badge-modulo">
                                            <%= auditoria.getModulo() %>
                                        </span>

                                    </td>

                                    <td>

                                        <span class="badge-accion">
                                            <%= auditoria.getAccion() %>
                                        </span>

                                    </td>

                                    <td>
                                        <%= auditoria.getIdRegistro() %>
                                    </td>

                                    <td class="descripcion-auditoria">
                                        <%= auditoria.getDescripcion() %>
                                    </td>

                                    <td>
                                        <%= auditoria.getFechaHora() %>
                                    </td>

                                </tr>

                                <%
                                        }

                                    } else {
                                %>

                                <tr>

                                    <td colspan="7"
                                        class="sin-registros">

                                        📋 No se encontraron registros
                                        de auditoría.

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </main>

    </div>

</body>

</html>