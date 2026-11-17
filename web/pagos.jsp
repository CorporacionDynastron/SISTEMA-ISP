<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Pago"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Pagos - Sistema ISP</title>

    <!-- CSS PRINCIPAL -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">


    <style>

        /* ==========================================
           PAGOS
           ========================================== */

        .pagos-contenido {
            width: 100%;
        }


        /* ==========================================
           ENCABEZADO
           ========================================== */

        .encabezado-pagos {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
            gap: 15px;
        }

        .encabezado-pagos h1 {
            margin: 0;
            color: #0f172a;
            font-size: 28px;
        }

        .encabezado-pagos p {
            margin: 6px 0 0;
            color: #64748b;
            font-size: 14px;
        }


        /* ==========================================
           BOTÓN REGISTRAR
           ========================================== */

        .boton {
            display: inline-flex;
            align-items: center;
            justify-content: center;

            background-color: #2563eb;
            color: white;

            padding: 11px 18px;

            text-decoration: none;

            border-radius: 7px;

            font-weight: bold;
            font-size: 14px;

            white-space: nowrap;
        }

        .boton:hover {
            background-color: #1d4ed8;
        }


        /* ==========================================
           PANEL DE FILTROS
           ========================================== */

        .filtros {
            background-color: white;

            padding: 20px;

            border-radius: 12px;

            margin-bottom: 25px;

            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }

        .filtros-titulo {
            font-size: 17px;

            font-weight: bold;

            color: #0f172a;

            margin-bottom: 15px;
        }

        .filtros-grid {
            display: grid;

            grid-template-columns:
                2fr 1fr 1fr 1fr auto auto;

            gap: 12px;

            align-items: end;
        }

        .campo {
            display: flex;

            flex-direction: column;
        }

        .campo label {
            font-size: 12px;

            color: #64748b;

            margin-bottom: 6px;

            font-weight: bold;
        }

        .campo input,
        .campo select {
            height: 40px;

            border: 1px solid #cbd5e1;

            border-radius: 6px;

            padding: 0 10px;

            font-size: 13px;

            outline: none;

            background-color: white;
        }

        .campo input:focus,
        .campo select:focus {
            border-color: #2563eb;
        }


        /* ==========================================
           BOTONES FILTRO
           ========================================== */

        .btn-buscar {
            height: 40px;

            background-color: #2563eb;

            color: white;

            border: none;

            border-radius: 6px;

            padding: 0 18px;

            cursor: pointer;

            font-weight: bold;
        }

        .btn-buscar:hover {
            background-color: #1d4ed8;
        }

        .btn-limpiar {
            height: 40px;

            background-color: #64748b;

            color: white;

            border: none;

            border-radius: 6px;

            padding: 0 18px;

            cursor: pointer;

            text-decoration: none;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: bold;
        }

        .btn-limpiar:hover {
            background-color: #475569;
        }


        /* ==========================================
           TABLA
           ========================================== */

        .tabla-contenedor {
            width: 100%;

            overflow-x: auto;

            background-color: white;

            border-radius: 12px;

            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }

        table {
            width: 100%;

            border-collapse: collapse;

            min-width: 1100px;
        }

        th {
            background-color: #1f2937;

            color: white;

            padding: 12px;

            font-size: 13px;

            white-space: nowrap;
        }

        td {
            padding: 10px;

            border-bottom: 1px solid #e2e8f0;

            text-align: center;

            font-size: 13px;
        }

        tr:hover {
            background-color: #f8fafc;
        }

        .monto {
            font-weight: bold;

            color: #16a34a;
        }


        /* ==========================================
           COMPROBANTE
           ========================================== */

        .ver-comprobante {
            background-color: #16a34a;

            color: white;

            padding: 7px 12px;

            border-radius: 6px;

            text-decoration: none;

            font-size: 13px;

            border: none;

            cursor: pointer;
        }

        .ver-comprobante:hover {
            background-color: #15803d;
        }

        .sin-comprobante {
            color: #94a3b8;

            font-size: 13px;
        }


        /* ==========================================
           EDITAR
           ========================================== */

        .editar {
            color: #2563eb;

            font-weight: bold;

            text-decoration: none;
        }

        .editar:hover {
            color: #1d4ed8;
        }


        /* ==========================================
           ELIMINAR
           ========================================== */

        .eliminar {
            background-color: #dc2626;

            color: white;

            border: none;

            padding: 7px 12px;

            border-radius: 6px;

            font-size: 13px;

            cursor: pointer;

            margin-left: 8px;
        }

        .eliminar:hover {
            background-color: #b91c1c;
        }


        /* ==========================================
           MODAL
           ========================================== */

        .modal {
            display: none;

            position: fixed;

            z-index: 9999;

            left: 0;

            top: 0;

            width: 100%;

            height: 100%;

            background-color: rgba(15, 23, 42, 0.80);

            justify-content: center;

            align-items: center;

            padding: 20px;
        }

        .modal-contenido {
            background-color: white;

            width: 90%;

            max-width: 900px;

            max-height: 90vh;

            border-radius: 14px;

            overflow: hidden;

            box-shadow: 0 20px 50px rgba(0,0,0,0.30);

            display: flex;

            flex-direction: column;
        }

        .modal-header {
            background-color: #0f172a;

            color: white;

            padding: 18px 22px;

            display: flex;

            justify-content: space-between;

            align-items: center;
        }

        .modal-header h2 {
            margin: 0;

            font-size: 18px;
        }

        .cerrar {
            background: none;

            border: none;

            color: white;

            font-size: 28px;

            cursor: pointer;

            line-height: 1;
        }

        .cerrar:hover {
            color: #38bdf8;
        }

        .modal-body {
            display: flex;

            gap: 25px;

            padding: 25px;

            overflow-y: auto;
        }

        .comprobante-imagen {
            flex: 1;

            display: flex;

            justify-content: center;

            align-items: center;

            background-color: #f1f5f9;

            border-radius: 10px;

            padding: 15px;

            min-height: 300px;
        }

        .comprobante-imagen img {
            max-width: 100%;

            max-height: 500px;

            object-fit: contain;

            border-radius: 8px;
        }

        .datos-pago {
            width: 300px;
        }

        .datos-pago h3 {
            margin-top: 0;

            color: #0f172a;
        }

        .dato {
            border-bottom: 1px solid #e2e8f0;

            padding: 10px 0;
        }

        .dato span {
            display: block;

            color: #64748b;

            font-size: 12px;

            margin-bottom: 4px;
        }

        .dato strong {
            color: #1e293b;

            font-size: 14px;
        }


        /* ==========================================
           RESPONSIVE
           ========================================== */

        @media (max-width: 1100px) {

            .filtros-grid {
                grid-template-columns:
                    1fr 1fr 1fr;
            }

        }


        @media (max-width: 700px) {

            .encabezado-pagos {
                flex-direction: column;

                align-items: flex-start;
            }

            .boton {
                width: 100%;
            }

            .filtros-grid {
                grid-template-columns: 1fr;
            }

            .modal-contenido {
                width: 95%;
            }

            .modal-body {
                flex-direction: column;
            }

            .datos-pago {
                width: 100%;
            }

            .comprobante-imagen {
                min-height: 250px;
            }

        }
        
        
        
        
        
        
        
        
/* ==========================================
   GRUPO STELLAR - PAGOS PREMIUM
   Solo modifica la apariencia de pagos.jsp
   ========================================== */

.pagos-body {
    background-color: #020817;
    background-image:
        radial-gradient(ellipse at top right, rgba(37, 99, 235, .16), transparent 48%),
        linear-gradient(135deg, #020817 0%, #0b1224 55%, #07172b 100%);
    background-attachment: fixed;
    color: #e5eefb;
}

.pagos-body .contenido {
    background: transparent;
}

.pagos-body .contenido-principal {
    background: transparent;
    padding: 30px;
}

.pagos-body .pagos-contenido {
    max-width: 1800px;
    margin: 0 auto;
}

/* Encabezado */

.pagos-body .encabezado-pagos {
    margin-bottom: 28px;
}

.pagos-body .encabezado-pagos h1 {
    color: #f8fafc;
    font-size: 30px;
    font-weight: 800;
    letter-spacing: -.6px;
}

.pagos-body .encabezado-pagos p {
    color: #94a3b8;
    font-size: 14px;
}

/* Botón registrar */

.pagos-body .boton {
    background: linear-gradient(135deg, #2563eb, #1d4ed8);
    padding: 12px 20px;
    border: 1px solid rgba(96, 165, 250, .35);
    border-radius: 10px;
    box-shadow: 0 7px 20px rgba(37, 99, 235, .2);
    transition: transform .2s ease, box-shadow .2s ease;
}

.pagos-body .boton:hover {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    transform: translateY(-2px);
    box-shadow: 0 10px 24px rgba(37, 99, 235, .3);
}

/* Panel de filtros */

.pagos-body .filtros {
    background: rgba(15, 23, 42, .88);
    border: 1px solid #26364d;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 25px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, .16);
}

.pagos-body .filtros-titulo {
    color: #f1f5f9;
    font-size: 17px;
    margin-bottom: 20px;
}

.pagos-body .campo label {
    color: #a8b8ce;
    font-size: 12px;
    letter-spacing: .2px;
}

.pagos-body .campo input,
.pagos-body .campo select {
    width: 100%;
    height: 43px;
    background-color: #0b1528;
    color: #e5eefb;
    border: 1px solid #33445e;
    border-radius: 9px;
    padding: 0 12px;
    transition: border-color .2s, box-shadow .2s;
}

.pagos-body .campo input::placeholder {
    color: #64748b;
}

.pagos-body .campo input:focus,
.pagos-body .campo select:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, .13);
    outline: none;
}

/* Botones de filtros */

.pagos-body .btn-buscar,
.pagos-body .btn-limpiar {
    height: 43px;
    border-radius: 9px;
    padding: 0 17px;
    transition: background .2s, transform .2s;
}

.pagos-body .btn-buscar {
    background: #2563eb;
}

.pagos-body .btn-buscar:hover {
    background: #3b82f6;
    transform: translateY(-1px);
}

.pagos-body .btn-limpiar {
    background: #334155;
}

.pagos-body .btn-limpiar:hover {
    background: #475569;
}

/* Tabla de pagos */

.pagos-body .tabla-contenedor {
    background: #0b1528;
    border: 1px solid #26364d;
    border-radius: 16px;
    overflow-x: auto;
    box-shadow: 0 15px 40px rgba(0, 0, 0, .18);
}

.pagos-body .tabla-contenedor table {
    width: 100%;
    min-width: 1100px;
    border-collapse: separate;
    border-spacing: 0;
}

.pagos-body .tabla-contenedor th {
    background: #14233b;
    color: #cbdcf4;
    padding: 16px 13px;
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .5px;
    border-bottom: 1px solid #33445e;
}

.pagos-body .tabla-contenedor td {
    background: transparent;
    color: #dbe6f5;
    padding: 14px 12px;
    border-bottom: 1px solid rgba(51, 68, 94, .55);
    font-size: 12px;
    vertical-align: middle;
}

.pagos-body .tabla-contenedor tr:hover td {
    background: rgba(37, 99, 235, .08);
}

.pagos-body .tabla-contenedor tr:last-child td {
    border-bottom: none;
}

.pagos-body .monto {
    color: #4ade80;
    font-weight: 800;
    white-space: nowrap;
}

/* Comprobante */

.pagos-body .ver-comprobante {
    background: rgba(22, 163, 74, .15);
    color: #4ade80;
    border: 1px solid rgba(74, 222, 128, .3);
    border-radius: 8px;
    padding: 8px 12px;
    transition: background .2s;
}

.pagos-body .ver-comprobante:hover {
    background: rgba(22, 163, 74, .3);
}

.pagos-body .sin-comprobante {
    color: #8493a8;
    font-size: 12px;
}

/* Acciones */

.pagos-body .editar {
    color: #60a5fa;
    white-space: nowrap;
}

.pagos-body .editar:hover {
    color: #93c5fd;
}

.pagos-body .eliminar {
    background: rgba(220, 38, 38, .15);
    color: #fca5a5;
    border: 1px solid rgba(248, 113, 113, .3);
    border-radius: 8px;
    padding: 8px 11px;
    margin: 6px 0 0;
    white-space: nowrap;
}

.pagos-body .eliminar:hover {
    background: rgba(220, 38, 38, .3);
}

/* Modal del comprobante */

.pagos-body .modal {
    background: rgba(2, 8, 23, .85);
    backdrop-filter: blur(7px);
}

.pagos-body .modal-contenido {
    background: #0b1528;
    border: 1px solid #33445e;
    border-radius: 16px;
    box-shadow: 0 25px 80px rgba(0, 0, 0, .45);
}

.pagos-body .modal-header {
    background: #14233b;
    border-bottom: 1px solid #33445e;
}

.pagos-body .modal-header h2 {
    color: #f8fafc;
}

.pagos-body .cerrar:hover {
    color: #60a5fa;
}

.pagos-body .modal-body {
    background: #0b1528;
}

.pagos-body .comprobante-imagen {
    background: #111e32;
    border: 1px solid #26364d;
}

.pagos-body .datos-pago h3 {
    color: #f1f5f9;
}

.pagos-body .dato {
    border-bottom-color: #26364d;
}

.pagos-body .dato span {
    color: #94a3b8;
}

.pagos-body .dato strong {
    color: #e5eefb;
}

/* Adaptación a pantallas pequeñas */

@media (max-width: 900px) {
    .pagos-body .contenido-principal {
        padding: 22px;
    }

    .pagos-body .filtros-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 600px) {
    .pagos-body .contenido-principal {
        padding: 16px;
    }

    .pagos-body .encabezado-pagos h1 {
        font-size: 24px;
    }

    .pagos-body .filtros {
        padding: 16px;
    }

    .pagos-body .filtros-grid {
        grid-template-columns: 1fr;
    }

    .pagos-body .encabezado-pagos .boton {
        width: 100%;
    }

    .pagos-body .modal-body {
        padding: 16px;
        gap: 18px;
    }
}

    </style>

</head>


<body class="pagos-body">


<div class="sistema">


    <!-- ==========================================
         SIDEBAR
         ========================================== -->

    <jsp:include page="menu.jsp"/>


    <!-- ==========================================
         CONTENIDO PRINCIPAL
         ========================================== -->

    <main class="contenido">

        <section class="contenido-principal">

            <div class="pagos-contenido">


                <!-- ==========================================
                     ENCABEZADO
                     ========================================== -->

                <div class="encabezado-pagos">

                    <div>

                        <h1>
                            💰 Gestión de Pagos
                        </h1>

                        <p>
                            Administra y consulta los pagos registrados de los clientes.
                        </p>

                    </div>


                    <!-- REGISTRAR -->

                    <a
                        href="PagoServlet?accion=nuevo"
                        class="boton"
                    >
                        + Registrar Pago
                    </a>

                </div>


                <!-- ==========================================
                     FILTROS
                     ========================================== -->

                <div class="filtros">

                    <div class="filtros-titulo">
                        🔎 Buscar y filtrar pagos
                    </div>


                    <form
                        action="PagoServlet"
                        method="GET"
                    >

                        <input
                            type="hidden"
                            name="accion"
                            value="buscar"
                        >


                        <div class="filtros-grid">


                            <!-- BUSCADOR -->

                            <div class="campo">

                                <label>
                                    Cliente / Código / DNI
                                </label>

                                <input
                                    type="text"
                                    name="texto"
                                    placeholder="Ej: Pedro, CLI0004, 45678912..."
                                    value="<%= request.getAttribute("texto") != null
                                            ? request.getAttribute("texto")
                                            : "" %>"
                                >

                            </div>


                            <!-- FECHA DESDE -->

                            <div class="campo">

                                <label>
                                    Desde
                                </label>

                                <input
                                    type="date"
                                    name="fechaDesde"
                                    value="<%= request.getAttribute("fechaDesde") != null
                                            ? request.getAttribute("fechaDesde")
                                            : "" %>"
                                >

                            </div>


                            <!-- FECHA HASTA -->

                            <div class="campo">

                                <label>
                                    Hasta
                                </label>

                                <input
                                    type="date"
                                    name="fechaHasta"
                                    value="<%= request.getAttribute("fechaHasta") != null
                                            ? request.getAttribute("fechaHasta")
                                            : "" %>"
                                >

                            </div>


                            <!-- MÉTODO -->

                            <div class="campo">

                                <label>
                                    Método de pago
                                </label>

                                <select name="metodoPago">

                                    <option value="">
                                        Todos
                                    </option>

                                    <option
                                        value="Yape"
                                        <%= "Yape".equals(
                                                request.getAttribute("metodoPago")
                                           ) ? "selected" : "" %>
                                    >
                                        Yape
                                    </option>

                                    <option
                                        value="Plin"
                                        <%= "Plin".equals(
                                                request.getAttribute("metodoPago")
                                           ) ? "selected" : "" %>
                                    >
                                        Plin
                                    </option>

                                    <option
                                        value="Transferencia"
                                        <%= "Transferencia".equals(
                                                request.getAttribute("metodoPago")
                                           ) ? "selected" : "" %>
                                    >
                                        Transferencia
                                    </option>

                                    <option
                                        value="Efectivo"
                                        <%= "Efectivo".equals(
                                                request.getAttribute("metodoPago")
                                           ) ? "selected" : "" %>
                                    >
                                        Efectivo
                                    </option>

                                    <option
                                        value="Depósito"
                                        <%= "Depósito".equals(
                                                request.getAttribute("metodoPago")
                                           ) ? "selected" : "" %>
                                    >
                                        Depósito
                                    </option>

                                </select>

                            </div>


                            <!-- BUSCAR -->

                            <button
                                type="submit"
                                class="btn-buscar"
                            >
                                🔍 Buscar
                            </button>


                            <!-- LIMPIAR -->

                            <a
                                href="PagoServlet"
                                class="btn-limpiar"
                            >
                                🔄 Limpiar
                            </a>


                        </div>

                    </form>

                </div>


                <!-- ==========================================
                     TABLA
                     ========================================== -->

                <div class="tabla-contenedor">

                    <table>

                        <tr>

                            <th>ID</th>

                            <th>Código Cliente</th>

                            <th>Cliente</th>

                            <th>Fecha de Pago</th>

                            <th>Periodo</th>

                            <th>Monto</th>

                            <th>Método</th>

                            <th>N.º Operación</th>

                            <th>Comprobante</th>

                            <th>Observación</th>

                            <th>Acciones</th>

                        </tr>


                        <%

                            List<Pago> pagos =
                                    (List<Pago>) request.getAttribute("pagos");


                            if (pagos != null &&
                                    !pagos.isEmpty()) {


                                for (Pago pago : pagos) {

                        %>


                        <tr>


                            <!-- ID -->

                            <td>
                                <%= pago.getIdPago() %>
                            </td>


                            <!-- CÓDIGO -->

                            <td>
                                <%= pago.getCodigoCliente() %>
                            </td>


                            <!-- CLIENTE -->

                            <td>
                                <%= pago.getNombreCliente() %>
                            </td>


                            <!-- FECHA -->

                            <td>
                                <%= pago.getFechaPago() %>
                            </td>


                            <!-- PERIODO -->

                            <td>
                                <%= pago.getPeriodo() %>
                            </td>


                            <!-- MONTO -->

                            <td class="monto">
                                S/ <%= pago.getMonto() %>
                            </td>


                            <!-- MÉTODO -->

                            <td>
                                <%= pago.getMetodoPago() %>
                            </td>


                            <!-- OPERACIÓN -->

                            <td>
                                <%= pago.getNumeroOperacion() %>
                            </td>


                            <!-- COMPROBANTE -->

                            <td>

                                <%

                                    if (pago.getComprobante() != null
                                            && !pago.getComprobante().isEmpty()) {

                                %>


                                    <button
                                        type="button"
                                        class="ver-comprobante"
                                        onclick="abrirComprobante(
                                            <%= pago.getIdPago() %>,
                                            '<%= pago.getNombreCliente()
                                                    .replace("'", "\\'") %>',
                                            '<%= pago.getFechaPago() %>',
                                            '<%= pago.getPeriodo() %>',
                                            '<%= pago.getMonto() %>',
                                            '<%= pago.getMetodoPago() %>',
                                            '<%= pago.getNumeroOperacion() == null
                                                    ? ""
                                                    : pago.getNumeroOperacion()
                                                            .replace("'", "\\'") %>'
                                        )"
                                    >
                                        👁️ Ver
                                    </button>


                                <%

                                    } else {

                                %>


                                    <span class="sin-comprobante">
                                        Sin archivo
                                    </span>


                                <%

                                    }

                                %>

                            </td>


                            <!-- OBSERVACIÓN -->

                            <td>
                                <%= pago.getObservacion() %>
                            </td>


                            <!-- ACCIONES -->

                            <td>


                                <!-- EDITAR -->

                                <a
                                    href="PagoServlet?accion=editar&id=<%= pago.getIdPago() %>"
                                    class="editar"
                                >
                                    ✏️ Editar
                                </a>


                                <!-- ELIMINAR -->

                                <form
                                    action="PagoServlet"
                                    method="POST"
                                    style="display:inline;"
                                    onsubmit="return confirmarEliminacion();"
                                >

                                    <input
                                        type="hidden"
                                        name="accion"
                                        value="eliminar"
                                    >

                                    <input
                                        type="hidden"
                                        name="idPago"
                                        value="<%= pago.getIdPago() %>"
                                    >


                                    <button
                                        type="submit"
                                        class="eliminar"
                                    >
                                        🗑️ Eliminar
                                    </button>

                                </form>


                            </td>


                        </tr>


                        <%

                                }

                            } else {

                        %>


                        <tr>

                            <td
                                colspan="11"
                                style="
                                    padding:30px;
                                    color:#64748b;
                                "
                            >
                                🔍 No se encontraron pagos con esos filtros.
                            </td>

                        </tr>


                        <%

                            }

                        %>


                    </table>

                </div>


            </div>

        </section>

    </main>

</div>


<!-- ==========================================
     MODAL COMPROBANTE
     ========================================== -->

<div
    id="modalComprobante"
    class="modal"
    onclick="cerrarModal(event)"
>


    <div
        class="modal-contenido"
        onclick="event.stopPropagation()"
    >


        <div class="modal-header">

            <h2>
                🧾 Comprobante de Pago
            </h2>


            <button
                class="cerrar"
                onclick="cerrarModal()"
            >
                ×
            </button>

        </div>


        <div class="modal-body">


            <!-- IMAGEN -->

            <div class="comprobante-imagen">

                <img
                    id="imagenComprobante"
                    src=""
                    alt="Comprobante de pago"
                >

            </div>


            <!-- DATOS -->

            <div class="datos-pago">

                <h3>
                    Información del pago
                </h3>


                <div class="dato">

                    <span>
                        Cliente
                    </span>

                    <strong id="modalCliente">
                        -
                    </strong>

                </div>


                <div class="dato">

                    <span>
                        Fecha de pago
                    </span>

                    <strong id="modalFecha">
                        -
                    </strong>

                </div>


                <div class="dato">

                    <span>
                        Periodo
                    </span>

                    <strong id="modalPeriodo">
                        -
                    </strong>

                </div>


                <div class="dato">

                    <span>
                        Monto
                    </span>

                    <strong id="modalMonto">
                        -
                    </strong>

                </div>


                <div class="dato">

                    <span>
                        Método de pago
                    </span>

                    <strong id="modalMetodo">
                        -
                    </strong>

                </div>


                <div class="dato">

                    <span>
                        N.º de operación
                    </span>

                    <strong id="modalOperacion">
                        -
                    </strong>

                </div>


            </div>

        </div>

    </div>

</div>


<!-- ==========================================
     JAVASCRIPT
     ========================================== -->

<script>


    // ==========================================
    // ABRIR COMPROBANTE
    // ==========================================

    function abrirComprobante(
            id,
            cliente,
            fecha,
            periodo,
            monto,
            metodo,
            operacion) {


        document.getElementById(
            "imagenComprobante"
        ).src =
            "ComprobanteServlet?id=" + id;


        document.getElementById(
            "modalCliente"
        ).textContent =
            cliente;


        document.getElementById(
            "modalFecha"
        ).textContent =
            fecha;


        document.getElementById(
            "modalPeriodo"
        ).textContent =
            periodo;


        document.getElementById(
            "modalMonto"
        ).textContent =
            "S/ " + monto;


        document.getElementById(
            "modalMetodo"
        ).textContent =
            metodo;


        document.getElementById(
            "modalOperacion"
        ).textContent =
            operacion || "No registrado";


        document.getElementById(
            "modalComprobante"
        ).style.display =
            "flex";
    }


    // ==========================================
    // CERRAR MODAL
    // ==========================================

    function cerrarModal(event) {


        if (event &&
            event.target.id !==
            "modalComprobante") {

            return;
        }


        document.getElementById(
            "modalComprobante"
        ).style.display =
            "none";


        document.getElementById(
            "imagenComprobante"
        ).src =
            "";
    }


    // ==========================================
    // CONFIRMAR ELIMINACIÓN
    // ==========================================

    function confirmarEliminacion() {

        return confirm(
            "⚠️ ¿Estás seguro de eliminar este pago?\n\n" +
            "También se eliminará su comprobante.\n\n" +
            "Esta acción no se puede deshacer."
        );
    }


    // ==========================================
    // ESC PARA CERRAR MODAL
    // ==========================================

    document.addEventListener(
        "keydown",
        function(event) {

            if (event.key === "Escape") {

                cerrarModal();

            }

        }
    );

</script>


</body>

</html>