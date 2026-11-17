package controlador;

import dao.PagoDAO;
import dao.CuotaDAO;
import dao.ClienteDAO;

import modelo.Pago;
import modelo.Cuota;
import modelo.Cliente;
import modelo.Usuario;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(
    name = "PagoServlet",
    urlPatterns = {"/PagoServlet"}
)
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class PagoServlet extends HttpServlet {

    PagoDAO dao = new PagoDAO();
    CuotaDAO cuotaDAO = new CuotaDAO();
    ClienteDAO clienteDAO = new ClienteDAO();


    // ==========================================
    // LISTAR PAGOS
    // ==========================================

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Actualizar automáticamente cuotas vencidas
        cuotaDAO.actualizarEstadosVencidos();

        List<Pago> lista =
                dao.listar();

        request.setAttribute(
                "pagos",
                lista
        );

        request.getRequestDispatcher(
                "pagos.jsp"
        ).forward(
                request,
                response
        );
    }


    // ==========================================
    // GET
    // ==========================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String accion =
                request.getParameter("accion");


        // ==========================================
        // BUSCAR / FILTRAR PAGOS
        // ==========================================

        if ("buscar".equals(accion)) {

            cuotaDAO.actualizarEstadosVencidos();

            String texto =
                    request.getParameter("texto");

            String fechaDesde =
                    request.getParameter("fechaDesde");

            String fechaHasta =
                    request.getParameter("fechaHasta");

            String metodoPago =
                    request.getParameter("metodoPago");


            List<Pago> lista =
                    dao.buscar(
                            texto,
                            fechaDesde,
                            fechaHasta,
                            metodoPago
                    );


            request.setAttribute(
                    "pagos",
                    lista
            );


            request.setAttribute(
                    "texto",
                    texto
            );

            request.setAttribute(
                    "fechaDesde",
                    fechaDesde
            );

            request.setAttribute(
                    "fechaHasta",
                    fechaHasta
            );

            request.setAttribute(
                    "metodoPago",
                    metodoPago
            );


            request.getRequestDispatcher(
                    "pagos.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // NUEVO PAGO
        // ==========================================

        if ("nuevo".equals(accion)) {

            // Actualizar cuotas vencidas
            cuotaDAO.actualizarEstadosVencidos();


            // --------------------------------------
            // CARGAR CLIENTES
            // --------------------------------------

            List<Cliente> clientes =
                    clienteDAO.listar();


            // --------------------------------------
            // CARGAR CUOTAS
            // --------------------------------------

            List<Cuota> cuotas =
                    cuotaDAO.listar();


            request.setAttribute(
                    "clientes",
                    clientes
            );

            request.setAttribute(
                    "cuotas",
                    cuotas
            );


            request.getRequestDispatcher(
                    "nuevoPago.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // EDITAR PAGO
        // ==========================================

        if ("editar".equals(accion)) {

            System.out.println(
                    "ENTRO A EDITAR PAGO"
            );


            int idPago =
                    Integer.parseInt(
                            request.getParameter("id")
                    );


            Pago pago =
                    dao.buscarPorId(idPago);


            List<Cliente> clientes =
                    clienteDAO.listar();


            request.setAttribute(
                    "pago",
                    pago
            );

            request.setAttribute(
                    "clientes",
                    clientes
            );


            request.getRequestDispatcher(
                    "editarPago.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // LISTAR NORMAL
        // ==========================================

        processRequest(
                request,
                response
        );
    }


    // ==========================================
    // POST
    // ==========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );


        String accion =
                request.getParameter("accion");


        // ==========================================
        // ELIMINAR PAGO
        // ==========================================

        if ("eliminar".equals(accion)) {

            // --------------------------------------
            // VERIFICAR SESIÓN
            // --------------------------------------

            HttpSession sesion =
                    request.getSession(false);

            Usuario usuarioSesion =
                    null;

            if (sesion != null) {

                usuarioSesion =
                        (Usuario) sesion.getAttribute(
                                "usuario"
                        );
            }


            // --------------------------------------
            // SOLO ADMIN
            // --------------------------------------

            if (usuarioSesion == null ||
                    !"ADMIN".equals(
                            usuarioSesion.getRol()
                    )) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "No tienes permisos para eliminar pagos."
                );

                return;
            }


            // --------------------------------------
            // OBTENER ID
            // --------------------------------------

            String idStr =
                    request.getParameter("idPago");


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


            // --------------------------------------
            // BUSCAR PAGO
            // --------------------------------------

            Pago pago =
                    dao.buscarPorId(idPago);


            if (pago == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Pago no encontrado."
                );

                return;
            }


            // --------------------------------------
            // ELIMINAR DE MYSQL
            // --------------------------------------

            boolean eliminado =
                    dao.eliminar(idPago);


            if (eliminado) {

                // ----------------------------------
                // ELIMINAR COMPROBANTE
                // ----------------------------------

                if (pago.getComprobante() != null &&
                        !pago.getComprobante().isEmpty()) {

                    String ruta =
                            "C:\\Users\\FRANCIS\\Documents\\SistemaISP_Comprobantes";


                    File archivo =
                            new File(
                                    ruta,
                                    pago.getComprobante()
                            );


                    if (archivo.exists()) {

                        archivo.delete();
                    }
                }


                response.sendRedirect(
                        "PagoServlet"
                );

            } else {

                response.getWriter().println(
                        "ERROR AL ELIMINAR EL PAGO"
                );
            }

            return;
        }


        // ==========================================
        // EDITAR PAGO
        // ==========================================

        String idPagoStr =
                request.getParameter("idPago");


        if (idPagoStr != null &&
                !idPagoStr.isEmpty()) {

            int idPago;

            try {

                idPago =
                        Integer.parseInt(idPagoStr);

            } catch (NumberFormatException e) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "ID de pago no válido."
                );

                return;
            }


            int idCliente =
                    Integer.parseInt(
                            request.getParameter(
                                    "idCliente"
                            )
                    );


            String fechaPago =
                    request.getParameter(
                            "fechaPago"
                    );


            String periodo =
                    request.getParameter(
                            "periodo"
                    );


            double monto =
                    Double.parseDouble(
                            request.getParameter(
                                    "monto"
                            )
                    );


            String metodoPago =
                    request.getParameter(
                            "metodoPago"
                    );


            String numeroOperacion =
                    request.getParameter(
                            "numeroOperacion"
                    );


            String observacion =
                    request.getParameter(
                            "observacion"
                    );


            Pago pago =
                    new Pago();


            pago.setIdPago(
                    idPago
            );

            pago.setIdCliente(
                    idCliente
            );

            pago.setFechaPago(
                    fechaPago
            );

            pago.setPeriodo(
                    periodo
            );

            pago.setMonto(
                    monto
            );

            pago.setMetodoPago(
                    metodoPago
            );

            pago.setNumeroOperacion(
                    numeroOperacion
            );

            pago.setObservacion(
                    observacion
            );


            boolean actualizado =
                    dao.actualizar(
                            pago
                    );


            if (actualizado) {

                response.sendRedirect(
                        "PagoServlet"
                );

            } else {

                response.getWriter().println(
                        "ERROR AL ACTUALIZAR EL PAGO"
                );
            }


            return;
        }


        // ==========================================
        // REGISTRAR PAGO
        // ==========================================

        String idCuotaStr =
                request.getParameter(
                        "idCuota"
                );


        // ------------------------------------------
        // VALIDAR CUOTA
        // ------------------------------------------

        if (idCuotaStr == null ||
                idCuotaStr.isEmpty()) {

            response.getWriter().println(
                    "ERROR: Debes seleccionar una cuota."
            );

            return;
        }


        int idCuota;

        try {

            idCuota =
                    Integer.parseInt(idCuotaStr);

        } catch (NumberFormatException e) {

            response.getWriter().println(
                    "ERROR: La cuota seleccionada no es válida."
            );

            return;
        }


        // ------------------------------------------
        // BUSCAR CUOTA
        // ------------------------------------------

        Cuota cuota =
                cuotaDAO.buscarPorId(idCuota);


        if (cuota == null) {

            response.getWriter().println(
                    "ERROR: La cuota no existe."
            );

            return;
        }


        // ------------------------------------------
        // VALIDAR ESTADO
        // ------------------------------------------

        if ("PAGADA".equalsIgnoreCase(
                cuota.getEstado()
        )) {

            response.getWriter().println(
                    "ERROR: Esta cuota ya está pagada."
            );

            return;
        }


        if ("ANULADA".equalsIgnoreCase(
                cuota.getEstado()
        )) {

            response.getWriter().println(
                    "ERROR: Esta cuota está anulada."
            );

            return;
        }


        // ------------------------------------------
        // DATOS DEL PAGO
        // ------------------------------------------

        int idCliente =
                cuota.getIdCliente();


        String fechaPago =
                request.getParameter(
                        "fechaPago"
                );


        String metodoPago =
                request.getParameter(
                        "metodoPago"
                );


        String numeroOperacion =
                request.getParameter(
                        "numeroOperacion"
                );


        String observacion =
                request.getParameter(
                        "observacion"
                );


        // ==========================================
        // RECIBIR COMPROBANTE
        // ==========================================

        Part comprobante =
                request.getPart(
                        "comprobante"
                );


        String nombreComprobante =
                null;


        if (comprobante != null &&
                comprobante.getSize() > 0) {

            String tipo =
                    comprobante.getContentType();


            // --------------------------------------
            // VALIDAR TIPO
            // --------------------------------------

            if (!"image/jpeg".equals(tipo)
                    && !"image/png".equals(tipo)
                    && !"image/webp".equals(tipo)) {

                response.getWriter().println(
                        "ERROR: El comprobante debe ser JPG, PNG o WEBP."
                );

                return;
            }


            // --------------------------------------
            // EXTENSIÓN
            // --------------------------------------

            String extension =
                    ".jpg";


            if ("image/png".equals(tipo)) {

                extension =
                        ".png";
            }


            if ("image/webp".equals(tipo)) {

                extension =
                        ".webp";
            }


            // --------------------------------------
            // NOMBRE SEGURO
            // --------------------------------------

            nombreComprobante =
                    "pago_"
                    + UUID.randomUUID()
                    + extension;


            // --------------------------------------
            // CARPETA PERMANENTE
            // --------------------------------------

            String ruta =
                    "C:\\Users\\FRANCIS\\Documents\\SistemaISP_Comprobantes";


            File carpeta =
                    new File(ruta);


            if (!carpeta.exists()) {

                carpeta.mkdirs();
            }


            // --------------------------------------
            // GUARDAR IMAGEN
            // --------------------------------------

            File archivo =
                    new File(
                            carpeta,
                            nombreComprobante
                    );


            try (
                InputStream input =
                        comprobante.getInputStream()
            ) {

                Files.copy(
                        input,
                        archivo.toPath(),
                        StandardCopyOption.REPLACE_EXISTING
                );
            }
        }


        // ==========================================
        // CREAR OBJETO PAGO
        // ==========================================

        Pago pago =
                new Pago();


        pago.setIdCliente(
                idCliente
        );

        pago.setIdCuota(
                idCuota
        );

        pago.setFechaPago(
                fechaPago
        );

        // El DAO toma el periodo y monto
        // directamente de la cuota.
        pago.setPeriodo(
                cuota.getPeriodo()
        );

        pago.setMonto(
                cuota.getMonto()
        );

        pago.setMetodoPago(
                metodoPago
        );

        pago.setNumeroOperacion(
                numeroOperacion
        );

        pago.setComprobante(
                nombreComprobante
        );


        // ==========================================
        // USUARIO DE SESIÓN
        // ==========================================

        HttpSession sesion =
                request.getSession(false);


        Usuario usuarioSesion =
                null;


        if (sesion != null) {

            usuarioSesion =
                    (Usuario) sesion.getAttribute(
                            "usuario"
                    );
        }


        if (usuarioSesion != null) {

            pago.setIdUsuario(
                    usuarioSesion.getIdUsuario()
            );

        } else {

            pago.setIdUsuario(
                    1
            );
        }


        pago.setObservacion(
                observacion
        );


        // ==========================================
        // REGISTRAR EN MYSQL
        // ==========================================

        boolean registrado =
                dao.registrar(
                        pago
                );


        if (registrado) {

            response.sendRedirect(
                    "PagoServlet"
            );

        } else {

            // --------------------------------------
            // SI FALLA MYSQL, BORRAR COMPROBANTE
            // --------------------------------------

            if (nombreComprobante != null) {

                String ruta =
                        "C:\\Users\\FRANCIS\\Documents\\SistemaISP_Comprobantes";


                File archivo =
                        new File(
                                ruta,
                                nombreComprobante
                        );


                if (archivo.exists()) {

                    archivo.delete();
                }
            }


            response.getWriter().println(
                    "ERROR AL REGISTRAR EL PAGO"
            );
        }
    }
}