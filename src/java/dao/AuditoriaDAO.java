
package dao;

import conexion.Conexion;
import modelo.Auditoria;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    // =====================================================
    // LISTAR TODAS LAS AUDITORÍAS
    // =====================================================

    public List<Auditoria> listar() {

        List<Auditoria> lista = new ArrayList<>();

        String sql = """
            SELECT
                id_auditoria,
                id_usuario,
                modulo,
                accion,
                id_registro,
                descripcion,
                fecha_hora
            FROM auditoria
            ORDER BY fecha_hora DESC,
                     id_auditoria DESC
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {
                lista.add(mapearAuditoria(rs));
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL LISTAR AUDITORÍAS: "
                    + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // BUSCAR Y FILTRAR AUDITORÍAS
    // =====================================================

    public List<Auditoria> buscar(
            String texto,
            String modulo,
            String accion
    ) {

        List<Auditoria> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT
                id_auditoria,
                id_usuario,
                modulo,
                accion,
                id_registro,
                descripcion,
                fecha_hora
            FROM auditoria
            WHERE 1 = 1
            """);

        List<Object> parametros = new ArrayList<>();

        // Buscar por texto
        if (texto != null && !texto.trim().isEmpty()) {

            sql.append("""
                AND (
                    modulo LIKE ?
                    OR accion LIKE ?
                    OR descripcion LIKE ?
                )
                """);

            String filtro = "%" + texto.trim() + "%";

            parametros.add(filtro);
            parametros.add(filtro);
            parametros.add(filtro);
        }

        // Filtrar por módulo
        if (modulo != null && !modulo.trim().isEmpty()) {

            sql.append(" AND modulo = ? ");

            parametros.add(modulo.trim());
        }

        // Filtrar por acción
        if (accion != null && !accion.trim().isEmpty()) {

            sql.append(" AND accion = ? ");

            parametros.add(accion.trim());
        }

        sql.append("""
            ORDER BY fecha_hora DESC,
                     id_auditoria DESC
            """);

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(
                        sql.toString()
                )
        ) {

            for (int i = 0; i < parametros.size(); i++) {

                ps.setObject(
                        i + 1,
                        parametros.get(i)
                );
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    lista.add(mapearAuditoria(rs));
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL BUSCAR AUDITORÍAS: "
                    + e.getMessage()
            );
        }

        return lista;
    }

    // =====================================================
    // REGISTRAR AUDITORÍA
    // =====================================================

    public boolean registrar(
            int idUsuario,
            String modulo,
            String accion,
            int idRegistro,
            String descripcion
    ) {

        String sql = """
            INSERT INTO auditoria (
                id_usuario,
                modulo,
                accion,
                id_registro,
                descripcion,
                fecha_hora
            )
            VALUES (?, ?, ?, ?, ?, NOW())
            """;

        try (
                Connection cn = Conexion.conectar();
                PreparedStatement ps = cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idUsuario);
            ps.setString(2, modulo);
            ps.setString(3, accion);
            ps.setInt(4, idRegistro);
            ps.setString(5, descripcion);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL REGISTRAR AUDITORÍA: "
                    + e.getMessage()
            );

            return false;
        }
    }

    // =====================================================
    // MAPEAR RESULTADO A OBJETO AUDITORIA
    // =====================================================

    private Auditoria mapearAuditoria(ResultSet rs)
            throws Exception {

        Auditoria auditoria = new Auditoria();

        auditoria.setIdAuditoria(
                rs.getInt("id_auditoria")
        );

        auditoria.setIdUsuario(
                rs.getInt("id_usuario")
        );

        auditoria.setModulo(
                rs.getString("modulo")
        );

        auditoria.setAccion(
                rs.getString("accion")
        );

        auditoria.setIdRegistro(
                rs.getInt("id_registro")
        );

        auditoria.setDescripcion(
                rs.getString("descripcion")
        );

        auditoria.setFechaHora(
                rs.getString("fecha_hora")
        );

        return auditoria;
    }
}