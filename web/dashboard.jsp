<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>

<%
    Integer totalClientesObj =
            (Integer) request.getAttribute("totalClientes");

    Integer clientesActivosObj =
            (Integer) request.getAttribute("clientesActivos");

    Integer clientesSuspendidosObj =
            (Integer) request.getAttribute("clientesSuspendidos");

    Integer totalMorososObj =
            (Integer) request.getAttribute("totalMorosos");

    Double ingresosMesObj =
            (Double) request.getAttribute("ingresosMes");

    List<Double> ingresosUltimos6Meses =
            (List<Double>) request.getAttribute("ingresosUltimos6Meses");

    List<String> clientesPorPlan =
            (List<String>) request.getAttribute("clientesPorPlan");

    List<String> ultimosPagos =
            (List<String>) request.getAttribute("ultimosPagos");


    int totalClientes =
            totalClientesObj != null ? totalClientesObj : 0;

    int clientesActivos =
            clientesActivosObj != null ? clientesActivosObj : 0;

    int clientesSuspendidos =
            clientesSuspendidosObj != null ? clientesSuspendidosObj : 0;

    int totalMorosos =
            totalMorososObj != null ? totalMorososObj : 0;

    double ingresosMes =
            ingresosMesObj != null ? ingresosMesObj : 0.0;


    if (ingresosUltimos6Meses == null) {
        ingresosUltimos6Meses = new java.util.ArrayList<Double>();
    }

    if (clientesPorPlan == null) {
        clientesPorPlan = new java.util.ArrayList<String>();
    }

    if (ultimosPagos == null) {
        ultimosPagos = new java.util.ArrayList<String>();
    }


    int porcentajeActivos = 0;

    if (totalClientes > 0) {
        porcentajeActivos =
                (clientesActivos * 100) / totalClientes;
    }


    int porcentajeSuspendidos = 0;

    if (totalClientes > 0) {
        porcentajeSuspendidos =
                (clientesSuspendidos * 100) / totalClientes;
    }


    int porcentajeMorosos = 0;

    if (totalClientes > 0) {
        porcentajeMorosos =
                (totalMorosos * 100) / totalClientes;
    }


    Object usuarioObj =
            session.getAttribute("usuario");

    String nombreUsuario = "Administrador";
    String rolUsuario = "ADMIN";

    if (usuarioObj != null) {

        try {

            modelo.Usuario usuario =
                    (modelo.Usuario) usuarioObj;

            if (usuario.getNombres() != null &&
                !usuario.getNombres().trim().isEmpty()) {

                nombreUsuario =
                        usuario.getNombres();

            }

            if (usuario.getRol() != null &&
                !usuario.getRol().trim().isEmpty()) {

                rolUsuario =
                        usuario.getRol();

            }

        } catch (Exception e) {
            // Valores por defecto
        }
    }


    double maxIngreso = 1;

    for (Double ingreso : ingresosUltimos6Meses) {

        if (ingreso != null && ingreso > maxIngreso) {
            maxIngreso = ingreso;
        }
    }
%>


<!DOCTYPE html>

<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Dashboard | Grupo Stellar</title>

    <!-- CSS PRINCIPAL DEL SISTEMA -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">
</head>


<body class="dashboard-body">


<div class="sistema">


    <!-- ================================================= -->
    <!-- SIDEBAR -->
    <!-- ================================================= -->

    <%@ include file="menu.jsp" %>


    <!-- ================================================= -->
    <!-- CONTENIDO -->
    <!-- ================================================= -->

    <main class="contenido dashboard-contenido">


        <!-- ================================================= -->
        <!-- TOPBAR -->
        <!-- ================================================= -->

        <header class="dash-topbar">


            <div class="dash-topbar-left">

                <div class="dash-system-indicator">

                    <span class="dash-online-dot"></span>

                    <span>SISTEMA ONLINE</span>

                </div>

                <span class="dash-topbar-separator"></span>

                <span class="dash-topbar-label">
                    CENTRO DE OPERACIONES STELLAR
                </span>

            </div>


            <div class="dash-user-panel">

                <div class="dash-user-avatar">

                    <span>
                        <%= nombreUsuario.substring(0,1).toUpperCase() %>
                    </span>

                </div>


                <div class="dash-user-info">

                    <strong>
                        <%= nombreUsuario %>
                    </strong>

                    <small>
                        <%= rolUsuario %>
                    </small>

                </div>


                <a
                    href="${pageContext.request.contextPath}/LogoutServlet"
                    class="dash-logout"
                    title="Cerrar sesión"
                >
                    ⏻
                </a>

            </div>


        </header>



        <!-- ================================================= -->
        <!-- ÁREA PRINCIPAL -->
        <!-- ================================================= -->

        <section class="dash-main">


            <!-- ================================================= -->
            <!-- HERO -->
            <!-- ================================================= -->

            <div class="dash-hero">


                <div class="dash-hero-content">

                    <div class="dash-overline">
                        GRUPO STELLAR · NETWORK OPERATIONS
                    </div>


                    <h1>
                        Centro de
                        <span>Operaciones Grupo Stellar</span>
                    </h1>


                    <p>
                        Monitoreo general de clientes, cobranzas,
                        ingresos y actividad del sistema.
                    </p>


                    <div class="dash-system-status">

                        <span class="dash-status-pulse"></span>

                        <span>
                            Todos los servicios operativos
                        </span>

                    </div>

                </div>


                <div class="dash-hero-decoration">

                    <div class="dash-orbit orbit-1"></div>
                    <div class="dash-orbit orbit-2"></div>
                    <div class="dash-orbit orbit-3"></div>

                    <div class="dash-network-core">

                        <span>GS</span>

                    </div>

                </div>

            </div>



            <!-- ================================================= -->
            <!-- KPI -->
            <!-- ================================================= -->

            <div class="dash-kpis">


                <!-- TOTAL CLIENTES -->

                <div class="dash-kpi kpi-blue">

                    <div class="dash-kpi-top">

                        <div class="dash-kpi-icon">
                            ◉
                        </div>

                        <span class="dash-kpi-code">
                            NET-001
                        </span>

                    </div>


                    <div class="dash-kpi-label">
                        TOTAL CLIENTES
                    </div>


                    <div class="dash-kpi-number">
                        <%= totalClientes %>
                    </div>


                    <div class="dash-kpi-bottom">

                        <span>
                            Base registrada
                        </span>

                        <strong>
                            100%
                        </strong>

                    </div>


                    <div class="dash-kpi-line"></div>

                </div>



                <!-- ACTIVOS -->

                <div class="dash-kpi kpi-green">

                    <div class="dash-kpi-top">

                        <div class="dash-kpi-icon">
                            ✓
                        </div>

                        <span class="dash-kpi-code">
                            NET-002
                        </span>

                    </div>


                    <div class="dash-kpi-label">
                        CLIENTES ACTIVOS
                    </div>


                    <div class="dash-kpi-number">
                        <%= clientesActivos %>
                    </div>


                    <div class="dash-kpi-bottom">

                        <span>
                            Operativos
                        </span>

                        <strong>
                            <%= porcentajeActivos %>%
                        </strong>

                    </div>


                    <div class="dash-kpi-line"></div>

                </div>



                <!-- SUSPENDIDOS -->

                <div class="dash-kpi kpi-orange">

                    <div class="dash-kpi-top">

                        <div class="dash-kpi-icon">
                            !
                        </div>

                        <span class="dash-kpi-code">
                            NET-003
                        </span>

                    </div>


                    <div class="dash-kpi-label">
                        SUSPENDIDOS
                    </div>


                    <div class="dash-kpi-number">
                        <%= clientesSuspendidos %>
                    </div>


                    <div class="dash-kpi-bottom">

                        <span>
                            Requieren atención
                        </span>

                        <strong>
                            <%= porcentajeSuspendidos %>%
                        </strong>

                    </div>


                    <div class="dash-kpi-line"></div>

                </div>



                <!-- MOROSOS -->

                <div class="dash-kpi kpi-red">

                    <div class="dash-kpi-top">

                        <div class="dash-kpi-icon">
                            $
                        </div>

                        <span class="dash-kpi-code">
                            NET-004
                        </span>

                    </div>


                    <div class="dash-kpi-label">
                        CLIENTES MOROSOS
                    </div>


                    <div class="dash-kpi-number">
                        <%= totalMorosos %>
                    </div>


                    <div class="dash-kpi-bottom">

                        <span>
                            Seguimiento requerido
                        </span>

                        <strong>
                            <%= porcentajeMorosos %>%
                        </strong>

                    </div>


                    <div class="dash-kpi-line"></div>

                </div>


            </div>



            <!-- ================================================= -->
            <!-- FILA PRINCIPAL -->
            <!-- ================================================= -->

            <div class="dash-grid-main">


                <!-- ================================================= -->
                <!-- INGRESOS -->
                <!-- ================================================= -->

                <section class="dash-panel dash-revenue-panel">


                    <div class="dash-panel-header">


                        <div>

                            <span class="dash-panel-tag">
                                FINANZAS
                            </span>

                            <h2>
                                Ingresos del mes
                            </h2>

                            <p>
                                Recaudación registrada
                            </p>

                        </div>


                        <div class="dash-panel-icon revenue-icon">
                            S/
                        </div>

                    </div>


                    <div class="dash-revenue-value">

                        <span>S/</span>

                        <strong>
                            <%= String.format("%.2f", ingresosMes) %>
                        </strong>

                    </div>


                    <div class="dash-revenue-status">

                        <span class="dash-check">
                            ✓
                        </span>

                        <span>
                            Ingresos registrados correctamente
                        </span>

                    </div>


                    <div class="dash-revenue-footer">

                        <div>

                            <small>
                                PERIODO ACTUAL
                            </small>

                            <strong>
                                Mes en curso
                            </strong>

                        </div>


                        <div>

                            <small>
                                ESTADO
                            </small>

                            <strong class="text-green">
                                ACTIVO
                            </strong>

                        </div>

                    </div>


                </section>



                <!-- ================================================= -->
                <!-- ESTADO CLIENTES -->
                <!-- ================================================= -->

                <section class="dash-panel">


                    <div class="dash-panel-header">

                        <div>

                            <span class="dash-panel-tag">
                                OPERACIONES
                            </span>

                            <h2>
                                Estado de cartera
                            </h2>

                            <p>
                                Distribución actual de clientes
                            </p>

                        </div>


                        <div class="dash-panel-icon">
                            ◈
                        </div>

                    </div>


                    <!-- ACTIVOS -->

                    <div class="dash-progress-item">

                        <div class="dash-progress-header">

                            <span>
                                Clientes activos
                            </span>

                            <strong>
                                <%= clientesActivos %>
                            </strong>

                        </div>


                        <div class="dash-progress-track">

                            <div
                                class="dash-progress-fill progress-green"
                                style="width:<%= porcentajeActivos %>%"
                            ></div>

                        </div>

                    </div>



                    <!-- SUSPENDIDOS -->

                    <div class="dash-progress-item">

                        <div class="dash-progress-header">

                            <span>
                                Suspendidos
                            </span>

                            <strong>
                                <%= clientesSuspendidos %>
                            </strong>

                        </div>


                        <div class="dash-progress-track">

                            <div
                                class="dash-progress-fill progress-orange"
                                style="width:<%= porcentajeSuspendidos %>%"
                            ></div>

                        </div>

                    </div>



                    <!-- MOROSOS -->

                    <div class="dash-progress-item">

                        <div class="dash-progress-header">

                            <span>
                                Morosos
                            </span>

                            <strong>
                                <%= totalMorosos %>
                            </strong>

                        </div>


                        <div class="dash-progress-track">

                            <div
                                class="dash-progress-fill progress-red"
                                style="width:<%= porcentajeMorosos %>%"
                            ></div>

                        </div>

                    </div>


                    <div class="dash-portfolio-footer">

                        <span>
                            CARTERA TOTAL
                        </span>

                        <strong>
                            <%= totalClientes %> clientes
                        </strong>

                    </div>


                </section>

            </div>



            <!-- ================================================= -->
            <!-- GRÁFICOS -->
            <!-- ================================================= -->

            <div class="dash-grid-main">


                <!-- ================================================= -->
                <!-- INGRESOS 6 MESES -->
                <!-- ================================================= -->

                <section class="dash-panel dash-chart-panel">


                    <div class="dash-panel-header">

                        <div>

                            <span class="dash-panel-tag">
                                ANALÍTICA
                            </span>

                            <h2>
                                Evolución de ingresos
                            </h2>

                            <p>
                                Últimos 6 periodos registrados
                            </p>

                        </div>


                        <div class="dash-chart-badge">
                            S/ PEN
                        </div>

                    </div>


                    <div class="dash-bars-chart">

                        <%
                            String[] nombresMeses = {
                                "Hace 5",
                                "Hace 4",
                                "Hace 3",
                                "Hace 2",
                                "Anterior",
                                "Actual"
                            };

                            for (int i = 0;
                                 i < ingresosUltimos6Meses.size();
                                 i++) {

                                double valor =
                                    ingresosUltimos6Meses.get(i) != null
                                    ? ingresosUltimos6Meses.get(i)
                                    : 0;

                                int altura =
                                    (int)((valor / maxIngreso) * 100);

                                if (valor > 0 && altura < 8) {
                                    altura = 8;
                                }
                        %>


                        <div class="dash-bar-column">


                            <div class="dash-bar-value">

                                S/
                                <%= String.format("%.0f", valor) %>

                            </div>


                            <div class="dash-bar-area">

                                <div
                                    class="dash-bar"
                                    style="height:<%= altura %>%"
                                >

                                    <span></span>

                                </div>

                            </div>


                            <small>
                                <%= nombresMeses[
                                    i < nombresMeses.length
                                    ? i
                                    : nombresMeses.length - 1
                                ] %>
                            </small>


                        </div>


                        <%
                            }
                        %>

                    </div>


                </section>



                <!-- ================================================= -->
                <!-- CLIENTES POR PLAN -->
                <!-- ================================================= -->

                <section class="dash-panel">


                    <div class="dash-panel-header">

                        <div>

                            <span class="dash-panel-tag">
                                SERVICIOS
                            </span>

                            <h2>
                                Clientes por plan
                            </h2>

                            <p>
                                Distribución de planes contratados
                            </p>

                        </div>


                        <div class="dash-panel-icon">
                            ≋
                        </div>

                    </div>


                    <div class="dash-plans">


                        <%
                            int maxPlan = 1;

                            for (String item : clientesPorPlan) {

                                try {

                                    String[] partes =
                                            item.split("\\|");

                                    int cantidad =
                                            Integer.parseInt(
                                                partes[1]
                                            );

                                    if (cantidad > maxPlan) {
                                        maxPlan = cantidad;
                                    }

                                } catch (Exception e) {
                                    // Ignorar fila inválida
                                }
                            }


                            for (String item : clientesPorPlan) {

                                String nombrePlan = "Plan";
                                int cantidad = 0;

                                try {

                                    String[] partes =
                                            item.split("\\|");

                                    if (partes.length >= 2) {

                                        nombrePlan =
                                                partes[0];

                                        cantidad =
                                                Integer.parseInt(
                                                    partes[1]
                                                );
                                    }

                                } catch (Exception e) {
                                    // Valores por defecto
                                }


                                int porcentaje =
                                    (int)((cantidad * 100.0) / maxPlan);
                        %>


                        <div class="dash-plan-row">


                            <div class="dash-plan-info">

                                <span>
                                    <%= nombrePlan %>
                                </span>

                                <strong>
                                    <%= cantidad %>
                                </strong>

                            </div>


                            <div class="dash-plan-track">

                                <div
                                    class="dash-plan-fill"
                                    style="width:<%= porcentaje %>%"
                                ></div>

                            </div>


                        </div>


                        <%
                            }

                            if (clientesPorPlan.isEmpty()) {
                        %>

                        <div class="dash-empty">

                            <span>◎</span>

                            <p>
                                No hay información de planes registrada.
                            </p>

                        </div>

                        <%
                            }
                        %>


                    </div>

                </section>

            </div>



            <!-- ================================================= -->
            <!-- ACTIVIDAD + ACCIONES -->
            <!-- ================================================= -->

            <div class="dash-grid-bottom">


                <!-- ================================================= -->
                <!-- ACTIVIDAD -->
                <!-- ================================================= -->

                <section class="dash-panel">


                    <div class="dash-panel-header">

                        <div>

                            <span class="dash-panel-tag">
                                MONITOREO
                            </span>

                            <h2>
                                Actividad reciente
                            </h2>

                            <p>
                                Últimos movimientos registrados
                            </p>

                        </div>


                        <div class="dash-live-label">

                            <span></span>

                            LIVE

                        </div>

                    </div>


                    <div class="dash-activity-list">


                        <%
                            if (ultimosPagos.isEmpty()) {
                        %>


                        <div class="dash-empty">

                            <span>◌</span>

                            <p>
                                No hay pagos recientes registrados.
                            </p>

                        </div>


                        <%
                            } else {

                                for (String item : ultimosPagos) {

                                    String nombres = "";
                                    String apellidos = "";
                                    String fecha = "";
                                    String monto = "";
                                    String metodo = "";
                                    String usuarioPago = "";

                                    try {

                                        String[] partes =
                                                item.split("\\|");

                                        if (partes.length > 0)
                                            nombres = partes[0];

                                        if (partes.length > 1)
                                            apellidos = partes[1];

                                        if (partes.length > 2)
                                            fecha = partes[2];

                                        if (partes.length > 3)
                                            monto = partes[3];

                                        if (partes.length > 4)
                                            metodo = partes[4];

                                        if (partes.length > 5)
                                            usuarioPago = partes[5];

                                    } catch (Exception e) {
                                        // Ignorar registro
                                    }
                        %>


                        <div class="dash-activity-item">


                            <div class="dash-activity-icon">
                                ✓
                            </div>


                            <div class="dash-activity-info">

                                <strong>
                                    <%= nombres %>
                                    <%= apellidos %>
                                </strong>

                                <span>
                                    Pago registrado ·
                                    <%= metodo %>
                                </span>

                                <small>
                                    <%= fecha %>
                                    <% if (!usuarioPago.isEmpty()) { %>
                                        · Usuario: <%= usuarioPago %>
                                    <% } %>
                                </small>

                            </div>


                            <div class="dash-activity-amount">

                                <span>
                                    S/
                                </span>

                                <strong>
                                    <%= monto %>
                                </strong>

                            </div>


                        </div>


                        <%
                                }
                            }
                        %>


                    </div>

                </section>



                <!-- ================================================= -->
                <!-- ACCIONES -->
                <!-- ================================================= -->

                <section class="dash-panel">


                    <div class="dash-panel-header">

                        <div>

                            <span class="dash-panel-tag">
                                CONTROL
                            </span>

                            <h2>
                                Acciones rápidas
                            </h2>

                            <p>
                                Acceso directo a módulos críticos
                            </p>

                        </div>


                        <div class="dash-panel-icon">
                            +
                        </div>

                    </div>


                    <div class="dash-actions">


                        <a
                            href="${pageContext.request.contextPath}/ClienteServlet"
                            class="dash-action"
                        >

                            <span class="action-blue">
                                ◉
                            </span>

                            <div>

                                <strong>
                                    Gestionar clientes
                                </strong>

                                <small>
                                    Registrar y administrar cartera
                                </small>

                            </div>

                            <b>›</b>

                        </a>



                        <a
                            href="${pageContext.request.contextPath}/PagoServlet"
                            class="dash-action"
                        >

                            <span class="action-green">
                                S/
                            </span>

                            <div>

                                <strong>
                                    Registrar pago
                                </strong>

                                <small>
                                    Registrar nueva cobranza
                                </small>

                            </div>

                            <b>›</b>

                        </a>



                        <a
                            href="${pageContext.request.contextPath}/MorosidadServlet"
                            class="dash-action"
                        >

                            <span class="action-red">
                                !
                            </span>

                            <div>

                                <strong>
                                    Revisar morosidad
                                </strong>

                                <small>
                                    Clientes con deuda pendiente
                                </small>

                            </div>

                            <b>›</b>

                        </a>



                        <a
                            href="${pageContext.request.contextPath}/ReporteServlet"
                            class="dash-action"
                        >

                            <span class="action-purple">
                                ▥
                            </span>

                            <div>

                                <strong>
                                    Generar reportes
                                </strong>

                                <small>
                                    Analizar pagos y recaudación
                                </small>

                            </div>

                            <b>›</b>

                        </a>



                        <a
                            href="${pageContext.request.contextPath}/AvisosWhatsAppServlet"
                            class="dash-action"
                        >

                            <span class="action-cyan">
                                W
                            </span>

                            <div>

                                <strong>
                                    Avisos WhatsApp
                                </strong>

                                <small>
                                    Notificaciones de cobranza
                                </small>

                            </div>

                            <b>›</b>

                        </a>


                    </div>

                </section>


            </div>



            <!-- ================================================= -->
            <!-- FOOTER -->
            <!-- ================================================= -->

            <footer class="dash-footer">

                <div>

                    <strong>
                        GRUPO STELLAR
                    </strong>

                    <span>
                        · Sistema de Gestión ISP
                    </span>

                </div>


                <div>

                    <span>
                        SISTEMA OPERATIVO
                    </span>

                    <i></i>

                    <strong>
                        ONLINE
                    </strong>

                </div>

            </footer>


        </section>

    </main>

</div>


</body>

</html>