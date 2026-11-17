package dao;

import conexion.Conexion;
import modelo.Plan;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PlanDAO {

    // ==========================================
    // LISTAR PLANES
    // ==========================================

    public List<Plan> listar() {

        List<Plan> lista =
                new ArrayList<>();

        String sql = """
            SELECT *
            FROM planes
            WHERE estado = 'ACTIVO'
            ORDER BY precio ASC
            """;

        try {

            Connection cn =
                    Conexion.conectar();

            PreparedStatement ps =
                    cn.prepareStatement(sql);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Plan plan =
                        new Plan();

                plan.setIdPlan(
                        rs.getInt("id_plan")
                );

                plan.setNombrePlan(
                        rs.getString("nombre_plan")
                );

                plan.setVelocidad(
                        rs.getString("velocidad")
                );

                plan.setPrecio(
                        rs.getDouble("precio")
                );

                plan.setDescripcion(
                        rs.getString("descripcion")
                );

                plan.setEstado(
                        rs.getString("estado")
                );

                lista.add(plan);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (Exception e) {

            System.out.println(
                    "ERROR AL LISTAR PLANES: "
                    + e.getMessage()
            );
        }

        return lista;
    }
}