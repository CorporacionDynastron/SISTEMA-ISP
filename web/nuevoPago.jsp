<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="modelo.Cliente"%>
<%@page import="modelo.Cuota"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Registrar Pago - Sistema ISP</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 30px;
        }

        .contenedor {
            max-width: 650px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }

        h1 {
            margin-bottom: 25px;
            color: #222;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
            color: #374151;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 11px;
            box-sizing: border-box;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-family: Arial, sans-serif;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #2563eb;
        }

        input[readonly] {
            background-color: #f3f4f6;
            color: #374151;
        }

        textarea {
            height: 80px;
            resize: vertical;
        }

        .informacion-cuota {
            margin-top: 20px;
            padding: 18px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
        }

        .informacion-cuota h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #1e293b;
        }

        .dato {
            display: flex;
            justify-content: space-between;
            padding: 7px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .dato:last-child {
            border-bottom: none;
        }

        .dato span:first-child {
            color: #64748b;
        }

        .dato span:last-child {
            font-weight: bold;
            color: #1e293b;
        }

        .estado {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 13px;
        }

        .estado-pendiente {
            background: #fef3c7;
            color: #92400e;
        }

        .estado-vencida {
            background: #fee2e2;
            color: #991b1b;
        }

        .mensaje {
            display: none;
            margin-top: 12px;
            padding: 12px;
            border-radius: 7px;
            background: #fff7ed;
            color: #9a3412;
            border: 1px solid #fed7aa;
        }

        .botones {
            margin-top: 25px;
        }

        button {
            padding: 11px 20px;
            border: none;
            border-radius: 7px;
            cursor: pointer;
            color: white;
            background-color: #2563eb;
            font-size: 14px;
        }

        button:hover {
            background-color: #1d4ed8;
        }

        .cancelar {
            margin-left: 10px;
            background-color: #6b7280;
            text-decoration: none;
            color: white;
            padding: 11px 20px;
            border-radius: 7px;
            display: inline-block;
        }

        .cancelar:hover {
            background-color: #4b5563;
        }

        .campo-oculto {
            display: none;
        }

    </style>

</head>

<body>

<div class="contenedor">

    <h1>💰 Registrar Pago</h1>


    <form
        action="PagoServlet"
        method="POST"
        enctype="multipart/form-data"
    >


        <!-- ==========================================
             CLIENTE
        =========================================== -->

        <label>Cliente</label>

        <select
            name="idCliente"
            id="idCliente"
            required
        >

            <option value="">
                -- Seleccionar cliente --
            </option>

            <%
                List<Cliente> clientes =
                    (List<Cliente>) request.getAttribute("clientes");

                if (clientes != null) {

                    for (Cliente cliente : clientes) {
            %>

            <option
                value="<%= cliente.getIdCliente() %>"
                data-plan="<%= cliente.getNombrePlan() == null ? "" : cliente.getNombrePlan() %>"
                data-precio="<%= cliente.getPrecioPlan() %>"
            >

                <%= cliente.getCodigoCliente() %>
                -
                <%= cliente.getNombres() %>
                <%= cliente.getApellidos() %>

            </option>

            <%
                    }
                }
            %>

        </select>


        <!-- ==========================================
             PLAN
        =========================================== -->

        <label>Plan</label>

        <input
            type="text"
            id="planCliente"
            readonly
            placeholder="El plan aparecerá automáticamente"
        >


        <!-- ==========================================
             PRECIO DEL PLAN
        =========================================== -->

        <label>Precio del Plan</label>

        <input
            type="text"
            id="precioPlan"
            readonly
            placeholder="El precio aparecerá automáticamente"
        >


        <!-- ==========================================
             CUOTA
        =========================================== -->

        <label>Cuota a pagar</label>

        <select
            name="idCuota"
            id="idCuota"
            required
        >

            <option value="">
                -- Primero selecciona un cliente --
            </option>

            <%
                List<Cuota> cuotas =
                    (List<Cuota>) request.getAttribute("cuotas");

                if (cuotas != null) {

                    for (Cuota cuota : cuotas) {

                        if ("PENDIENTE".equalsIgnoreCase(cuota.getEstado())
                                || "VENCIDA".equalsIgnoreCase(cuota.getEstado())) {
            %>

            <option
                value="<%= cuota.getIdCuota() %>"
                data-cliente="<%= cuota.getIdCliente() %>"
                data-periodo="<%= cuota.getPeriodo() %>"
                data-vencimiento="<%= cuota.getFechaVencimiento() %>"
                data-monto="<%= cuota.getMonto() %>"
                data-estado="<%= cuota.getEstado() %>"
                style="display:none;"
            >

                <%= cuota.getPeriodo() %>
                -
                S/ <%= String.format("%.2f", cuota.getMonto()) %>
                -
                <%= cuota.getEstado() %>

            </option>

            <%
                        }
                    }
                }
            %>

        </select>


        <!-- ==========================================
             INFORMACIÓN DE LA CUOTA
        =========================================== -->

        <div
            class="informacion-cuota"
            id="informacionCuota"
            style="display:none;"
        >

            <h3>📄 Información de la cuota</h3>

            <div class="dato">

                <span>Periodo</span>

                <span id="periodoMostrar">
                    -
                </span>

            </div>


            <div class="dato">

                <span>Fecha de vencimiento</span>

                <span id="vencimientoMostrar">
                    -
                </span>

            </div>


            <div class="dato">

                <span>Monto</span>

                <span id="montoMostrar">
                    -
                </span>

            </div>


            <div class="dato">

                <span>Estado</span>

                <span id="estadoMostrar">
                    -
                </span>

            </div>

        </div>


        <div
            class="mensaje"
            id="mensajeCuota"
        >
            Este cliente no tiene cuotas pendientes o vencidas.
        </div>


        <!-- ==========================================
             FECHA DE PAGO
        =========================================== -->

        <label>Fecha de Pago</label>

        <input
            type="date"
            name="fechaPago"
            id="fechaPago"
            required
        >


        <!-- ==========================================
             PERIODO OCULTO
        =========================================== -->

        <input
            type="hidden"
            name="periodo"
            id="periodo"
        >


        <!-- ==========================================
             MONTO OCULTO
        =========================================== -->

        <input
            type="hidden"
            name="monto"
            id="monto"
        >


        <!-- ==========================================
             MÉTODO DE PAGO
        =========================================== -->

        <label>Método de Pago</label>

        <select
            name="metodoPago"
            required
        >

            <option value="">
                -- Seleccionar método --
            </option>

            <option value="Yape">
                Yape
            </option>

            <option value="Plin">
                Plin
            </option>

            <option value="Transferencia">
                Transferencia
            </option>

            <option value="Efectivo">
                Efectivo
            </option>

            <option value="Depósito">
                Depósito
            </option>

        </select>


        <!-- ==========================================
             NÚMERO DE OPERACIÓN
        =========================================== -->

        <label>N.º de Operación</label>

        <input
            type="text"
            name="numeroOperacion"
            placeholder="Ejemplo: 123456789"
        >


        <!-- ==========================================
             COMPROBANTE
        =========================================== -->

        <label>📎 Comprobante de Pago</label>

        <input
            type="file"
            name="comprobante"
            accept="image/jpeg,image/png,image/webp"
        >


        <!-- ==========================================
             OBSERVACIÓN
        =========================================== -->

        <label>Observación</label>

        <textarea
            name="observacion"
            placeholder="Observaciones del pago..."
        ></textarea>


        <!-- ==========================================
             BOTONES
        =========================================== -->

        <div class="botones">

            <button type="submit">
                💾 Guardar Pago
            </button>

            <a
                href="PagoServlet"
                class="cancelar"
            >
                Cancelar
            </a>

        </div>


    </form>

</div>


<script>

    // ==========================================
    // ELEMENTOS
    // ==========================================

    const selectCliente =
        document.getElementById("idCliente");

    const selectCuota =
        document.getElementById("idCuota");

    const planCliente =
        document.getElementById("planCliente");

    const precioPlan =
        document.getElementById("precioPlan");

    const informacionCuota =
        document.getElementById("informacionCuota");

    const mensajeCuota =
        document.getElementById("mensajeCuota");

    const periodoMostrar =
        document.getElementById("periodoMostrar");

    const vencimientoMostrar =
        document.getElementById("vencimientoMostrar");

    const montoMostrar =
        document.getElementById("montoMostrar");

    const estadoMostrar =
        document.getElementById("estadoMostrar");

    const periodo =
        document.getElementById("periodo");

    const monto =
        document.getElementById("monto");


    // ==========================================
    // FECHA ACTUAL
    // ==========================================

    const fechaPago =
        document.getElementById("fechaPago");

    const hoy =
        new Date();

    const año =
        hoy.getFullYear();

    const mes =
        String(hoy.getMonth() + 1).padStart(2, "0");

    const dia =
        String(hoy.getDate()).padStart(2, "0");

    fechaPago.value =
        año + "-" + mes + "-" + dia;


    // ==========================================
    // CAMBIO DE CLIENTE
    // ==========================================

    selectCliente.addEventListener(
        "change",
        function() {

            const opcion =
                this.options[this.selectedIndex];


            // --------------------------------------
            // PLAN
            // --------------------------------------

            if (this.value === "") {

                planCliente.value = "";
                precioPlan.value = "";

            } else {

                const plan =
                    opcion.getAttribute("data-plan");

                const precio =
                    opcion.getAttribute("data-precio");


                planCliente.value =
                    plan || "";

                precioPlan.value =
                    "S/ " + parseFloat(precio).toFixed(2);
            }


            // --------------------------------------
            // LIMPIAR CUOTA
            // --------------------------------------

            selectCuota.value = "";

            informacionCuota.style.display =
                "none";

            mensajeCuota.style.display =
                "none";

            periodo.value = "";
            monto.value = "";


            // --------------------------------------
            // OCULTAR / MOSTRAR CUOTAS
            // --------------------------------------

            const opciones =
                selectCuota.querySelectorAll(
                    "option[data-cliente]"
                );

            let cantidadCuotas =
                0;


            opciones.forEach(
                function(opcionCuota) {

                    const idClienteCuota =
                        opcionCuota.getAttribute(
                            "data-cliente"
                        );


                    if (
                        idClienteCuota ===
                        this.value
                    ) {

                        opcionCuota.style.display =
                            "block";

                        cantidadCuotas++;

                    } else {

                        opcionCuota.style.display =
                            "none";
                    }

                }.bind(this)
            );


            // --------------------------------------
            // MENSAJE SI NO HAY CUOTAS
            // --------------------------------------

            if (
                this.value !== "" &&
                cantidadCuotas === 0
            ) {

                mensajeCuota.style.display =
                    "block";
            }

        }
    );


    // ==========================================
    // CAMBIO DE CUOTA
    // ==========================================

    selectCuota.addEventListener(
        "change",
        function() {

            const opcion =
                this.options[this.selectedIndex];


            if (this.value === "") {

                informacionCuota.style.display =
                    "none";

                periodo.value = "";
                monto.value = "";

                return;
            }


            // --------------------------------------
            // DATOS
            // --------------------------------------

            const periodoDato =
                opcion.getAttribute(
                    "data-periodo"
                );

            const vencimiento =
                opcion.getAttribute(
                    "data-vencimiento"
                );

            const montoDato =
                opcion.getAttribute(
                    "data-monto"
                );

            const estado =
                opcion.getAttribute(
                    "data-estado"
                );


            // --------------------------------------
            // MOSTRAR
            // --------------------------------------

            periodoMostrar.textContent =
                periodoDato;

            vencimientoMostrar.textContent =
                vencimiento;

            montoMostrar.textContent =
                "S/ " +
                parseFloat(montoDato).toFixed(2);

            estadoMostrar.textContent =
                estado;


            // --------------------------------------
            // ESTADO VISUAL
            // --------------------------------------

            estadoMostrar.className =
                "estado";


            if (
                estado === "PENDIENTE"
            ) {

                estadoMostrar.classList.add(
                    "estado-pendiente"
                );

            } else if (
                estado === "VENCIDA"
            ) {

                estadoMostrar.classList.add(
                    "estado-vencida"
                );
            }


            // --------------------------------------
            // CAMPOS OCULTOS
            // --------------------------------------

            periodo.value =
                periodoDato;

            monto.value =
                montoDato;


            informacionCuota.style.display =
                "block";

        }
    );

</script>

</body>
</html>