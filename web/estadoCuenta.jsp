<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="modelo.Cliente"%>
<%@page import="modelo.Morosidad"%>
<%@page import="modelo.Cuota"%>
<%@page import="modelo.Pago"%>

<%@page import="java.util.List"%>


<%
    Cliente cliente =
            (Cliente) request.getAttribute("cliente");


    List<Morosidad> cuotas =
            (List<Morosidad>) request.getAttribute("cuotas");


    List<Cuota> cuotasTodas =
            (List<Cuota>) request.getAttribute("cuotasTodas");


    List<Pago> pagos =
            (List<Pago>) request.getAttribute("pagos");


    Double totalDeudaObj =
            (Double) request.getAttribute("totalDeuda");


    double totalDeuda =
            totalDeudaObj != null
            ? totalDeudaObj
            : 0;


    int totalCuotas =
            cuotasTodas != null
            ? cuotasTodas.size()
            : 0;


    int totalPagos =
            pagos != null
            ? pagos.size()
            : 0;


    int cuotasVencidas = 0;

    int cuotasPendientes = 0;


    if (cuotas != null) {


        for (Morosidad cuota : cuotas) {


            if (
                    "VENCIDA".equalsIgnoreCase(
                            cuota.getEstado()
                    )
            ) {


                cuotasVencidas++;


            } else if (
                    "PENDIENTE".equalsIgnoreCase(
                            cuota.getEstado()
                    )
            ) {


                cuotasPendientes++;

            }

        }

    }
%>


<!DOCTYPE html>

<html>

<head>


    <meta charset="UTF-8">


    <title>
        Estado de Cuenta - Grupo Stellar
    </title>


    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilo.css"
    >


    <style>


        /* =====================================================
           CONTENEDOR PRINCIPAL
        ===================================================== */

        .estado-cuenta {

            max-width: 1200px;

            margin: auto;

        }


        /* =====================================================
           CABECERA
        ===================================================== */

        .cabecera-cuenta {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 25px;

            gap: 15px;

        }


        .cabecera-cuenta h1 {

            margin: 0;

            color: #1e293b;

        }


        .cabecera-cuenta p {

            margin-top: 6px;

            color: #64748b;

        }


        .acciones-cuenta {

            display: flex;

            gap: 8px;

        }


        .btn-imprimir {

            background: #2563eb;

            color: white;

            border: none;

            padding: 11px 18px;

            border-radius: 8px;

            cursor: pointer;

            font-weight: bold;

        }


        .btn-imprimir:hover {

            background: #1d4ed8;

        }


        .btn-volver {

            background: #64748b;

            color: white;

            text-decoration: none;

            padding: 11px 18px;

            border-radius: 8px;

            font-weight: bold;

        }


        .btn-volver:hover {

            background: #475569;

        }


        /* =====================================================
           INFORMACIÓN DEL CLIENTE
        ===================================================== */

        .cliente-card {

            background: white;

            border-radius: 14px;

            padding: 25px;

            margin-bottom: 20px;

            box-shadow: 0 4px 15px rgba(0,0,0,.08);

        }


        .cliente-card h2 {

            margin-top: 0;

            color: #0f172a;

        }


        .cliente-grid {

            display: grid;

            grid-template-columns: repeat(3, 1fr);

            gap: 18px;

        }


        .dato label {

            display: block;

            font-size: 12px;

            color: #64748b;

            margin-bottom: 5px;

        }


        .dato strong {

            font-size: 15px;

            color: #0f172a;

        }


        /* =====================================================
           RESUMEN
        ===================================================== */

        .resumen-grid {

            display: grid;

            grid-template-columns: repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 25px;

        }


        .resumen-card {

            background: white;

            border-radius: 14px;

            padding: 20px;

            box-shadow: 0 4px 15px rgba(0,0,0,.08);

        }


        .resumen-card span {

            display: block;

            color: #64748b;

            font-size: 13px;

            margin-bottom: 8px;

        }


        .resumen-card strong {

            font-size: 23px;

            color: #0f172a;

        }


        .deuda {

            color: #dc2626 !important;

        }


        .vencidas-numero {

            color: #dc2626 !important;

        }


        .pendientes-numero {

            color: #d97706 !important;

        }


        /* =====================================================
           SECCIONES
        ===================================================== */

        .seccion-cuenta {

            background: white;

            border-radius: 14px;

            padding: 25px;

            margin-bottom: 25px;

            box-shadow: 0 4px 15px rgba(0,0,0,.08);

        }


        .seccion-cuenta h2 {

            margin-top: 0;

            color: #0f172a;

        }


        /* =====================================================
           TABLAS
        ===================================================== */

        .tabla-cuenta {

            width: 100%;

            border-collapse: collapse;

            margin-top: 15px;

        }


        .tabla-cuenta th {

            background: #f1f5f9;

            color: #475569;

            padding: 13px;

            text-align: left;

            font-size: 13px;

            white-space: nowrap;

        }


        .tabla-cuenta td {

            padding: 13px;

            border-bottom: 1px solid #e2e8f0;

            font-size: 14px;

            color: #334155;

        }


        .tabla-cuenta tr:hover {

            background: #f8fafc;

        }


        .tabla-contenedor {

            width: 100%;

            overflow-x: auto;

        }


        /* =====================================================
           ESTADOS
        ===================================================== */

        .estado-badge {

            padding: 5px 10px;

            border-radius: 20px;

            font-size: 12px;

            font-weight: bold;

            display: inline-block;

            white-space: nowrap;

        }


        .estado-vencida {

            background: #fee2e2;

            color: #b91c1c;

        }


        .estado-pendiente {

            background: #fef3c7;

            color: #92400e;

        }


        .estado-pagada {

            background: #dcfce7;

            color: #166534;

        }


        .estado-anulada {

            background: #e2e8f0;

            color: #475569;

        }


        .atraso {

            color: #dc2626;

            font-weight: bold;

        }


        .sin-datos {

            text-align: center;

            padding: 30px;

            color: #64748b;

        }


        /* =====================================================
           TOTAL
        ===================================================== */

        .total-final {

            margin-top: 20px;

            display: flex;

            justify-content: flex-end;

            align-items: center;

            gap: 15px;

            padding-top: 18px;

            border-top: 2px solid #e2e8f0;

        }


        .total-final span {

            font-weight: bold;

            color: #475569;

        }


        .total-final strong {

            font-size: 25px;

            color: #dc2626;

        }


        /* =====================================================
           RESPONSIVE
        ===================================================== */

        @media (max-width: 900px) {


            .cliente-grid {

                grid-template-columns: repeat(2, 1fr);

            }


            .resumen-grid {

                grid-template-columns: repeat(2, 1fr);

            }

        }


        @media (max-width: 600px) {


            .cabecera-cuenta {

                flex-direction: column;

                align-items: flex-start;

            }


            .cliente-grid,
            .resumen-grid {

                grid-template-columns: 1fr;

            }


            .acciones-cuenta {

                width: 100%;

            }


            .btn-volver,
            .btn-imprimir {

                flex: 1;

                text-align: center;

            }


            .tabla-cuenta {

                min-width: 750px;

            }

        }


        /* =====================================================
           IMPRESIÓN
        ===================================================== */

        @media print {


            .sidebar,
            .acciones-cuenta {

                display: none !important;

            }


            .contenido {

                margin: 0 !important;

                width: 100% !important;

            }


            .estado-cuenta {

                max-width: 100%;

            }


            body {

                background: white;

            }


            .cliente-card,
            .resumen-card,
            .seccion-cuenta {

                box-shadow: none;

                border: 1px solid #ddd;

            }


            .tabla-cuenta {

                min-width: 0;

            }

        }


    </style>


</head>


<body>


<div class="sistema">


    <!-- =====================================================
         MENÚ LATERAL
    ===================================================== -->

    <jsp:include page="menu.jsp"/>


    <main class="contenido">


        <section class="contenido-principal">


            <div class="contenedor estado-cuenta">


                <!-- =================================================
                     CABECERA
                ================================================= -->

                <div class="cabecera-cuenta">


                    <div>


                        <h1>
                            📄 Estado de Cuenta
                        </h1>


                        <p>
                            Información financiera del cliente
                        </p>


                    </div>


                    <div class="acciones-cuenta">


                        <a
                            href="${pageContext.request.contextPath}/MorosidadServlet"
                            class="btn-volver"
                        >
                            ← Volver
                        </a>


                        <button
                            class="btn-imprimir"
                            onclick="window.print()"
                        >
                            🖨️ Imprimir
                        </button>


                    </div>


                </div>


                <!-- =================================================
                     INFORMACIÓN DEL CLIENTE
                ================================================= -->

                <div class="cliente-card">


                    <h2>
                        👤 Información del Cliente
                    </h2>


                    <div class="cliente-grid">


                        <div class="dato">


                            <label>
                                Código de cliente
                            </label>


                            <strong>
                                <%= cliente.getCodigoCliente() %>
                            </strong>


                        </div>


                        <div class="dato">


                            <label>
                                Cliente
                            </label>


                            <strong>

                                <%= cliente.getNombres() %>
                                <%= cliente.getApellidos() %>

                            </strong>


                        </div>


                        <div class="dato">


                            <label>
                                DNI
                            </label>


                            <strong>
                                <%= cliente.getDni() %>
                            </strong>


                        </div>


                        <div class="dato">


                            <label>
                                Teléfono
                            </label>


                            <strong>
                                <%= cliente.getTelefono() %>
                            </strong>


                        </div>


                        <div class="dato">


                            <label>
                                Plan contratado
                            </label>


                            <strong>
                                <%= cliente.getNombrePlan() %>
                            </strong>


                        </div>


                        <div class="dato">


                            <label>
                                Precio mensual
                            </label>


                            <strong>

                                S/
                                <%= String.format(
                                        "%.2f",
                                        cliente.getPrecioPlan()
                                ) %>

                            </strong>


                        </div>


                    </div>


                </div>


                <!-- =================================================
                     RESUMEN
                ================================================= -->

                <div class="resumen-grid">


                    <div class="resumen-card">


                        <span>
                            Total pendiente
                        </span>


                        <strong class="deuda">


                            S/
                            <%= String.format(
                                    "%.2f",
                                    totalDeuda
                            ) %>


                        </strong>


                    </div>


                    <div class="resumen-card">


                        <span>
                            Cuotas vencidas
                        </span>


                        <strong class="vencidas-numero">

                            <%= cuotasVencidas %>

                        </strong>


                    </div>


                    <div class="resumen-card">


                        <span>
                            Cuotas pendientes
                        </span>


                        <strong class="pendientes-numero">

                            <%= cuotasPendientes %>

                        </strong>


                    </div>


                    <div class="resumen-card">


                        <span>
                            Pagos registrados
                        </span>


                        <strong>

                            <%= totalPagos %>

                        </strong>


                    </div>


                </div>


                <!-- =================================================
                     CUOTAS PENDIENTES Y VENCIDAS
                ================================================= -->

                <div class="seccion-cuenta">


                    <h2>
                        💰 Cuotas pendientes y vencidas
                    </h2>


                    <% if (
                            cuotas != null &&
                            !cuotas.isEmpty()
                       ) { %>


                        <div class="tabla-contenedor">


                            <table class="tabla-cuenta">


                                <thead>


                                    <tr>

                                        <th>
                                            Periodo
                                        </th>

                                        <th>
                                            Generación
                                        </th>

                                        <th>
                                            Vencimiento
                                        </th>

                                        <th>
                                            Monto
                                        </th>

                                        <th>
                                            Estado
                                        </th>

                                        <th>
                                            Atraso
                                        </th>

                                    </tr>


                                </thead>


                                <tbody>


                                <% for (
                                        Morosidad cuota :
                                        cuotas
                                   ) { %>


                                    <tr>


                                        <td>
                                            <%= cuota.getPeriodo() %>
                                        </td>


                                        <td>
                                            <%= cuota.getFechaGeneracion() %>
                                        </td>


                                        <td>
                                            <%= cuota.getFechaVencimiento() %>
                                        </td>


                                        <td>


                                            <strong>

                                                S/
                                                <%= String.format(
                                                        "%.2f",
                                                        cuota.getMonto()
                                                ) %>

                                            </strong>


                                        </td>


                                        <td>


                                            <% if (
                                                "VENCIDA".equalsIgnoreCase(
                                                    cuota.getEstado()
                                                )
                                            ) { %>


                                                <span
                                                    class="estado-badge estado-vencida"
                                                >
                                                    VENCIDA
                                                </span>


                                            <% } else { %>


                                                <span
                                                    class="estado-badge estado-pendiente"
                                                >
                                                    PENDIENTE
                                                </span>


                                            <% } %>


                                        </td>


                                        <td>


                                            <% if (
                                                cuota.getDiasAtraso() > 0
                                            ) { %>


                                                <span class="atraso">

                                                    <%= cuota.getDiasAtraso() %>
                                                    días

                                                </span>


                                            <% } else { %>


                                                <span>
                                                    —
                                                </span>


                                            <% } %>


                                        </td>


                                    </tr>


                                <% } %>


                                </tbody>


                            </table>


                        </div>


                        <div class="total-final">


                            <span>
                                TOTAL DEUDA:
                            </span>


                            <strong>


                                S/
                                <%= String.format(
                                        "%.2f",
                                        totalDeuda
                                ) %>


                            </strong>


                        </div>


                    <% } else { %>


                        <div class="sin-datos">


                            ✅ Este cliente no tiene cuotas
                            pendientes ni vencidas.


                        </div>


                    <% } %>


                </div>


                <!-- =================================================
                     HISTORIAL COMPLETO DE CUOTAS
                ================================================= -->

                <div class="seccion-cuenta">


                    <h2>
                        📚 Historial Completo de Cuotas
                    </h2>


                    <p style="color: #64748b;">

                        Registro de todas las cuotas generadas
                        para este cliente.

                    </p>


                    <% if (
                            cuotasTodas != null &&
                            !cuotasTodas.isEmpty()
                       ) { %>


                        <div class="tabla-contenedor">


                            <table class="tabla-cuenta">


                                <thead>


                                    <tr>


                                        <th>
                                            Periodo
                                        </th>


                                        <th>
                                            Generación
                                        </th>


                                        <th>
                                            Vencimiento
                                        </th>


                                        <th>
                                            Fecha de pago
                                        </th>


                                        <th>
                                            Monto
                                        </th>


                                        <th>
                                            Estado
                                        </th>


                                    </tr>


                                </thead>


                                <tbody>


                                <% for (
                                        Cuota cuota :
                                        cuotasTodas
                                   ) { %>


                                    <tr>


                                        <td>
                                            <%= cuota.getPeriodo() %>
                                        </td>


                                        <td>
                                            <%= cuota.getFechaGeneracion() %>
                                        </td>


                                        <td>
                                            <%= cuota.getFechaVencimiento() %>
                                        </td>


                                        <td>


                                            <%= cuota.getFechaPago() != null &&
                                                !cuota.getFechaPago()
                                                      .trim()
                                                      .isEmpty()
                                                ? cuota.getFechaPago()
                                                : "—" %>


                                        </td>


                                        <td>


                                            <strong>


                                                S/
                                                <%= String.format(
                                                        "%.2f",
                                                        cuota.getMonto()
                                                ) %>


                                            </strong>


                                        </td>


                                        <td>


                                            <% if (
                                                "PAGADA".equalsIgnoreCase(
                                                    cuota.getEstado()
                                                )
                                            ) { %>


                                                <span
                                                    class="estado-badge estado-pagada"
                                                >
                                                    PAGADA
                                                </span>


                                            <% } else if (
                                                "VENCIDA".equalsIgnoreCase(
                                                    cuota.getEstado()
                                                )
                                            ) { %>


                                                <span
                                                    class="estado-badge estado-vencida"
                                                >
                                                    VENCIDA
                                                </span>


                                            <% } else if (
                                                "ANULADA".equalsIgnoreCase(
                                                    cuota.getEstado()
                                                )
                                            ) { %>


                                                <span
                                                    class="estado-badge estado-anulada"
                                                >
                                                    ANULADA
                                                </span>


                                            <% } else { %>


                                                <span
                                                    class="estado-badge estado-pendiente"
                                                >
                                                    PENDIENTE
                                                </span>


                                            <% } %>


                                        </td>


                                    </tr>


                                <% } %>


                                </tbody>


                            </table>


                        </div>


                    <% } else { %>


                        <div class="sin-datos">


                            📭 Este cliente todavía no tiene
                            historial de cuotas.


                        </div>


                    <% } %>


                </div>


                <!-- =================================================
                     HISTORIAL DE PAGOS
                ================================================= -->

                <div class="seccion-cuenta">


                    <h2>
                        🧾 Historial de Pagos
                    </h2>


                    <% if (
                            pagos != null &&
                            !pagos.isEmpty()
                       ) { %>


                        <div class="tabla-contenedor">


                            <table class="tabla-cuenta">


                                <thead>


                                    <tr>


                                        <th>
                                            Código
                                        </th>


                                        <th>
                                            Fecha
                                        </th>


                                        <th>
                                            Periodo
                                        </th>


                                        <th>
                                            Monto
                                        </th>


                                        <th>
                                            Método
                                        </th>


                                        <th>
                                            N.º Operación
                                        </th>


                                        <th>
                                            Usuario
                                        </th>


                                    </tr>


                                </thead>


                                <tbody>


                                <% for (
                                        Pago pago :
                                        pagos
                                   ) { %>


                                    <tr>


                                        <td>


                                            <strong>
                                                <%= pago.getCodigoPago() %>
                                            </strong>


                                        </td>


                                        <td>
                                            <%= pago.getFechaPago() %>
                                        </td>


                                        <td>
                                            <%= pago.getPeriodo() %>
                                        </td>


                                        <td>


                                            <strong>


                                                S/
                                                <%= String.format(
                                                        "%.2f",
                                                        pago.getMonto()
                                                ) %>


                                            </strong>


                                        </td>


                                        <td>
                                            <%= pago.getMetodoPago() %>
                                        </td>


                                        <td>


                                            <%= pago.getNumeroOperacion() != null
                                                    &&
                                                !pago.getNumeroOperacion()
                                                     .trim()
                                                     .isEmpty()
                                                ? pago.getNumeroOperacion()
                                                : "—" %>


                                        </td>


                                        <td>


                                            <%= pago.getNombreUsuario() != null
                                                    &&
                                                !pago.getNombreUsuario()
                                                     .trim()
                                                     .isEmpty()
                                                ? pago.getNombreUsuario()
                                                : "—" %>


                                        </td>


                                    </tr>


                                <% } %>


                                </tbody>


                            </table>


                        </div>


                    <% } else { %>


                        <div class="sin-datos">


                            📭 Este cliente todavía no tiene
                            pagos registrados.


                        </div>


                    <% } %>


                </div>


            </div>


        </section>


    </main>


</div>


</body>


</html>