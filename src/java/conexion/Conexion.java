package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL =
            "jdbc:mysql://localhost:3306/sistema_isp?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USER = "isp_admin";

    private static final String PASSWORD = "Dynastron2026_ISP";

    public static Connection conectar() {

        Connection conexion = null;

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            try {
                conexion = DriverManager.getConnection(
                        URL,
                        USER,
                        PASSWORD
                );
            } catch (SQLException e) {
                // Fallback para entorno local de desarrollo (XAMPP / root sin password)
                conexion = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/sistema_isp",
                        "root",
                        ""
                );
            }

        } catch (ClassNotFoundException e) {

            System.out.println(
                    "ERROR: No se encontro el driver de MySQL"
            );

        } catch (SQLException e) {

            System.out.println(
                    "ERROR DE CONEXION: " + e.getMessage()
            );
        }

        return conexion;
    }
}
