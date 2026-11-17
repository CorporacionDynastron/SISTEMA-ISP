package controlador;

import dao.CuotaDAO;
import dao.MorosidadDAO;
import modelo.Morosidad;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
    name = "MorosidadServlet",
    urlPatterns = {"/MorosidadServlet"}
)
public class MorosidadServlet extends HttpServlet {

    private MorosidadDAO dao = new MorosidadDAO();
    private CuotaDAO cuotaDAO = new CuotaDAO();

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Actualizar cuotas vencidas
        cuotaDAO.actualizarEstadosVencidos();

        // Texto de búsqueda
        String buscar = request.getParameter("buscar");

        List<Morosidad> lista;

        if (buscar != null && !buscar.trim().isEmpty()) {
            lista = dao.buscar(buscar.trim());
        } else {
            lista = dao.listar();
        }

        // Datos para las tarjetas
        request.setAttribute(
                "morosos",
                lista
        );

        request.setAttribute(
                "totalMorosos",
                dao.contarClientesMorosos()
        );

        request.setAttribute(
                "totalPendiente",
                dao.obtenerTotalPendiente()
        );

        request.getRequestDispatcher(
                "morosidad.jsp"
        ).forward(
                request,
                response
        );
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