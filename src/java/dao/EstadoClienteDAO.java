package dao;

import modelo.EstadoCliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import conexion.Conexion;

public class EstadoClienteDAO {

    // ==========================================================
    // LISTAR TODOS
    // ==========================================================

    public List<EstadoCliente> listar() {

        return buscarPorTextoYEstado(null, null);
    }


    // ==========================================================
    // BUSCAR POR TEXTO
    // ==========================================================

    public List<EstadoCliente> buscar(String texto) {

        return buscarPorTextoYEstado(texto, null);
    }


    // ==========================================================
    // LISTAR POR ESTADO
    // ==========================================================

    public List<EstadoCliente> listarPorEstado(String estado) {

        return buscarPorTextoYEstado(null, estado);
    }


    // ==========================================================
    // BUSCAR + FILTRAR
    // ==========================================================

    public List<EstadoCliente> buscarPorTextoYEstado(
            String texto,
            String estado) {

        List<EstadoCliente> lista =
                new ArrayList<>();

        StringBuilder sql =
                new StringBuilder();

        sql.append(
            "SELECT * FROM ("
        );

        sql.append(
            " SELECT "
        );

        sql.append(
            " c.id_cliente, "
        );

        sql.append(
            " c.codigo_cliente, "
        );

        sql.append(
            " CONCAT(c.nombres, ' ', c.apellidos) AS cliente, "
        );

        sql.append(
            " c.dni, "
        );

        sql.append(
            " c.telefono, "
        );

        sql.append(
            " c.estado AS estado_servicio, "
        );

        sql.append(
            " COUNT("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "THEN 1 END"
            + ") AS cuotas_pendientes, "
        );

        sql.append(
            " COALESCE("
            + "SUM("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "THEN q.monto "
            + "ELSE 0 END"
            + "),0"
            + ") AS deuda_total, "
        );

        sql.append(
            " MAX("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "AND CURDATE() > q.fecha_vencimiento "
            + "THEN DATEDIFF(CURDATE(), q.fecha_vencimiento) "
            + "ELSE 0 END"
            + ") AS dias_atraso, "
        );

        sql.append(
            " MIN("
            + "CASE "
            + "WHEN q.estado = 'PENDIENTE' "
            + "AND q.fecha_vencimiento >= CURDATE() "
            + "THEN q.fecha_vencimiento "
            + "ELSE NULL END"
            + ") AS proximo_vencimiento, "
        );

        sql.append(
            " CASE "

            + "WHEN MAX("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "AND CURDATE() > q.fecha_vencimiento "
            + "THEN DATEDIFF(CURDATE(), q.fecha_vencimiento) "
            + "ELSE 0 END"
            + ") >= 30 "

            + "THEN 'MOROSO' "

            + "WHEN MAX("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "AND CURDATE() > q.fecha_vencimiento "
            + "THEN DATEDIFF(CURDATE(), q.fecha_vencimiento) "
            + "ELSE 0 END"
            + ") > 0 "

            + "THEN 'VENCIDO' "

            + "WHEN MIN("
            + "CASE "
            + "WHEN q.estado = 'PENDIENTE' "
            + "AND q.fecha_vencimiento >= CURDATE() "
            + "THEN DATEDIFF(q.fecha_vencimiento, CURDATE()) "
            + "ELSE NULL END"
            + ") <= 3 "

            + "THEN 'PROXIMO A VENCER' "

            + "ELSE 'AL DIA' "

            + "END AS estado_pago "

        );

        sql.append(
            " FROM clientes c "
        );

        sql.append(
            " LEFT JOIN cuotas q "
            + "ON c.id_cliente = q.id_cliente "
        );

        // ======================================================
        // EXCLUIR CLIENTES RETIRADOS
        // ======================================================

        sql.append(
            " WHERE c.estado <> 'RETIRADO' "
        );

        sql.append(
            " GROUP BY "
            + "c.id_cliente, "
            + "c.codigo_cliente, "
            + "c.nombres, "
            + "c.apellidos, "
            + "c.dni, "
            + "c.telefono, "
            + "c.estado "
        );

        sql.append(
            ") AS datos "
        );

        sql.append(
            " WHERE 1=1 "
        );


        // ======================================================
        // FILTRO DE BÚSQUEDA
        // ======================================================

        boolean tieneTexto =
                texto != null &&
                !texto.trim().isEmpty();


        if (tieneTexto) {

            sql.append(
                " AND ("
                + "datos.codigo_cliente LIKE ? "
                + "OR datos.cliente LIKE ? "
                + "OR datos.dni LIKE ? "
                + "OR datos.telefono LIKE ?"
                + ") "
            );
        }


        // ======================================================
        // FILTRO DE ESTADO
        // ======================================================

        boolean tieneEstado =
                estado != null &&
                !estado.trim().isEmpty() &&
                !"TODOS".equalsIgnoreCase(
                    estado.trim()
                );


        if (tieneEstado) {

            sql.append(
                " AND datos.estado_pago = ? "
            );
        }


        // ======================================================
        // ORDEN
        // ======================================================

        sql.append(
            " ORDER BY "
            + "CASE datos.estado_pago "
            + "WHEN 'MOROSO' THEN 1 "
            + "WHEN 'VENCIDO' THEN 2 "
            + "WHEN 'PROXIMO A VENCER' THEN 3 "
            + "WHEN 'AL DIA' THEN 4 "
            + "ELSE 5 "
            + "END, "
            + "datos.cliente ASC"
        );


        try (
            Connection con =
                Conexion.conectar();

            PreparedStatement ps =
                con.prepareStatement(
                    sql.toString()
                )
        ) {

            int posicion = 1;


            // ==================================================
            // PARÁMETROS DE BÚSQUEDA
            // ==================================================

            if (tieneTexto) {

                String filtro =
                    "%" +
                    texto.trim() +
                    "%";

                ps.setString(
                    posicion++,
                    filtro
                );

                ps.setString(
                    posicion++,
                    filtro
                );

                ps.setString(
                    posicion++,
                    filtro
                );

                ps.setString(
                    posicion++,
                    filtro
                );
            }


            // ==================================================
            // PARÁMETRO ESTADO
            // ==================================================

            if (tieneEstado) {

                ps.setString(
                    posicion++,
                    estado.trim().toUpperCase()
                );
            }


            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    lista.add(
                        mapear(rs)
                    );
                }
            }


        } catch (Exception e) {

            System.out.println(
                "ERROR EstadoClienteDAO.buscarPorTextoYEstado:"
            );

            e.printStackTrace();
        }


        return lista;
    }


    // ==========================================================
    // CONTAR POR ESTADO
    // ==========================================================

    public int contarPorEstado(
            String estado) {

        String sql =
            "SELECT COUNT(*) FROM ("

            + "SELECT "
            + "c.id_cliente, "

            + "CASE "

            + "WHEN MAX("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "AND CURDATE() > q.fecha_vencimiento "
            + "THEN DATEDIFF(CURDATE(),q.fecha_vencimiento) "
            + "ELSE 0 END"
            + ") >= 30 "
            + "THEN 'MOROSO' "

            + "WHEN MAX("
            + "CASE "
            + "WHEN q.estado IN ('PENDIENTE','VENCIDA') "
            + "AND CURDATE() > q.fecha_vencimiento "
            + "THEN DATEDIFF(CURDATE(),q.fecha_vencimiento) "
            + "ELSE 0 END"
            + ") > 0 "
            + "THEN 'VENCIDO' "

            + "WHEN MIN("
            + "CASE "
            + "WHEN q.estado='PENDIENTE' "
            + "AND q.fecha_vencimiento >= CURDATE() "
            + "THEN DATEDIFF(q.fecha_vencimiento,CURDATE()) "
            + "ELSE NULL END"
            + ") <= 3 "
            + "THEN 'PROXIMO A VENCER' "

            + "ELSE 'AL DIA' "

            + "END AS estado_pago "

            + "FROM clientes c "

            + "LEFT JOIN cuotas q "
            + "ON c.id_cliente=q.id_cliente "

            // ==================================================
            // EXCLUIR CLIENTES RETIRADOS
            // ==================================================

            + "WHERE c.estado <> 'RETIRADO' "

            + "GROUP BY c.id_cliente"

            + ") AS datos "

            + "WHERE datos.estado_pago = ?";


        try (
            Connection con =
                Conexion.conectar();

            PreparedStatement ps =
                con.prepareStatement(sql)
        ) {

            ps.setString(
                1,
                estado
            );

            try (ResultSet rs =
                    ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1);
                }
            }


        } catch (Exception e) {

            System.out.println(
                "ERROR contarPorEstado:"
            );

            e.printStackTrace();
        }


        return 0;
    }


    // ==========================================================
    // DEUDA TOTAL
    // ==========================================================

    public double obtenerDeudaTotal() {

        String sql =
            "SELECT COALESCE("
            + "SUM(q.monto),0"
            + ") "
            + "FROM cuotas q "
            + "INNER JOIN clientes c "
            + "ON c.id_cliente = q.id_cliente "
            + "WHERE q.estado IN "
            + "('PENDIENTE','VENCIDA') "
            + "AND c.estado <> 'RETIRADO'";


        try (
            Connection con =
                Conexion.conectar();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ResultSet rs =
                ps.executeQuery()
        ) {

            if (rs.next()) {

                return rs.getDouble(1);
            }

        } catch (Exception e) {

            System.out.println(
                "ERROR obtenerDeudaTotal:"
            );

            e.printStackTrace();
        }


        return 0;
    }


    // ==========================================================
    // MAPEAR RESULTADO
    // ==========================================================

    private EstadoCliente mapear(
            ResultSet rs)
            throws Exception {

        EstadoCliente ec =
            new EstadoCliente();


        ec.setIdCliente(
            rs.getInt("id_cliente")
        );

        ec.setCodigoCliente(
            rs.getString("codigo_cliente")
        );

        ec.setCliente(
            rs.getString("cliente")
        );

        ec.setDni(
            rs.getString("dni")
        );

        ec.setTelefono(
            rs.getString("telefono")
        );

        ec.setEstadoServicio(
            rs.getString("estado_servicio")
        );

        ec.setCuotasPendientes(
            rs.getInt("cuotas_pendientes")
        );

        ec.setDeudaTotal(
            rs.getDouble("deuda_total")
        );

        ec.setDiasAtraso(
            rs.getInt("dias_atraso")
        );


        java.sql.Date fecha =
            rs.getDate(
                "proximo_vencimiento"
            );


        if (fecha != null) {

            ec.setProximoVencimiento(
                fecha.toString()
            );

        } else {

            ec.setProximoVencimiento(
                null
            );
        }


        ec.setEstadoPago(
            rs.getString("estado_pago")
        );


        return ec;
    }
}