package controlador;

import dao.ClienteDAO;
import dao.PlanDAO;
import dao.PagoDAO;

import modelo.Cliente;
import modelo.Plan;
import modelo.Pago;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(
        name = "ClienteServlet",
        urlPatterns = {"/ClienteServlet"}
)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class ClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    private final PlanDAO planDAO = new PlanDAO();

    private final PagoDAO pagoDAO = new PagoDAO();


    // ==========================================
    // CARGAR PLANES
    // ==========================================

    private void cargarPlanes(
            HttpServletRequest request) {

        List<Plan> planes = planDAO.listar();

        request.setAttribute(
                "planes",
                planes
        );
    }


    // ==========================================
    // LISTAR CLIENTES
    // ==========================================

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Cliente> lista = dao.listar();

        request.setAttribute(
                "clientes",
                lista
        );

        cargarPlanes(request);

        request.getRequestDispatcher(
                "clientes.jsp"
        ).forward(
                request,
                response
        );
    }


    // ==========================================
    // GUARDAR FOTO DE PERFIL
    // ==========================================

    private String guardarFoto(
            HttpServletRequest request,
            Part archivo)
            throws IOException {

        if (archivo == null ||
                archivo.getSize() == 0) {

            return null;
        }

        String nombreOriginal =
                Paths.get(
                        archivo.getSubmittedFileName()
                ).getFileName().toString();

        String extension = "";

        int punto =
                nombreOriginal.lastIndexOf(".");

        if (punto >= 0) {

            extension =
                    nombreOriginal
                            .substring(punto)
                            .toLowerCase();
        }

        if (!extension.equals(".jpg") &&
                !extension.equals(".jpeg") &&
                !extension.equals(".png") &&
                !extension.equals(".webp")) {

            throw new IOException(
                    "Formato de imagen no permitido. "
                    + "Usa JPG, JPEG, PNG o WEBP."
            );
        }

        String nombreArchivo =
                "cliente_"
                + UUID.randomUUID()
                + extension;

        String rutaReal =
                getServletContext().getRealPath(
                        "/uploads/clientes"
                );

        if (rutaReal == null) {

            throw new IOException(
                    "No se pudo encontrar la carpeta "
                    + "de almacenamiento de imágenes."
            );
        }

        File carpeta =
                new File(rutaReal);

        if (!carpeta.exists()) {

            carpeta.mkdirs();
        }

        Path rutaArchivo =
                Paths.get(
                        carpeta.getAbsolutePath(),
                        nombreArchivo
                );

        try (InputStream entrada =
                archivo.getInputStream()) {

            Files.copy(
                    entrada,
                    rutaArchivo,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }

        return "uploads/clientes/"
                + nombreArchivo;
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
        // BUSCAR Y FILTRAR
        // ==========================================

        if ("buscar".equals(accion)) {

            String texto =
                    request.getParameter("texto");

            String estado =
                    request.getParameter("estado");

            String idPlan =
                    request.getParameter("idPlan");

            List<Cliente> lista =
                    dao.buscar(
                            texto,
                            estado,
                            idPlan
                    );

            request.setAttribute(
                    "clientes",
                    lista
            );

            request.setAttribute(
                    "texto",
                    texto
            );

            request.setAttribute(
                    "estado",
                    estado
            );

            request.setAttribute(
                    "idPlan",
                    idPlan
            );

            cargarPlanes(request);

            request.getRequestDispatcher(
                    "clientes.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // VER CLIENTE
        // ==========================================

        if ("ver".equals(accion)) {

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            Cliente cliente =
                    dao.buscarPorId(id);

            if (cliente == null) {

                response.getWriter().println(
                        "CLIENTE NO ENCONTRADO"
                );

                return;
            }

            List<Pago> pagos =
                    pagoDAO.listarPorCliente(id);

            request.setAttribute(
                    "cliente",
                    cliente
            );

            request.setAttribute(
                    "pagos",
                    pagos
            );

            request.getRequestDispatcher(
                    "verCliente.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // NUEVO CLIENTE
        // ==========================================

        if ("nuevo".equals(accion)) {

            cargarPlanes(request);

            request.getRequestDispatcher(
                    "nuevoCliente.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // EDITAR CLIENTE
        // ==========================================

        if ("editar".equals(accion)) {

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            Cliente cliente =
                    dao.buscarPorId(id);

            if (cliente == null) {

                response.getWriter().println(
                        "CLIENTE NO ENCONTRADO"
                );

                return;
            }

            request.setAttribute(
                    "cliente",
                    cliente
            );

            cargarPlanes(request);

            request.getRequestDispatcher(
                    "editarCliente.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }


        // ==========================================
        // ELIMINAR CLIENTE
        // ==========================================

        if ("eliminar".equals(accion)) {

            String idStr =
                    request.getParameter("id");

            int idCliente;

            try {

                idCliente =
                        Integer.parseInt(idStr);

            } catch (NumberFormatException e) {

                response.getWriter().println(
                        "ERROR: ID DE CLIENTE NO VÁLIDO."
                );

                return;
            }

            boolean eliminado =
                    dao.eliminar(idCliente);

            if (eliminado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/ClienteServlet"
                );

            } else {

                response.getWriter().println(
                        "ERROR AL ELIMINAR EL CLIENTE"
                );
            }

            return;
        }


        // ==========================================
        // LISTAR CLIENTES
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

        request.setCharacterEncoding("UTF-8");


        // ==========================================
        // ID CLIENTE
        // ==========================================

        String idClienteStr =
                request.getParameter("idCliente");


        // ==========================================
        // DATOS GENERALES
        // ==========================================

        String codigoCliente =
                request.getParameter("codigoCliente");

        String nombres =
                request.getParameter("nombres");

        String apellidos =
                request.getParameter("apellidos");

        String dni =
                request.getParameter("dni");

        String telefono =
                request.getParameter("telefono");

        String telefono2 =
                request.getParameter("telefono2");

        String direccion =
                request.getParameter("direccion");

        String referenciaDomicilio =
                request.getParameter("referenciaDomicilio");

        String observaciones =
                request.getParameter("observaciones");


        // ==========================================
        // DATOS DEL SERVICIO
        // ==========================================

        String idPlanStr =
                request.getParameter("idPlan");

        String fechaInstalacion =
                request.getParameter("fechaInstalacion");

        String diaVencimientoStr =
                request.getParameter("diaVencimiento");

        // NUEVO:
        // Tipo de emisión:
        // QUINCENAL
        // FIN_DE_MES
        String tipoEmision =
                request.getParameter("tipoEmision");

        // Si por alguna razón el formulario todavía
        // no envía el campo, usamos QUINCENAL
        // como valor temporal por compatibilidad.
        if (tipoEmision == null ||
                tipoEmision.trim().isEmpty()) {

            tipoEmision = "QUINCENAL";
        }


        // ==========================================
        // VALIDAR TIPO DE EMISIÓN
        // ==========================================

        if (!"QUINCENAL".equals(tipoEmision) &&
                !"FIN_DE_MES".equals(tipoEmision)) {

            response.getWriter().println(
                    "ERROR: EL TIPO DE EMISIÓN NO ES VÁLIDO."
            );

            return;
        }


        // ==========================================
        // VALIDAR PLAN
        // ==========================================

        if (idPlanStr == null ||
                idPlanStr.isEmpty()) {

            response.getWriter().println(
                    "ERROR: DEBES SELECCIONAR UN PLAN."
            );

            return;
        }


        // ==========================================
        // CONVERTIR PLAN
        // ==========================================

        int idPlan;

        try {

            idPlan =
                    Integer.parseInt(idPlanStr);

        } catch (NumberFormatException e) {

            response.getWriter().println(
                    "ERROR: EL PLAN NO ES VÁLIDO."
            );

            return;
        }


        // ==========================================
        // CONVERTIR DÍA DE VENCIMIENTO
        // ==========================================
        //
        // Se mantiene temporalmente porque todavía
        // existe en la BD y en otras partes del sistema.
        //
        // La nueva lógica de cuotas utilizará
        // tipoEmision.
        // ==========================================

        int diaVencimiento = 0;

        try {

            if (diaVencimientoStr != null &&
                    !diaVencimientoStr.isEmpty()) {

                diaVencimiento =
                        Integer.parseInt(
                                diaVencimientoStr
                        );
            }

        } catch (NumberFormatException e) {

            response.getWriter().println(
                    "ERROR: EL DÍA DE VENCIMIENTO NO ES VÁLIDO."
            );

            return;
        }


        // ==========================================
        // RECIBIR FOTO
        // ==========================================

        Part archivoFoto = null;

        try {

            archivoFoto =
                    request.getPart("foto");

        } catch (Exception e) {

            System.out.println(
                    "ADVERTENCIA: NO SE RECIBIÓ FOTO: "
                    + e.getMessage()
            );
        }


        // ==========================================
        // BUSCAR CLIENTE ANTERIOR
        // ==========================================

        Cliente clienteAnterior = null;

        if (idClienteStr != null &&
                !idClienteStr.isEmpty()) {

            try {

                int idAnterior =
                        Integer.parseInt(idClienteStr);

                clienteAnterior =
                        dao.buscarPorId(idAnterior);

            } catch (NumberFormatException e) {

                response.getWriter().println(
                        "ERROR: ID DE CLIENTE NO VÁLIDO."
                );

                return;
            }
        }


        // ==========================================
        // PROCESAR FOTO
        // ==========================================

        String fotoPerfil = null;

        if (archivoFoto != null &&
                archivoFoto.getSize() > 0) {

            try {

                fotoPerfil =
                        guardarFoto(
                                request,
                                archivoFoto
                        );

            } catch (IOException e) {

                response.getWriter().println(
                        "ERROR AL GUARDAR FOTO: "
                        + e.getMessage()
                );

                return;
            }

        } else if (clienteAnterior != null) {

            // Mantener foto anterior al editar

            fotoPerfil =
                    clienteAnterior.getFotoPerfil();
        }


        // ==========================================
        // CREAR OBJETO CLIENTE
        // ==========================================

        Cliente cliente =
                new Cliente();

        cliente.setCodigoCliente(
                codigoCliente
        );

        cliente.setNombres(
                nombres
        );

        cliente.setApellidos(
                apellidos
        );

        cliente.setDni(
                dni
        );

        cliente.setTelefono(
                telefono
        );

        cliente.setTelefono2(
                telefono2
        );

        cliente.setDireccion(
                direccion
        );

        cliente.setReferenciaDomicilio(
                referenciaDomicilio
        );

        cliente.setObservaciones(
                observaciones
        );

        cliente.setFotoPerfil(
                fotoPerfil
        );

        cliente.setIdPlan(
                idPlan
        );

        cliente.setFechaInstalacion(
                fechaInstalacion
        );

        cliente.setDiaVencimiento(
                diaVencimiento
        );

        // NUEVO:
        // Guardar la modalidad seleccionada
        cliente.setTipoEmision(
                tipoEmision
        );


        // ==========================================
        // ACTUALIZAR CLIENTE
        // ==========================================

        if (idClienteStr != null &&
                !idClienteStr.isEmpty()) {

            int idCliente;

            try {

                idCliente =
                        Integer.parseInt(
                                idClienteStr
                        );

            } catch (NumberFormatException e) {

                response.getWriter().println(
                        "ERROR: ID DE CLIENTE NO VÁLIDO."
                );

                return;
            }

            cliente.setIdCliente(
                    idCliente
            );

            boolean actualizado =
                    dao.actualizar(cliente);

            if (actualizado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/ClienteServlet"
                );

            } else {

                response.getWriter().println(
                        "ERROR AL ACTUALIZAR EL CLIENTE"
                );
            }

            return;
        }


        // ==========================================
        // REGISTRAR NUEVO CLIENTE
        // ==========================================

        boolean registrado =
                dao.registrar(cliente);

        if (registrado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ClienteServlet"
            );

        } else {

            response.getWriter().println(
                    "ERROR AL REGISTRAR EL CLIENTE"
            );
        }
    }
}

