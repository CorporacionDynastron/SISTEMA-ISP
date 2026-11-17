
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="modelo.Cliente"%>
<%@page import="modelo.Plan"%>
<%@page import="java.util.List"%>

<%
    Cliente cliente =
            (Cliente) request.getAttribute("cliente");

    List<Plan> planes =
            (List<Plan>) request.getAttribute("planes");
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Editar Cliente - Sistema ISP</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/estilo.css">

    <style>

        .formulario-contenedor {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .encabezado-formulario {
            margin-bottom: 25px;
        }

        .encabezado-formulario h1 {
            margin: 0;
            font-size: 28px;
            color: #0f172a;
        }

        .encabezado-formulario p {
            margin: 7px 0 0;
            color: #64748b;
            font-size: 14px;
        }

        .seccion-formulario {
            margin-top: 25px;
            margin-bottom: 20px;
            padding-bottom: 8px;
            border-bottom: 1px solid #e2e8f0;
        }

        .seccion-formulario h2 {
            margin: 0;
            font-size: 17px;
            color: #1e293b;
        }

        .seccion-formulario p {
            margin: 5px 0 0;
            font-size: 13px;
            color: #64748b;
        }

        .campo {
            margin-bottom: 18px;
        }

        .campo label {
            display: block;
            margin-bottom: 7px;
            font-size: 13px;
            font-weight: bold;
            color: #334155;
        }

        .campo input,
        .campo select,
        .campo textarea {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            padding: 10px 12px;
            font-size: 14px;
            box-sizing: border-box;
            outline: none;
            background: white;
            font-family: Arial, sans-serif;
        }

        .campo input,
        .campo select {
            height: 42px;
        }

        .campo textarea {
            min-height: 90px;
            resize: vertical;
        }

        .campo input:focus,
        .campo select:focus,
        .campo textarea:focus {
            border-color: #2563eb;
        }

        .fila {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .ayuda {
            display: block;
            margin-top: 5px;
            font-size: 12px;
            color: #64748b;
        }

        /* FOTO */

        .contenedor-foto {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .foto-actual,
        .vista-previa {
            width: 125px;
            height: 125px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #dbeafe;
            background: #f1f5f9;
        }

        .icono-foto {
            width: 125px;
            height: 125px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eff6ff;
            border: 3px solid #dbeafe;
            font-size: 42px;
        }

        .vista-previa {
            display: none;
        }

        .selector-foto {
            flex: 1;
            min-width: 220px;
        }

        .acciones-formulario {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .btn-cancelar {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 18px;
            border-radius: 7px;
            text-decoration: none;
            background: #e2e8f0;
            color: #334155;
            font-weight: bold;
            font-size: 14px;
        }

        .btn-cancelar:hover {
            background: #cbd5e1;
        }

        .btn-guardar {
            border: none;
            padding: 11px 20px;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-guardar:hover {
            background: #1d4ed8;
        }

        @media (max-width: 700px) {

            .fila {
                grid-template-columns: 1fr;
            }

            .formulario-contenedor {
                padding: 20px;
            }

            .acciones-formulario {
                flex-direction: column;
            }

            .btn-cancelar,
            .btn-guardar {
                width: 100%;
            }

        }

    </style>

</head>

<body>

<div class="sistema">

    <jsp:include page="menu.jsp"/>

    <main class="contenido">

        <section class="contenido-principal">

            <div class="formulario-contenedor">

                <div class="encabezado-formulario">

                    <h1>✏️ Editar Cliente</h1>

                    <p>
                        Modifica los datos personales y el servicio del cliente.
                    </p>

                </div>


                <!-- enctype NECESARIO PARA SUBIR FOTO -->

                <form
                    action="${pageContext.request.contextPath}/ClienteServlet"
                    method="POST"
                    enctype="multipart/form-data"
                >


                    <!-- ID DEL CLIENTE -->

                    <input
                        type="hidden"
                        name="idCliente"
                        value="<%= cliente.getIdCliente() %>"
                    >


                    <!-- INFORMACIÓN PERSONAL -->

                    <div class="seccion-formulario">

                        <h2>👤 Información personal</h2>

                        <p>
                            Datos principales del cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Código del cliente</label>

                        <input
                            type="text"
                            name="codigoCliente"
                            value="<%= cliente.getCodigoCliente() %>"
                            required
                        >

                    </div>


                    <div class="fila">

                        <div class="campo">

                            <label>Nombres</label>

                            <input
                                type="text"
                                name="nombres"
                                value="<%= cliente.getNombres() %>"
                                required
                            >

                        </div>


                        <div class="campo">

                            <label>Apellidos</label>

                            <input
                                type="text"
                                name="apellidos"
                                value="<%= cliente.getApellidos() %>"
                                required
                            >

                        </div>

                    </div>


                    <div class="fila">

                        <div class="campo">

                            <label>DNI</label>

                            <input
                                type="text"
                                name="dni"
                                maxlength="8"
                                value="<%= cliente.getDni() == null ? "" : cliente.getDni() %>"
                            >

                        </div>


                        <div class="campo">

                            <label>Teléfono principal</label>

                            <input
                                type="text"
                                name="telefono"
                                value="<%= cliente.getTelefono() == null ? "" : cliente.getTelefono() %>"
                            >

                        </div>

                    </div>


                    <div class="campo">

                        <label>Teléfono secundario</label>

                        <input
                            type="text"
                            name="telefono2"
                            value="<%= cliente.getTelefono2() == null ? "" : cliente.getTelefono2() %>"
                        >

                    </div>


                    <!-- DOMICILIO -->

                    <div class="seccion-formulario">

                        <h2>🏠 Información del domicilio</h2>

                        <p>
                            Datos de ubicación y referencia.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Dirección</label>

                        <input
                            type="text"
                            name="direccion"
                            value="<%= cliente.getDireccion() == null ? "" : cliente.getDireccion() %>"
                            placeholder="Dirección del domicilio"
                        >

                    </div>


                    <div class="campo">

                        <label>Referencia del domicilio</label>

                        <input
                            type="text"
                            name="referenciaDomicilio"
                            value="<%= cliente.getReferenciaDomicilio() == null ? "" : cliente.getReferenciaDomicilio() %>"
                            placeholder="Ejemplo: Frente al parque"
                        >

                    </div>


                    <!-- SERVICIO -->

                    <div class="seccion-formulario">

                        <h2>🌐 Servicio de Internet</h2>

                        <p>
                            Configuración del plan y facturación.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Plan de Internet</label>

                        <select name="idPlan" required>

                            <%
                                if (planes != null &&
                                    !planes.isEmpty()) {

                                    for (Plan plan : planes) {
                            %>

                                <option
                                    value="<%= plan.getIdPlan() %>"
                                    <%= cliente.getIdPlan()
                                            == plan.getIdPlan()
                                            ? "selected"
                                            : "" %>
                                >

                                    📡 <%= plan.getNombrePlan() %>
                                    -
                                    <%= plan.getVelocidad() %>
                                    -
                                    S/ <%= String.format(
                                            "%.2f",
                                            plan.getPrecio()
                                        ) %>

                                </option>

                            <%
                                    }

                                } else {
                            %>

                                <option value="">
                                    No hay planes disponibles
                                </option>

                            <%
                                }
                            %>

                        </select>

                    </div>


                    <div class="fila">

                        <div class="campo">

                            <label>Fecha de instalación</label>

                            <input
                                type="date"
                                name="fechaInstalacion"
                                value="<%= cliente.getFechaInstalacion() == null ? "" : cliente.getFechaInstalacion() %>"
                            >

                        </div>


                        <div class="campo">

                            <label>Día de vencimiento</label>

                            <input
                                type="number"
                                name="diaVencimiento"
                                min="1"
                                max="31"
                                value="<%= cliente.getDiaVencimiento() %>"
                                required
                            >

                        </div>

                    </div>


                    <!-- INFORMACIÓN ADICIONAL -->

                    <div class="seccion-formulario">

                        <h2>📝 Información adicional</h2>

                        <p>
                            Observaciones importantes del cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Observaciones</label>

                        <textarea
                            name="observaciones"
                            placeholder="Observaciones del cliente..."
                        ><%= cliente.getObservaciones() == null ? "" : cliente.getObservaciones() %></textarea>

                    </div>


                    <!-- FOTO DE PERFIL -->

                    <div class="seccion-formulario">

                        <h2>📸 Foto de perfil</h2>

                        <p>
                            Puedes conservar la foto actual o seleccionar una nueva.
                        </p>

                    </div>


                    <div class="campo">

                        <div class="contenedor-foto">

                            <%
                                String fotoActual =
                                        cliente.getFotoPerfil();
                            %>

                            <%
                                if (fotoActual != null &&
                                    !fotoActual.trim().isEmpty()) {
                            %>

                                <img
                                    id="fotoActual"
                                    class="foto-actual"
                                    src="${pageContext.request.contextPath}/<%= fotoActual %>"
                                    alt="Foto actual del cliente"
                                >

                            <%
                                } else {
                            %>

                                <div
                                    id="iconoFoto"
                                    class="icono-foto"
                                >
                                    👤
                                </div>

                            <%
                                }
                            %>


                            <img
                                id="vistaPrevia"
                                class="vista-previa"
                                alt="Vista previa de la nueva foto"
                            >


                            <div class="selector-foto">

                                <label>Seleccionar nueva fotografía</label>

                                <input
                                    type="file"
                                    name="foto"
                                    id="foto"
                                    accept="image/jpeg,image/png,image/webp"
                                >

                                <span class="ayuda">
                                    Si no seleccionas una imagen,
                                    se conservará la foto actual.
                                </span>

                                <span class="ayuda">
                                    Formatos: JPG, JPEG, PNG y WEBP.
                                    Tamaño máximo: 5 MB.
                                </span>

                            </div>

                        </div>

                    </div>


                    <!-- BOTONES -->

                    <div class="acciones-formulario">

                        <a
                            href="${pageContext.request.contextPath}/ClienteServlet"
                            class="btn-cancelar"
                        >
                            ← Cancelar
                        </a>


                        <button
                            type="submit"
                            class="btn-guardar"
                        >
                            💾 Guardar Cambios
                        </button>

                    </div>

                </form>

            </div>

        </section>

    </main>

</div>


<!-- VISTA PREVIA -->

<script>

    const inputFoto =
        document.getElementById("foto");

    const vistaPrevia =
        document.getElementById("vistaPrevia");

    const fotoActual =
        document.getElementById("fotoActual");

    const iconoFoto =
        document.getElementById("iconoFoto");


    inputFoto.addEventListener("change", function () {

        const archivo = this.files[0];

        if (!archivo) {

            vistaPrevia.style.display = "none";

            if (fotoActual) {
                fotoActual.style.display = "block";
            }

            if (iconoFoto) {
                iconoFoto.style.display = "flex";
            }

            return;
        }

        const tiposPermitidos = [
            "image/jpeg",
            "image/png",
            "image/webp"
        ];

        if (!tiposPermitidos.includes(archivo.type)) {

            alert(
                "Selecciona una imagen JPG, PNG o WEBP."
            );

            inputFoto.value = "";
            vistaPrevia.style.display = "none";

            return;
        }

        if (archivo.size > 5 * 1024 * 1024) {

            alert(
                "La imagen no puede superar los 5 MB."
            );

            inputFoto.value = "";
            vistaPrevia.style.display = "none";

            return;
        }

        const lector =
            new FileReader();

        lector.onload = function (evento) {

            vistaPrevia.src =
                evento.target.result;

            vistaPrevia.style.display = "block";

            if (fotoActual) {
                fotoActual.style.display = "none";
            }

            if (iconoFoto) {
                iconoFoto.style.display = "none";
            }

        };

        lector.readAsDataURL(archivo);

    });

</script>

</body>
</html>