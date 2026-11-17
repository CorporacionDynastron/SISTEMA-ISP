package controlador;

import dao.ClienteDAO;
import dao.CuotaDAO;
import dao.MorosidadDAO;
import dao.PagoDAO;

import modelo.Cliente;
import modelo.Cuota;
import modelo.Morosidad;
import modelo.Pago;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
    name = "EstadoCuentaServlet",
    urlPatterns = {"/EstadoCuentaServlet"}
)
public class EstadoCuentaServlet extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO();

    private CuotaDAO cuotaDAO = new CuotaDAO();

    private MorosidadDAO morosidadDAO = new MorosidadDAO();

    private PagoDAO pagoDAO = new PagoDAO();


    // =========================================================
    // PROCESAR SOLICITUD
    // =========================================================

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        String idParametro =
                request.getParameter("idCliente");


        // Validar parámetro del cliente

        if (
                idParametro == null ||
                idParametro.trim().isEmpty()
        ) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/MorosidadServlet"
            );

            return;
        }


        try {

            int idCliente =
                    Integer.parseInt(idParametro);


            // =================================================
            // ACTUALIZAR ESTADOS DE CUOTAS VENCIDAS
            // =================================================

            cuotaDAO.actualizarEstadosVencidos();


            // =================================================
            // BUSCAR CLIENTE
            // =================================================

            Cliente cliente =
                    clienteDAO.buscarPorId(idCliente);


            if (cliente == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/MorosidadServlet"
                );

                return;
            }


            // =================================================
            // CUOTAS PENDIENTES Y VENCIDAS
            // =================================================

            List<Morosidad> cuotas =
                    morosidadDAO.listarPorCliente(idCliente);


            // =================================================
            // HISTORIAL COMPLETO DE CUOTAS
            // Incluye PAGADA, PENDIENTE, VENCIDA y ANULADA
            // =================================================

            List<Cuota> cuotasTodas =
                    cuotaDAO.listarPorCliente(idCliente);


            // =================================================
            // HISTORIAL DE PAGOS
            // =================================================

            List<Pago> pagos =
                    pagoDAO.listarPorCliente(idCliente);


            // =================================================
            // TOTAL DE DEUDA
            // =================================================

            double totalDeuda =
                    morosidadDAO.obtenerTotalDeuda(idCliente);


            // =================================================
            // ENVIAR INFORMACIÓN AL JSP
            // =================================================

            request.setAttribute(
                    "cliente",
                    cliente
            );


            request.setAttribute(
                    "cuotas",
                    cuotas
            );


            request.setAttribute(
                    "cuotasTodas",
                    cuotasTodas
            );


            request.setAttribute(
                    "pagos",
                    pagos
            );


            request.setAttribute(
                    "totalDeuda",
                    totalDeuda
            );


            // =================================================
            // ABRIR ESTADO DE CUENTA
            // =================================================

            request.getRequestDispatcher(
                    "estadoCuenta.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (NumberFormatException e) {


            response.sendRedirect(
                    request.getContextPath()
                    + "/MorosidadServlet"
            );


        } catch (Exception e) {


            System.out.println(
                    "ERROR EN ESTADO DE CUENTA: "
                    + e.getMessage()
            );


            e.printStackTrace();


            response.sendRedirect(
                    request.getContextPath()
                    + "/MorosidadServlet"
            );

        }

    }


    // =========================================================
    // MÉTODO GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        processRequest(
                request,
                response
        );

    }

}