

package servlets;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.util.IOUtils;
import clases.FotosPlanilla;
import clases.Persona;

@WebServlet("/expPlanilla")
public class expPlanilla extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  
String idPlanilla = request.getParameter("id");

String rutaCarpeta = Persona.obtenerRutaExcelPorIdPlanilla(idPlanilla);

if (rutaCarpeta == null || rutaCarpeta.isEmpty()) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró la carpeta del vendedor para la planilla.");
    return;
}

File carpeta = new File(rutaCarpeta);
if (!carpeta.exists() || !carpeta.isDirectory()) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "La carpeta del vendedor no existe.");
    return;
}

File[] archivosExcel = carpeta.listFiles((dir, name) -> name.toLowerCase().endsWith(".xlsm"));

if (archivosExcel == null || archivosExcel.length == 0) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró ningún archivo Excel en la carpeta.");
    return;
}

File archivoExcel = archivosExcel[0];
String rutaExcel = archivoExcel.getAbsolutePath();

System.out.println("Archivo Excel encontrado: " + rutaExcel);

Path excelFilePath = Paths.get(rutaExcel);
if (!Files.exists(excelFilePath)) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "El archivo Excel no existe en la ruta proporcionada.");
    return;
}


        try (FileInputStream fis = new FileInputStream(excelFilePath.toFile());
             Workbook workbook = new XSSFWorkbook(fis)) {

            Sheet sheet = workbook.getSheet("Fotos");
            if (sheet == null) {
                sheet = workbook.createSheet("Fotos");
            }

            List<FotosPlanilla> fotos = FotosPlanilla.obtenerFotosPorPlanilla(idPlanilla);
            if (fotos.isEmpty()) {
                response.getWriter().write("No hay imágenes para agregar.");
                return;
            }

            // Obtener la dirección usando el ID de la planilla
String direccion = Persona.obtenerDireccionPorIdPlanilla(idPlanilla);

if (direccion == null) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró la dirección del vendedor.");
    return;
}

// Insertar la dirección en la hoja de Excel junto con las imágenes
// Insertar la dirección una sola vez en la celda A1 (fila 0, columna 0)
if (sheet.getRow(0) == null) {
    sheet.createRow(0);
}
sheet.getRow(0).createCell(0).setCellValue(direccion); // A1

// Insertar las imágenes en la hoja de Excel
Drawing<?> drawing = sheet.createDrawingPatriarch();
int rowIndex = sheet.getLastRowNum() + 1; // Comienza después de la última fila usada

for (FotosPlanilla foto : fotos) {
    try (FileInputStream inputStream = new FileInputStream(foto.getRutaFoto())) {
        byte[] bytes = IOUtils.toByteArray(inputStream);
        int pictureIdx = workbook.addPicture(bytes, Workbook.PICTURE_TYPE_JPEG);
        CreationHelper helper = workbook.getCreationHelper();
        ClientAnchor anchor = helper.createClientAnchor();
        anchor.setCol1(0);
        anchor.setRow1(rowIndex);
        Picture pict = drawing.createPicture(anchor, pictureIdx);

        if (sheet.getRow(rowIndex) == null) {
            sheet.createRow(rowIndex);
        }
        sheet.getRow(rowIndex).setHeightInPoints(15);
        pict.resize();

        rowIndex++;
    } catch (Exception e) {
        System.err.println("Error al procesar la imagen: " + e.getMessage());
    }
}

            try (FileOutputStream fos = new FileOutputStream(excelFilePath.toFile())) {
                workbook.write(fos);
            }

            // Responder con éxito
            response.setContentType("text/plain");
            response.getWriter().write("Imágenes agregadas exitosamente a " + excelFilePath.getFileName());
        }
        response.sendRedirect("principal.jsp?CONTENIDO=generarPlanilla.jsp");
    }
}


