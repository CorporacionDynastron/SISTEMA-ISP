package dao;

import conexion.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    // ==========================================
    // TOTAL DE CLIENTES
    // ==========================================
    public int totalClientes() {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM clientes
            WHERE estado <> 'RETIRADO'
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR TOTAL CLIENTES: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // CLIENTES ACTIVOS
    // ==========================================
    public int clientesActivos() {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM clientes
            WHERE estado = 'ACTIVO'
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR CLIENTES ACTIVOS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // CLIENTES SUSPENDIDOS
    // ==========================================
    public int clientesSuspendidos() {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM clientes
            WHERE estado = 'SUSPENDIDO'
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR CLIENTES SUSPENDIDOS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // TOTAL DE MOROSOS
    // ==========================================
    public int totalMorosos() {

        int total = 0;

        String sql = """
            SELECT COUNT(*)
            FROM clientes c
            WHERE c.estado = 'ACTIVO'
            AND NOT EXISTS (
                SELECT 1
                FROM pagos pg
                WHERE pg.id_cliente = c.id_cliente
                AND MONTH(pg.fecha_pago) = MONTH(CURDATE())
                AND YEAR(pg.fecha_pago) = YEAR(CURDATE())
            )
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR TOTAL MOROSOS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // INGRESOS DEL MES
    // ==========================================
    public double ingresosMes() {

        double total = 0;

        String sql = """
            SELECT COALESCE(SUM(monto), 0)
            FROM pagos
            WHERE MONTH(fecha_pago) = MONTH(CURDATE())
            AND YEAR(fecha_pago) = YEAR(CURDATE())
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble(1);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR INGRESOS DEL MES: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // ==========================================
    // INGRESOS DE LOS ÚLTIMOS 6 MESES
    // ==========================================
    // ==========================================
// INGRESOS DE LOS ÚLTIMOS 6 MESES
// ==========================================
public List<Double> ingresosUltimos6Meses() {

    List<Double> ingresos = new ArrayList<>();

    String sql = """
        SELECT
            COALESCE(SUM(p.monto), 0) AS total
        FROM (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
        ) meses
        LEFT JOIN pagos p
            ON YEAR(p.fecha_pago) =
               YEAR(DATE_SUB(CURDATE(),
               INTERVAL meses.n MONTH))
            AND MONTH(p.fecha_pago) =
                MONTH(DATE_SUB(CURDATE(),
                INTERVAL meses.n MONTH))
        GROUP BY meses.n
        ORDER BY meses.n DESC
        """;

    try {

        Connection cn = Conexion.conectar();
        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            ingresos.add(
                    rs.getDouble("total")
            );
        }

        rs.close();
        ps.close();
        cn.close();

    } catch (Exception e) {

        System.out.println(
                "ERROR INGRESOS 6 MESES: "
                + e.getMessage()
        );
    }

    return ingresos;
}


    // ==========================================
    // CLIENTES POR PLAN
    // ==========================================
    public List<String> clientesPorPlan() {

        List<String> datos = new ArrayList<>();

        String sql = """
            SELECT
                p.nombre_plan,
                COUNT(c.id_cliente) AS cantidad
            FROM planes p
            LEFT JOIN clientes c
                ON p.id_plan = c.id_plan
                AND c.estado <> 'RETIRADO'
            WHERE p.estado = 'ACTIVO'
            GROUP BY p.id_plan, p.nombre_plan
            ORDER BY p.id_plan
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                datos.add(
                        rs.getString("nombre_plan")
                        + "|"
                        + rs.getInt("cantidad")
                );
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR CLIENTES POR PLAN: "
                    + e.getMessage()
            );
        }

        return datos;
    }


    // ==========================================
    // ÚLTIMOS PAGOS
    // ==========================================
    public List<String> ultimosPagos() {

        List<String> pagos = new ArrayList<>();

        String sql = """
            SELECT
                c.nombres,
                c.apellidos,
                pg.fecha_pago,
                pg.monto,
                pg.metodo_pago,
                u.usuario
            FROM pagos pg
            INNER JOIN clientes c
                ON pg.id_cliente = c.id_cliente
            LEFT JOIN usuarios u
                ON pg.id_usuario = u.id_usuario
            ORDER BY pg.fecha_pago DESC
            LIMIT 5
            """;

        try {

            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                pagos.add(
                        rs.getString("nombres")
                        + "|"
                        + rs.getString("apellidos")
                        + "|"
                        + rs.getDate("fecha_pago")
                        + "|"
                        + rs.getDouble("monto")
                        + "|"
                        + rs.getString("metodo_pago")
                        + "|"
                        + rs.getString("usuario")
                );
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR ULTIMOS PAGOS: "
                    + e.getMessage()
            );
        }

        return pagos;
    }
}