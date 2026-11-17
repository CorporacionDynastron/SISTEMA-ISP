<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>

<%
    modelo.Cliente cliente =
            (modelo.Cliente) request.getAttribute("cliente");

    List<modelo.Pago> pagos =
            (List<modelo.Pago>) request.getAttribute("pagos");

    if (cliente == null) {
%>

    <h2>Cliente no encontrado</h2>

<%
        return;
    }

    // ==========================================
    // RESUMEN FINANCIERO
    // ==========================================

    double totalPagado = 0;
    String ultimoPago = "Sin pagos";

    if (pagos != null && !pagos.isEmpty()) {

        for (modelo.Pago pago : pagos) {
            totalPagado += pago.getMonto();
        }

        ultimoPago = pagos.get(0).getFechaPago();
    }

    // ==========================================
    // ESTADO DEL CLIENTE
    // ==========================================

    String estado = cliente.getEstado();

    String claseEstado = "";

    if ("ACTIVO".equals(estado)) {
        claseEstado = "activo";
    } else if ("SUSPENDIDO".equals(estado)) {
        claseEstado = "suspendido";
    } else {
        claseEstado = "retirado";
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>
        Cliente - <%= cliente.getCodigoCliente() %>
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            color: #1e293b;
        }

        .contenedor {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px;
        }

        /* ==========================================
           HEADER
           ========================================== */

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .titulo h1 {
            margin: 0;
            font-size: 28px;
        }

        .titulo p {
            margin: 7px 0 0;
            color: #64748b;
        }

        .btn-volver {
            text-decoration: none;
            background: #ffffff;
            color: #334155;
            border: 1px solid #cbd5e1;
            padding: 11px 18px;
            border-radius: 8px;
            font-weight: bold;
        }

        .btn-volver:hover {
            background: #e2e8f0;
        }

        /* ==========================================
           PERFIL
           ========================================== */

        .perfil {
            background: #ffffff;
            border-radius: 14px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .avatar {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            font-weight: bold;
        }

        .perfil-info h2 {
            margin: 0 0 7px;
            font-size: 23px;
        }

        .codigo {
            color: #64748b;
            font-size: 14px;
        }

        .estado {
            margin-left: auto;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .activo {
            background: #dcfce7;
            color: #15803d;
        }

        .suspendido {
            background: #fef3c7;
            color: #b45309;
        }

        .retirado {
            background: #fee2e2;
            color: #b91c1c;
        }

        /* ==========================================
           GRID
           ========================================== */

        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .card {
            background: #ffffff;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }

        .card h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 12px;
        }

        .dato {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .dato:last-child {
            border-bottom: none;
        }

        .dato span:first-child {
            color: #64748b;
        }

        .dato span:last-child {
            font-weight: bold;
            text-align: right;
        }

        /* ==========================================
           PLAN
           ========================================== */

        .plan {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 12px;
            padding: 20px;
        }

        .plan-nombre {
            font-size: 22px;
            font-weight: bold;
            color: #1d4ed8;
        }

        .velocidad {
            font-size: 16px;
            color: #475569;
            margin-top: 8px;
        }

        .precio {
            font-size: 28px;
            font-weight: bold;
            margin-top: 15px;
            color: #0f172a;
        }

        .precio small {
            font-size: 13px;
            color: #64748b;
        }

        /* ==========================================
           RESUMEN FINANCIERO
           ========================================== */

        .resumen-financiero {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .resumen-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }

        .resumen-icono {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: #eff6ff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 23px;
            flex-shrink: 0;
        }

        .resumen-card span {
            display: block;
            color: #64748b;
            font-size: 12px;
            margin-bottom: 6px;
        }

        .resumen-card strong {
            display: block;
            color: #0f172a;
            font-size: 18px;
        }

        /* ==========================================
           HISTORIAL DE PAGOS
           ========================================== */

        .historial {
            margin-top: 20px;
        }

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f8fafc;
        }

        th {
            padding: 13px;
            text-align: left;
            font-size: 13px;
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 14px 13px;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14px;
        }

        tbody tr:hover {
            background: #f8fafc;
        }

        .monto {
            font-weight: bold;
            color: #15803d;
        }

        .metodo {
            display: inline-block;
            background: #eff6ff;
            color: #1d4ed8;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .btn-comprobante {
            border: none;
            background: #2563eb;
            color: white;
            padding: 7px 11px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-comprobante:hover {
            background: #1d4ed8;
        }

        .sin-comprobante {
            color: #94a3b8;
            font-size: 12px;
        }

        .sin-pagos {
            text-align: center;
            padding: 35px;
            color: #64748b;
        }

        .icono-pago {
            font-size: 38px;
            margin-bottom: 10px;
        }

        .sin-pagos strong {
            display: block;
            color: #334155;
            font-size: 17px;
        }

        .sin-pagos p {
            margin-top: 7px;
        }

        /* ==========================================
           RESPONSIVE
           ========================================== */

        @media (max-width: 900px) {

            .resumen-financiero {
                grid-template-columns: 1fr 1fr;
            }

        }

        @media (max-width: 800px) {

            .grid {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .perfil {
                flex-wrap: wrap;
            }

            .estado {
                margin-left: 0;
            }

        }

        @media (max-width: 550px) {

            .resumen-financiero {
                grid-template-columns: 1fr;
            }

            .contenedor {
                padding: 15px;
            }

        }

    </style>

</head>

<body>

<div class="contenedor">

    <!-- ==========================================
         HEADER
         ========================================== -->

    <div class="header">

        <div class="titulo">

            <h1>👤 Información del Cliente</h1>

            <p>
                Detalle y configuración del servicio
            </p>

        </div>

        <a
            href="ClienteServlet"
            class="btn-volver"
        >
            ← Volver a clientes
        </a>

    </div>


    <!-- ==========================================
         PERFIL
         ========================================== -->

    <div class="perfil">

        <div class="avatar">

            <%= cliente.getNombres()
                    .substring(0, 1)
                    .toUpperCase() %>

        </div>

        <div class="perfil-info">

            <h2>

                <%= cliente.getNombres() %>
                <%= cliente.getApellidos() %>

            </h2>

            <div class="codigo">

                Código:
                <strong>
                    <%= cliente.getCodigoCliente() %>
                </strong>

            </div>

        </div>

        <div class="estado <%= claseEstado %>">

            <%= estado %>

        </div>

    </div>


    <!-- ==========================================
         INFORMACIÓN
         ========================================== -->

    <div class="grid">

        <!-- DATOS PERSONALES -->

        <div class="card">

            <h3>👤 Datos personales</h3>

            <div class="dato">

                <span>DNI</span>

                <span>
                    <%= cliente.getDni() %>
                </span>

            </div>

            <div class="dato">

                <span>Teléfono</span>

                <span>
                    <%= cliente.getTelefono() %>
                </span>

            </div>

            <div class="dato">

                <span>Dirección</span>

                <span>
                    <%= cliente.getDireccion() %>
                </span>

            </div>

        </div>


        <!-- SERVICIO -->

        <div class="card">

            <h3>📡 Servicio contratado</h3>

            <div class="plan">

                <div class="plan-nombre">

                    <%= cliente.getNombrePlan() %>

                </div>

                <div class="velocidad">

                    Velocidad:

                    <strong>

                        <%= cliente.getVelocidad() != null
                            ? cliente.getVelocidad()
                            : "No especificada" %>

                    </strong>

                </div>

                <div class="precio">

                    S/

                    <%= String.format(
                        "%.2f",
                        cliente.getPrecioPlan()
                    ) %>

                    <small>
                        / mes
                    </small>

                </div>

            </div>

        </div>


        <!-- INSTALACIÓN -->

        <div class="card">

            <h3>🔧 Instalación</h3>

            <div class="dato">

                <span>Fecha de instalación</span>

                <span>
                    <%= cliente.getFechaInstalacion() %>
                </span>

            </div>

            <div class="dato">

                <span>Día de vencimiento</span>

                <span>
                    Día <%= cliente.getDiaVencimiento() %>
                </span>

            </div>

        </div>


        <!-- ESTADO -->

        <div class="card">

            <h3>📊 Estado del servicio</h3>

            <div class="dato">

                <span>Estado actual</span>

                <span>
                    <%= cliente.getEstado() %>
                </span>

            </div>

            <div class="dato">

                <span>Código de cliente</span>

                <span>
                    <%= cliente.getCodigoCliente() %>
                </span>

            </div>

        </div>

    </div>


    <!-- ==========================================
         RESUMEN FINANCIERO
         ========================================== -->

    <div class="resumen-financiero">

        <!-- TOTAL PAGADO -->

        <div class="resumen-card">

            <div class="resumen-icono">
                💰
            </div>

            <div>

                <span>Total pagado</span>

                <strong>

                    S/
                    <%= String.format(
                        "%.2f",
                        totalPagado
                    ) %>

                </strong>

            </div>

        </div>


        <!-- ÚLTIMO PAGO -->

        <div class="resumen-card">

            <div class="resumen-icono">
                📅
            </div>

            <div>

                <span>Último pago</span>

                <strong>

                    <%= ultimoPago %>

                </strong>

            </div>

        </div>


        <!-- PAGOS REGISTRADOS -->

        <div class="resumen-card">

            <div class="resumen-icono">
                📊
            </div>

            <div>

                <span>Pagos registrados</span>

                <strong>

                    <%= pagos != null
                        ? pagos.size()
                        : 0 %>

                </strong>

            </div>

        </div>


        <!-- MENSUALIDAD -->

        <div class="resumen-card">

            <div class="resumen-icono">
                📡
            </div>

            <div>

                <span>Mensualidad</span>

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


    <!-- ==========================================
         HISTORIAL DE PAGOS
         ========================================== -->

    <div class="card historial">

        <h3>💰 Historial de pagos</h3>


        <% if (pagos == null || pagos.isEmpty()) { %>

            <div class="sin-pagos">

                <div class="icono-pago">
                    💳
                </div>

                <strong>
                    No hay pagos registrados
                </strong>

                <p>
                    Este cliente todavía no tiene pagos registrados.
                </p>

            </div>

        <% } else { %>


            <div class="tabla-contenedor">

                <table>

                    <thead>

                        <tr>

                            <th>ID</th>
                            <th>Fecha</th>
                            <th>Periodo</th>
                            <th>Monto</th>
                            <th>Método</th>
                            <th>N.º Operación</th>
                            <th>Comprobante</th>

                        </tr>

                    </thead>

                    <tbody>

                    <% for (modelo.Pago pago : pagos) { %>

                        <tr>

                            <td>
                                #<%= pago.getIdPago() %>
                            </td>

                            <td>
                                <%= pago.getFechaPago() %>
                            </td>

                            <td>

                                <strong>
                                    <%= pago.getPeriodo() %>
                                </strong>

                            </td>

                            <td class="monto">

                                S/

                                <%= String.format(
                                    "%.2f",
                                    pago.getMonto()
                                ) %>

                            </td>

                            <td>

                                <span class="metodo">

                                    <%= pago.getMetodoPago() %>

                                </span>

                            </td>

                            <td>

                                <%= pago.getNumeroOperacion() != null
                                    && !pago.getNumeroOperacion().isEmpty()
                                    ? pago.getNumeroOperacion()
                                    : "—" %>

                            </td>

                            <td>

                                <% if (pago.getComprobante() != null
                                        && !pago.getComprobante().isEmpty()) { %>

                                    <button
                                        type="button"
                                        class="btn-comprobante"
                                        onclick="verComprobante(<%= pago.getIdPago() %>)"
                                    >
                                        🧾 Ver
                                    </button>

                                <% } else { %>

                                    <span class="sin-comprobante">
                                        Sin comprobante
                                    </span>

                                <% } %>

                            </td>

                        </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        <% } %>

    </div>

</div>


<script>

function verComprobante(idPago) {

    window.open(
        'ComprobanteServlet?id=' + idPago,
        '_blank'
    );

}

</script>

</body>

</html>