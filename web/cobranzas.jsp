<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="modelo.EstadoCliente" %>

<%

    // ==========================================
    // DATOS RECIBIDOS DEL SERVLET
    // ==========================================

    List<EstadoCliente> clientesEstado =
        (List<EstadoCliente>)
        request.getAttribute("clientesEstado");


    Integer totalAlDia =
        (Integer)
        request.getAttribute("totalAlDia");


    Integer totalProximos =
        (Integer)
        request.getAttribute("totalProximos");


    Integer totalVencidos =
        (Integer)
        request.getAttribute("totalVencidos");


    Integer totalMorosos =
        (Integer)
        request.getAttribute("totalMorosos");


    Double deudaTotal =
        (Double)
        request.getAttribute("deudaTotal");


    String buscarActual =
        (String)
        request.getAttribute("buscarActual");


    String estadoActual =
        (String)
        request.getAttribute("estadoActual");


    // ==========================================
    // VALORES POR DEFECTO
    // ==========================================

    if (clientesEstado == null) {
        clientesEstado =
            new java.util.ArrayList<EstadoCliente>();
    }

    if (totalAlDia == null) {
        totalAlDia = 0;
    }

    if (totalProximos == null) {
        totalProximos = 0;
    }

    if (totalVencidos == null) {
        totalVencidos = 0;
    }

    if (totalMorosos == null) {
        totalMorosos = 0;
    }

    if (deudaTotal == null) {
        deudaTotal = 0.0;
    }

    if (buscarActual == null) {
        buscarActual = "";
    }

    if (estadoActual == null) {
        estadoActual = "";
    }

%>

<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>
        Cobranzas - Grupo Stellar
    </title>

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estilo.css"
    >

    <style>

        /* ==========================================
           ENCABEZADO
        ========================================== */

        .cabecera-cobranzas {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 25px;

            gap: 20px;

            flex-wrap: wrap;
        }


        .cabecera-cobranzas h1 {

            margin: 0;

            font-size: 28px;

            color: #0f172a;
        }


        .cabecera-cobranzas p {

            margin: 6px 0 0;

            color: #64748b;
        }


        /* ==========================================
           TARJETAS
        ========================================== */

        .tarjetas-cobranza {

            display: grid;

            grid-template-columns:
                repeat(5, minmax(150px, 1fr));

            gap: 16px;

            margin-bottom: 25px;
        }


        .tarjeta-cobranza {

            background: white;

            border-radius: 14px;

            padding: 20px;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 4px 12px
                rgba(15, 23, 42, 0.06);
        }


        .tarjeta-cobranza .icono {

            font-size: 25px;

            margin-bottom: 12px;
        }


        .tarjeta-cobranza .titulo {

            color: #64748b;

            font-size: 13px;

            margin-bottom: 6px;
        }


        .tarjeta-cobranza .numero {

            font-size: 27px;

            font-weight: bold;

            color: #0f172a;
        }


        .tarjeta-deuda {

            background:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #1e3a8a
                );

            color: white;

            border: none;
        }


        .tarjeta-deuda .titulo {

            color: #cbd5e1;
        }


        .tarjeta-deuda .numero {

            color: white;
        }


        /* ==========================================
           COLORES
        ========================================== */

        .verde {

            border-left:
                5px solid #16a34a;
        }


        .amarillo {

            border-left:
                5px solid #eab308;
        }


        .naranja {

            border-left:
                5px solid #f97316;
        }


        .rojo {

            border-left:
                5px solid #dc2626;
        }


        /* ==========================================
           FILTROS
        ========================================== */

        .filtros-cobranza {

            background: white;

            padding: 18px;

            border-radius: 14px;

            border: 1px solid #e2e8f0;

            margin-bottom: 20px;

            display: flex;

            gap: 10px;

            flex-wrap: wrap;
        }


        .buscador-cobranza {

            flex: 1;

            min-width: 230px;
        }


        .buscador-cobranza input,
        .filtros-cobranza select {

            width: 100%;

            padding: 11px 13px;

            border:
                1px solid #cbd5e1;

            border-radius: 8px;

            font-size: 14px;

            outline: none;

            box-sizing: border-box;
        }


        .buscador-cobranza input:focus,
        .filtros-cobranza select:focus {

            border-color: #2563eb;
        }


        .boton-filtrar {

            padding:
                11px 18px;

            border: none;

            border-radius: 8px;

            background: #2563eb;

            color: white;

            font-weight: bold;

            cursor: pointer;
        }


        .boton-filtrar:hover {

            background: #1d4ed8;
        }


        .boton-limpiar {

            padding:
                11px 18px;

            border-radius: 8px;

            background: #f1f5f9;

            color: #334155;

            text-decoration: none;

            font-weight: bold;
        }


        .boton-limpiar:hover {

            background: #e2e8f0;
        }


        /* ==========================================
           TABLA
        ========================================== */

        .contenedor-tabla-cobranza {

            background: white;

            border-radius: 14px;

            border:
                1px solid #e2e8f0;

            overflow-x: auto;

            box-shadow:
                0 4px 12px
                rgba(15, 23, 42, 0.05);
        }


        .tabla-cobranza {

            width: 100%;

            border-collapse: collapse;

            min-width: 950px;
        }


        .tabla-cobranza th {

            background: #f8fafc;

            padding: 14px;

            text-align: left;

            font-size: 12px;

            color: #64748b;

            text-transform: uppercase;

            border-bottom:
                1px solid #e2e8f0;
        }


        .tabla-cobranza td {

            padding: 14px;

            border-bottom:
                1px solid #f1f5f9;

            font-size: 13px;

            color: #334155;
        }


        .tabla-cobranza tr:hover {

            background: #f8fafc;
        }


        /* ==========================================
           ESTADOS
        ========================================== */

        .estado {

            display: inline-block;

            padding:
                6px 10px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: bold;

            white-space: nowrap;
        }


        .estado-al-dia {

            background: #dcfce7;

            color: #166534;
        }


        .estado-proximo {

            background: #fef9c3;

            color: #854d0e;
        }


        .estado-vencido {

            background: #ffedd5;

            color: #9a3412;
        }


        .estado-moroso {

            background: #fee2e2;

            color: #991b1b;
        }


        /* ==========================================
           DEUDA
        ========================================== */

        .deuda {

            font-weight: bold;

            color: #dc2626;
        }


        .sin-deuda {

            font-weight: bold;

            color: #16a34a;
        }


        .atraso {

            font-weight: bold;

            color: #dc2626;
        }


        /* ==========================================
           BOTON CUENTA
        ========================================== */

        .btn-cuenta-cobranza {

            display: inline-block;

            padding:
                7px 11px;

            background: #2563eb;

            color: white;

            text-decoration: none;

            border-radius: 7px;

            font-size: 11px;

            font-weight: bold;

            white-space: nowrap;
        }


        .btn-cuenta-cobranza:hover {

            background: #1d4ed8;
        }


        /* ==========================================
           MENSAJE VACIO
        ========================================== */

        .mensaje-vacio {

            text-align: center;

            padding: 45px !important;

            color: #64748b;

            font-size: 14px;
        }


        /* ==========================================
           RESPONSIVE
        ========================================== */

        @media (max-width: 1100px) {

            .tarjetas-cobranza {

                grid-template-columns:
                    repeat(
                        3,
                        minmax(150px, 1fr)
                    );
            }
        }


        @media (max-width: 700px) {

            .tarjetas-cobranza {

                grid-template-columns:
                    repeat(
                        2,
                        minmax(130px, 1fr)
                    );
            }


            .cabecera-cobranzas h1 {

                font-size: 23px;
            }
        }
        
        
        
        
        
        
/* ==========================================
   GRUPO STELLAR - COBRANZAS PREMIUM
   Solo diseño visual
   ========================================== */

.cobranzas-body {
    background-color: #020817;
    background-image:
        radial-gradient(ellipse at top right, rgba(37, 99, 235, .16), transparent 48%),
        linear-gradient(135deg, #020817 0%, #0b1224 55%, #07172b 100%);
    background-attachment: fixed;
    color: #e5eefb;
}

.cobranzas-body .contenido,
.cobranzas-body .contenido-principal {
    background: transparent;
}

.cobranzas-body .contenido-principal {
    padding: 30px;
}

.cobranzas-body .contenedor {
    max-width: 1800px;
    margin: 0 auto;
}

/* Encabezado */

.cobranzas-body .cabecera-cobranzas {
    margin-bottom: 28px;
}

.cobranzas-body .cabecera-cobranzas h1 {
    color: #f8fafc;
    font-size: 30px;
    font-weight: 800;
    letter-spacing: -.5px;
}

.cobranzas-body .cabecera-cobranzas p {
    color: #94a3b8;
    font-size: 14px;
    margin-top: 8px;
}

/* Tarjetas de resumen */

.cobranzas-body .tarjetas-cobranza {
    grid-template-columns: repeat(5, minmax(0, 1fr));
    gap: 16px;
    margin-bottom: 25px;
}

.cobranzas-body .tarjeta-cobranza {
    background: linear-gradient(145deg, #111e32, #0b1528);
    border: 1px solid #26364d;
    border-radius: 15px;
    padding: 22px;
    box-shadow: 0 12px 32px rgba(0, 0, 0, .16);
    transition: transform .2s ease, border-color .2s ease;
}

.cobranzas-body .tarjeta-cobranza:hover {
    transform: translateY(-3px);
    border-color: #3b5475;
}

.cobranzas-body .tarjeta-cobranza .icono {
    font-size: 24px;
    margin-bottom: 15px;
}

.cobranzas-body .tarjeta-cobranza .titulo {
    color: #a8b8ce;
    font-size: 12px;
    font-weight: 600;
    margin-bottom: 9px;
}

.cobranzas-body .tarjeta-cobranza .numero {
    color: #f8fafc;
    font-size: 27px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.cobranzas-body .tarjeta-cobranza.verde {
    border-left: 4px solid #4ade80;
}

.cobranzas-body .tarjeta-cobranza.amarillo {
    border-left: 4px solid #facc15;
}

.cobranzas-body .tarjeta-cobranza.naranja {
    border-left: 4px solid #fb923c;
}

.cobranzas-body .tarjeta-cobranza.rojo {
    border-left: 4px solid #f87171;
}

.cobranzas-body .tarjeta-cobranza.tarjeta-deuda {
    background: linear-gradient(145deg, #142b50, #10203b);
    border: 1px solid #294d7a;
    border-left: 4px solid #60a5fa;
}

.cobranzas-body .tarjeta-deuda .titulo {
    color: #bfdbfe;
}

.cobranzas-body .tarjeta-deuda .numero {
    color: #f8fafc;
}

/* Filtros */

.cobranzas-body .filtros-cobranza {
    background: rgba(15, 23, 42, .88);
    border: 1px solid #26364d;
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 23px;
    box-shadow: 0 12px 32px rgba(0, 0, 0, .14);
    align-items: center;
}

.cobranzas-body .buscador-cobranza {
    min-width: 230px;
}

.cobranzas-body .buscador-cobranza input,
.cobranzas-body .filtros-cobranza select {
    min-height: 44px;
    background: #0b1528;
    color: #e5eefb;
    border: 1px solid #33445e;
    border-radius: 9px;
    padding: 11px 13px;
    transition: border-color .2s, box-shadow .2s;
}

.cobranzas-body .buscador-cobranza input::placeholder {
    color: #718198;
}

.cobranzas-body .buscador-cobranza input:focus,
.cobranzas-body .filtros-cobranza select:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, .13);
}

.cobranzas-body .filtros-cobranza > div[style] {
    min-width: 200px;
}

.cobranzas-body .boton-filtrar,
.cobranzas-body .boton-limpiar {
    display: inline-flex;
    min-height: 44px;
    align-items: center;
    justify-content: center;
    padding: 0 19px;
    border-radius: 9px;
    font-size: 13px;
    white-space: nowrap;
    transition: background .2s, transform .2s;
}

.cobranzas-body .boton-filtrar {
    background: #2563eb;
    color: white;
}

.cobranzas-body .boton-filtrar:hover {
    background: #3b82f6;
    transform: translateY(-1px);
}

.cobranzas-body .boton-limpiar {
    background: #26364d;
    color: #dbeafe;
}

.cobranzas-body .boton-limpiar:hover {
    background: #334b6a;
}

/* Tabla */

.cobranzas-body .contenedor-tabla-cobranza {
    background: #0b1528;
    border: 1px solid #26364d;
    border-radius: 16px;
    overflow-x: auto;
    box-shadow: 0 15px 40px rgba(0, 0, 0, .18);
}

.cobranzas-body .tabla-cobranza {
    width: 100%;
    min-width: 950px;
    border-collapse: separate;
    border-spacing: 0;
}

.cobranzas-body .tabla-cobranza th {
    background: #14233b;
    color: #cbdcf4;
    padding: 16px 14px;
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .4px;
    border-bottom: 1px solid #33445e;
    white-space: nowrap;
}

.cobranzas-body .tabla-cobranza td {
    background: transparent;
    color: #dbe6f5;
    padding: 15px 14px;
    font-size: 13px;
    border-bottom: 1px solid rgba(51, 68, 94, .55);
    vertical-align: middle;
}

.cobranzas-body .tabla-cobranza tbody tr:hover td {
    background: rgba(37, 99, 235, .08);
}

.cobranzas-body .tabla-cobranza tbody tr:last-child td {
    border-bottom: none;
}

.cobranzas-body .tabla-cobranza td strong {
    color: #f1f5f9;
}

.cobranzas-body .tabla-cobranza td small {
    display: inline-block;
    color: #7f9abb;
    margin-top: 5px;
    font-size: 11px;
}

/* Etiquetas de estado */

.cobranzas-body .estado {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 7px 10px;
    border-radius: 20px;
    font-size: 10px;
    font-weight: 800;
    white-space: nowrap;
}

.cobranzas-body .estado-al-dia {
    background: rgba(34, 197, 94, .13);
    color: #4ade80;
    border: 1px solid rgba(74, 222, 128, .25);
}

.cobranzas-body .estado-proximo {
    background: rgba(234, 179, 8, .13);
    color: #fde047;
    border: 1px solid rgba(250, 204, 21, .25);
}

.cobranzas-body .estado-vencido {
    background: rgba(249, 115, 22, .13);
    color: #fdba74;
    border: 1px solid rgba(251, 146, 60, .25);
}

.cobranzas-body .estado-moroso {
    background: rgba(239, 68, 68, .13);
    color: #fca5a5;
    border: 1px solid rgba(248, 113, 113, .25);
}

/* Deuda y atraso */

.cobranzas-body .deuda,
.cobranzas-body .atraso {
    color: #f87171;
    font-weight: 800;
    white-space: nowrap;
}

.cobranzas-body .sin-deuda {
    color: #4ade80;
    font-weight: 800;
    white-space: nowrap;
}

/* Botón estado de cuenta */

.cobranzas-body .btn-cuenta-cobranza {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 9px 12px;
    background: rgba(37, 99, 235, .16);
    color: #93c5fd;
    border: 1px solid rgba(96, 165, 250, .3);
    border-radius: 9px;
    font-size: 11px;
    font-weight: 700;
    transition: background .2s, transform .2s;
}

.cobranzas-body .btn-cuenta-cobranza:hover {
    background: rgba(37, 99, 235, .3);
    transform: translateY(-1px);
}

/* Mensaje vacío */

.cobranzas-body .mensaje-vacio {
    padding: 45px !important;
    text-align: center;
    color: #94a3b8;
    font-size: 14px;
}

/* Adaptación a pantallas medianas */

@media (max-width: 1250px) {
    .cobranzas-body .tarjetas-cobranza {
        grid-template-columns: repeat(3, minmax(0, 1fr));
    }
}

@media (max-width: 900px) {
    .cobranzas-body .contenido-principal {
        padding: 22px;
    }

    .cobranzas-body .tarjetas-cobranza {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

/* Adaptación a móviles */

@media (max-width: 600px) {
    .cobranzas-body .contenido-principal {
        padding: 16px;
    }

    .cobranzas-body .cabecera-cobranzas h1 {
        font-size: 24px;
    }

    .cobranzas-body .tarjetas-cobranza {
        grid-template-columns: 1fr;
        gap: 13px;
    }

    .cobranzas-body .tarjeta-cobranza {
        padding: 20px;
    }

    .cobranzas-body .filtros-cobranza {
        flex-direction: column;
        align-items: stretch;
        padding: 15px;
    }

    .cobranzas-body .buscador-cobranza,
    .cobranzas-body .filtros-cobranza > div[style] {
        width: 100%;
        min-width: 0 !important;
    }

    .cobranzas-body .boton-filtrar,
    .cobranzas-body .boton-limpiar {
        width: 100%;
        box-sizing: border-box;
    }
}

    </style>

</head>


<body class="cobranzas-body">

<div class="sistema">


    <!-- ==========================================
         MENU
    ========================================== -->

    <jsp:include page="menu.jsp"/>


    <main class="contenido">

        <section class="contenido-principal">

            <div class="contenedor">


                <!-- ==================================
                     ENCABEZADO
                =================================== -->

                <div class="cabecera-cobranzas">

                    <div>

                        <h1>
                            💰 Cobranzas
                        </h1>

                        <p>
                            Control de pagos, vencimientos y morosidad
                        </p>

                    </div>

                </div>


                <!-- ==================================
                     TARJETAS
                =================================== -->

                <div class="tarjetas-cobranza">


                    <div class="tarjeta-cobranza verde">

                        <div class="icono">
                            🟢
                        </div>

                        <div class="titulo">
                            Al día
                        </div>

                        <div class="numero">
                            <%= totalAlDia %>
                        </div>

                    </div>


                    <div class="tarjeta-cobranza amarillo">

                        <div class="icono">
                            🟡
                        </div>

                        <div class="titulo">
                            Próximos a vencer
                        </div>

                        <div class="numero">
                            <%= totalProximos %>
                        </div>

                    </div>


                    <div class="tarjeta-cobranza naranja">

                        <div class="icono">
                            🟠
                        </div>

                        <div class="titulo">
                            Vencidos
                        </div>

                        <div class="numero">
                            <%= totalVencidos %>
                        </div>

                    </div>


                    <div class="tarjeta-cobranza rojo">

                        <div class="icono">
                            🔴
                        </div>

                        <div class="titulo">
                            Morosos
                        </div>

                        <div class="numero">
                            <%= totalMorosos %>
                        </div>

                    </div>


                    <div class="tarjeta-cobranza tarjeta-deuda">

                        <div class="icono">
                            💰
                        </div>

                        <div class="titulo">
                            Deuda total
                        </div>

                        <div class="numero">

                            S/
                            <%= String.format(
                                "%.2f",
                                deudaTotal
                            ) %>

                        </div>

                    </div>

                </div>


                <!-- ==================================
                     FILTROS
                =================================== -->

                <form
                    action="${pageContext.request.contextPath}/CobranzasServlet"
                    method="get"
                    class="filtros-cobranza"
                >

                    <div class="buscador-cobranza">

                        <input
                            type="text"
                            name="buscar"
                            placeholder="🔎 Buscar cliente, DNI, código o teléfono..."
                            value="<%= buscarActual %>"
                        >

                    </div>


                    <div style="min-width:200px;">

                        <select name="estado">

                            <option
                                value="TODOS"
                                <%= estadoActual.isEmpty()
                                    ? "selected"
                                    : "" %>
                            >
                                Todos los estados
                            </option>


                            <option
                                value="AL DIA"
                                <%= "AL DIA".equals(estadoActual)
                                    ? "selected"
                                    : "" %>
                            >
                                🟢 Al día
                            </option>


                            <option
                                value="PROXIMO A VENCER"
                                <%= "PROXIMO A VENCER".equals(estadoActual)
                                    ? "selected"
                                    : "" %>
                            >
                                🟡 Próximo a vencer
                            </option>


                            <option
                                value="VENCIDO"
                                <%= "VENCIDO".equals(estadoActual)
                                    ? "selected"
                                    : "" %>
                            >
                                🟠 Vencido
                            </option>


                            <option
                                value="MOROSO"
                                <%= "MOROSO".equals(estadoActual)
                                    ? "selected"
                                    : "" %>
                            >
                                🔴 Moroso
                            </option>

                        </select>

                    </div>


                    <button
                        type="submit"
                        class="boton-filtrar"
                    >
                        Filtrar
                    </button>


                    <a
                        href="${pageContext.request.contextPath}/CobranzasServlet"
                        class="boton-limpiar"
                    >
                        Limpiar
                    </a>

                </form>


                <!-- ==================================
                     TABLA
                =================================== -->

                <div class="contenedor-tabla-cobranza">

                    <table class="tabla-cobranza">

                        <thead>

                            <tr>

                                <th>
                                    Cliente
                                </th>

                                <th>
                                    DNI
                                </th>

                                <th>
                                    Teléfono
                                </th>

                                <th>
                                    Cuotas
                                </th>

                                <th>
                                    Deuda
                                </th>

                                <th>
                                    Días atraso
                                </th>

                                <th>
                                    Próximo vencimiento
                                </th>

                                <th>
                                    Estado
                                </th>

                                <th>
                                    Acciones
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                        <%

                        if (!clientesEstado.isEmpty()) {

                            for (
                                EstadoCliente ec :
                                clientesEstado
                            ) {

                        %>

                            <tr>


                                <!-- CLIENTE -->

                                <td>

                                    <strong>
                                        <%= ec.getCliente() %>
                                    </strong>

                                    <br>

                                    <small>
                                        <%= ec.getCodigoCliente() %>
                                    </small>

                                </td>


                                <!-- DNI -->

                                <td>

                                    <%= ec.getDni() != null
                                        ? ec.getDni()
                                        : "-" %>

                                </td>


                                <!-- TELEFONO -->

                                <td>

                                    <%= ec.getTelefono() != null
                                        ? ec.getTelefono()
                                        : "-" %>

                                </td>


                                <!-- CUOTAS -->

                                <td>

                                    <%= ec.getCuotasPendientes() %>

                                </td>


                                <!-- DEUDA -->

                                <td>

                                    <%
                                    if (ec.getDeudaTotal() > 0) {
                                    %>

                                        <span class="deuda">

                                            S/
                                            <%= String.format(
                                                "%.2f",
                                                ec.getDeudaTotal()
                                            ) %>

                                        </span>

                                    <%
                                    } else {
                                    %>

                                        <span class="sin-deuda">

                                            S/ 0.00

                                        </span>

                                    <%
                                    }
                                    %>

                                </td>


                                <!-- DIAS ATRASO -->

                                <td>

                                    <%
                                    if (ec.getDiasAtraso() > 0) {
                                    %>

                                        <span class="atraso">

                                            <%= ec.getDiasAtraso() %>
                                            días

                                        </span>

                                    <%
                                    } else {
                                    %>

                                        -

                                    <%
                                    }
                                    %>

                                </td>


                                <!-- PROXIMO VENCIMIENTO -->

                                <td>

                                    <%= ec.getProximoVencimiento() != null
                                        && !ec.getProximoVencimiento().isEmpty()
                                        ? ec.getProximoVencimiento()
                                        : "-" %>

                                </td>


                                <!-- ESTADO -->

                                <td>

                                    <%

                                    String estadoPago =
                                        ec.getEstadoPago();

                                    String claseEstado =
                                        "estado-al-dia";

                                    String textoEstado =
                                        "🟢 AL DÍA";


                                    if (
                                        "PROXIMO A VENCER"
                                        .equals(estadoPago)
                                    ) {

                                        claseEstado =
                                            "estado-proximo";

                                        textoEstado =
                                            "🟡 PRÓXIMO A VENCER";

                                    }

                                    else if (
                                        "VENCIDO"
                                        .equals(estadoPago)
                                    ) {

                                        claseEstado =
                                            "estado-vencido";

                                        textoEstado =
                                            "🟠 VENCIDO";

                                    }

                                    else if (
                                        "MOROSO"
                                        .equals(estadoPago)
                                    ) {

                                        claseEstado =
                                            "estado-moroso";

                                        textoEstado =
                                            "🔴 MOROSO";
                                    }

                                    %>


                                    <span
                                        class="estado <%= claseEstado %>"
                                    >

                                        <%= textoEstado %>

                                    </span>

                                </td>


                                <!-- ACCIONES -->

                                <td>

                                    <a
                                        href="${pageContext.request.contextPath}/EstadoCuentaServlet?idCliente=<%= ec.getIdCliente() %>"
                                        class="btn-cuenta-cobranza"
                                    >
                                        📄 Ver cuenta
                                    </a>

                                </td>

                            </tr>

                        <%

                            }

                        } else {

                        %>

                            <tr>

                                <td
                                    colspan="9"
                                    class="mensaje-vacio"
                                >

                                    No se encontraron clientes.

                                </td>

                            </tr>

                        <%

                        }

                        %>

                        </tbody>

                    </table>

                </div>

            </div>

        </section>

    </main>

</div>

</body>

</html>