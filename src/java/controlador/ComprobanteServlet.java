package controlador;

import dao.PagoDAO;
import modelo.Pago;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(
    name = "ComprobanteServlet",
    urlPatterns = {"/ComprobanteServlet"}
)
public class ComprobanteServlet extends HttpServlet {

    PagoDAO dao = new PagoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // VERIFICAR SESIÓN
        // ==========================================

        HttpSession sesion =
                request.getSession(false);

        if (sesion == null ||
                sesion.getAttribute("usuario") == null) {

            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Debes iniciar sesión."
            );

            return;
        }


        // ==========================================
        // OBTENER ID DEL PAGO
        // ==========================================

        String idStr =
                request.getParameter("id");

        if (idStr == null ||
                idStr.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID de pago no válido."
            );

            return;
        }


        int idPago;

        try {

            idPago =
                    Integer.parseInt(idStr);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "ID de pago no válido."
            );

            return;
        }


        // ==========================================
        // BUSCAR PAGO EN BASE DE DATOS
        // ==========================================

        Pago pago =
                dao.buscarPorId(idPago);

        if (pago == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Pago no encontrado."
            );

            return;
        }


        // ==========================================
        // VERIFICAR COMPROBANTE
        // ==========================================

        if (pago.getComprobante() == null ||
                pago.getComprobante().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Este pago no tiene comprobante."
            );

            return;
        }


        // ==========================================
        // CARPETA PERMANENTE
        // ==========================================

        String ruta =
                "C:\\Users\\FRANCIS\\Documents\\SistemaISP_Comprobantes";


        // ==========================================
        // BUSCAR ARCHIVO
        // ==========================================

        File archivo =
                new File(
                        ruta,
                        pago.getComprobante()
                );


        if (!archivo.exists() ||
                !archivo.isFile()) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "El archivo no existe."
            );

            return;
        }


        // ==========================================
        // DETERMINAR TIPO DE IMAGEN
        // ==========================================

        String nombre =
                archivo.getName()
                        .toLowerCase();


        if (nombre.endsWith(".png")) {

            response.setContentType(
                    "image/png"
            );

        } else if (nombre.endsWith(".webp")) {

            response.setContentType(
                    "image/webp"
            );

        } else if (nombre.endsWith(".jpg")
                || nombre.endsWith(".jpeg")) {

            response.setContentType(
                    "image/jpeg"
            );

        } else {

            response.sendError(
                    HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                    "Tipo de archivo no permitido."
            );

            return;
        }


        // ==========================================
        // ENVIAR IMAGEN AL NAVEGADOR
        // ==========================================

        response.setContentLengthLong(
                archivo.length()
        );


        try (
            InputStream input =
                    new java.io.FileInputStream(
                            archivo
                    );

            OutputStream output =
                    response.getOutputStream()
        ) {

            byte[] buffer =
                    new byte[8192];

            int bytesLeidos;

            while (
                (bytesLeidos =
                    input.read(buffer)) != -1
            ) {

                output.write(
                        buffer,
                        0,
                        bytesLeidos
                );
            }
        }
    }
}