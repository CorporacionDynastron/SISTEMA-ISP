<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Pago"%>
<%@page import="modelo.Cliente"%>

<%
    Pago pago = (Pago) request.getAttribute("pago");
    List<Cliente> clientes =
            (List<Cliente>) request.getAttribute("clientes");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Pago - Sistema ISP</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 30px;
        }

        .contenedor {
            max-width: 600px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
        }

        h1 {
            color: #222;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input,
        select,
        textarea {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        textarea {
            resize: vertical;
        }

        .boton {
            margin-top: 20px;
            padding: 12px 20px;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .cancelar {
            display: inline-block;
            margin-top: 20px;
            margin-left: 10px;
            padding: 12px 20px;
            background-color: #6b7280;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

    </style>
</head>

<body>

<div class="contenedor">

    <h1>✏️ Editar Pago</h1>

    <form action="PagoServlet" method="POST">

        <input
            type="hidden"
            name="idPago"
            value="<%= pago.getIdPago() %>"
        >

        <label>Cliente</label>

        <select name="idCliente" required>

            <%
                if (clientes != null) {

                    for (Cliente cliente : clientes) {
            %>

            <option
                value="<%= cliente.getIdCliente() %>"
                <%= cliente.getIdCliente() == pago.getIdCliente()
                    ? "selected"
                    : "" %>
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


        <label>Fecha de Pago</label>

        <input
            type="date"
            name="fechaPago"
            value="<%= pago.getFechaPago() %>"
            required
        >


        <label>Periodo</label>

        <input
            type="text"
            name="periodo"
            value="<%= pago.getPeriodo() %>"
            required
        >


        <label>Monto</label>

        <input
            type="number"
            name="monto"
            step="0.01"
            min="0"
            value="<%= pago.getMonto() %>"
            required
        >


        <label>Método de Pago</label>

        <select name="metodoPago" required>

            <option value="Yape"
                <%= "Yape".equals(pago.getMetodoPago())
                    ? "selected" : "" %>>
                Yape
            </option>

            <option value="Plin"
                <%= "Plin".equals(pago.getMetodoPago())
                    ? "selected" : "" %>>
                Plin
            </option>

            <option value="Efectivo"
                <%= "Efectivo".equals(pago.getMetodoPago())
                    ? "selected" : "" %>>
                Efectivo
            </option>

            <option value="Transferencia"
                <%= "Transferencia".equals(pago.getMetodoPago())
                    ? "selected" : "" %>>
                Transferencia
            </option>

            <option value="Otro"
                <%= "Otro".equals(pago.getMetodoPago())
                    ? "selected" : "" %>>
                Otro
            </option>

        </select>


        <label>N.º de Operación</label>

        <input
            type="text"
            name="numeroOperacion"
            value="<%= pago.getNumeroOperacion() %>"
        >


        <label>Observación</label>

        <textarea
            name="observacion"
            rows="4"
        ><%= pago.getObservacion() %></textarea>


        <button type="submit" class="boton">
            💾 Guardar Cambios
        </button>

        <a href="PagoServlet" class="cancelar">
            Cancelar
        </a>

    </form>

</div>

</body>
</html>