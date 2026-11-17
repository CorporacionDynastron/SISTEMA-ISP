<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="modelo.AvisoWhatsApp"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>

<%
    List<AvisoWhatsApp> avisos =
            (List<AvisoWhatsApp>) request.getAttribute("avisos");

    if (avisos == null) {
        avisos = new ArrayList<>();
    }

    String contextPath =
            request.getContextPath();


    // =========================================================
    // CONTADORES
    // =========================================================

    int totalEmision = 0;
    int totalRecordatorio = 0;
    int totalVencimiento = 0;
    int totalSegundoAviso = 0;
    int totalSuspension = 0;

    for (AvisoWhatsApp aviso : avisos) {

        String tipo = aviso.getTipoAviso();

        if ("EMISION".equalsIgnoreCase(tipo)) {

            totalEmision++;

        } else if ("RECORDATORIO".equalsIgnoreCase(tipo)) {

            totalRecordatorio++;

        } else if ("VENCIMIENTO".equalsIgnoreCase(tipo)) {

            totalVencimiento++;

        } else if ("SEGUNDO_AVISO".equalsIgnoreCase(tipo)) {

            totalSegundoAviso++;

        } else if ("SUSPENSION".equalsIgnoreCase(tipo)) {

            totalSuspension++;
        }
    }


    int totalAvisos = avisos.size();


    // =========================================================
    // NIVEL DE URGENCIA
    // =========================================================

    String nivelUrgencia = "SIN AVISOS";
    String claseUrgencia = "sin-urgencia";
    String iconoUrgencia = "✅";
    String mensajeUrgencia =
            "No tienes notificaciones pendientes para hoy.";

    if (totalSuspension > 0) {

        nivelUrgencia = "URGENTE";
        claseUrgencia = "urgente";
        iconoUrgencia = "⛔";

        mensajeUrgencia =
                "Hay clientes que llegan a la etapa de suspensión.";

    } else if (totalSegundoAviso > 0) {

        nivelUrgencia = "ALTA";
        claseUrgencia = "alta";
        iconoUrgencia = "🔴";

        mensajeUrgencia =
                "Hay clientes con cuotas atrasadas que requieren atención.";

    } else if (totalVencimiento > 0) {

        nivelUrgencia = "MEDIA";
        claseUrgencia = "media";
        iconoUrgencia = "🟠";

        mensajeUrgencia =
                "Hay clientes cuyas cuotas vencen hoy.";

    } else if (totalRecordatorio > 0) {

        nivelUrgencia = "PREVENTIVA";
        claseUrgencia = "preventiva";
        iconoUrgencia = "🟡";

        mensajeUrgencia =
                "Hay clientes a los que se debe recordar su próximo vencimiento.";

    } else if (totalEmision > 0) {

        nivelUrgencia = "INFORMATIVA";
        claseUrgencia = "informativa";
        iconoUrgencia = "🔵";

        mensajeUrgencia =
                "Hay nuevas cuotas generadas que requieren comunicación.";
    }
%>


<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Avisos WhatsApp | Grupo Stellar</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/estilo.css">


    <style>

        /* =====================================================
           CONTENEDOR PRINCIPAL
           ===================================================== */

        .avisos-contenedor {
            padding: 25px;
        }


        /* =====================================================
           ENCABEZADO
           ===================================================== */

        .avisos-encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .avisos-encabezado h1 {
            margin: 0;
            color: #f8fafc;
            font-size: 28px;
        }

        .avisos-encabezado p {
            color: #94a3b8;
            margin-top: 8px;
        }

        .buscador-avisos {
            width: 100%;
            max-width: 400px;
            padding: 13px 16px;
            border: 1px solid #334155;
            border-radius: 10px;
            background: #0f172a;
            color: white;
            outline: none;
        }


        /* =====================================================
           PANEL DE HOY
           ===================================================== */

        .panel-hoy {

            display: grid;

            grid-template-columns:
                1fr auto;

            gap: 20px;

            padding: 24px;

            margin-bottom: 25px;

            border-radius: 16px;

            background:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #1e293b
                );

            border: 1px solid #334155;

            box-shadow:
                0 8px 25px rgba(0, 0, 0, 0.20);
        }


        .panel-hoy-contenido h2 {

            margin: 0;

            color: white;

            font-size: 22px;
        }


        .panel-hoy-contenido p {

            margin: 8px 0 0;

            color: #94a3b8;

            line-height: 1.5;
        }


        .panel-hoy-total {

            display: flex;

            flex-direction: column;

            align-items: center;

            justify-content: center;

            min-width: 130px;

            padding: 15px 25px;

            border-radius: 14px;

            background: rgba(255,255,255,0.06);

            border: 1px solid #475569;
        }


        .panel-hoy-total strong {

            font-size: 38px;

            color: white;

            line-height: 1;
        }


        .panel-hoy-total span {

            margin-top: 7px;

            color: #cbd5e1;

            font-size: 12px;

            text-transform: uppercase;

            font-weight: bold;
        }


        /* =====================================================
           URGENCIA
           ===================================================== */

        .urgencia {

            display: flex;

            align-items: center;

            gap: 10px;

            margin-top: 15px;

            padding: 10px 14px;

            border-radius: 9px;

            font-size: 13px;

            font-weight: bold;

            width: fit-content;
        }


        .urgencia.urgente {

            background: #450a0a;

            color: #fecaca;

            border: 1px solid #991b1b;
        }


        .urgencia.alta {

            background: #7f1d1d;

            color: #fee2e2;

            border: 1px solid #dc2626;
        }


        .urgencia.media {

            background: #7c2d12;

            color: #fed7aa;

            border: 1px solid #f97316;
        }


        .urgencia.preventiva {

            background: #713f12;

            color: #fef08a;

            border: 1px solid #eab308;
        }


        .urgencia.informativa {

            background: #172554;

            color: #bfdbfe;

            border: 1px solid #3b82f6;
        }


        .urgencia.sin-urgencia {

            background: #14532d;

            color: #bbf7d0;

            border: 1px solid #22c55e;
        }


        /* =====================================================
           RESUMEN
           ===================================================== */

        .resumen-avisos {

            display: grid;

            grid-template-columns:
                repeat(auto-fit, minmax(180px, 1fr));

            gap: 18px;

            margin-bottom: 25px;
        }


        .resumen-card {

            padding: 20px;

            border-radius: 14px;

            background: #1e293b;

            border: 1px solid #334155;
        }


        .resumen-card h3 {

            color: #cbd5e1;

            font-size: 14px;

            margin: 0 0 10px;
        }


        .resumen-card strong {

            color: white;

            font-size: 30px;
        }


        .resumen-emision {

            border-left: 5px solid #3b82f6;
        }


        .resumen-recordatorio {

            border-left: 5px solid #eab308;
        }


        .resumen-vencimiento {

            border-left: 5px solid #f97316;
        }


        .resumen-segundo {

            border-left: 5px solid #ef4444;
        }


        .resumen-suspension {

            border-left: 5px solid #991b1b;
        }


        /* =====================================================
           LISTA
           ===================================================== */

        .lista-avisos {

            display: grid;

            grid-template-columns:
                repeat(auto-fit, minmax(310px, 1fr));

            gap: 22px;
        }


        .aviso-card {

            background: #ffffff;

            border-radius: 16px;

            padding: 22px;

            box-shadow:
                0 8px 25px rgba(0, 0, 0, 0.20);

            border-top: 5px solid #3b82f6;
        }


        .aviso-card.recordatorio {

            border-top-color: #eab308;
        }


        .aviso-card.vencimiento {

            border-top-color: #f97316;
        }


        .aviso-card.segundo-aviso {

            border-top-color: #ef4444;
        }


        .aviso-card.suspension {

            border-top-color: #991b1b;
        }


        /* =====================================================
           CABECERA
           ===================================================== */

        .aviso-cabecera {

            display: flex;

            justify-content: space-between;

            align-items: flex-start;

            gap: 10px;

            margin-bottom: 15px;
        }


        .aviso-cabecera h2 {

            margin: 0;

            font-size: 18px;

            color: #0f172a;
        }


        .codigo-cliente {

            color: #64748b;

            font-size: 12px;

            margin-top: 5px;
        }


        /* =====================================================
           ETIQUETAS
           ===================================================== */

        .etiqueta {

            padding: 6px 10px;

            border-radius: 20px;

            font-size: 11px;

            font-weight: bold;

            white-space: nowrap;
        }


        .etiqueta.emision {

            background: #dbeafe;

            color: #1d4ed8;
        }


        .etiqueta.recordatorio {

            background: #fef9c3;

            color: #854d0e;
        }


        .etiqueta.vencimiento {

            background: #ffedd5;

            color: #c2410c;
        }


        .etiqueta.segundo-aviso {

            background: #fee2e2;

            color: #991b1b;
        }


        .etiqueta.suspension {

            background: #450a0a;

            color: #ffffff;
        }


        /* =====================================================
           DATOS
           ===================================================== */

        .aviso-datos {

            display: grid;

            gap: 9px;

            margin-bottom: 18px;
        }


        .dato {

            display: flex;

            justify-content: space-between;

            gap: 12px;

            border-bottom: 1px solid #e2e8f0;

            padding-bottom: 8px;

            font-size: 13px;
        }


        .dato span:first-child {

            color: #64748b;
        }


        .dato span:last-child {

            color: #0f172a;

            font-weight: bold;

            text-align: right;
        }


        .telefono-sin-dato {

            color: #dc2626 !important;
        }


        /* =====================================================
           MENSAJE
           ===================================================== */

        .mensaje-contenedor {

            margin-top: 15px;
        }


        .mensaje-contenedor label {

            display: block;

            font-size: 13px;

            font-weight: bold;

            color: #334155;

            margin-bottom: 8px;
        }


        .mensaje {

            width: 100%;

            min-height: 190px;

            resize: vertical;

            padding: 12px;

            border: 1px solid #cbd5e1;

            border-radius: 10px;

            background: #f8fafc;

            color: #334155;

            font-family: Arial, sans-serif;

            font-size: 13px;

            line-height: 1.5;

            box-sizing: border-box;
        }


        /* =====================================================
           BOTONES
           ===================================================== */

        .acciones-aviso {

            display: flex;

            gap: 10px;

            flex-wrap: wrap;

            margin-top: 14px;
        }


        .btn-copiar {

            border: none;

            border-radius: 9px;

            padding: 11px 15px;

            cursor: pointer;

            background: #16a34a;

            color: white;

            font-weight: bold;

            transition: 0.2s;
        }


        .btn-copiar:hover {

            background: #15803d;
        }


        .btn-whatsapp {

            border: none;

            border-radius: 9px;

            padding: 11px 15px;

            cursor: pointer;

            background: #25d366;

            color: white;

            font-weight: bold;

            text-decoration: none;
        }


        .btn-whatsapp:hover {

            background: #20bd5a;
        }


        /* =====================================================
           SIN AVISOS
           ===================================================== */

        .sin-avisos {

            text-align: center;

            padding: 50px 20px;

            border-radius: 14px;

            background: #1e293b;

            color: #cbd5e1;
        }


        .sin-avisos h2 {

            color: white;
        }


        /* =====================================================
           RESPONSIVE
           ===================================================== */

        @media (max-width: 700px) {

            .avisos-contenedor {

                padding: 15px;
            }


            .panel-hoy {

                grid-template-columns: 1fr;
            }


            .panel-hoy-total {

                width: 100%;

                box-sizing: border-box;
            }


            .aviso-cabecera {

                flex-direction: column;
            }


            .dato {

                font-size: 12px;
            }

        }
        
        
        
        
        
        
        
        
        /* =====================================================
           GRUPO STELLAR - AVISOS WHATSAPP PREMIUM
           Solo diseño visual
           ===================================================== */

        body.avisos-whatsapp-body {
            background: #0b1120;
            color: #e2e8f0;
        }

        .avisos-whatsapp-body .contenido {
            background:
                radial-gradient(ellipse at top right, rgba(37, 99, 235, 0.09), transparent 40%),
                #0b1120;
            min-height: 100vh;
        }

        .avisos-whatsapp-body .topbar {
            background: rgba(15, 23, 42, 0.96);
            border-bottom: 1px solid #263449;
            color: #f8fafc;
        }

        .avisos-whatsapp-body .topbar h2 {
            color: #f8fafc;
        }

        .avisos-whatsapp-body .usuario {
            color: #cbd5e1;
        }

        .avisos-whatsapp-body .avisos-contenedor {
            padding: 28px;
        }

        /* Encabezado */

        .avisos-whatsapp-body .avisos-encabezado h1 {
            color: #f8fafc;
            font-size: 30px;
            letter-spacing: -0.5px;
        }

        .avisos-whatsapp-body .avisos-encabezado p {
            color: #94a3b8;
        }

        .avisos-whatsapp-body .buscador-avisos {
            background: #111c30;
            color: #f8fafc;
            border: 1px solid #334155;
            border-radius: 12px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .avisos-whatsapp-body .buscador-avisos:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }

        .avisos-whatsapp-body .buscador-avisos::placeholder {
            color: #64748b;
        }

        /* Panel de avisos del día */

        .avisos-whatsapp-body .panel-hoy {
            background: linear-gradient(135deg, #111c30, #172641);
            border: 1px solid #2b3b54;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.22);
            position: relative;
            overflow: hidden;
        }

        .avisos-whatsapp-body .panel-hoy-contenido h2 {
            color: #f8fafc;
        }

        .avisos-whatsapp-body .panel-hoy-contenido p {
            color: #a8b7cc;
        }

        .avisos-whatsapp-body .panel-hoy-total {
            background: rgba(59, 130, 246, 0.09);
            border: 1px solid #334d72;
        }

        .avisos-whatsapp-body .panel-hoy-total strong {
            color: #60a5fa;
        }

        .avisos-whatsapp-body .panel-hoy-total span {
            color: #cbd5e1;
        }

        /* Tarjetas de resumen */

        .avisos-whatsapp-body .resumen-card {
            background: linear-gradient(145deg, #172338, #111c30);
            border: 1px solid #29384e;
            border-radius: 15px;
            box-shadow: 0 8px 22px rgba(0, 0, 0, 0.13);
            transition: transform 0.2s, border-color 0.2s;
        }

        .avisos-whatsapp-body .resumen-card:hover {
            transform: translateY(-3px);
            border-color: #456080;
        }

        .avisos-whatsapp-body .resumen-card h3 {
            color: #aebed2;
        }

        .avisos-whatsapp-body .resumen-card strong {
            color: #f8fafc;
            font-size: 32px;
        }

        /* Tarjetas individuales */

        .avisos-whatsapp-body .aviso-card {
            background: linear-gradient(145deg, #172338, #111c30);
            color: #e2e8f0;
            border: 1px solid #2b3b51;
            border-top: 4px solid #3b82f6;
            border-radius: 16px;
            padding: 22px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.20);
            transition: transform 0.2s, border-color 0.2s, box-shadow 0.2s;
            min-width: 0;
        }

        .avisos-whatsapp-body .aviso-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 32px rgba(0, 0, 0, 0.28);
        }

        .avisos-whatsapp-body .aviso-card h2 {
            color: #f1f5f9;
            overflow-wrap: anywhere;
        }

        .avisos-whatsapp-body .codigo-cliente {
            color: #93a4bb;
        }

        /* Datos del cliente */

        .avisos-whatsapp-body .aviso-datos {
            gap: 0;
        }

        .avisos-whatsapp-body .dato {
            padding: 11px 0;
            border-bottom: 1px solid #2b3b51;
            color: #cbd5e1;
            gap: 14px;
        }

        .avisos-whatsapp-body .dato span:first-child {
            color: #94a3b8;
        }

        .avisos-whatsapp-body .dato span:last-child {
            color: #f1f5f9;
            overflow-wrap: anywhere;
        }

        .avisos-whatsapp-body .dato .telefono-sin-dato {
            color: #f87171 !important;
        }

        /* Mensaje generado */

        .avisos-whatsapp-body .mensaje-contenedor label {
            color: #cbd5e1;
        }

        .avisos-whatsapp-body .mensaje {
            background: #0b1425;
            color: #dbeafe;
            border: 1px solid #34445b;
            border-radius: 11px;
            line-height: 1.65;
            font-size: 13px;
        }

        .avisos-whatsapp-body .mensaje:focus {
            outline: 1px solid #3b82f6;
        }

        /* Botones */

        .avisos-whatsapp-body .acciones-aviso {
            margin-top: 16px;
        }

        .avisos-whatsapp-body .btn-copiar,
        .avisos-whatsapp-body .btn-whatsapp {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 42px;
            box-sizing: border-box;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 700;
            transition: transform 0.2s, filter 0.2s;
        }

        .avisos-whatsapp-body .btn-copiar {
            background: #2563eb;
            color: #ffffff;
        }

        .avisos-whatsapp-body .btn-copiar:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .avisos-whatsapp-body .btn-whatsapp {
            background: #16a34a;
            color: #ffffff;
        }

        .avisos-whatsapp-body .btn-whatsapp:hover {
            background: #15803d;
            color: #ffffff;
            transform: translateY(-1px);
        }

        /* Estado sin avisos */

        .avisos-whatsapp-body .sin-avisos {
            background: linear-gradient(145deg, #172338, #111c30);
            color: #aebed2;
            border: 1px solid #2b3b51;
            border-radius: 16px;
            padding: 42px 24px;
        }

        .avisos-whatsapp-body .sin-avisos h2 {
            color: #f8fafc;
        }

        /* Etiquetas más limpias */

        .avisos-whatsapp-body .etiqueta {
            letter-spacing: 0.3px;
            border: 1px solid transparent;
        }

        .avisos-whatsapp-body .etiqueta.emision {
            background: #172f53;
            color: #93c5fd;
            border-color: #28518a;
        }

        .avisos-whatsapp-body .etiqueta.recordatorio {
            background: #403315;
            color: #fde68a;
            border-color: #76601e;
        }

        .avisos-whatsapp-body .etiqueta.vencimiento {
            background: #492819;
            color: #fdba74;
            border-color: #8c4b23;
        }

        .avisos-whatsapp-body .etiqueta.segundo-aviso {
            background: #491f2b;
            color: #fda4af;
            border-color: #8e3043;
        }

        .avisos-whatsapp-body .etiqueta.suspension {
            background: #450a0a;
            color: #fecaca;
            border-color: #991b1b;
        }

        /* Diseño adaptable */

        @media (max-width: 900px) {
            .avisos-whatsapp-body .avisos-contenedor {
                padding: 20px;
            }

            .avisos-whatsapp-body .lista-avisos {
                grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
                gap: 16px;
            }
        }

        @media (max-width: 700px) {
            .avisos-whatsapp-body .avisos-contenedor {
                padding: 15px;
            }

            .avisos-whatsapp-body .avisos-encabezado h1 {
                font-size: 25px;
            }

            .avisos-whatsapp-body .buscador-avisos {
                max-width: none;
                width: 100%;
                box-sizing: border-box;
            }

            .avisos-whatsapp-body .panel-hoy {
                grid-template-columns: 1fr;
                padding: 18px;
            }

            .avisos-whatsapp-body .panel-hoy-total {
                width: 100%;
                box-sizing: border-box;
            }

            .avisos-whatsapp-body .lista-avisos {
                grid-template-columns: minmax(0, 1fr);
            }

            .avisos-whatsapp-body .aviso-card {
                padding: 17px;
            }

            .avisos-whatsapp-body .aviso-cabecera {
                flex-direction: column;
            }

            .avisos-whatsapp-body .dato {
                font-size: 12px;
            }

            .avisos-whatsapp-body .acciones-aviso > * {
                flex: 1 1 100%;
                text-align: center;
            }
        }

    </style>

</head>


<body class="avisos-whatsapp-body">


<div class="sistema">


    <!-- =====================================================
         SIDEBAR
         ===================================================== -->

    <aside class="sidebar">

        <div class="logo">

            🌐 SISTEMA ISP

        </div>


        <div class="menu">


            <a href="<%= contextPath %>/DashboardServlet">

                📊 Dashboard

            </a>


            <a href="<%= contextPath %>/ClienteServlet">

                👥 Clientes

            </a>


            <a href="<%= contextPath %>/PagoServlet">

                💳 Pagos

            </a>


            <a href="<%= contextPath %>/CobranzasServlet">

                ⚠️ Morosidad

            </a>


            <a href="<%= contextPath %>/ReporteServlet">

                📈 Reportes

            </a>


            <a href="<%= contextPath %>/AvisosWhatsAppServlet"
               class="activo">

                📱 Avisos WhatsApp

            </a>


        </div>

    </aside>


    <!-- =====================================================
         CONTENIDO
         ===================================================== -->

    <main class="contenido">


        <header class="topbar">

            <h2>
                Panel de administración
            </h2>


            <div class="usuario">

                👤 Usuario

            </div>

        </header>


        <section class="avisos-contenedor">


            <!-- =================================================
                 ENCABEZADO
                 ================================================= -->

            <div class="avisos-encabezado">


                <div>

                    <h1>

                        📱 Avisos WhatsApp

                    </h1>


                    <p>

                        Gestión de notificaciones de cobranza
                        según el estado de cada cuota.

                    </p>

                </div>


                <input

                    type="text"

                    id="buscadorAvisos"

                    class="buscador-avisos"

                    placeholder="🔍 Buscar cliente o código..."

                    onkeyup="filtrarAvisos()">

            </div>


            <!-- =================================================
                 PANEL AVISOS DE HOY
                 ================================================= -->

            <div class="panel-hoy">


                <div class="panel-hoy-contenido">


                    <h2>

                        📢 Avisos de cobranza de hoy

                    </h2>


                    <p>

                        Tienes
                        <strong style="color:white;">
                            <%= totalAvisos %>
                        </strong>
                        aviso(s) que requieren atención
                        durante el día.

                    </p>


                    <div class="urgencia <%= claseUrgencia %>">

                        <span>
                            <%= iconoUrgencia %>
                        </span>

                        <span>

                            <%= nivelUrgencia %> —
                            <%= mensajeUrgencia %>

                        </span>

                    </div>


                </div>


                <div class="panel-hoy-total">


                    <strong>

                        <%= totalAvisos %>

                    </strong>


                    <span>

                        Clientes / avisos

                    </span>


                </div>


            </div>


            <!-- =================================================
                 CONTADORES
                 ================================================= -->

            <div class="resumen-avisos">


                <div class="resumen-card resumen-emision">

                    <h3>
                        🔵 Emisión
                    </h3>


                    <strong>
                        <%= totalEmision %>
                    </strong>

                </div>


                <div class="resumen-card resumen-recordatorio">

                    <h3>
                        🟡 Recordatorio
                    </h3>


                    <strong>
                        <%= totalRecordatorio %>
                    </strong>

                </div>


                <div class="resumen-card resumen-vencimiento">

                    <h3>
                        🟠 Vencimiento
                    </h3>


                    <strong>
                        <%= totalVencimiento %>
                    </strong>

                </div>


                <div class="resumen-card resumen-segundo">

                    <h3>
                        🔴 Segundo aviso
                    </h3>


                    <strong>
                        <%= totalSegundoAviso %>
                    </strong>

                </div>


                <div class="resumen-card resumen-suspension">

                    <h3>
                        ⛔ Suspensión
                    </h3>


                    <strong>
                        <%= totalSuspension %>
                    </strong>

                </div>


                <div class="resumen-card">

                    <h3>
                        📋 Total de avisos
                    </h3>


                    <strong>
                        <%= totalAvisos %>
                    </strong>

                </div>


            </div>


            <!-- =================================================
                 SIN AVISOS
                 ================================================= -->

            <%

                if (avisos.isEmpty()) {

            %>


                <div class="sin-avisos">


                    <h2>

                        ✅ No hay avisos para hoy

                    </h2>


                    <p>

                        Actualmente no existe ninguna
                        notificación programada para este día.

                    </p>


                </div>


            <%

                } else {

            %>


            <!-- =================================================
                 LISTA
                 ================================================= -->

            <div

                class="lista-avisos"

                id="listaAvisos">


                <%

                    for (AvisoWhatsApp aviso : avisos) {


                        String tipo =
                                aviso.getTipoAviso();


                        String claseCard = "";

                        String claseEtiqueta = "";

                        String textoEtiqueta = "";


                        if ("EMISION".equalsIgnoreCase(tipo)) {


                            claseCard = "emision";

                            claseEtiqueta = "emision";

                            textoEtiqueta =
                                    "1.ª EMISIÓN";


                        } else if (

                                "RECORDATORIO"
                                .equalsIgnoreCase(tipo)) {


                            claseCard = "recordatorio";

                            claseEtiqueta = "recordatorio";

                            textoEtiqueta =
                                    "2.ª RECORDATORIO";


                        } else if (

                                "VENCIMIENTO"
                                .equalsIgnoreCase(tipo)) {


                            claseCard = "vencimiento";

                            claseEtiqueta = "vencimiento";

                            textoEtiqueta =
                                    "3.ª VENCIMIENTO";


                        } else if (

                                "SEGUNDO_AVISO"
                                .equalsIgnoreCase(tipo)) {


                            claseCard =
                                    "segundo-aviso";

                            claseEtiqueta =
                                    "segundo-aviso";

                            textoEtiqueta =
                                    "4.ª SEGUNDO AVISO";


                        } else if (

                                "SUSPENSION"
                                .equalsIgnoreCase(tipo)) {


                            claseCard =
                                    "suspension";

                            claseEtiqueta =
                                    "suspension";

                            textoEtiqueta =
                                    "5.ª SUSPENSIÓN";

                        }


                        String telefono =

                                aviso.getTelefono() == null

                                ? ""

                                : aviso.getTelefono().trim();


                        String telefonoLimpio =

                                telefono.replaceAll(
                                        "[^0-9]",
                                        ""
                                );


                        // =================================================
                        // WHATSAPP
                        // =================================================

                        String telefonoWhatsApp =
                                telefonoLimpio;


                        if (
                                telefonoWhatsApp.length() == 9
                        ) {

                            telefonoWhatsApp =
                                    "51"
                                    + telefonoWhatsApp;
                        }


                        String mensajeWhatsApp =

                                URLEncoder.encode(
                                        aviso.getMensaje(),
                                        "UTF-8"
                                );

                %>


                <div

                    class="aviso-card <%= claseCard %>"

                    data-busqueda="<%= (

                        aviso.getNombreCliente()

                        + " "

                        + aviso.getCodigoCliente()

                    ).toLowerCase() %>">


                    <!-- =========================================
                         CABECERA
                         ========================================= -->

                    <div class="aviso-cabecera">


                        <div>


                            <h2>

                                👤
                                <%= aviso.getNombreCliente() %>

                            </h2>


                            <div class="codigo-cliente">

                                Código:
                                <%= aviso.getCodigoCliente() %>

                            </div>


                        </div>


                        <span
                            class="etiqueta <%= claseEtiqueta %>">

                            <%= textoEtiqueta %>

                        </span>


                    </div>


                    <!-- =========================================
                         DATOS
                         ========================================= -->

                    <div class="aviso-datos">


                        <div class="dato">


                            <span>

                                📱 Teléfono

                            </span>


                            <span class="<%=

                                telefono.isEmpty()

                                ? "telefono-sin-dato"

                                : ""

                            %>">


                                <%=

                                    telefono.isEmpty()

                                    ? "No registrado"

                                    : telefono

                                %>


                            </span>


                        </div>


                        
<div class="dato">
    <span>📅 Fecha de emisión</span>
    <span>
        <%= aviso.getFechaEmision() != null
            ? aviso.getFechaEmision()
            : "No registrada" %>
    </span>
</div>


                        <div class="dato">


                            <span>

                                📅 Fecha de vencimiento

                            </span>


                            <span>

                                <%= aviso.getFechaVencimiento() %>

                            </span>


                        </div>


                        <div class="dato">


                            <span>

                                💰 Monto

                            </span>


                            <span>

                                S/

                                <%= String.format(

                                    "%.2f",

                                    aviso.getMonto()

                                ) %>


                            </span>


                        </div>


                        <div class="dato">


                            <span>

                                📌 Periodo

                            </span>


                            <span>

                                <%= aviso.getPeriodo() %>

                            </span>


                        </div>


                        <%

                            if (
                                aviso.getDiasAtraso() > 0
                            ) {

                        %>


                        <div class="dato">


                            <span>

                                ⏰ Días de atraso

                            </span>


                            <span
                                style="color:#dc2626;">

                                <%= aviso.getDiasAtraso() %>
                                días

                            </span>


                        </div>


                        <%

                            }

                        %>


                    </div>


                    <!-- =========================================
                         MENSAJE
                         ========================================= -->

                    <div class="mensaje-contenedor">


                        <label>

                            ✉️ Mensaje generado

                        </label>


                        <textarea

                            class="mensaje"

                            readonly><%= aviso.getMensaje() %></textarea>


                    </div>


                    <!-- =========================================
                         ACCIONES
                         ========================================= -->

                    <div class="acciones-aviso">


                        <button

                            type="button"

                            class="btn-copiar"

                            onclick="copiarMensaje(this)">


                            📋 Copiar mensaje


                        </button>


                        <%

                            if (
                                !telefonoWhatsApp.isEmpty()
                            ) {

                        %>


                        <a

                            class="btn-whatsapp"

                            href="https://wa.me/<%= telefonoWhatsApp %>?text=<%= mensajeWhatsApp %>"

                            target="_blank"

                            rel="noopener noreferrer">


                            💬 Abrir WhatsApp


                        </a>


                        <%

                            }

                        %>


                    </div>


                </div>


                <%

                    }

                %>


            </div>


            <!-- =================================================
                 SIN RESULTADOS
                 ================================================= -->

            <div

                id="mensajeSinResultados"

                class="sin-avisos"

                style="
                    display:none;
                    margin-top:25px;
                ">


                <h2>

                    🔍 No se encontraron resultados

                </h2>


                <p>

                    Intenta buscar con otro nombre o código.

                </p>


            </div>


            <%

                }

            %>


        </section>


    </main>


</div>


<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


    // =========================================================
    // COPIAR MENSAJE
    // =========================================================

    function copiarMensaje(boton) {


        const tarjeta =

            boton.closest(".aviso-card");


        const textarea =

            tarjeta.querySelector(".mensaje");


        const mensaje =

            textarea.value;


        navigator.clipboard.writeText(mensaje)


            .then(function() {


                const textoOriginal =

                    boton.innerHTML;


                boton.innerHTML =

                    "✅ ¡Copiado!";


                setTimeout(function() {


                    boton.innerHTML =

                        textoOriginal;


                }, 2000);


            })


            .catch(function() {


                textarea.removeAttribute(
                    "readonly"
                );


                textarea.select();


                document.execCommand("copy");


                textarea.setAttribute(
                    "readonly",
                    true
                );


                boton.innerHTML =

                    "✅ ¡Copiado!";

            });

    }


    // =========================================================
    // BUSCADOR
    // =========================================================

    function filtrarAvisos() {


        const buscador =

            document.getElementById(
                "buscadorAvisos"
            );


        const texto =

            buscador.value
                .toLowerCase()
                .trim();


        const tarjetas =

            document.querySelectorAll(
                ".aviso-card"
            );


        const mensajeSinResultados =

            document.getElementById(
                "mensajeSinResultados"
            );


        let encontrados = 0;


        tarjetas.forEach(function(tarjeta) {


            const contenido =

                tarjeta.getAttribute(
                    "data-busqueda"
                );


            if (
                contenido.includes(texto)
            ) {


                tarjeta.style.display =
                    "block";


                encontrados++;


            } else {


                tarjeta.style.display =
                    "none";

            }

        });


        if (mensajeSinResultados) {


            mensajeSinResultados.style.display =

                encontrados === 0

                ? "block"

                : "none";

        }

    }


</script>


</body>

</html>