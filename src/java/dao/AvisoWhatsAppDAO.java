
package dao;

import conexion.Conexion;
import modelo.AvisoWhatsApp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AvisoWhatsAppDAO {

    // =========================================================
    // MODO DE PRUEBA
    // =========================================================

    // true  = simula una fecha para probar los avisos.
    // false = utiliza la fecha real del sistema.
    private static final boolean MODO_PRUEBA = false;

    // Fecha para realizar pruebas.
    private static final String FECHA_PRUEBA = "2026-10-12";

    // =========================================================
    // LISTAR AVISOS DE WHATSAPP
    // =========================================================

    public List<AvisoWhatsApp> listarAvisos() {

        List<AvisoWhatsApp> lista = new ArrayList<>();

        String fechaActual = MODO_PRUEBA
                ? "'" + FECHA_PRUEBA + "'"
                : "CURDATE()";

        String sql = """
            SELECT
                c.id_cliente,
                c.telefono,
                c.codigo_cliente,
                CONCAT(c.nombres, ' ', c.apellidos)
                    AS nombre_cliente,

                q.id_cuota,
                q.periodo,
                q.fecha_generacion,
                q.fecha_emision,
                q.fecha_vencimiento,
                q.fecha_pago,
                q.monto,
                q.estado,

                CASE
                    WHEN %s > q.fecha_vencimiento
                    THEN DATEDIFF(
                        %s,
                        q.fecha_vencimiento
                    )
                    ELSE 0
                END AS dias_atraso,

                a.tipo_aviso

            FROM cuotas q

            INNER JOIN clientes c
                ON q.id_cliente = c.id_cliente

            INNER JOIN (
                -- 1. DIA DE EMISION
                SELECT
                    id_cuota,
                    'EMISION' AS tipo_aviso
                FROM cuotas
                WHERE fecha_emision = %s

                UNION ALL

                -- 2. DIA DE VENCIMIENTO
                SELECT
                    id_cuota,
                    'VENCIMIENTO' AS tipo_aviso
                FROM cuotas
                WHERE fecha_vencimiento = %s

                UNION ALL

                -- 3. TRES DIAS DESPUES DEL VENCIMIENTO
                SELECT
                    id_cuota,
                    'SUSPENSION' AS tipo_aviso
                FROM cuotas
                WHERE DATE_ADD(
                    fecha_vencimiento,
                    INTERVAL 3 DAY
                ) = %s

            ) a ON a.id_cuota = q.id_cuota

            WHERE q.estado IN ('PENDIENTE', 'VENCIDA')
              AND q.fecha_pago IS NULL
              AND c.estado <> 'RETIRADO'

            ORDER BY
                q.fecha_vencimiento ASC,
                c.apellidos ASC,
                c.nombres ASC,
                CASE a.tipo_aviso
                    WHEN 'EMISION' THEN 1
                    WHEN 'VENCIMIENTO' THEN 2
                    WHEN 'SUSPENSION' THEN 3
                    ELSE 4
                END ASC
            """.formatted(
                fechaActual,
                fechaActual,
                fechaActual,
                fechaActual,
                fechaActual
            );

        try (
            Connection cn = Conexion.conectar();
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                AvisoWhatsApp aviso = new AvisoWhatsApp();

                // DATOS DEL CLIENTE
                aviso.setIdCliente(rs.getInt("id_cliente"));
                aviso.setIdCuota(rs.getInt("id_cuota"));

                aviso.setCodigoCliente(
                    rs.getString("codigo_cliente")
                );

                aviso.setNombreCliente(
                    rs.getString("nombre_cliente")
                );

                aviso.setTelefono(
                    rs.getString("telefono")
                );

                // DATOS DE LA CUOTA
                aviso.setPeriodo(
                    rs.getString("periodo")
                );

                aviso.setFechaGeneracion(
                    rs.getString("fecha_generacion")
                );

                aviso.setFechaEmision(
                    rs.getString("fecha_emision")
                );

                aviso.setFechaVencimiento(
                    rs.getString("fecha_vencimiento")
                );

                aviso.setMonto(
                    rs.getDouble("monto")
                );

                aviso.setEstado(
                    rs.getString("estado")
                );

                // DATOS DEL AVISO
                aviso.setDiasAtraso(
                    rs.getInt("dias_atraso")
                );

                aviso.setTipoAviso(
                    rs.getString("tipo_aviso")
                );

                // MENSAJE PARA WHATSAPP
                aviso.setMensaje(
                    generarMensaje(aviso)
                );

                lista.add(aviso);
            }

        } catch (Exception e) {

            System.out.println(
                "ERROR AL LISTAR AVISOS WHATSAPP: "
                + e.getMessage()
            );

            e.printStackTrace();
        }

        return lista;
    }

    // =========================================================
    // GENERAR MENSAJE PARA WHATSAPP
    // =========================================================

    private String generarMensaje(AvisoWhatsApp aviso) {

        String nombre = aviso.getNombreCliente();
        String fecha = aviso.getFechaVencimiento();

        String monto = String.format(
            java.util.Locale.US,
            "S/ %.2f",
            aviso.getMonto()
        );

        String tipo = aviso.getTipoAviso();

        StringBuilder mensaje = new StringBuilder();

        mensaje.append("Hola, ");
        mensaje.append(nombre);
        mensaje.append(" 👋\n\n");

        // 1. EMISION
        if ("EMISION".equalsIgnoreCase(tipo)) {

            mensaje.append(
                "Te informamos que se ha emitido tu recibo "
                + "de internet por "
                + monto
                + ".\n\n"
            );

            mensaje.append("Fecha de vencimiento: ");
            mensaje.append(fecha);

            mensaje.append(
                "\n\nPuedes realizar tu pago mediante "
                + "Yape, Plin, transferencia o efectivo."
            );
        }

        // 2. VENCIMIENTO
        else if ("VENCIMIENTO".equalsIgnoreCase(tipo)) {

            mensaje.append(
                "Te informamos que hoy vence tu recibo "
                + "de internet por "
                + monto
                + ".\n\n"
            );

            mensaje.append("Fecha de vencimiento: ");
            mensaje.append(fecha);

            mensaje.append(
                "\n\nTe recomendamos realizar tu pago "
                + "hoy para evitar retrasos y una posible "
                + "suspensión del servicio."
            );
        }

        // 3. AVISO DE SUSPENSION
        else if ("SUSPENSION".equalsIgnoreCase(tipo)) {

            mensaje.append(
                "Te informamos que tu recibo de internet "
                + "por "
                + monto
                + " continúa pendiente de pago.\n\n"
            );

            mensaje.append("Fecha de vencimiento: ");
            mensaje.append(fecha);

            mensaje.append("\nDías de atraso: ");
            mensaje.append(aviso.getDiasAtraso());

            mensaje.append(
                "\n\nDe acuerdo con las condiciones "
                + "del servicio, corresponde evaluar "
                + "la suspensión por falta de pago. "
                + "Por favor, regulariza tu deuda."
            );
        }

        // FIRMA
        mensaje.append("\n\nGrupo Stellar");
        mensaje.append("\n🌐 Conectamos tu mundo.");

        return mensaje.toString();
    }
}
