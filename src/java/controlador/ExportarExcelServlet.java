
package controlador;

import dao.PagoDAO;
import modelo.Pago;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

@WebServlet(
    name = "ExportarExcelServlet",
    urlPatterns = {"/ExportarExcelServlet"}
)
public class ExportarExcelServlet extends HttpServlet {

    private final PagoDAO pagoDAO = new PagoDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==============================
        // RECIBIR FECHAS DEL FORMULARIO
        // ==============================

        String fechaInicio = request.getParameter(
            "fechaInicio"
        );

        String fechaFin = request.getParameter(
            "fechaFin"
        );

        if (fechaInicio == null
                || fechaFin == null
                || fechaInicio.trim().isEmpty()
                || fechaFin.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Debe seleccionar la fecha inicial y final."
            );

            return;
        }

        fechaInicio = fechaInicio.trim();
        fechaFin = fechaFin.trim();

        if (fechaInicio.compareTo(fechaFin) > 0) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "La fecha inicial no puede ser mayor que la fecha final."
            );

            return;
        }

        // ==============================
        // OBTENER PAGOS DEL PERIODO
        // ==============================

        List<Pago> pagos = pagoDAO.listarPagosPorFechas(
            fechaInicio,
            fechaFin
        );

        try (Workbook libro = new XSSFWorkbook()) {

            Sheet hoja = libro.createSheet(
                "Reporte de Pagos"
            );

            // ==============================
            // CONFIGURACIÓN DE COLUMNAS
            // ==============================

            int[] anchos = {
                22, 18, 30, 18, 15, 16, 20, 22
            };

            for (int i = 0; i < anchos.length; i++) {

                hoja.setColumnWidth(
                    i,
                    anchos[i] * 256
                );
            }

            // ==============================
            // FUENTES
            // ==============================

            Font fuenteTitulo = libro.createFont();

            fuenteTitulo.setBold(true);
            fuenteTitulo.setFontHeightInPoints(
                (short) 16
            );

            Font fuenteEncabezado =
                    libro.createFont();

            fuenteEncabezado.setBold(true);

            fuenteEncabezado.setColor(
                IndexedColors.WHITE.getIndex()
            );

            // ==============================
            // ESTILO DEL TITULO
            // ==============================

            CellStyle estiloTitulo =
                    libro.createCellStyle();

            estiloTitulo.setFont(
                fuenteTitulo
            );

            estiloTitulo.setAlignment(
                HorizontalAlignment.CENTER
            );

            estiloTitulo.setVerticalAlignment(
                VerticalAlignment.CENTER
            );

            estiloTitulo.setWrapText(true);

            // ==============================
            // ESTILO DE ENCABEZADOS
            // ==============================

            CellStyle estiloEncabezado =
                    libro.createCellStyle();

            estiloEncabezado.setFont(
                fuenteEncabezado
            );

            estiloEncabezado.setFillForegroundColor(
                IndexedColors.DARK_BLUE.getIndex()
            );

            estiloEncabezado.setFillPattern(
                FillPatternType.SOLID_FOREGROUND
            );

            estiloEncabezado.setAlignment(
                HorizontalAlignment.CENTER
            );

            estiloEncabezado.setVerticalAlignment(
                VerticalAlignment.CENTER
            );

            estiloEncabezado.setWrapText(true);

            estiloEncabezado.setBorderBottom(
                BorderStyle.THIN
            );

            // ==============================
            // ESTILO DE MONTOS
            // ==============================

            CellStyle estiloMonto =
                    libro.createCellStyle();

            estiloMonto.setDataFormat(
                libro.createDataFormat()
                    .getFormat("\"S/ \"#,##0.00")
            );

            // ==============================
            // ESTILO DE INFORMACIÓN
            // ==============================

            CellStyle estiloInformacion =
                    libro.createCellStyle();

            estiloInformacion.setWrapText(true);

            estiloInformacion.setVerticalAlignment(
                VerticalAlignment.CENTER
            );

            // ==============================
            // INSERTAR LOGO
            // ==============================

            InputStream imagen =
                    getServletContext()
                        .getResourceAsStream(
                            "/img/logo-stellar-facturas.jpg"
                        );

            if (imagen != null) {

                byte[] bytes =
                        IOUtils.toByteArray(imagen);

                int imagenId =
                        libro.addPicture(
                            bytes,
                            Workbook.PICTURE_TYPE_JPEG
                        );

                imagen.close();

                CreationHelper helper =
                        libro.getCreationHelper();

                ClientAnchor anchor =
                        helper.createClientAnchor();

                anchor.setCol1(0);
                anchor.setRow1(0);
                anchor.setCol2(2);
                anchor.setRow2(4);

                hoja.createDrawingPatriarch()
                    .createPicture(
                        anchor,
                        imagenId
                    );
            }

            // ==============================
            // TITULO DEL REPORTE
            // ==============================

            hoja.addMergedRegion(
                new CellRangeAddress(
                    0,
                    3,
                    2,
                    7
                )
            );

            Row filaTitulo = hoja.getRow(1);

            if (filaTitulo == null) {

                filaTitulo = hoja.createRow(1);
            }

            Cell celdaTitulo =
                    filaTitulo.createCell(2);

            celdaTitulo.setCellValue(
                "GRUPO STELLAR\n"
                + "REPORTE DE PAGOS POR PERIODO"
            );

            celdaTitulo.setCellStyle(
                estiloTitulo
            );

            filaTitulo.setHeightInPoints(
                60
            );

            // ==============================
            // LEMA
            // ==============================

            Row filaLema =
                    hoja.createRow(4);

            Cell celdaLema =
                    filaLema.createCell(0);

            celdaLema.setCellValue(
                "Grupo Stellar - Conectamos tu mundo."
            );

            // ==============================
            // PERIODO SELECCIONADO
            // ==============================

            Row filaPeriodo =
                    hoja.createRow(5);

            Cell celdaPeriodo =
                    filaPeriodo.createCell(0);

            celdaPeriodo.setCellValue(
                "Periodo: "
                + fechaInicio
                + " hasta "
                + fechaFin
            );

            // ==============================
            // RESUMEN
            // ==============================

            int filaInicio = 6;

            Row filaResumen =
                    hoja.createRow(filaInicio);

            filaResumen.createCell(0)
                .setCellValue(
                    "Total de pagos:"
                );

            filaResumen.createCell(1)
                .setCellValue(
                    pagos.size()
                );

            
double total = 0;

double totalYape = 0;
double totalPlin = 0;
double totalEfectivo = 0;
double totalTransferencia = 0;
double totalDeposito = 0;

for (Pago pago : pagos) {

    total += pago.getMonto();

    String metodo = pago.getMetodoPago();

    if (metodo != null) {

        if (metodo.equalsIgnoreCase("Yape")) {

            totalYape += pago.getMonto();

        } else if (metodo.equalsIgnoreCase("Plin")) {

            totalPlin += pago.getMonto();

        } else if (metodo.equalsIgnoreCase("Efectivo")) {

            totalEfectivo += pago.getMonto();

        } else if (metodo.equalsIgnoreCase("Transferencia")) {

            totalTransferencia += pago.getMonto();

        } else if (metodo.equalsIgnoreCase("Depósito")
                || metodo.equalsIgnoreCase("Deposito")) {

            totalDeposito += pago.getMonto();
        }
    }
}

            filaResumen.createCell(3)
                .setCellValue(
                    "Total recaudado:"
                );

            Cell celdaTotal =
                    filaResumen.createCell(4);

            celdaTotal.setCellValue(total);

            celdaTotal.setCellStyle(
                estiloMonto
            );
            
 // ==============================
 // TOTALES POR MÉTODO DE PAGO
 // ==============================

Row filaMetodos = hoja.createRow(7);

filaMetodos.createCell(0)
    .setCellValue("Yape:");

Cell celdaYape = filaMetodos.createCell(1);

celdaYape.setCellValue(totalYape);

celdaYape.setCellStyle(estiloMonto);


filaMetodos.createCell(2)
    .setCellValue("Plin:");

Cell celdaPlin = filaMetodos.createCell(3);

celdaPlin.setCellValue(totalPlin);

celdaPlin.setCellStyle(estiloMonto);


filaMetodos.createCell(4)
    .setCellValue("Efectivo:");

Cell celdaEfectivo = filaMetodos.createCell(5);

celdaEfectivo.setCellValue(totalEfectivo);

celdaEfectivo.setCellStyle(estiloMonto);


Row filaMetodos2 = hoja.createRow(8);

filaMetodos2.createCell(0)
    .setCellValue("Transferencia:");

Cell celdaTransferencia = filaMetodos2.createCell(1);

celdaTransferencia.setCellValue(totalTransferencia);

celdaTransferencia.setCellStyle(estiloMonto);


filaMetodos2.createCell(2)
    .setCellValue("Depósito:");

Cell celdaDeposito = filaMetodos2.createCell(3);

celdaDeposito.setCellValue(totalDeposito);

celdaDeposito.setCellStyle(estiloMonto);

            // ==============================
            // ENCABEZADOS DE TABLA
            // ==============================

           int filaCabecera = 10;

            Row encabezado =
                    hoja.createRow(filaCabecera);

            String[] columnas = {

                "Código de pago",
                "Código cliente",
                "Cliente",
                "Fecha de pago",
                "Periodo",
                "Monto",
                "Método de pago",
                "N.º operación"
            };

            for (int i = 0; i < columnas.length; i++) {

                Cell celda =
                        encabezado.createCell(i);

                celda.setCellValue(
                    columnas[i]
                );

                celda.setCellStyle(
                    estiloEncabezado
                );
            }

            encabezado.setHeightInPoints(
                30
            );

            // ==============================
            // REGISTROS DE PAGOS
            // ==============================

            int filaActual = 11;

            for (Pago pago : pagos) {

                Row fila =
                        hoja.createRow(filaActual++);

                Cell codigoPago =
                        fila.createCell(0);

                codigoPago.setCellValue(
                    pago.getCodigoPago()
                );

                codigoPago.setCellStyle(
                    estiloInformacion
                );

                Cell codigoCliente =
                        fila.createCell(1);

                codigoCliente.setCellValue(
                    pago.getCodigoCliente()
                );

                codigoCliente.setCellStyle(
                    estiloInformacion
                );

                Cell cliente =
                        fila.createCell(2);

                cliente.setCellValue(
                    pago.getNombreCliente()
                );

                cliente.setCellStyle(
                    estiloInformacion
                );

                Cell fechaPago =
                        fila.createCell(3);

                fechaPago.setCellValue(
                    pago.getFechaPago()
                );

                fechaPago.setCellStyle(
                    estiloInformacion
                );

                Cell periodo =
                        fila.createCell(4);

                periodo.setCellValue(
                    pago.getPeriodo()
                );

                periodo.setCellStyle(
                    estiloInformacion
                );

                Cell monto =
                        fila.createCell(5);

                monto.setCellValue(
                    pago.getMonto()
                );

                monto.setCellStyle(
                    estiloMonto
                );

                Cell metodo =
                        fila.createCell(6);

                metodo.setCellValue(
                    pago.getMetodoPago()
                );

                metodo.setCellStyle(
                    estiloInformacion
                );

                Cell operacion =
                        fila.createCell(7);

                operacion.setCellValue(
                    pago.getNumeroOperacion()
                );

                operacion.setCellStyle(
                    estiloInformacion
                );
            }

            // ==============================
            // FILTRO DE TABLA
            // ==============================

            if (filaActual > 9) {

                hoja.setAutoFilter(
                    new CellRangeAddress(
                        8,
                        filaActual - 1,
                        0,
                        7
                    )
                );
            }

            // ==============================
            // CONGELAR ENCABEZADOS
            // ==============================

            hoja.createFreezePane(
    0,
    11
);

            // ==============================
            // CONFIGURAR DESCARGA
            // ==============================

            response.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            );

            response.setHeader(
                "Content-Disposition",
                "attachment; filename=Reporte_Grupo_Stellar.xlsx"
            );

            libro.write(
                response.getOutputStream()
            );

            response.getOutputStream().flush();

        } catch (Exception e) {

            e.printStackTrace();

            if (!response.isCommitted()) {

                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error al generar el reporte Excel."
                );
            }
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}