
package controlador;

import dao.AuditoriaDAO;
import modelo.Auditoria;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(
        name = "AuditoriaServlet",
        urlPatterns = {"/AuditoriaServlet"}
)
public class AuditoriaServlet extends HttpServlet {

    private final AuditoriaDAO auditoriaDAO =
            new AuditoriaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String buscar = request.getParameter("buscar");
        String modulo = request.getParameter("modulo");
        String accion = request.getParameter("accion");

        if (buscar == null) {
            buscar = "";
        }

        if (modulo == null) {
            modulo = "";
        }

        if (accion == null) {
            accion = "";
        }

        buscar = buscar.trim();
        modulo = modulo.trim();
        accion = accion.trim();

        List<Auditoria> auditorias;

        if (
                buscar.isEmpty()
                && modulo.isEmpty()
                && accion.isEmpty()
        ) {

            auditorias = auditoriaDAO.listar();

        } else {

            auditorias = auditoriaDAO.buscar(
                    buscar,
                    modulo,
                    accion
            );
        }

        request.setAttribute(
                "auditorias",
                auditorias
        );

        request.setAttribute(
                "buscarActual",
                buscar
        );

        request.setAttribute(
                "moduloActual",
                modulo
        );

        request.setAttribute(
                "accionActual",
                accion
        );

        request.getRequestDispatcher(
                "auditoria.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        doGet(request, response);
    }
}