<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="modelo.Morosidad"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Morosidad - Sistema ISP</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">

    <style>

        .encabezado-morosidad {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .encabezado-morosidad h1 {
            margin: 0;
            color: #1e293b;
        }

        .tarjetas {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .tarjeta {
            background: white;
            padding: 22px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,.06);
        }

        .tarjeta-titulo {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .tarjeta-valor {
            font-size: 28px;
            font-weight: bold;
            color: #1e293b;
        }

        .tarjeta-morosos {
            border-left: 5px solid #ef4444;
        }

        .tarjeta-deuda {
            border-left: 5px solid #f59e0b;
        }

        .barra-herramientas {
            background: white;
            padding: 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }

        .barra-herramientas input {
            flex: 1;
            padding: 11px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
        }

        .btn-buscar {
            padding: 11px 20px;
            border: none;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-buscar:hover {
            background: #1d4ed8;
        }

        .tabla-contenedor {
            background: white;
            border-radius: 12px;
            overflow-x: auto;
            box-shadow: 0 4px 15px rgba(0,0,0,.06);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f8fafc;
            color: #475569;
            text-align: left;
            padding: 14px;
            font-size: 13px;
            white-space: nowrap;
        }

        td {
            padding: 14px;
            border-top: 1px solid #e5e7eb;
            color: #334155;
        }

        tr:hover {
            background: #f8fafc;
        }

        .estado {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .pendiente {
            background: #fef3c7;
            color: #92400e;
        }

        .vencida {
            background: #fee2e2;
            color: #991b1b;
        }

        .atraso {
            color: #dc2626;
            font-weight: bold;
        }

        .sin-datos {
            text-align: center;
            padding: 40px;
            color: #64748b;
        }

        /* BOTÓN ESTADO DE CUENTA */

        .btn-cuenta {
            display: inline-block;
            padding: 7px 12px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 7px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .btn-cuenta:hover {
            background: #1d4ed8;
        }

        @media (max-width: 800px) {

            .tarjetas {
                grid-template-columns: 1fr;
            }

            .barra-herramientas {
                flex-direction: column;
            }

        }
        
        
        
        
        
        
/* ==========================================
   GRUPO STELLAR - MOROSIDAD PREMIUM
   Solo diseño visual
   ========================================== */

.morosidad-body {
    background-color: #020817;
    background-image:
        radial-gradient(ellipse at top right, rgba(37, 99, 235, .16), transparent 48%),
        linear-gradient(135deg, #020817 0%, #0b1224 55%, #07172b 100%);
    background-attachment: fixed;
    color: #e5eefb;
}

.morosidad-body .contenido,
.morosidad-body .contenido-principal {
    background: transparent;
}

.morosidad-body .contenido-principal {
    padding: 30px;
}

.morosidad-body .contenedor {
    max-width: 1800px;
    margin: 0 auto;
}

/* Encabezado */

.morosidad-body .encabezado-morosidad {
    margin-bottom: 28px;
}

.morosidad-body .encabezado-morosidad h1 {
    color: #f8fafc;
    font-size: 30px;
    font-weight: 800;
    letter-spacing: -.5px;
}

.morosidad-body .encabezado-morosidad p {
    color: #94a3b8;
    margin-top: 8px;
    font-size: 14px;
}

/* Tarjetas estadísticas */

.morosidad-body .tarjetas {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
    margin-bottom: 25px;
}

.morosidad-body .tarjeta {
    position: relative;
    overflow: hidden;
    background: linear-gradient(145deg, #111e32, #0b1528);
    border: 1px solid #26364d;
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, .16);
    transition: transform .2s ease, border-color .2s ease;
}

.morosidad-body .tarjeta:hover {
    transform: translateY(-3px);
    border-color: #3b5475;
}

.morosidad-body .tarjeta-morosos {
    border-left: 4px solid #f87171;
}

.morosidad-body .tarjeta-deuda {
    border-left: 4px solid #fbbf24;
}

.morosidad-body .tarjeta-titulo {
    color: #a8b8ce;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 12px;
}

.morosidad-body .tarjeta-valor {
    color: #f8fafc;
    font-size: 32px;
    font-weight: 800;
    letter-spacing: -.5px;
}

/* Buscador */

.morosidad-body .barra-herramientas {
    background: rgba(15, 23, 42, .88);
    border: 1px solid #26364d;
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 22px;
    box-shadow: 0 12px 32px rgba(0, 0, 0, .14);
}

.morosidad-body .barra-herramientas form {
    align-items: center;
}

.morosidad-body .barra-herramientas input {
    min-width: 0;
    height: 44px;
    padding: 0 14px;
    color: #e5eefb;
    background: #0b1528;
    border: 1px solid #33445e;
    border-radius: 9px;
    outline: none;
    transition: border-color .2s, box-shadow .2s;
}

.morosidad-body .barra-herramientas input::placeholder {
    color: #718198;
}

.morosidad-body .barra-herramientas input:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, .13);
}

.morosidad-body .btn-buscar {
    min-height: 44px;
    border-radius: 9px;
    padding: 0 22px;
    background: linear-gradient(135deg, #2563eb, #1d4ed8);
    white-space: nowrap;
    transition: transform .2s, background .2s;
}

.morosidad-body .btn-buscar:hover {
    background: #3b82f6;
    transform: translateY(-1px);
}

/* Tabla */

.morosidad-body .tabla-contenedor {
    background: #0b1528;
    border: 1px solid #26364d;
    border-radius: 16px;
    overflow-x: auto;
    box-shadow: 0 15px 40px rgba(0, 0, 0, .18);
}

.morosidad-body .tabla-contenedor table {
    width: 100%;
    min-width: 850px;
    border-collapse: separate;
    border-spacing: 0;
}

.morosidad-body .tabla-contenedor th {
    background: #14233b;
    color: #cbdcf4;
    text-align: left;
    padding: 16px;
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .5px;
    border-bottom: 1px solid #33445e;
}

.morosidad-body .tabla-contenedor td {
    background: transparent;
    color: #dbe6f5;
    padding: 15px 16px;
    border-top: none;
    border-bottom: 1px solid rgba(51, 68, 94, .55);
    font-size: 13px;
    vertical-align: middle;
}

.morosidad-body .tabla-contenedor tbody tr:hover td {
    background: rgba(37, 99, 235, .08);
}

.morosidad-body .tabla-contenedor tbody tr:last-child td {
    border-bottom: none;
}

.morosidad-body .tabla-contenedor td strong {
    color: #f1f5f9;
}

.morosidad-body .tabla-contenedor td:first-child strong {
    color: #60a5fa;
}

/* Estados */

.morosidad-body .estado {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 6px 11px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

.morosidad-body .pendiente {
    background: rgba(245, 158, 11, .14);
    color: #fbbf24;
    border: 1px solid rgba(245, 158, 11, .25);
}

.morosidad-body .vencida {
    background: rgba(239, 68, 68, .14);
    color: #fca5a5;
    border: 1px solid rgba(248, 113, 113, .28);
}

.morosidad-body .atraso {
    color: #f87171;
    font-weight: 800;
    white-space: nowrap;
}

/* Botón estado de cuenta */

.morosidad-body .btn-cuenta {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 9px 13px;
    background: rgba(37, 99, 235, .16);
    color: #93c5fd;
    border: 1px solid rgba(96, 165, 250, .3);
    border-radius: 9px;
    font-size: 12px;
    font-weight: 700;
    transition: background .2s, transform .2s;
}

.morosidad-body .btn-cuenta:hover {
    background: rgba(37, 99, 235, .3);
    transform: translateY(-1px);
}

/* Estado vacío */

.morosidad-body .sin-datos {
    padding: 42px 20px;
    color: #94a3b8;
    text-align: center;
    font-size: 14px;
}

/* Responsive */

@media (max-width: 900px) {
    .morosidad-body .contenido-principal {
        padding: 22px;
    }
}

@media (max-width: 600px) {
    .morosidad-body .contenido-principal {
        padding: 16px;
    }

    .morosidad-body .encabezado-morosidad h1 {
        font-size: 24px;
    }

    .morosidad-body .tarjetas {
        grid-template-columns: 1fr;
    }

    .morosidad-body .tarjeta {
        padding: 21px;
    }

    .morosidad-body .barra-herramientas {
        padding: 14px;
    }

    .morosidad-body .barra-herramientas form {
        flex-direction: column;
        align-items: stretch;
    }

    .morosidad-body .barra-herramientas input,
    .morosidad-body .btn-buscar {
        width: 100%;
    }
}
        
        
    </style>

</head>

<body class="morosidad-body">

<div class="sistema">

    <jsp:include page="menu.jsp"/>

    <main class="contenido">

        <section class="contenido-principal">

            <div class="contenedor">


                <!-- =====================================
                     ENCABEZADO
                ====================================== -->

                <div class="encabezado-morosidad">

                    <div>

                        <h1>🔴 Morosidad y Cobranzas</h1>

                        <p>
                            Clientes con cuotas pendientes o vencidas
                        </p>

                    </div>

                </div>


                <!-- =====================================
                     TARJETAS
                ====================================== -->

                <%

                    Integer totalMorosos =
                            (Integer) request.getAttribute(
                                    "totalMorosos"
                            );

                    Double totalPendiente =
                            (Double) request.getAttribute(
                                    "totalPendiente"
                            );

                    if (totalMorosos == null) {
                        totalMorosos = 0;
                    }

                    if (totalPendiente == null) {
                        totalPendiente = 0.0;
                    }

                %>


                <div class="tarjetas">


                    <div class="tarjeta tarjeta-morosos">

                        <div class="tarjeta-titulo">
                            Clientes con deuda
                        </div>

                        <div class="tarjeta-valor">
                            <%= totalMorosos %>
                        </div>

                    </div>


                    <div class="tarjeta tarjeta-deuda">

                        <div class="tarjeta-titulo">
                            Total pendiente
                        </div>

                        <div class="tarjeta-valor">

                            S/
                            <%= String.format(
                                    "%.2f",
                                    totalPendiente
                            ) %>

                        </div>

                    </div>

                </div>


                <!-- =====================================
                     BUSCADOR
                ====================================== -->

                <div class="barra-herramientas">

                    <form
                        action="MorosidadServlet"
                        method="GET"
                        style="display:flex;width:100%;gap:10px;"
                    >

                        <input
                            type="text"
                            name="buscar"
                            placeholder="Buscar por código, cliente, DNI o teléfono..."
                            value="<%= request.getParameter("buscar") != null
                                    ? request.getParameter("buscar")
                                    : "" %>"
                        >

                        <button
                            type="submit"
                            class="btn-buscar"
                        >
                            🔎 Buscar
                        </button>

                    </form>

                </div>


                <!-- =====================================
                     TABLA
                ====================================== -->

                <div class="tabla-contenedor">

                    <table>

                        <thead>

                            <tr>

                                <th>Cliente</th>

                                <th>DNI</th>

                                <th>Periodo</th>

                                <th>Vencimiento</th>

                                <th>Monto</th>

                                <th>Estado</th>

                                <th>Atraso</th>

                                <th>Acciones</th>

                            </tr>

                        </thead>


                        <tbody>

                        <%

                            List<Morosidad> morosos =
                                    (List<Morosidad>)
                                    request.getAttribute(
                                            "morosos"
                                    );

                            if (
                                morosos != null &&
                                !morosos.isEmpty()
                            ) {

                                for (
                                    Morosidad m :
                                    morosos
                                ) {

                        %>

                            <tr>

                                <!-- CLIENTE -->

                                <td>

                                    <strong>
                                        <%= m.getCodigoCliente() %>
                                    </strong>

                                    <br>

                                    <%= m.getCliente() %>

                                </td>


                                <!-- DNI -->

                                <td>
                                    <%= m.getDni() %>
                                </td>


                                <!-- PERIODO -->

                                <td>
                                    <%= m.getPeriodo() %>
                                </td>


                                <!-- VENCIMIENTO -->

                                <td>
                                    <%= m.getFechaVencimiento() %>
                                </td>


                                <!-- MONTO -->

                                <td>

                                    <strong>

                                        S/
                                        <%= String.format(
                                                "%.2f",
                                                m.getMonto()
                                        ) %>

                                    </strong>

                                </td>


                                <!-- ESTADO -->

                                <td>

                                    <%

                                        String claseEstado =
                                                "PENDIENTE".equalsIgnoreCase(
                                                        m.getEstado()
                                                )
                                                ? "pendiente"
                                                : "vencida";

                                    %>

                                    <span
                                        class="estado <%= claseEstado %>"
                                    >

                                        <%= m.getEstado() %>

                                    </span>

                                </td>


                                <!-- ATRASO -->

                                <td>

                                    <% if (m.getDiasAtraso() > 0) { %>

                                        <span class="atraso">

                                            <%= m.getDiasAtraso() %>
                                            días

                                        </span>

                                    <% } else { %>

                                        <span>
                                            Al día
                                        </span>

                                    <% } %>

                                </td>


                                <!-- ACCIONES -->

                                <td>

                                    <a
                                        href="EstadoCuentaServlet?idCliente=<%= m.getIdCliente() %>"
                                        class="btn-cuenta"
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
                                    colspan="8"
                                    class="sin-datos"
                                >

                                    🎉 No hay clientes con deuda.

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