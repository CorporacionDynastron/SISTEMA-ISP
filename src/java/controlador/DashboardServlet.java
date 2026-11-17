package controlador;

import dao.DashboardDAO;
import modelo.Usuario;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet(
    name = "DashboardServlet",
    urlPatterns = {"/DashboardServlet"}
)
public class DashboardServlet extends HttpServlet {

    DashboardDAO dao = new DashboardDAO();

   protected void processRequest(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession sesion = request.getSession(false);

    Usuario usuarioSesion = null;

    if (sesion != null) {
        usuarioSesion =
                (Usuario) sesion.getAttribute("usuario");
    }

    request.setAttribute(
            "usuarioSesion",
            usuarioSesion
    );


        int totalClientes =
                dao.totalClientes();

        int clientesActivos =
                dao.clientesActivos();

        int clientesSuspendidos =
                dao.clientesSuspendidos();

        int totalMorosos =
                dao.totalMorosos();

        double ingresosMes =
                dao.ingresosMes();


        // ==========================================
        // NUEVAS ESTADÍSTICAS DEL DASHBOARD
        // ==========================================

        List<Double> ingresosUltimos6Meses =
                dao.ingresosUltimos6Meses();

        List<String> clientesPorPlan =
                dao.clientesPorPlan();

        List<String> ultimosPagos =
                dao.ultimosPagos();


        // ==========================================
        // ENVIAR DATOS AL JSP
        // ==========================================

        request.setAttribute(
                "totalClientes",
                totalClientes
        );

        request.setAttribute(
                "clientesActivos",
                clientesActivos
        );

        request.setAttribute(
                "clientesSuspendidos",
                clientesSuspendidos
        );

        request.setAttribute(
                "totalMorosos",
                totalMorosos
        );

        request.setAttribute(
                "ingresosMes",
                ingresosMes
        );


        // NUEVOS DATOS

        request.setAttribute(
                "ingresosUltimos6Meses",
                ingresosUltimos6Meses
        );

        request.setAttribute(
                "clientesPorPlan",
                clientesPorPlan
        );

        request.setAttribute(
                "ultimosPagos",
                ultimosPagos
        );


        // ==========================================
        // MOSTRAR DASHBOARD
        // ==========================================

        request.getRequestDispatcher(
                "dashboard.jsp"
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