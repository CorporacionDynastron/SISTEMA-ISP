
package dao;

import conexion.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReporteDAO {

    // ==========================================
    // TOTAL RECAUDADO DEL MES ACTUAL
    // ==========================================

    public double totalRecaudadoMes() {

        double total = 0;

        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM pagos
            WHERE fecha_pago >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
            AND fecha_pago < DATE_ADD(
                DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                INTERVAL 1 MONTH
            )
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR TOTAL RECAUDADO: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // TOTAL RECAUDADO POR RANGO DE FECHAS
    // ==========================================

    public double totalRecaudadoPorFechas(
            String fechaInicio,
            String fechaFin) {

        double total = 0;

        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM pagos
            WHERE fecha_pago >= ?
            AND fecha_pago < DATE_ADD(?, INTERVAL 1 DAY)
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    total = rs.getDouble(1);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR TOTAL POR FECHAS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // CANTIDAD DE PAGOS DEL MES ACTUAL
    // ==========================================

    public int cantidadPagosMes() {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM pagos
            WHERE fecha_pago >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
            AND fecha_pago < DATE_ADD(
                DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                INTERVAL 1 MONTH
            )
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR CANTIDAD PAGOS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // CANTIDAD DE PAGOS POR RANGO DE FECHAS
    // ==========================================

    public int cantidadPagosPorFechas(
            String fechaInicio,
            String fechaFin) {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM pagos
            WHERE fecha_pago >= ?
            AND fecha_pago < DATE_ADD(?, INTERVAL 1 DAY)
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR CANTIDAD POR FECHAS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // TOTAL PAGOS POR YAPE
    // ==========================================

    public double totalYape() {
        return totalPorMetodo("Yape");
    }


    // ==========================================
    // TOTAL PAGOS POR PLIN
    // ==========================================

    public double totalPlin() {
        return totalPorMetodo("Plin");
    }


    // ==========================================
    // TOTAL PAGOS EN EFECTIVO
    // ==========================================

    public double totalEfectivo() {
        return totalPorMetodo("Efectivo");
    }


    // ==========================================
    // TOTAL PAGOS POR TRANSFERENCIA
    // ==========================================

    public double totalTransferencia() {
        return totalPorMetodo("Transferencia");
    }


    // ==========================================
    // TOTAL YAPE POR RANGO DE FECHAS
    // ==========================================

    public double totalYapePorFechas(
            String fechaInicio,
            String fechaFin) {

        return totalPorMetodoFechas(
                "Yape",
                fechaInicio,
                fechaFin
        );
    }


    // ==========================================
    // TOTAL PLIN POR RANGO DE FECHAS
    // ==========================================

    public double totalPlinPorFechas(
            String fechaInicio,
            String fechaFin) {

        return totalPorMetodoFechas(
                "Plin",
                fechaInicio,
                fechaFin
        );
    }


    // ==========================================
    // TOTAL EFECTIVO POR RANGO DE FECHAS
    // ==========================================

    public double totalEfectivoPorFechas(
            String fechaInicio,
            String fechaFin) {

        return totalPorMetodoFechas(
                "Efectivo",
                fechaInicio,
                fechaFin
        );
    }


    // ==========================================
    // TOTAL TRANSFERENCIA POR RANGO DE FECHAS
    // ==========================================

    public double totalTransferenciaPorFechas(
            String fechaInicio,
            String fechaFin) {

        return totalPorMetodoFechas(
                "Transferencia",
                fechaInicio,
                fechaFin
        );
    }


    // ==========================================
    // TOTAL POR MÉTODO DEL MES ACTUAL
    // ==========================================

    private double totalPorMetodo(String metodo) {

        double total = 0;

        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM pagos
            WHERE metodo_pago = ?
            AND fecha_pago >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
            AND fecha_pago < DATE_ADD(
                DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                INTERVAL 1 MONTH
            )
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, metodo);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    total = rs.getDouble(1);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR TOTAL POR METODO: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // TOTAL POR MÉTODO Y RANGO DE FECHAS
    // ==========================================

    private double totalPorMetodoFechas(
            String metodo,
            String fechaInicio,
            String fechaFin) {

        double total = 0;

        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM pagos
            WHERE metodo_pago = ?
            AND fecha_pago >= ?
            AND fecha_pago < DATE_ADD(?, INTERVAL 1 DAY)
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setString(1, metodo);
            ps.setString(2, fechaInicio);
            ps.setString(3, fechaFin);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    total = rs.getDouble(1);
                }
            }

        } catch (Exception e) {
            System.out.println(
                    "ERROR TOTAL METODO POR FECHAS: "
                    + e.getMessage()
            );
        }

        return total;
    }
}