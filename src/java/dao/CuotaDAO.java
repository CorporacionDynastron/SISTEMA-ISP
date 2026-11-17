
package dao;

import conexion.Conexion;
import modelo.Cuota;
import java.sql.SQLException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.YearMonth;

public class CuotaDAO {

    // =====================================================
    // LISTAR TODAS LAS CUOTAS
    // =====================================================

    public List<Cuota> listar() {
        List<Cuota> lista = new ArrayList<>();

        String sql = """
            SELECT q.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente
            FROM cuotas q
            INNER JOIN clientes c ON q.id_cliente = c.id_cliente
            ORDER BY q.fecha_vencimiento DESC, q.id_cuota DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearCuota(rs));
            }

        } catch (Exception e) {
            System.out.println("ERROR AL LISTAR CUOTAS: " + e.getMessage());
        }

        return lista;
    }

    // =====================================================
    // BUSCAR CUOTA POR ID
    // =====================================================

    public Cuota buscarPorId(int idCuota) {
        String sql = """
            SELECT q.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente
            FROM cuotas q
            INNER JOIN clientes c ON q.id_cliente = c.id_cliente
            WHERE q.id_cuota = ?
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCuota);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCuota(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR AL BUSCAR CUOTA: " + e.getMessage());
        }

        return null;
    }

    // =====================================================
    // BUSCAR CUOTA POR CLIENTE Y PERIODO
    // =====================================================

    public Cuota buscarPorClientePeriodo(int idCliente, String periodo) {
        String sql = """
            SELECT q.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente
            FROM cuotas q
            INNER JOIN clientes c ON q.id_cliente = c.id_cliente
            WHERE q.id_cliente = ? AND q.periodo = ?
            LIMIT 1
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            ps.setString(2, periodo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCuota(rs);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL BUSCAR CUOTA POR PERIODO: " + e.getMessage()
            );
        }

        return null;
    }

    // =====================================================
    // LISTAR CUOTAS DE UN CLIENTE
    // =====================================================

    public List<Cuota> listarPorCliente(int idCliente) {
        List<Cuota> lista = new ArrayList<>();

        String sql = """
            SELECT q.*, c.codigo_cliente,
                   CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente
            FROM cuotas q
            INNER JOIN clientes c ON q.id_cliente = c.id_cliente
            WHERE q.id_cliente = ?
            ORDER BY q.fecha_vencimiento DESC, q.id_cuota DESC
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearCuota(rs));
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL LISTAR CUOTAS DEL CLIENTE: " + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // MAPEAR RESULTSET A CUOTA
    // =====================================================

    private Cuota mapearCuota(ResultSet rs) throws Exception {
        Cuota cuota = new Cuota();

        cuota.setIdCuota(rs.getInt("id_cuota"));
        cuota.setIdCliente(rs.getInt("id_cliente"));
        cuota.setPeriodo(rs.getString("periodo"));
        cuota.setFechaGeneracion(rs.getString("fecha_generacion"));
        cuota.setFechaVencimiento(rs.getString("fecha_vencimiento"));
        cuota.setFechaPago(rs.getString("fecha_pago"));
        cuota.setMonto(rs.getDouble("monto"));
        cuota.setEstado(rs.getString("estado"));
        cuota.setObservacion(rs.getString("observacion"));
        cuota.setCodigoCliente(rs.getString("codigo_cliente"));
        cuota.setNombreCliente(rs.getString("nombre_cliente"));

        return cuota;
    }

    // =====================================================
    // REGISTRAR CUOTA
    // =====================================================


    // =====================================================
    // REGISTRAR CUOTA CON FECHA DE EMISION DEL RECIBO
    // =====================================================

public boolean registrar(Cuota cuota) {
    String sql = "INSERT INTO cuotas ("
            + "id_cliente, periodo, fecha_generacion, fecha_emision, "
            + "fecha_vencimiento, fecha_pago, monto, estado, observacion"
            + ") VALUES (?, ?, ?, DATE_SUB(?, INTERVAL 3 DAY), ?, ?, ?, ?, ?)";

  try (Connection con = Conexion.conectar();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, cuota.getIdCliente());
        ps.setString(2, cuota.getPeriodo());
        ps.setString(3, cuota.getFechaGeneracion());
        ps.setString(4, cuota.getFechaVencimiento());
        ps.setString(5, cuota.getFechaVencimiento());

        if (cuota.getFechaPago() != null
                && !cuota.getFechaPago().trim().isEmpty()) {
            ps.setString(6, cuota.getFechaPago());
        } else {
            ps.setNull(6, java.sql.Types.DATE);
        }

        ps.setDouble(7, cuota.getMonto());
        ps.setString(8, cuota.getEstado());
        ps.setString(9, cuota.getObservacion());

        return ps.executeUpdate() > 0;

    } catch (SQLException e) {
        System.err.println("Error al registrar cuota: " + e.getMessage());
        return false;
    }
}

    // =====================================================
    // ACTUALIZAR ESTADOS VENCIDOS
    // =====================================================

    public void actualizarEstadosVencidos() {
        String sql = """
            UPDATE cuotas
            SET estado = 'VENCIDA'
            WHERE estado = 'PENDIENTE'
              AND fecha_vencimiento < CURDATE()
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.executeUpdate();

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL ACTUALIZAR CUOTAS VENCIDAS: " + e.getMessage()
            );
        }
    }

    // =====================================================
    // MARCAR CUOTA COMO PAGADA
    // =====================================================

    public boolean marcarPagada(int idCuota, String fechaPago) {
        String sql = """
            UPDATE cuotas
            SET estado = 'PAGADA', fecha_pago = ?
            WHERE id_cuota = ?
              AND estado NOT IN ('PAGADA', 'ANULADA')
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, fechaPago);
            ps.setInt(2, idCuota);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL MARCAR CUOTA COMO PAGADA: " + e.getMessage()
            );
            return false;
        }
    }

    // =====================================================
    // OBTENER DÍA DE VENCIMIENTO DEL CLIENTE
    // =====================================================

    private int obtenerDiaVencimientoCliente(int idCliente)
            throws Exception {

        String sql = """
            SELECT dia_vencimiento
            FROM clientes
            WHERE id_cliente = ?
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int dia = rs.getInt("dia_vencimiento");

                    if (dia >= 1 && dia <= 31) {
                        return dia;
                    }
                }
            }
        }

        throw new IllegalArgumentException(
                "No se encontró un día de vencimiento válido para el cliente "
                + idCliente
        );
    }

    // =====================================================
    // CALCULAR SIGUIENTE VENCIMIENTO
    // =====================================================

    public LocalDate calcularSiguienteVencimiento(
            LocalDate fechaBase, int diaVencimiento) {

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

        return siguienteMes.atDay(diaReal);
    }

    // =====================================================
    // GENERAR PRIMERA CUOTA
    // =====================================================

    public boolean generarPrimeraCuota(
            int idCliente,
            LocalDate fechaInstalacion,
            int diaVencimiento,
            double monto) {

        try {
            if (fechaInstalacion == null) {
                throw new IllegalArgumentException(
                        "La fecha de instalación es obligatoria."
                );
            }

            LocalDate vencimiento = calcularSiguienteVencimiento(
                    fechaInstalacion, diaVencimiento
            );

            String periodo = String.format(
                    "%04d-%02d",
                    vencimiento.getYear(),
                    vencimiento.getMonthValue()
            );

            if (buscarPorClientePeriodo(idCliente, periodo) != null) {
                return true;
            }

            Cuota cuota = new Cuota();
            cuota.setIdCliente(idCliente);
            cuota.setPeriodo(periodo);
            cuota.setFechaGeneracion(fechaInstalacion.toString());
            cuota.setFechaVencimiento(vencimiento.toString());
            cuota.setFechaPago(null);
            cuota.setMonto(monto);
            cuota.setEstado("PENDIENTE");
            cuota.setObservacion(
                    "Primera cuota generada automáticamente. "
                    + "Día elegido: " + diaVencimiento
            );

            return registrar(cuota);

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL GENERAR PRIMERA CUOTA: " + e.getMessage()
            );
            return false;
        }
    }

    // =====================================================
    // GENERAR SIGUIENTE CUOTA
    // =====================================================

    public boolean generarSiguienteCuota(
            int idCliente,
            LocalDate fechaBase,
            int diaVencimiento,
            double monto) {

        try {
            LocalDate vencimiento = calcularSiguienteVencimiento(
                    fechaBase, diaVencimiento
            );

            String periodo = String.format(
                    "%04d-%02d",
                    vencimiento.getYear(),
                    vencimiento.getMonthValue()
            );

            if (buscarPorClientePeriodo(idCliente, periodo) != null) {
                return true;
            }

            Cuota cuota = new Cuota();
            cuota.setIdCliente(idCliente);
            cuota.setPeriodo(periodo);
            cuota.setFechaGeneracion(LocalDate.now().toString());
            cuota.setFechaVencimiento(vencimiento.toString());
            cuota.setFechaPago(null);
            cuota.setMonto(monto);
            cuota.setEstado("PENDIENTE");
            cuota.setObservacion(
                    "Cuota generada automáticamente. "
                    + "Día elegido: " + diaVencimiento
            );

            return registrar(cuota);

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL GENERAR SIGUIENTE CUOTA: " + e.getMessage()
            );
            return false;
        }
    }

    // =====================================================
    // COMPATIBILIDAD CON LLAMADAS ANTIGUAS
    // =====================================================

    public boolean generarPrimeraCuota(
            int idCliente,
            LocalDate fechaInstalacion,
            String tipoEmision,
            double monto) {

        try {
            return generarPrimeraCuota(
                    idCliente,
                    fechaInstalacion,
                    obtenerDiaVencimientoCliente(idCliente),
                    monto
            );
        } catch (Exception e) {
            System.out.println(
                    "ERROR AL GENERAR PRIMERA CUOTA: " + e.getMessage()
            );
            return false;
        }
    }

    public boolean generarSiguienteCuota(
            int idCliente,
            LocalDate fechaBase,
            String tipoEmision,
            double monto) {

        try {
            return generarSiguienteCuota(
                    idCliente,
                    fechaBase,
                    obtenerDiaVencimientoCliente(idCliente),
                    monto
            );
        } catch (Exception e) {
            System.out.println(
                    "ERROR AL GENERAR SIGUIENTE CUOTA: " + e.getMessage()
            );
            return false;
        }
    }

    public boolean generarPrimeraCuota(
            int idCliente,
            LocalDate fechaInstalacion,
            double monto) {

        try {
            return generarPrimeraCuota(
                    idCliente,
                    fechaInstalacion,
                    obtenerDiaVencimientoCliente(idCliente),
                    monto
            );
        } catch (Exception e) {
            System.out.println(
                    "ERROR AL GENERAR PRIMERA CUOTA: " + e.getMessage()
            );
            return false;
        }
    }

    // =====================================================
    // OBTENER DEUDA TOTAL DEL CLIENTE
    // =====================================================

    public double obtenerDeudaCliente(int idCliente) {
        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM cuotas
            WHERE id_cliente = ?
              AND estado IN ('PENDIENTE', 'VENCIDA')
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR AL OBTENER DEUDA: " + e.getMessage());
        }

        return 0;
    }

    // =====================================================
    // CONTAR CUOTAS PENDIENTES
    // =====================================================

    public int contarPendientes(int idCliente) {
        String sql = """
            SELECT COUNT(*)
            FROM cuotas
            WHERE id_cliente = ?
              AND estado IN ('PENDIENTE', 'VENCIDA')
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR AL CONTAR CUOTAS: " + e.getMessage());
        }

        return 0;
    }

    // =====================================================
    // OBTENER DÍAS DE ATRASO
    // =====================================================

    public int obtenerDiasAtraso(int idCuota) {
        String sql = """
            SELECT CASE
                WHEN estado IN ('PENDIENTE', 'VENCIDA')
                     AND CURDATE() > fecha_vencimiento
                THEN DATEDIFF(CURDATE(), fecha_vencimiento)
                ELSE 0
            END AS dias
            FROM cuotas
            WHERE id_cuota = ?
            """;

        try (Connection cn = Conexion.conectar();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idCuota);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("dias");
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR AL OBTENER DIAS DE ATRASO: " + e.getMessage()
            );
        }

        return 0;
    }
}