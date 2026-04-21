package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.jacob.com.Dispatch;
import com.jacob.com.Variant;
import com.jacob.activeX.ActiveXComponent;
import com.jacob.com.LibraryLoader;
import java.io.IOException;

@WebServlet("/MacroExecute")
public class MacroExecute extends HttpServlet {

    private static boolean jacobLoaded = false; // Bandera para evitar carga duplicada

    static {
        if (!jacobLoaded) {
            System.setProperty("jacob.dll.path", "C:\\libs\\jacob\\jacob-1.21-x64.dll");
            LibraryLoader.loadJacobLibrary(); // Cargar solo si no está cargado
            jacobLoaded = true;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ActiveXComponent excel = null;
        Dispatch workbook = null;

        try {
            // Iniciar Excel en modo invisible (para ejecutar la macro en segundo plano)
            excel = new ActiveXComponent("Excel.Application");
            excel.setProperty("Visible", new Variant(false));

            // Abrir el archivo
            Dispatch workbooks = excel.getProperty("Workbooks").toDispatch();
            workbook = Dispatch.call(workbooks, "Open", "C:\\GENERAR RECAUDOS\\GENERAR RECAUDOS.xlsm").toDispatch();

            // Ejecutar macro
            Dispatch.call(excel, "Run", "Módulo1.macroPrincipal");

            // Guardar y cerrar el archivo
            Dispatch.call(workbook, "Save");
            Dispatch.call(workbook, "Close", false);

            System.out.println("Macro ejecutada correctamente.");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (excel != null) {
                    excel.invoke("Quit");  // Cerrar Excel en segundo plano
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Abrir una nueva instancia visible de Excel con el archivo
        try {
            ActiveXComponent excelVisible = new ActiveXComponent("Excel.Application");
            excelVisible.setProperty("Visible", new Variant(true)); // Mostrar Excel
            Dispatch workbooksVisible = excelVisible.getProperty("Workbooks").toDispatch();
            Dispatch.call(workbooksVisible, "Open", "C:\\GENERAR RECAUDOS\\GENERAR RECAUDOS.xlsm");
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirigir después de ejecutar la macro
        response.sendRedirect("principal.jsp?CONTENIDO=generarPlanilla.jsp");
    }
}
