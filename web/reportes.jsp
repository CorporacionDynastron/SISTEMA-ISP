
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="modelo.Pago"%>
<%@page import="java.util.List"%>

<%
    Double totalRecaudado =
            (Double) request.getAttribute("totalRecaudado");

    Integer cantidadPagos =
            (Integer) request.getAttribute("cantidadPagos");

    Double totalYape =
            (Double) request.getAttribute("totalYape");

    Double totalPlin =
            (Double) request.getAttribute("totalPlin");

    Double totalEfectivo =
            (Double) request.getAttribute("totalEfectivo");

    Double totalTransferencia =
            (Double) request.getAttribute("totalTransferencia");

    List<Pago> pagosMes =
            (List<Pago>) request.getAttribute("pagosMes");

    if (totalRecaudado == null) totalRecaudado = 0.0;
    if (cantidadPagos == null) cantidadPagos = 0;
    if (totalYape == null) totalYape = 0.0;
    if (totalPlin == null) totalPlin = 0.0;
    if (totalEfectivo == null) totalEfectivo = 0.0;
    if (totalTransferencia == null) totalTransferencia = 0.0;

    if (pagosMes == null) {
        pagosMes = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Reportes - Sistema ISP</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">

    <style>

        .reportes-contenedor {
            padding: 30px;
            max-width: 1600px;
            margin: auto;
        }

        .encabezado {
            margin-bottom: 25px;
        }

        .encabezado h1 {
            margin: 0;
            font-size: 30px;
        }

        .encabezado p {
            color: #6b7280;
        }

        /* FILTROS */

        .filtros-reporte {
            display: flex;
            flex-wrap: wrap;
            align-items: end;
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        }

        .filtros-reporte div {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filtros-reporte label {
            font-weight: bold;
            color: #334155;
            font-size: 14px;
        }

        .filtros-reporte input {
            padding: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-family: Arial, sans-serif;
        }

        .btn-exportar {
            display: inline-block;
            padding: 11px 18px;
            background: #166534;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }

        .btn-exportar:hover {
            background: #14532d;
        }

        /* RESUMEN */

        .resumen {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .tarjeta {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .titulo {
            color: #6b7280;
            font-size: 15px;
            margin-bottom: 10px;
        }

        .numero {
            font-size: 30px;
            font-weight: bold;
        }

        .recaudado {
            border-left: 5px solid #16a34a;
        }

        .pagos {
            border-left: 5px solid #2563eb;
        }

        /* SECCIONES */

        .seccion {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .seccion h2 {
            margin-top: 0;
            margin-bottom: 25px;
        }

        /* METODOS */

        .metodos {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .metodo {
            padding: 20px;
            border-radius: 10px;
            background-color: #f8fafc;
            text-align: center;
        }

        .metodo h3 {
            margin-top: 0;
        }

        .monto {
            font-size: 24px;
            font-weight: bold;
        }

        /* TABLA */

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        .tabla {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        .tabla th {
            background-color: #1f2937;
            color: white;
            padding: 14px;
            text-align: left;
            font-size: 13px;
            white-space: nowrap;
        }

        .tabla td {
            padding: 13px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
            white-space: nowrap;
        }

        .tabla tbody tr:hover {
            background-color: #f8fafc;
        }

        .codigo {
            color: #2563eb;
            font-weight: bold;
        }

        .monto-tabla {
            color: #15803d;
            font-weight: bold;
        }

        .estado {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            background-color: #dcfce7;
            color: #166534;
            font-size: 12px;
            font-weight: bold;
        }

        .sin-datos {
            text-align: center;
            padding: 35px;
            color: #6b7280;
        }

        .boton {
            display: inline-block;
            padding: 12px 18px;
            background-color: #1f2937;
            color: white;
            text-decoration: none;
            border-radius: 7px;
        }

        .boton:hover {
            background-color: #111827;
        }

        @media (max-width: 900px) {

            .metodos {
                grid-template-columns: repeat(2, 1fr);
            }

        }

        @media (max-width: 600px) {

            .reportes-contenedor {
                padding: 15px;
            }

            .resumen {
                grid-template-columns: 1fr;
            }

            .metodos {
                grid-template-columns: 1fr;
            }

            .encabezado h1 {
                font-size: 24px;
            }

            .filtros-reporte {
                flex-direction: column;
                align-items: stretch;
            }

        }
        
        
        
        
        
        
        /* =========================================
           GRUPO STELLAR - REPORTES PREMIUM
           Solo cambios visuales
           ========================================= */

        body.reportes-body {
            background: #0b1120;
            color: #e2e8f0;
        }

        .reportes-body .contenido {
            min-height: 100vh;
            background:
                radial-gradient(ellipse at top right, rgba(37, 99, 235, 0.08), transparent 42%),
                #0b1120;
        }

        .reportes-body .reportes-contenedor {
            padding: 28px;
            max-width: 1600px;
        }

        /* Encabezado */

        .reportes-body .encabezado h1 {
            color: #f8fafc;
            font-size: 30px;
            letter-spacing: -0.5px;
        }

        .reportes-body .encabezado p {
            color: #94a3b8;
            line-height: 1.6;
        }

        /* Filtros */

        .reportes-body .filtros-reporte {
            background: linear-gradient(145deg, #172338, #111c30);
            border: 1px solid #29384e;
            border-radius: 16px;
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.18);
        }

        .reportes-body .filtros-reporte label {
            color: #cbd5e1;
            font-size: 13px;
        }

        .reportes-body .filtros-reporte input {
            background: #0b1425;
            color: #f8fafc;
            border: 1px solid #34445b;
            border-radius: 9px;
            padding: 11px 12px;
            color-scheme: dark;
        }

        .reportes-body .filtros-reporte input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.14);
        }

        .reportes-body .btn-filtrar {
            padding: 12px 18px;
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 9px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .reportes-body .btn-filtrar:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .reportes-body .form-exportar {
            margin: -15px 0 28px;
        }

        .reportes-body .btn-exportar {
            background: #15803d;
            padding: 12px 18px;
            border: 1px solid #22c55e;
            border-radius: 9px;
            transition: background 0.2s, transform 0.2s;
        }

        .reportes-body .btn-exportar:hover {
            background: #166534;
            transform: translateY(-1px);
        }

        /* Resumen general */

        .reportes-body .tarjeta {
            background: linear-gradient(145deg, #172338, #111c30);
            border: 1px solid #29384e;
            border-left: 4px solid #16a34a;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.17);
            transition: transform 0.2s, border-color 0.2s;
        }

        .reportes-body .tarjeta:hover {
            transform: translateY(-3px);
        }

        .reportes-body .tarjeta.recaudado {
            border-left-color: #22c55e;
        }

        .reportes-body .tarjeta.pagos {
            border-left-color: #3b82f6;
        }

        .reportes-body .titulo {
            color: #aebed2;
            font-size: 14px;
        }

        .reportes-body .numero {
            color: #f8fafc;
            font-size: 32px;
        }

        .reportes-body .tarjeta.recaudado .numero {
            color: #4ade80;
        }

        .reportes-body .tarjeta.pagos .numero {
            color: #60a5fa;
        }

        /* Secciones */

        .reportes-body .seccion {
            background: linear-gradient(145deg, #172338, #111c30);
            border: 1px solid #29384e;
            border-radius: 16px;
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.17);
            padding: 24px;
            margin-bottom: 26px;
        }

        .reportes-body .seccion h2 {
            color: #f1f5f9;
            font-size: 20px;
            margin-bottom: 24px;
        }

        /* Métodos de pago */

        .reportes-body .metodo {
            background: #0e192b;
            border: 1px solid #2b3b51;
            border-radius: 13px;
            padding: 22px 15px;
            transition: transform 0.2s, border-color 0.2s;
        }

        .reportes-body .metodo:hover {
            transform: translateY(-3px);
            border-color: #3b82f6;
        }

        .reportes-body .metodo h3 {
            color: #cbd5e1;
            font-size: 15px;
        }

        .reportes-body .monto {
            color: #4ade80;
            font-size: 25px;
            overflow-wrap: anywhere;
        }

        /* Tabla */

        .reportes-body .tabla-contenedor {
            border: 1px solid #2b3b51;
            border-radius: 12px;
            overflow-x: auto;
            background: #111c30;
        }

        .reportes-body .tabla {
            border-collapse: separate;
            border-spacing: 0;
            min-width: 1000px;
        }

        .reportes-body .tabla th {
            background: #1b2b43;
            color: #dbeafe;
            padding: 15px 14px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.35px;
            border-bottom: 1px solid #3a4b64;
        }

        .reportes-body .tabla td {
            color: #cbd5e1;
            padding: 14px;
            border-bottom: 1px solid #26364b;
            font-size: 13px;
        }

        .reportes-body .tabla tbody tr {
            background: #111c30;
            transition: background 0.15s;
        }

        .reportes-body .tabla tbody tr:nth-child(even) {
            background: #142035;
        }

        .reportes-body .tabla tbody tr:hover {
            background: #1d304b;
        }

        .reportes-body .tabla tbody tr:last-child td {
            border-bottom: none;
        }

        .reportes-body .codigo {
            color: #60a5fa;
            font-weight: 700;
        }

        .reportes-body .monto-tabla {
            color: #4ade80;
            font-weight: 700;
        }

        .reportes-body .estado {
            background: #123b2a;
            color: #86efac;
            border: 1px solid #226344;
            border-radius: 20px;
            padding: 6px 10px;
            font-size: 11px;
        }

        .reportes-body .sin-datos {
            color: #94a3b8;
            padding: 35px;
            text-align: center;
        }

        /* Volver al dashboard */

        .reportes-body .boton {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            background: #1d4ed8;
            color: #fff;
            border: 1px solid #3b82f6;
            border-radius: 9px;
            font-weight: 700;
            transition: background 0.2s, transform 0.2s;
        }

        .reportes-body .boton:hover {
            background: #1e40af;
            transform: translateY(-1px);
        }

        /* Adaptación a pantallas pequeñas */

        @media (max-width: 900px) {
            .reportes-body .reportes-contenedor {
                padding: 20px;
            }

            .reportes-body .metodos {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 600px) {
            .reportes-body .reportes-contenedor {
                padding: 14px;
            }

            .reportes-body .encabezado h1 {
                font-size: 24px;
            }

            .reportes-body .resumen,
            .reportes-body .metodos {
                grid-template-columns: minmax(0, 1fr);
            }

            .reportes-body .filtros-reporte {
                flex-direction: column;
                align-items: stretch;
            }

            .reportes-body .filtros-reporte div,
            .reportes-body .filtros-reporte input,
            .reportes-body .btn-filtrar {
                width: 100%;
                box-sizing: border-box;
            }

            .reportes-body .seccion {
                padding: 15px;
            }

            .reportes-body .form-exportar {
                margin-top: -12px;
            }
        }

    </style>

</head>

<body class="reportes-body">

    <div class="sistema">

        <!-- MENÚ LATERAL -->

        <jsp:include page="menu.jsp"/>

        <!-- CONTENIDO PRINCIPAL -->

        <main class="contenido">

            <div class="reportes-contenedor">

                <!-- ENCABEZADO -->

                <div class="encabezado">

                    <h1>📊 Reportes de Cobranza</h1>

                    <p>
                        Resumen de los pagos registrados durante el mes actual.
                    </p>

                </div>

                <!-- FILTROS Y EXPORTACIÓN -->


<!-- ==========================================
     FILTRO DE REPORTES
     ========================================== -->

<form
    action="${pageContext.request.contextPath}/ReporteServlet"
    method="get"
    class="filtros-reporte"
>

    <div>
        <label>Fecha inicial</label>

        <input
            type="date"
            name="fechaInicio"
            value="${fechaInicio}"
            required
        >
    </div>


    <div>
        <label>Fecha final</label>

        <input
            type="date"
            name="fechaFin"
            value="${fechaFin}"
            required
        >
    </div>


    <button
        type="submit"
        class="btn-filtrar"
    >
        🔍 Filtrar reporte
    </button>

</form>


<!-- ==========================================
     EXPORTAR EXCEL
     ========================================== -->

<form
    action="${pageContext.request.contextPath}/ExportarExcelServlet"
    method="get"
    class="form-exportar"
>

    <input
        type="hidden"
        name="fechaInicio"
        value="${fechaInicio}"
    >

    <input
        type="hidden"
        name="fechaFin"
        value="${fechaFin}"
    >

    <button
        type="submit"
        class="btn-exportar"
    >
        📊 Exportar Excel
    </button>

</form>

                <!-- RESUMEN GENERAL -->

                <div class="resumen">

                    <div class="tarjeta recaudado">

                        <div class="titulo">
                            💰 Total Recaudado
                        </div>

                        <div class="numero">

                            S/
                            <%= String.format("%.2f", totalRecaudado) %>

                        </div>

                    </div>

                    <div class="tarjeta pagos">

                        <div class="titulo">
                            🧾 Cantidad de Pagos
                        </div>

                        <div class="numero">

                            <%= cantidadPagos %>

                        </div>

                    </div>

                </div>

                <!-- METODOS DE PAGO -->

                <div class="seccion">

                    <h2>💳 Recaudación por Método de Pago</h2>

                    <div class="metodos">

                        <div class="metodo">

                            <h3>📱 Yape</h3>

                            <div class="monto">

                                S/
                                <%= String.format("%.2f", totalYape) %>

                            </div>

                        </div>

                        <div class="metodo">

                            <h3>📱 Plin</h3>

                            <div class="monto">

                                S/
                                <%= String.format("%.2f", totalPlin) %>

                            </div>

                        </div>

                        <div class="metodo">

                            <h3>💵 Efectivo</h3>

                            <div class="monto">

                                S/
                                <%= String.format("%.2f", totalEfectivo) %>

                            </div>

                        </div>

                        <div class="metodo">

                            <h3>🏦 Transferencia</h3>

                            <div class="monto">

                                S/
                                <%= String.format("%.2f", totalTransferencia) %>

                            </div>

                        </div>

                    </div>

                </div>

                <!-- HISTORIAL DE PAGOS -->

                <div class="seccion">

                    <h2>🧾 Historial de Pagos del Mes Actual</h2>

                    <div class="tabla-contenedor">

                        <table class="tabla">

                            <thead>

                                <tr>

                                    <th>Código de pago</th>
                                    <th>Fecha</th>
                                    <th>Código cliente</th>
                                    <th>Cliente</th>
                                    <th>Periodo</th>
                                    <th>Método</th>
                                    <th>Monto</th>
                                    <th>N.º operación</th>
                                    <th>Estado</th>
                                    <th>Observación</th>

                                </tr>

                            </thead>

                            <tbody>

                                <%
                                    if (pagosMes.isEmpty()) {
                                %>

                                    <tr>

                                        <td
                                            colspan="10"
                                            class="sin-datos"
                                        >

                                            No existen pagos registrados
                                            durante este mes.

                                        </td>

                                    </tr>

                                <%
                                    } else {

                                        for (Pago pago : pagosMes) {
                                %>

                                    <tr>

                                        <td class="codigo">

                                            <%= pago.getCodigoPago() != null
                                                    ? pago.getCodigoPago()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <%= pago.getFechaPago() != null
                                                    ? pago.getFechaPago()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <%= pago.getCodigoCliente() != null
                                                    ? pago.getCodigoCliente()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <%= pago.getNombreCliente() != null
                                                    ? pago.getNombreCliente()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <%= pago.getPeriodo() != null
                                                    ? pago.getPeriodo()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <%= pago.getMetodoPago() != null
                                                    ? pago.getMetodoPago()
                                                    : "-" %>

                                        </td>

                                        <td class="monto-tabla">

                                            S/

                                            <%= String.format(
                                                    "%.2f",
                                                    pago.getMonto()
                                            ) %>

                                        </td>

                                        <td>

                                            <%= pago.getNumeroOperacion() != null
                                                    ? pago.getNumeroOperacion()
                                                    : "-" %>

                                        </td>

                                        <td>

                                            <span class="estado">

                                                <%= pago.getEstadoCuota() != null
                                                        ? pago.getEstadoCuota()
                                                        : "PAGADA" %>

                                            </span>

                                        </td>

                                        <td>

                                            <%= pago.getObservacion() != null
                                                    ? pago.getObservacion()
                                                    : "-" %>

                                        </td>

                                    </tr>

                                <%
                                        }

                                    }
                                %>

                            </tbody>

                        </table>

                    </div>

                </div>

                <!-- REGRESAR -->

                <a
                    href="${pageContext.request.contextPath}/DashboardServlet"
                    class="boton"
                >

                    ← Volver al Dashboard

                </a>

            </div>

        </main>

    </div>

</body>

</html>