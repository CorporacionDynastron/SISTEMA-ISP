
package dao;

import conexion.Conexion;
import modelo.Pago;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {

    // =====================================================
    // LISTAR PAGOS
    // =====================================================

    public List<Pago> listar() {
        List<Pago> lista = new ArrayList<>();

        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            ORDER BY p.fecha_pago DESC, p.id_pago DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearPago(rs));
            }

        } catch (Exception e) {
            System.out.println("ERROR AL LISTAR PAGOS: " + e.getMessage());
        }

        return lista;
    }

    // =====================================================
    // BUSCAR Y FILTRAR PAGOS
    // =====================================================

    public List<Pago> buscar(
            String texto, String fechaDesde,
            String fechaHasta, String metodoPago) {

        List<Pago> lista = new ArrayList<>();

        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            WHERE (
                c.codigo_cliente LIKE ?
                OR c.nombres LIKE ?
                OR c.apellidos LIKE ?
                OR c.dni LIKE ?
            )
            AND (? = '' OR p.fecha_pago >= ?)
            AND (? = '' OR p.fecha_pago <= ?)
            AND (? = '' OR p.metodo_pago = ?)
            ORDER BY p.fecha_pago DESC, p.id_pago DESC
            """;

        String buscar = "%" + (texto == null ? "" : texto.trim()) + "%";
        String desde = fechaDesde == null ? "" : fechaDesde.trim();
        String hasta = fechaHasta == null ? "" : fechaHasta.trim();
        String metodo = metodoPago == null ? "" : metodoPago.trim();

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, buscar);
            ps.setString(2, buscar);
            ps.setString(3, buscar);
            ps.setString(4, buscar);
            ps.setString(5, desde);
            ps.setString(6, desde);
            ps.setString(7, hasta);
            ps.setString(8, hasta);
            ps.setString(9, metodo);
            ps.setString(10, metodo);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPago(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR AL BUSCAR PAGOS: " + e.getMessage());
        }

        return lista;
    }

    // =====================================================
    // REGISTRAR PAGO Y GENERAR LA SIGUIENTE CUOTA
    // =====================================================

    public boolean registrar(Pago pago) {
        Connection cn = null;

        try {
            cn = Conexion.conectar();
            cn.setAutoCommit(false);

            // 1. Consultar y bloquear la cuota seleccionada.
            String sqlCuota = """
                SELECT q.id_cuota, q.id_cliente, q.periodo,
                       q.monto, q.estado, q.fecha_vencimiento,
                       c.dia_vencimiento, p.precio
                FROM cuotas q
                INNER JOIN clientes c ON q.id_cliente = c.id_cliente
                INNER JOIN planes p ON c.id_plan = p.id_plan
                WHERE q.id_cuota = ?
                FOR UPDATE
                """;

            int idCliente;
            int diaVencimiento;
            double montoCuota;
            double precioPlan;
            String periodo;
            String estadoCuota;
            String fechaVencimientoTexto;

            try (PreparedStatement ps = cn.prepareStatement(sqlCuota)) {
                ps.setInt(1, pago.getIdCuota());

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException(
                                "La cuota seleccionada no existe."
                        );
                    }

                    idCliente = rs.getInt("id_cliente");
                    diaVencimiento = rs.getInt("dia_vencimiento");
                    montoCuota = rs.getDouble("monto");
                    precioPlan = rs.getDouble("precio");
                    periodo = rs.getString("periodo");
                    estadoCuota = rs.getString("estado");
                    fechaVencimientoTexto =
                            rs.getString("fecha_vencimiento");
                }
            }

            if (diaVencimiento < 1 || diaVencimiento > 31) {
                throw new IllegalArgumentException(
                        "El día de vencimiento debe estar entre 1 y 31."
                );
            }

            if (estadoCuota == null
                    || "PAGADA".equalsIgnoreCase(estadoCuota)) {
                throw new IllegalArgumentException(
                        "Esta cuota ya está pagada o no tiene un estado válido."
                );
            }

            if ("ANULADA".equalsIgnoreCase(estadoCuota)) {
                throw new IllegalArgumentException(
                        "No se puede pagar una cuota anulada."
                );
            }

            if (fechaVencimientoTexto == null
                    || fechaVencimientoTexto.isBlank()) {
                throw new IllegalArgumentException(
                        "La cuota no tiene fecha de vencimiento."
                );
            }

            if (pago.getFechaPago() == null
                    || pago.getFechaPago().isBlank()) {
                throw new IllegalArgumentException(
                        "Debes indicar la fecha de pago."
                );
            }

            LocalDate fechaBase =
                    LocalDate.parse(fechaVencimientoTexto);

            // 2. Generar código de pago.
            String codigoPago = generarCodigoPago(cn);
            pago.setCodigoPago(codigoPago);

            // 3. Insertar el pago.
            String sqlPago = """
                INSERT INTO pagos (
                    codigo_pago, id_cliente, id_cuota,
                    fecha_pago, periodo, monto, metodo_pago,
                    numero_operacion, comprobante, id_usuario,
                    observacion
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

            try (PreparedStatement ps = cn.prepareStatement(
                    sqlPago, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, codigoPago);
                ps.setInt(2, idCliente);
                ps.setInt(3, pago.getIdCuota());
                ps.setString(4, pago.getFechaPago());
                ps.setString(5, periodo);
                ps.setDouble(6, montoCuota);
                ps.setString(7, pago.getMetodoPago());
                ps.setString(8, pago.getNumeroOperacion());
                ps.setString(9, pago.getComprobante());
                ps.setInt(10, pago.getIdUsuario());
                ps.setString(11, pago.getObservacion());

                if (ps.executeUpdate() <= 0) {
                    throw new IllegalStateException(
                            "No se pudo registrar el pago."
                    );
                }

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        pago.setIdPago(keys.getInt(1));
                    }
                }
            }

            // 4. Marcar la cuota como pagada.
            String sqlActualizar = """
                UPDATE cuotas
                SET estado = 'PAGADA', fecha_pago = ?
                WHERE id_cuota = ?
                  AND estado NOT IN ('PAGADA', 'ANULADA')
                """;

            try (PreparedStatement ps =
                    cn.prepareStatement(sqlActualizar)) {

                ps.setString(1, pago.getFechaPago());
                ps.setInt(2, pago.getIdCuota());

                if (ps.executeUpdate() != 1) {
                    throw new IllegalStateException(
                            "No se pudo actualizar el estado de la cuota."
                    );
                }
            }

            // 5. Generar la siguiente cuota usando el día del cliente.
            boolean siguienteGenerada = generarSiguienteCuota(
                    cn, idCliente, fechaBase, diaVencimiento, precioPlan
            );

            if (!siguienteGenerada) {
                throw new IllegalStateException(
                        "No se pudo generar la siguiente cuota."
                );
            }

            // 6. Registrar auditoría.
            registrarAuditoria(
                    cn,
                    pago.getIdUsuario(),
                    "PAGOS",
                    "REGISTRAR",
                    pago.getIdCuota(),
                    "Pago registrado: " + codigoPago
            );

            // 7. Confirmar todas las operaciones.
            cn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
                System.out.println(
                        "ERROR AL HACER ROLLBACK: " + ex.getMessage()
                );
            }

            System.out.println(
                    "ERROR AL REGISTRAR PAGO: " + e.getMessage()
            );
            return false;

        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (Exception e) {
                    System.out.println(
                            "ERROR AL CERRAR CONEXIÓN: " + e.getMessage()
                    );
                }
            }
        }
    }

    // =====================================================
    // BUSCAR PAGO POR ID
    // =====================================================

    public Pago buscarPorId(int idPago) {
        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            WHERE p.id_pago = ?
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idPago);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearPago(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR AL BUSCAR PAGO: " + e.getMessage());
        }

        return null;
    }

    // =====================================================
    // ACTUALIZAR PAGO
    // =====================================================

    public boolean actualizar(Pago pago) {
        String sql = """
            UPDATE pagos SET
                id_cliente = ?, fecha_pago = ?, periodo = ?,
                monto = ?, metodo_pago = ?, numero_operacion = ?,
                observacion = ?
            WHERE id_pago = ?
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, pago.getIdCliente());
            ps.setString(2, pago.getFechaPago());
            ps.setString(3, pago.getPeriodo());
            ps.setDouble(4, pago.getMonto());
            ps.setString(5, pago.getMetodoPago());
            ps.setString(6, pago.getNumeroOperacion());
            ps.setString(7, pago.getObservacion());
            ps.setInt(8, pago.getIdPago());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL ACTUALIZAR PAGO: " + e.getMessage()
            );
            return false;
        }
    }

    // =====================================================
    // ELIMINAR PAGO
    // =====================================================

    public boolean eliminar(int idPago) {
        Connection cn = null;

        try {
            cn = Conexion.conectar();
            cn.setAutoCommit(false);

            int idCuota;
            int idUsuario;

            String sqlBuscar = """
                SELECT id_cuota, id_usuario
                FROM pagos
                WHERE id_pago = ?
                FOR UPDATE
                """;

            try (PreparedStatement ps = cn.prepareStatement(sqlBuscar)) {
                ps.setInt(1, idPago);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        cn.rollback();
                        return false;
                    }

                    idCuota = rs.getInt("id_cuota");
                    idUsuario = rs.getInt("id_usuario");
                }
            }

            String sqlEliminar = """
                DELETE FROM pagos WHERE id_pago = ?
                """;

            try (PreparedStatement ps = cn.prepareStatement(sqlEliminar)) {
                ps.setInt(1, idPago);

                if (ps.executeUpdate() <= 0) {
                    cn.rollback();
                    return false;
                }
            }

            // Restablecer la cuota asociada.
            String sqlCuota = """
                UPDATE cuotas
                SET estado = CASE
                    WHEN fecha_vencimiento < CURDATE()
                    THEN 'VENCIDA'
                    ELSE 'PENDIENTE'
                END,
                fecha_pago = NULL
                WHERE id_cuota = ? AND estado = 'PAGADA'
                """;

            try (PreparedStatement ps = cn.prepareStatement(sqlCuota)) {
                ps.setInt(1, idCuota);
                ps.executeUpdate();
            }

            registrarAuditoria(
                    cn, idUsuario, "PAGOS", "ELIMINAR",
                    idPago, "Pago eliminado"
            );

            cn.commit();
            return true;

        } catch (Exception e) {
            try {
                if (cn != null) {
                    cn.rollback();
                }
            } catch (Exception ex) {
                System.out.println("ERROR AL REVERTIR ELIMINACIÓN: "
                        + ex.getMessage());
            }

            System.out.println(
                    "ERROR AL ELIMINAR PAGO: " + e.getMessage()
            );
            return false;

        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (Exception e) {
                    System.out.println(
                            "ERROR AL CERRAR CONEXIÓN: " + e.getMessage()
                    );
                }
            }
        }
    }

    // =====================================================
    // HISTORIAL DE PAGOS DE UN CLIENTE
    // =====================================================

    public List<Pago> listarPorCliente(int idCliente) {
        List<Pago> lista = new ArrayList<>();

        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            WHERE p.id_cliente = ?
            ORDER BY p.fecha_pago DESC, p.id_pago DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPago(rs));
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL LISTAR PAGOS DEL CLIENTE: " + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // PAGOS DEL MES ACTUAL
    // =====================================================

    public List<Pago> listarPagosMesActual() {
        List<Pago> lista = new ArrayList<>();

        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            WHERE p.fecha_pago >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
              AND p.fecha_pago < DATE_ADD(
                    DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                    INTERVAL 1 MONTH
              )
            ORDER BY p.fecha_pago DESC, p.id_pago DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearPago(rs));
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL LISTAR PAGOS DEL MES: " + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // PAGOS POR RANGO DE FECHAS
    // =====================================================

    public List<Pago> listarPagosPorFechas(
            String fechaInicio, String fechaFin) {

        List<Pago> lista = new ArrayList<>();

        String sql = """
            SELECT p.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente,
                   q.fecha_vencimiento, q.estado AS estado_cuota
            FROM pagos p
            INNER JOIN clientes c ON p.id_cliente = c.id_cliente
            LEFT JOIN cuotas q ON p.id_cuota = q.id_cuota
            WHERE p.fecha_pago >= ?
              AND p.fecha_pago < DATE_ADD(?, INTERVAL 1 DAY)
            ORDER BY p.fecha_pago DESC, p.id_pago DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearPago(rs));
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL LISTAR PAGOS POR FECHAS: " + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // MAPEAR RESULTSET A PAGO
    // =====================================================

    private Pago mapearPago(ResultSet rs) throws Exception {
        Pago pago = new Pago();

        pago.setIdPago(rs.getInt("id_pago"));
        pago.setCodigoPago(rs.getString("codigo_pago"));
        pago.setIdCliente(rs.getInt("id_cliente"));
        pago.setIdCuota(rs.getInt("id_cuota"));
        pago.setFechaPago(rs.getString("fecha_pago"));
        pago.setPeriodo(rs.getString("periodo"));
        pago.setMonto(rs.getDouble("monto"));
        pago.setMetodoPago(rs.getString("metodo_pago"));
        pago.setNumeroOperacion(rs.getString("numero_operacion"));
        pago.setComprobante(rs.getString("comprobante"));
        pago.setIdUsuario(rs.getInt("id_usuario"));
        pago.setObservacion(rs.getString("observacion"));
        pago.setCodigoCliente(rs.getString("codigo_cliente"));
        pago.setNombreCliente(rs.getString("nombre_cliente"));
        pago.setFechaVencimiento(rs.getString("fecha_vencimiento"));
        pago.setEstadoCuota(rs.getString("estado_cuota"));

        return pago;
    }

    // =====================================================
    // GENERAR CÓDIGO DE PAGO
    // =====================================================

    private String generarCodigoPago(Connection cn) throws Exception {
        String fecha = LocalDate.now().toString().replace("-", "");

        String sql = """
            SELECT COUNT(*) + 1
            FROM pagos
            WHERE DATE(fecha_pago) = CURDATE()
            """;

        try (PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int numero = 1;
            if (rs.next()) {
                numero = rs.getInt(1);
            }

            return String.format("PAG-%s-%04d", fecha, numero);
        }
    }

    // =====================================================
    // GENERAR SIGUIENTE CUOTA SEGÚN EL DÍA DEL CLIENTE
    // =====================================================

    private boolean generarSiguienteCuota(
            Connection cn,
            int idCliente,
            LocalDate fechaBase,
            int diaVencimiento,
            double monto) throws Exception {

        if (fechaBase == null) {
            throw new IllegalArgumentException(
                    "La fecha base no puede ser nula."
            );
        }

        if (diaVencimiento < 1 || diaVencimiento > 31) {
            throw new IllegalArgumentException(
                    "El día de vencimiento debe estar entre 1 y 31."
            );
        }

        YearMonth siguienteMes =
                YearMonth.from(fechaBase).plusMonths(1);

        int diaReal = Math.min(
                diaVencimiento,
                siguienteMes.lengthOfMonth()
        );

        LocalDate fechaVencimiento =
                siguienteMes.atDay(diaReal);

        String periodo = String.format(
                "%04d-%02d",
                fechaVencimiento.getYear(),
                fechaVencimiento.getMonthValue()
        );

        // Comprobar el periodo dentro de la misma transacción.
        String sqlExiste = """
            SELECT id_cuota
            FROM cuotas
            WHERE id_cliente = ? AND periodo = ?
            LIMIT 1
            FOR UPDATE
            """;

        try (PreparedStatement ps = cn.prepareStatement(sqlExiste)) {
            ps.setInt(1, idCliente);
            ps.setString(2, periodo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Ya existe una cuota para ese cliente y periodo.
                    return true;
                }
            }
        }


String sqlInsertar = """
    INSERT INTO cuotas (
        id_cliente,
        periodo,
        fecha_generacion,
        fecha_emision,
        fecha_vencimiento,
        fecha_pago,
        monto,
        estado,
        observacion
    )
    VALUES (
        ?, ?, CURDATE(),
        DATE_SUB(?, INTERVAL 3 DAY),
        ?, NULL, ?, 'PENDIENTE', ?
    )
    """;

try (PreparedStatement ps = cn.prepareStatement(sqlInsertar)) {
    ps.setInt(1, idCliente);
    ps.setString(2, periodo);
    ps.setString(3, fechaVencimiento.toString());
    ps.setString(4, fechaVencimiento.toString());
    ps.setDouble(5, monto);
    ps.setString(
            6,
            "Cuota generada automáticamente para el día "
            + diaVencimiento
    );

    return ps.executeUpdate() == 1;
}
    }

    // =====================================================
    // AUDITORÍA
    // =====================================================

    private void registrarAuditoria(
            Connection cn,
            int idUsuario,
            String modulo,
            String accion,
            int idRegistro,
            String descripcion) throws Exception {

        String sql = """
            INSERT INTO auditoria (
                id_usuario, modulo, accion, id_registro, descripcion
            )
            VALUES (?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setString(2, modulo);
            ps.setString(3, accion);
            ps.setInt(4, idRegistro);
            ps.setString(5, descripcion);
            ps.executeUpdate();
        }
    }
}