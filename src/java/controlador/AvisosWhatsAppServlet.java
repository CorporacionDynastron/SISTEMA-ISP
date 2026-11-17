
package controlador;

import dao.AvisoWhatsAppDAO;
import dao.CuotaDAO;
import modelo.AvisoWhatsApp;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(
    name = "AvisosWhatsAppServlet",
    urlPatterns = {"/AvisosWhatsAppServlet"}
)
public class AvisosWhatsAppServlet extends HttpServlet {

    private final AvisoWhatsAppDAO avisoDAO =
            new AvisoWhatsAppDAO();

    private final CuotaDAO cuotaDAO =
            new CuotaDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // ==========================================
            // ACTUALIZAR ESTADOS DE LAS CUOTAS
            // ==========================================

            cuotaDAO.actualizarEstadosVencidos();

            // ==========================================
            // OBTENER AVISOS DE WHATSAPP
            // ==========================================

            List<AvisoWhatsApp> avisos =
                    avisoDAO.listarAvisos();

            // ==========================================
            // ENVIAR AVISOS AL JSP
            // ==========================================

            request.setAttribute(
                    "avisos",
                    avisos
            );

            // ==========================================
            // ABRIR VISTA
            // ==========================================

            request.getRequestDispatcher(
                    "avisos-whatsapp.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            System.out.println(
                    "ERROR EN AVISOS WHATSAPP: "
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
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}