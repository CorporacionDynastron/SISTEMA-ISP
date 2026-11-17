package controlador;

import dao.CuotaDAO;
import dao.EstadoClienteDAO;
import modelo.EstadoCliente;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
    name = "CobranzasServlet",
    urlPatterns = {"/CobranzasServlet"}
)
public class CobranzasServlet extends HttpServlet {


    private final EstadoClienteDAO estadoClienteDAO =
            new EstadoClienteDAO();


    private final CuotaDAO cuotaDAO =
            new CuotaDAO();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // ==========================================
        // ACTUALIZAR VENCIMIENTOS
        // ==========================================

        cuotaDAO.actualizarEstadosVencidos();


        // ==========================================
        // RECIBIR BUSQUEDA
        // ==========================================

        String buscar =
                request.getParameter("buscar");


        String estado =
                request.getParameter("estado");


        if (buscar != null) {

            buscar =
                buscar.trim();

            if (buscar.isEmpty()) {

                buscar = null;
            }
        }


        if (estado != null) {

            estado =
                estado.trim();

            if (
                estado.isEmpty()
                ||
                estado.equalsIgnoreCase("TODOS")
            ) {

                estado = null;
            }
        }


        // ==========================================
        // OBTENER CLIENTES
        // ==========================================

        List<EstadoCliente> lista =
                estadoClienteDAO.buscarPorTextoYEstado(
                    buscar,
                    estado
                );


        // ==========================================
        // ESTADISTICAS
        // ==========================================

        int totalAlDia =
                estadoClienteDAO.contarPorEstado(
                    "AL DIA"
                );


        int totalProximos =
                estadoClienteDAO.contarPorEstado(
                    "PROXIMO A VENCER"
                );


        int totalVencidos =
                estadoClienteDAO.contarPorEstado(
                    "VENCIDO"
                );


        int totalMorosos =
                estadoClienteDAO.contarPorEstado(
                    "MOROSO"
                );


        double deudaTotal =
                estadoClienteDAO.obtenerDeudaTotal();


        // ==========================================
        // ENVIAR AL JSP
        // ==========================================

        request.setAttribute(
            "clientesEstado",
            lista
        );


        request.setAttribute(
            "totalAlDia",
            totalAlDia
        );


        request.setAttribute(
            "totalProximos",
            totalProximos
        );


        request.setAttribute(
            "totalVencidos",
            totalVencidos
        );


        request.setAttribute(
            "totalMorosos",
            totalMorosos
        );


        request.setAttribute(
            "deudaTotal",
            deudaTotal
        );


        request.setAttribute(
            "buscarActual",
            buscar == null
                ? ""
                : buscar
        );


        request.setAttribute(
            "estadoActual",
            estado == null
                ? ""
                : estado
        );


        // ==========================================
        // ENVIAR A JSP
        // ==========================================

        request.getRequestDispatcher(
            "cobranzas.jsp"
        ).forward(
            request,
            response
        );
    }
}