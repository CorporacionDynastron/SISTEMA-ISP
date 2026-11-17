
package dao;

import conexion.Conexion;
import modelo.Cliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    // =========================================================
    // LISTAR CLIENTES
    // =========================================================

    public List<Cliente> listar() {

        List<Cliente> lista = new ArrayList<>();

        String sql = """
            SELECT
                c.*,
                p.nombre_plan,
                p.velocidad,
                p.precio
            FROM clientes c
            INNER JOIN planes p
                ON c.id_plan = p.id_plan
            ORDER BY c.id_cliente DESC
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                lista.add(crearClienteDesdeResultSet(rs));
            }

        } catch (Exception e) {
            System.out.println(
                "ERROR AL LISTAR CLIENTES: " + e.getMessage()
            );
        }

        return lista;
    }

    // =========================================================
    // LISTAR CLIENTES ACTIVOS
    // =========================================================

    public List<Cliente> listarActivos() {

        List<Cliente> lista = new ArrayList<>();

        String sql = """
            SELECT
                c.*,
                p.nombre_plan,
                p.velocidad,
                p.precio
            FROM clientes c
            INNER JOIN planes p
                ON c.id_plan = p.id_plan
            WHERE c.estado = 'ACTIVO'
            ORDER BY c.nombres, c.apellidos
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                lista.add(crearClienteDesdeResultSet(rs));
            }

        } catch (Exception e) {
            System.out.println(
                "ERROR AL LISTAR CLIENTES ACTIVOS: " + e.getMessage()
            );
        }

        return lista;
    }

    // =========================================================
    // BUSCAR Y FILTRAR CLIENTES
    // =========================================================

    public List<Cliente> buscar(
            String texto,
            String estado,
            String idPlan) {

        List<Cliente> lista = new ArrayList<>();

        String sql = """
            SELECT
                c.*,
                p.nombre_plan,
                p.velocidad,
                p.precio
            FROM clientes c
            INNER JOIN planes p
                ON c.id_plan = p.id_plan
            WHERE
                (
                    c.codigo_cliente LIKE ?
                    OR c.nombres LIKE ?
                    OR c.apellidos LIKE ?
                    OR c.dni LIKE ?
                )
            AND (? = '' OR c.estado = ?)
            AND (? = '' OR c.id_plan = ?)
            ORDER BY c.id_cliente DESC
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            String buscar = "%" + (texto == null ? "" : texto) + "%";

            ps.setString(1, buscar);
            ps.setString(2, buscar);
            ps.setString(3, buscar);
            ps.setString(4, buscar);

            String estadoFiltro = estado == null ? "" : estado;

            ps.setString(5, estadoFiltro);
            ps.setString(6, estadoFiltro);

            String planFiltro = idPlan == null ? "" : idPlan;

            ps.setString(7, planFiltro);
            ps.setString(8, planFiltro);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(crearClienteDesdeResultSet(rs));
                }
            }

        } catch (Exception e) {
            System.out.println(
                "ERROR AL BUSCAR CLIENTES: " + e.getMessage()
            );
        }

        return lista;
    }

    // =========================================================
    // BUSCAR CLIENTE POR ID
    // =========================================================

    public Cliente buscarPorId(int idCliente) {

        String sql = """
            SELECT
                c.*,
                p.nombre_plan,
                p.velocidad,
                p.precio
            FROM clientes c
            INNER JOIN planes p
                ON c.id_plan = p.id_plan
            WHERE c.id_cliente = ?
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return crearClienteDesdeResultSet(rs);
                }
            }

        } catch (Exception e) {
            System.out.println(
                "ERROR AL BUSCAR CLIENTE: " + e.getMessage()
            );
        }

        return null;
    }

    // =========================================================
    // BUSCAR CLIENTE POR CÓDIGO
    // =========================================================

    public Cliente buscarPorCodigo(String codigoCliente) {

        String sql = """
            SELECT
                c.*,
                p.nombre_plan,
                p.velocidad,
                p.precio
            FROM clientes c
            INNER JOIN planes p
                ON c.id_plan = p.id_plan
            WHERE c.codigo_cliente = ?
            LIMIT 1
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, codigoCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return crearClienteDesdeResultSet(rs);
                }
            }

        } catch (Exception e) {
            System.out.println(
                "ERROR AL BUSCAR CLIENTE POR CÓDIGO: " + e.getMessage()
            );
        }

        return null;
    }

    // =========================================================
    // REGISTRAR CLIENTE
    // =========================================================

    public boolean registrar(Cliente cliente) {

        if (cliente == null) {
            System.out.println("ERROR: EL CLIENTE ES NULO.");
            return false;
        }

        // Validar el día de vencimiento seleccionado.
        int diaVencimiento = cliente.getDiaVencimiento();

        if (diaVencimiento < 1 || diaVencimiento > 31) {
            System.out.println(
                "ERROR: EL DÍA DE VENCIMIENTO DEBE ESTAR ENTRE 1 Y 31."
            );
            return false;
        }

        String sql = """
            INSERT INTO clientes (
                codigo_cliente,
                nombres,
                apellidos,
                dni,
                telefono,
                telefono2,
                direccion,
                referencia_domicilio,
                observaciones,
                foto_perfil,
                id_plan,
                fecha_instalacion,
                dia_vencimiento,
                tipo_emision
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        Connection cn = null;
        int idCliente = 0;
        double precioPlan = 0;

        try {

            cn = Conexion.conectar();

            PreparedStatement ps = cn.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setString(1, cliente.getCodigoCliente());
            ps.setString(2, cliente.getNombres());
            ps.setString(3, cliente.getApellidos());
            ps.setString(4, cliente.getDni());
            ps.setString(5, cliente.getTelefono());
            ps.setString(6, cliente.getTelefono2());
            ps.setString(7, cliente.getDireccion());
            ps.setString(8, cliente.getReferenciaDomicilio());
            ps.setString(9, cliente.getObservaciones());
            ps.setString(10, cliente.getFotoPerfil());
            ps.setInt(11, cliente.getIdPlan());
            ps.setString(12, cliente.getFechaInstalacion());
            ps.setInt(13, diaVencimiento);

            /*
             * Conservamos tipo_emision por compatibilidad
             * con la estructura actual de la base de datos.
             * La programación de las cuotas usará dia_vencimiento.
             */
            ps.setString(14, obtenerTipoEmision(cliente));

            int resultado = ps.executeUpdate();

            if (resultado == 0) {
                ps.close();
                return false;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    idCliente = generatedKeys.getInt(1);
                }
            }

            ps.close();

            if (idCliente <= 0) {
                System.out.println(
                    "ERROR: NO SE PUDO OBTENER EL ID DEL CLIENTE."
                );
                return false;
            }

            // ================================================
            // OBTENER PRECIO DEL PLAN
            // ================================================

            String sqlPlan = """
                SELECT precio
                FROM planes
                WHERE id_plan = ?
                """;

            try (PreparedStatement psPlan =
                    cn.prepareStatement(sqlPlan)) {

                psPlan.setInt(1, cliente.getIdPlan());

                try (ResultSet rsPlan = psPlan.executeQuery()) {
                    if (rsPlan.next()) {
                        precioPlan = rsPlan.getDouble("precio");
                    } else {
                        System.out.println(
                            "ERROR: NO SE ENCONTRÓ EL PLAN DEL CLIENTE."
                        );
                        return false;
                    }
                }
            }

            /*
             * Cerramos la conexión antes de llamar a CuotaDAO,
             * porque CuotaDAO trabaja con su propia conexión.
             */
            cn.close();
            cn = null;

            // ================================================
            // GENERAR LA PRIMERA CUOTA
            // ================================================

            if (cliente.getFechaInstalacion() != null
                    && !cliente.getFechaInstalacion().trim().isEmpty()) {

                LocalDate fechaInstalacion = LocalDate.parse(
                    cliente.getFechaInstalacion().trim()
                );

                CuotaDAO cuotaDAO = new CuotaDAO();

                /*
                 * CAMBIO IMPORTANTE:
                 * Enviamos el día de vencimiento seleccionado
                 * por el usuario, no el tipo_emision.
                 *
                 * Esta llamada requiere el método:
                 * generarPrimeraCuota(int, LocalDate, int, double)
                 * en CuotaDAO.
                 */
                boolean cuotaCreada = cuotaDAO.generarPrimeraCuota(
                    idCliente,
                    fechaInstalacion,
                    diaVencimiento,
                    precioPlan
                );

                if (!cuotaCreada) {
                    System.out.println(
                        "ADVERTENCIA: EL CLIENTE SE REGISTRÓ, "
                        + "PERO NO SE PUDO GENERAR LA PRIMERA CUOTA."
                    );

                    return false;
                }
            }

            System.out.println(
                "CLIENTE REGISTRADO. ID: " + idCliente
                + ", DÍA DE VENCIMIENTO: " + diaVencimiento
            );

            return true;

        } catch (Exception e) {

            System.out.println(
                "========== ERROR AL REGISTRAR CLIENTE =========="
            );

            e.printStackTrace();

            System.out.println(
                "================================================="
            );

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                System.out.println(
                    "ERROR AL CERRAR CONEXIÓN: " + e.getMessage()
                );
            }
        }
    }

    // =========================================================
    // ACTUALIZAR CLIENTE
    // =========================================================

    public boolean actualizar(Cliente cliente) {

        if (cliente == null) {
            return false;
        }

        int diaVencimiento = cliente.getDiaVencimiento();

        if (diaVencimiento < 1 || diaVencimiento > 31) {
            System.out.println(
                "ERROR: EL DÍA DE VENCIMIENTO DEBE ESTAR ENTRE 1 Y 31."
            );
            return false;
        }

        String sql = """
            UPDATE clientes
            SET
                codigo_cliente = ?,
                nombres = ?,
                apellidos = ?,
                dni = ?,
                telefono = ?,
                telefono2 = ?,
                direccion = ?,
                referencia_domicilio = ?,
                observaciones = ?,
                foto_perfil = ?,
                id_plan = ?,
                fecha_instalacion = ?,
                dia_vencimiento = ?,
                tipo_emision = ?
            WHERE id_cliente = ?
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, cliente.getCodigoCliente());
            ps.setString(2, cliente.getNombres());
            ps.setString(3, cliente.getApellidos());
            ps.setString(4, cliente.getDni());
            ps.setString(5, cliente.getTelefono());
            ps.setString(6, cliente.getTelefono2());
            ps.setString(7, cliente.getDireccion());
            ps.setString(8, cliente.getReferenciaDomicilio());
            ps.setString(9, cliente.getObservaciones());
            ps.setString(10, cliente.getFotoPerfil());
            ps.setInt(11, cliente.getIdPlan());
            ps.setString(12, cliente.getFechaInstalacion());
            ps.setInt(13, diaVencimiento);
            ps.setString(14, obtenerTipoEmision(cliente));
            ps.setInt(15, cliente.getIdCliente());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println(
                "ERROR AL ACTUALIZAR CLIENTE: " + e.getMessage()
            );
            return false;
        }
    }

    // =========================================================
    // CAMBIAR ESTADO DEL CLIENTE
    // =========================================================

    public boolean cambiarEstado(int idCliente, String estado) {

        String sql = """
            UPDATE clientes
            SET estado = ?
            WHERE id_cliente = ?
            """;

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, estado);
            ps.setInt(2, idCliente);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println(
                "ERROR AL CAMBIAR ESTADO DEL CLIENTE: " + e.getMessage()
            );
            return false;
        }
    }

    // =========================================================
    // ELIMINAR CLIENTE
    // =========================================================

    public boolean eliminar(int idCliente) {

        Connection cn = null;

        try {

            cn = Conexion.conectar();
            cn.setAutoCommit(false);

            // Eliminar pagos del cliente.
            String sqlPagos = """
                DELETE FROM pagos
                WHERE id_cliente = ?
                """;

            try (PreparedStatement psPagos =
                    cn.prepareStatement(sqlPagos)) {

                psPagos.setInt(1, idCliente);
                psPagos.executeUpdate();
            }

            // Eliminar cuotas del cliente.
            String sqlCuotas = """
                DELETE FROM cuotas
                WHERE id_cliente = ?
                """;

            try (PreparedStatement psCuotas =
                    cn.prepareStatement(sqlCuotas)) {

                psCuotas.setInt(1, idCliente);
                psCuotas.executeUpdate();
            }

            // Eliminar cliente.
            String sqlCliente = """
                DELETE FROM clientes
                WHERE id_cliente = ?
                """;

            int resultado;

            try (PreparedStatement psCliente =
                    cn.prepareStatement(sqlCliente)) {

                psCliente.setInt(1, idCliente);
                resultado = psCliente.executeUpdate();
            }

            if (resultado > 0) {
                cn.commit();
                return true;
            } else {
                cn.rollback();
                return false;
            }

        } catch (Exception e) {

            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception rollbackError) {
                System.out.println(
                    "ERROR AL HACER ROLLBACK: "
                    + rollbackError.getMessage()
                );
            }

            System.out.println(
                "ERROR AL ELIMINAR CLIENTE: " + e.getMessage()
            );

            return false;

        } finally {

            try {
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
            } catch (Exception e) {
                System.out.println(
                    "ERROR AL CERRAR CONEXIÓN: " + e.getMessage()
                );
            }
        }
    }

    // =========================================================
    // CREAR CLIENTE DESDE RESULTSET
    // =========================================================

    private Cliente crearClienteDesdeResultSet(
            ResultSet rs) throws Exception {

        Cliente cliente = new Cliente();

        cliente.setIdCliente(rs.getInt("id_cliente"));
        cliente.setCodigoCliente(rs.getString("codigo_cliente"));
        cliente.setNombres(rs.getString("nombres"));
        cliente.setApellidos(rs.getString("apellidos"));
        cliente.setDni(rs.getString("dni"));
        cliente.setTelefono(rs.getString("telefono"));
        cliente.setTelefono2(rs.getString("telefono2"));
        cliente.setDireccion(rs.getString("direccion"));
        cliente.setReferenciaDomicilio(
            rs.getString("referencia_domicilio")
        );
        cliente.setObservaciones(rs.getString("observaciones"));
        cliente.setFotoPerfil(rs.getString("foto_perfil"));
        cliente.setIdPlan(rs.getInt("id_plan"));
        cliente.setNombrePlan(rs.getString("nombre_plan"));
        cliente.setVelocidad(rs.getString("velocidad"));
        cliente.setPrecioPlan(rs.getDouble("precio"));
        cliente.setFechaInstalacion(rs.getString("fecha_instalacion"));
        cliente.setDiaVencimiento(rs.getInt("dia_vencimiento"));
        cliente.setTipoEmision(rs.getString("tipo_emision"));
        cliente.setEstado(rs.getString("estado"));

        return cliente;
    }

    // =========================================================
    // OBTENER TIPO DE EMISIÓN
    // =========================================================

    /*
     * Se conserva por compatibilidad con la columna tipo_emision
     * y con otras partes actuales del sistema.
     *
     * La fecha de vencimiento de las cuotas se controla mediante
     * dia_vencimiento, que es el día seleccionado para el cliente.
     */
    private String obtenerTipoEmision(Cliente cliente) {

        String tipo = cliente.getTipoEmision();

        if (tipo == null || tipo.trim().isEmpty()) {
            return "QUINCENAL";
        }

        tipo = tipo.trim().toUpperCase();

        if (!"QUINCENAL".equals(tipo)
                && !"FIN_DE_MES".equals(tipo)) {
            return "QUINCENAL";
        }

        return tipo;
    }
}