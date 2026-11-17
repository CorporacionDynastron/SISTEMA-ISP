
package controlador;

import dao.ReporteDAO;
import dao.PagoDAO;

import modelo.Pago;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
        name = "ReporteServlet",
        urlPatterns = {"/ReporteServlet"}
)
public class ReporteServlet extends HttpServlet {

    private final ReporteDAO dao = new ReporteDAO();

    private final PagoDAO pagoDAO = new PagoDAO();


    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ==========================================
            // RECIBIR FILTROS DE FECHA
            // ==========================================

            String fechaInicio =
                    request.getParameter("fechaInicio");

            String fechaFin =
                    request.getParameter("fechaFin");


            boolean usarFiltro =

                    fechaInicio != null
                    && !fechaInicio.trim().isEmpty()
                    && fechaFin != null
                    && !fechaFin.trim().isEmpty();


            // ==========================================
            // VALIDAR RANGO DE FECHAS
            // ==========================================

            if (usarFiltro && fechaInicio.compareTo(fechaFin) > 0) {

                request.setAttribute(
                        "errorReporte",
                        "La fecha inicial no puede ser mayor que la fecha final."
                );

                usarFiltro = false;
            }


            // ==========================================
            // VARIABLES DEL REPORTE
            // ==========================================

            double totalRecaudado;

            int cantidadPagos;

            double totalYape;

            double totalPlin;

            double totalEfectivo;

            double totalTransferencia;

            List<Pago> pagosMes;


            // ==========================================
            // REPORTE CON FILTRO DE FECHAS
            // ==========================================

            if (usarFiltro) {

                totalRecaudado =
                        dao.totalRecaudadoPorFechas(
                                fechaInicio,
                                fechaFin
                        );

                cantidadPagos =
                        dao.cantidadPagosPorFechas(
                                fechaInicio,
                                fechaFin
                        );

                totalYape =
                        dao.totalYapePorFechas(
                                fechaInicio,
                                fechaFin
                        );

                totalPlin =
                        dao.totalPlinPorFechas(
                                fechaInicio,
                                fechaFin
                        );

                totalEfectivo =
                        dao.totalEfectivoPorFechas(
                                fechaInicio,
                                fechaFin
                        );

                totalTransferencia =
                        dao.totalTransferenciaPorFechas(
                                fechaInicio,
                                fechaFin
                        );

                pagosMes =
                        pagoDAO.listarPagosPorFechas(
                                fechaInicio,
                                fechaFin
                        );

            } else {

                // ==========================================
                // REPORTE DEL MES ACTUAL
                // ==========================================

                totalRecaudado =
                        dao.totalRecaudadoMes();

                cantidadPagos =
                        dao.cantidadPagosMes();

                totalYape =
                        dao.totalYape();

                totalPlin =
                        dao.totalPlin();

                totalEfectivo =
                        dao.totalEfectivo();

                totalTransferencia =
                        dao.totalTransferencia();

                pagosMes =
                        pagoDAO.listarPagosMesActual();
            }


            // ==========================================
            // ENVIAR DATOS A LA VISTA
            // ==========================================

            request.setAttribute(
                    "totalRecaudado",
                    totalRecaudado
            );

            request.setAttribute(
                    "cantidadPagos",
                    cantidadPagos
            );

            request.setAttribute(
                    "totalYape",
                    totalYape
            );

            request.setAttribute(
                    "totalPlin",
                    totalPlin
            );

            request.setAttribute(
                    "totalEfectivo",
                    totalEfectivo
            );

            request.setAttribute(
                    "totalTransferencia",
                    totalTransferencia
            );

            request.setAttribute(
                    "pagosMes",
                    pagosMes
            );


            // ==========================================
            // CONSERVAR FECHAS EN EL JSP
            // ==========================================

            request.setAttribute(
                    "fechaInicio",
                    fechaInicio
            );

            request.setAttribute(
                    "fechaFin",
                    fechaFin
            );


            request.setAttribute(
                    "usarFiltro",
                    usarFiltro
            );


            // ==========================================
            // MOSTRAR REPORTES
            // ==========================================

            request.getRequestDispatcher(
                    "reportes.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            System.out.println(
                    "ERROR EN REPORTES: "
                    + e.getMessage()
            );

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/DashboardServlet"
            );
        }
    }


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