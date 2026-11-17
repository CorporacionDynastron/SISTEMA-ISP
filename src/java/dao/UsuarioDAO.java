package dao;

import conexion.Conexion;
import modelo.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    public Usuario validarUsuario(String usuario, String password) {

        Usuario usuarioEncontrado = null;

        String sql = """
            SELECT *
            FROM usuarios
            WHERE usuario = ?
            AND password = ?
            AND estado = 'ACTIVO'
            """;

        try {

            Connection cn = Conexion.conectar();

            PreparedStatement ps =
                    cn.prepareStatement(sql);

            ps.setString(1, usuario);
            ps.setString(2, password);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                usuarioEncontrado = new Usuario();

                usuarioEncontrado.setIdUsuario(
                        rs.getInt("id_usuario")
                );

                usuarioEncontrado.setUsuario(
                        rs.getString("usuario")
                );

                usuarioEncontrado.setPassword(
                        rs.getString("password")
                );

                usuarioEncontrado.setNombres(
                        rs.getString("nombres")
                );

                usuarioEncontrado.setRol(
                        rs.getString("rol")
                );

                usuarioEncontrado.setEstado(
                        rs.getString("estado")
                );
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR VALIDAR USUARIO: "
                    + e.getMessage()
            );
        }

        return usuarioEncontrado;
    }
}