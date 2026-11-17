package dao;

import conexion.Conexion;
import modelo.Morosidad;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MorosidadDAO {

    // =========================================================
    // LISTAR TODAS LAS DEUDAS
    // =========================================================

    public List<Morosidad> listar() {

        List<Morosidad> lista = new ArrayList<>();

        String sql =
                "SELECT * FROM vw_deudas " +
                "ORDER BY dias_atraso DESC, fecha_vencimiento ASC";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                lista.add(mapear(rs));
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL LISTAR MOROSIDAD: "
                    + e.getMessage()
            );
        }

        return lista;
    }


    // =========================================================
    // BUSCAR MOROSOS
    // =========================================================

    public List<Morosidad> buscar(String texto) {

        List<Morosidad> lista = new ArrayList<>();

        String sql =
                "SELECT * FROM vw_deudas " +
                "WHERE codigo_cliente LIKE ? " +
                "OR cliente LIKE ? " +
                "OR dni LIKE ? " +
                "OR telefono LIKE ? " +
                "ORDER BY dias_atraso DESC, fecha_vencimiento ASC";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            String busqueda = "%" + texto + "%";

            ps.setString(1, busqueda);
            ps.setString(2, busqueda);
            ps.setString(3, busqueda);
            ps.setString(4, busqueda);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    lista.add(mapear(rs));
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL BUSCAR MOROSIDAD: "
                    + e.getMessage()
            );
        }

        return lista;
    }


    // =========================================================
    // DEUDAS DE UN CLIENTE
    // =========================================================

    public List<Morosidad> listarPorCliente(int idCliente) {

        List<Morosidad> lista = new ArrayList<>();

        String sql =
                "SELECT * FROM vw_deudas " +
                "WHERE id_cliente = ? " +
                "ORDER BY fecha_vencimiento ASC";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    lista.add(mapear(rs));
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL LISTAR DEUDA DEL CLIENTE: "
                    + e.getMessage()
            );
        }

        return lista;
    }


    // =========================================================
    // TOTAL DEUDA DE UN CLIENTE
    // =========================================================

    public double obtenerTotalDeuda(int idCliente) {

        double total = 0;

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM vw_deudas " +
                "WHERE id_cliente = ?";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idCliente);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    total = rs.getDouble("total");
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL OBTENER DEUDA: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // =========================================================
    // CONTAR CLIENTES MOROSOS
    // =========================================================

    public int contarClientesMorosos() {

        int total = 0;

        String sql =
                "SELECT COUNT(DISTINCT id_cliente) AS total " +
                "FROM vw_deudas";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                total = rs.getInt("total");
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL CONTAR MOROSOS: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // =========================================================
    // TOTAL DINERO PENDIENTE
    // =========================================================

    public double obtenerTotalPendiente() {

        double total = 0;

        String sql =
                "SELECT COALESCE(SUM(monto), 0) AS total " +
                "FROM vw_deudas";

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                total = rs.getDouble("total");
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL OBTENER TOTAL PENDIENTE: "
                    + e.getMessage()
            );
        }

        return total;
    }


    // =========================================================
    // MAPEAR RESULTADO
    // =========================================================

    private Morosidad mapear(ResultSet rs) throws Exception {

        Morosidad m = new Morosidad();

        m.setIdCliente(
                rs.getInt("id_cliente")
        );

        m.setCodigoCliente(
                rs.getString("codigo_cliente")
        );

        m.setCliente(
                rs.getString("cliente")
        );

        m.setDni(
                rs.getString("dni")
        );

        m.setTelefono(
                rs.getString("telefono")
        );

        m.setDireccion(
                rs.getString("direccion")
        );

        m.setIdCuota(
                rs.getInt("id_cuota")
        );

        m.setPeriodo(
                rs.getString("periodo")
        );

        m.setFechaGeneracion(
                rs.getString("fecha_generacion")
        );

        m.setFechaVencimiento(
                rs.getString("fecha_vencimiento")
        );

        m.setMonto(
                rs.getDouble("monto")
        );

        m.setEstado(
                rs.getString("estado")
        );

        m.setDiasAtraso(
                rs.getInt("dias_atraso")
        );

        return m;
    }
}