
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Plan"%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Nuevo Cliente - Sistema ISP</title>

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

        .info-cuota {
            margin-top: 5px;
            padding: 12px 15px;
            border-radius: 8px;
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            color: #1e40af;
            font-size: 13px;
            line-height: 1.5;
        }

        /* FOTO DE PERFIL */

        .contenedor-foto {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .vista-previa {
            width: 125px;
            height: 125px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #dbeafe;
            background: #f1f5f9;
            display: none;
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

        .btn-registrar {
            border: none;
            padding: 11px 20px;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-registrar:hover {
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
            .btn-registrar {
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

                    <h1>👤 Registrar Nuevo Cliente</h1>

                    <p>
                        Ingresa los datos del cliente y configura su servicio de internet.
                    </p>

                </div>


                <!-- IMPORTANTE: enctype para subir archivos -->

                <form
                    action="${pageContext.request.contextPath}/ClienteServlet"
                    method="POST"
                    enctype="multipart/form-data"
                >


                    <!-- INFORMACIÓN PERSONAL -->

                    <div class="seccion-formulario">

                        <h2>👤 Información personal</h2>

                        <p>
                            Datos principales del titular del servicio.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Código del cliente *</label>

                        <input
                            type="text"
                            name="codigoCliente"
                            placeholder="Ejemplo: CLI0004"
                            required
                        >

                        <span class="ayuda">
                            Código único utilizado para identificar al cliente.
                        </span>

                    </div>


                    <div class="fila">

                        <div class="campo">

                            <label>Nombres *</label>

                            <input
                                type="text"
                                name="nombres"
                                placeholder="Nombres"
                                required
                            >

                        </div>


                        <div class="campo">

                            <label>Apellidos *</label>

                            <input
                                type="text"
                                name="apellidos"
                                placeholder="Apellidos"
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
                                inputmode="numeric"
                                placeholder="8 dígitos"
                            >

                        </div>


                        <div class="campo">

                            <label>Teléfono principal</label>

                            <input
                                type="text"
                                name="telefono"
                                maxlength="20"
                                inputmode="tel"
                                placeholder="Ejemplo: 987654321"
                            >

                        </div>

                    </div>


                    <div class="campo">

                        <label>Teléfono secundario</label>

                        <input
                            type="text"
                            name="telefono2"
                            maxlength="20"
                            inputmode="tel"
                            placeholder="Número alternativo"
                        >

                    </div>


                    <!-- DOMICILIO -->

                    <div class="seccion-formulario">

                        <h2>🏠 Información del domicilio</h2>

                        <p>
                            Datos necesarios para identificar la ubicación del cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Dirección</label>

                        <input
                            type="text"
                            name="direccion"
                            placeholder="Dirección del domicilio"
                        >

                    </div>


                    <div class="campo">

                        <label>Referencia del domicilio</label>

                        <input
                            type="text"
                            name="referenciaDomicilio"
                            placeholder="Ejemplo: Frente al parque, casa de 2 pisos"
                        >

                    </div>


                    <!-- SERVICIO -->

                    <div class="seccion-formulario">

                        <h2>🌐 Servicio de Internet</h2>

                        <p>
                            Configura el plan y el ciclo de facturación del cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Plan de Internet *</label>

                        <select name="idPlan" required>

                            <option value="">
                                Seleccionar plan
                            </option>

                            <%
                                List<Plan> planes =
                                    (List<Plan>) request.getAttribute("planes");

                                if (planes != null) {

                                    for (Plan plan : planes) {
                            %>

                                <option value="<%= plan.getIdPlan() %>">

                                    📡 <%= plan.getNombrePlan() %>
                                    -
                                    <%= plan.getVelocidad() %>
                                    -
                                    S/ <%= String.format("%.2f", plan.getPrecio()) %>

                                </option>

                            <%
                                    }

                                }
                            %>

                        </select>

                        <span class="ayuda">
                            El monto mensual se tomará automáticamente del plan seleccionado.
                        </span>

                    </div>


                    <div class="fila">

                        <div class="campo">

                            <label>Fecha de instalación *</label>

                            <input
                                type="date"
                                name="fechaInstalacion"
                                required
                            >

                            <span class="ayuda">
                                Esta fecha será la referencia del ciclo de facturación.
                            </span>

                        </div>


                        <div class="campo">

                            <label>Día de vencimiento *</label>

                            <input
                                type="number"
                                name="diaVencimiento"
                                min="1"
                                max="31"
                                placeholder="Ejemplo: 14"
                                required
                            >

                            <span class="ayuda">
                                Se conservará este día para los siguientes meses.
                            </span>

                        </div>

                    </div>


                    <div class="info-cuota">

                        💡 <strong>Facturación automática:</strong>

                        al registrar el cliente, el sistema generará automáticamente
                        su primera cuota mensual y la dejará como
                        <strong>PENDIENTE</strong>.

                    </div>


                    <!-- INFORMACIÓN ADICIONAL -->

                    <div class="seccion-formulario">

                        <h2>📝 Información adicional</h2>

                        <p>
                            Puedes agregar observaciones importantes del cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <label>Observaciones</label>

                        <textarea
                            name="observaciones"
                            placeholder="Ejemplo: Cliente solicita instalación en horario de tarde..."
                        ></textarea>

                    </div>


                    <!-- FOTO DE PERFIL -->

                    <div class="seccion-formulario">

                        <h2>📸 Foto de perfil</h2>

                        <p>
                            Puedes agregar una fotografía para identificar al cliente.
                        </p>

                    </div>


                    <div class="campo">

                        <div class="contenedor-foto">

                            <div class="icono-foto" id="iconoFoto">
                                👤
                            </div>

                            <img
                                id="vistaPrevia"
                                class="vista-previa"
                                alt="Vista previa de la foto"
                            >

                            <div class="selector-foto">

                                <label>Seleccionar fotografía</label>

                                <input
                                    type="file"
                                    name="foto"
                                    id="foto"
                                    accept="image/jpeg,image/png,image/webp"
                                >

                                <span class="ayuda">
                                    Formatos permitidos: JPG, JPEG, PNG y WEBP.
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
                            class="btn-registrar"
                        >
                            💾 Registrar Cliente
                        </button>

                    </div>

                </form>

            </div>

        </section>

    </main>

</div>


<!-- VISTA PREVIA DE IMAGEN -->

<script>

    const inputFoto =
        document.getElementById("foto");

    const vistaPrevia =
        document.getElementById("vistaPrevia");

    const iconoFoto =
        document.getElementById("iconoFoto");


    inputFoto.addEventListener("change", function () {

        const archivo = this.files[0];

        if (!archivo) {

            vistaPrevia.style.display = "none";
            iconoFoto.style.display = "flex";

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
            iconoFoto.style.display = "flex";

            return;
        }

        if (archivo.size > 5 * 1024 * 1024) {

            alert(
                "La imagen no puede superar los 5 MB."
            );

            inputFoto.value = "";
            vistaPrevia.style.display = "none";
            iconoFoto.style.display = "flex";

            return;
        }

        const lector =
            new FileReader();

        lector.onload = function (evento) {

            vistaPrevia.src =
                evento.target.result;

            vistaPrevia.style.display = "block";
            iconoFoto.style.display = "none";
        };

        lector.readAsDataURL(archivo);

    });

</script>

</body>
</html>