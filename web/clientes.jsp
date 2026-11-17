<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Cliente"%>
<%
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    String texto = (String) request.getAttribute("texto");
    String estado = (String) request.getAttribute("estado");
    String idPlan = (String) request.getAttribute("idPlan");

    if (texto == null) texto = "";
    if (estado == null) estado = "";
    if (idPlan == null) idPlan = "";

    int totalClientesVista = (clientes == null) ? 0 : clientes.size();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clientes | Grupo Stellar</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body class="clientes-body">
<div class="sistema">
    <jsp:include page="menu.jsp"/>

    <main class="contenido clientes-contenido">
        <section class="contenido-principal clientes-page">

            <header class="clientes-header">
                <div class="clientes-heading">
                    <div class="clientes-eyebrow"><span class="clientes-live-dot"></span> GESTIÓN DE CLIENTES</div>
                    <h1>Directorio de clientes</h1>
                    <p>Administra abonados, planes contratados y estado del servicio desde un solo lugar.</p>
                </div>
                <a href="${pageContext.request.contextPath}/ClienteServlet?accion=nuevo" class="clientes-btn clientes-btn-primary">
                    <span class="clientes-btn-icon">＋</span> Nuevo cliente
                </a>
            </header>

            <div class="clientes-overview">
                <div class="clientes-overview-card">
                    <div class="clientes-overview-icon">♙</div>
                    <div>
                        <span class="clientes-overview-label">Registros en esta vista</span>
                        <strong><%= totalClientesVista %></strong>
                        <small>Clientes devueltos por la consulta actual</small>
                    </div>
                </div>
                <div class="clientes-overview-note">
                    <span class="clientes-note-icon">⌕</span>
                    <div>
                        <strong>Encuentra un abonado rápidamente</strong>
                        <p>Busca por código, nombre, apellido o DNI, o combina los filtros de estado y plan.</p>
                    </div>
                </div>
            </div>

            <section class="clientes-panel clientes-filters-panel">
                <div class="clientes-panel-heading">
                    <div>
                        <span class="clientes-section-kicker">CONSULTA</span>
                        <h2>Buscar y filtrar</h2>
                    </div>
                    <span class="clientes-panel-mark">01 / CLIENTES</span>
                </div>

                <form action="${pageContext.request.contextPath}/ClienteServlet" method="GET" class="clientes-filter-form">
                    <input type="hidden" name="accion" value="buscar">

                    <div class="clientes-field clientes-field-search">
                        <label for="clientesTexto">Cliente</label>
                        <div class="clientes-input-wrap">
                            <span class="clientes-input-icon">⌕</span>
                            <input id="clientesTexto" type="text" name="texto"
                                   placeholder="Código, nombre, apellido o DNI..."
                                   value="<%= texto %>">
                        </div>
                    </div>

                    <div class="clientes-field">
                        <label for="clientesEstado">Estado del servicio</label>
                        <select id="clientesEstado" name="estado">
                            <option value="" <%= "".equals(estado) ? "selected" : "" %>>Todos los estados</option>
                            <option value="ACTIVO" <%= "ACTIVO".equals(estado) ? "selected" : "" %>>Activo</option>
                            <option value="SUSPENDIDO" <%= "SUSPENDIDO".equals(estado) ? "selected" : "" %>>Suspendido</option>
                            <option value="RETIRADO" <%= "RETIRADO".equals(estado) ? "selected" : "" %>>Retirado</option>
                        </select>
                    </div>

                    <div class="clientes-field">
                        <label for="clientesPlan">Plan contratado</label>
                        <select id="clientesPlan" name="idPlan">
                            <option value="" <%= "".equals(idPlan) ? "selected" : "" %>>Todos los planes</option>
                            <%
                                List<modelo.Plan> planes = (List<modelo.Plan>) request.getAttribute("planes");
                                if (planes != null) {
                                    for (modelo.Plan plan : planes) {
                            %>
                                <option value="<%= plan.getIdPlan() %>"
                                    <%= String.valueOf(plan.getIdPlan()).equals(idPlan) ? "selected" : "" %>>
                                    <%= plan.getNombrePlan() %> — <%= plan.getVelocidad() %>
                                </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="clientes-filter-actions">
                        <button type="submit" class="clientes-btn clientes-btn-primary">⌕ Buscar</button>
                        <a href="${pageContext.request.contextPath}/ClienteServlet" class="clientes-btn clientes-btn-secondary">Limpiar</a>
                    </div>
                </form>
            </section>

            <section class="clientes-panel clientes-directory-panel">
                <div class="clientes-panel-heading clientes-directory-heading">
                    <div>
                        <span class="clientes-section-kicker">BASE DE DATOS</span>
                        <h2>Clientes registrados</h2>
                        <p>Información de contacto, plan y estado actual de cada abonado.</p>
                    </div>
                    <div class="clientes-record-count"><span></span><%= totalClientesVista %> en pantalla</div>
                </div>

                <div class="clientes-table-scroll">
                    <table class="clientes-table">
                        <thead>
                            <tr>
                                <th>Perfil</th>
                                <th>Código</th>
                                <th>Cliente</th>
                                <th>DNI</th>
                                <th>Teléfono</th>
                                <th>Plan</th>
                                <th>Precio</th>
                                <th>Vencimiento</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (clientes != null && !clientes.isEmpty()) {
                                for (Cliente cliente : clientes) {
                        %>
                            <tr>
                                <td>
                                    <div class="clientes-avatar">
                                    <%
                                        String fotoCliente = cliente.getFotoPerfil();
                                        if (fotoCliente != null && !fotoCliente.trim().isEmpty()) {
                                    %>
                                        <img src="${pageContext.request.contextPath}/<%= fotoCliente %>"
                                             alt="Foto de <%= cliente.getNombres() %>"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        <span class="clientes-avatar-fallback" style="display:none;">♙</span>
                                    <%
                                        } else {
                                    %>
                                        <span class="clientes-avatar-fallback">♙</span>
                                    <%
                                        }
                                    %>
                                    </div>
                                </td>
                                <td><span class="clientes-code"><%= cliente.getCodigoCliente() %></span></td>
                                <td>
                                    <div class="clientes-person">
                                        <strong><%= cliente.getNombres() %> <%= cliente.getApellidos() %></strong>
                                        <small>Abonado de Grupo Stellar</small>
                                    </div>
                                </td>
                                <td class="clientes-muted-cell"><%= cliente.getDni() %></td>
                                <td class="clientes-muted-cell"><%= cliente.getTelefono() %></td>
                                <td><span class="clientes-plan-chip"><span>◈</span><%= cliente.getNombrePlan() %></span></td>
                                <td><span class="clientes-price">S/ <%= String.format("%.2f", cliente.getPrecioPlan()) %></span></td>
                                <td><span class="clientes-due-chip">Día <%= cliente.getDiaVencimiento() %></span></td>
                                <td>
                                    <%
                                        String estadoCliente = cliente.getEstado();
                                        if ("ACTIVO".equals(estadoCliente)) {
                                    %>
                                        <span class="clientes-status clientes-status-active"><i></i> Activo</span>
                                    <%
                                        } else if ("SUSPENDIDO".equals(estadoCliente)) {
                                    %>
                                        <span class="clientes-status clientes-status-suspended"><i></i> Suspendido</span>
                                    <%
                                        } else {
                                    %>
                                        <span class="clientes-status clientes-status-retired"><i></i> Retirado</span>
                                    <%
                                        }
                                    %>
                                </td>
                                <td>
                                    <div class="clientes-row-actions">
                                        <a href="${pageContext.request.contextPath}/ClienteServlet?accion=editar&id=<%= cliente.getIdCliente() %>"
                                           class="clientes-action-btn clientes-action-edit" title="Editar cliente">Editar</a>
                                        <a href="${pageContext.request.contextPath}/ClienteServlet?accion=ver&id=<%= cliente.getIdCliente() %>"
                                           class="clientes-action-btn clientes-action-view" title="Ver ficha del cliente">Ver</a>
                                        <a href="${pageContext.request.contextPath}/ClienteServlet?accion=eliminar&id=<%= cliente.getIdCliente() %>"
                                           class="clientes-action-btn clientes-action-delete"
                                           onclick="return confirmarEliminacion('<%= cliente.getNombres() %> <%= cliente.getApellidos() %>');"
                                           title="Eliminar cliente">Eliminar</a>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="10">
                                    <div class="clientes-empty-state">
                                        <div class="clientes-empty-icon">⌕</div>
                                        <h3>No se encontraron clientes</h3>
                                        <p>Prueba con otro nombre, código, DNI, estado o plan.</p>
                                        <a href="${pageContext.request.contextPath}/ClienteServlet" class="clientes-btn clientes-btn-secondary">Ver todos los clientes</a>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <div class="clientes-table-footer">
                    <span><span class="clientes-live-dot"></span> Datos consultados desde SistemaISP</span>
                    <span>Grupo Stellar · Gestión de abonados</span>
                </div>
            </section>

        </section>
    </main>
</div>

<script>
    function confirmarEliminacion(nombre) {
        return confirm(
            "¿ESTÁS SEGURO DE ELIMINAR ESTE CLIENTE?\n\n" +
            "Cliente: " + nombre + "\n\n" +
            "Se eliminarán también sus pagos y cuotas.\n\n" +
            "Esta acción no se puede deshacer."
        );
    }
</script>
</body>
</html>
