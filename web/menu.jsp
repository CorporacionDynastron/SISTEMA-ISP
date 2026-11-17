
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<aside class="sidebar">

    <div class="logo">
        🌐 Grupo <span>Stellar</span>
    </div>

    <nav class="menu">

        <div class="menu-titulo">
            Principal
        </div>

        <a href="${pageContext.request.contextPath}/DashboardServlet">
            📊 Dashboard
        </a>


        <div class="menu-titulo">
            Gestión
        </div>

        <a href="${pageContext.request.contextPath}/ClienteServlet">
            👥 Clientes
        </a>

        <a href="${pageContext.request.contextPath}/PagoServlet">
            💰 Pagos
        </a>

        <a href="${pageContext.request.contextPath}/MorosidadServlet">
            🔴 Morosidad
        </a>

        <a href="${pageContext.request.contextPath}/CobranzasServlet">
            💰 Cobranzas
        </a>

        <a href="${pageContext.request.contextPath}/AvisosWhatsAppServlet">
            📱 Avisos WhatsApp
        </a>

        <a href="${pageContext.request.contextPath}/ReporteServlet">
            📈 Reportes
        </a>


        <div class="menu-titulo">
            Cuenta
        </div>

        <a
            href="${pageContext.request.contextPath}/LogoutServlet"
            class="logout"
        >
            🚪 Cerrar sesión
        </a>

    </nav>

</aside>