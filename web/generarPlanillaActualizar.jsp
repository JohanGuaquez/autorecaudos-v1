<%@page import="clases.Persona"%>
<%@page import="dao.HistorialDao"%>
<%@page import="java.sql.SQLException"%>
<%@page import="clasesGenericas.ConectorBD"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletRequestContext"%>
<%@page import="clases.Planilla"%>
<%@page import="clases.FotosPlanilla"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.io.File"%>

<%
    boolean subioArchivo = false;
    Map<String, String> variables = new HashMap<>();
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    List<String> fotosSubidas = new ArrayList<>(); 

    if (!isMultipart) {
        variables.put("accion", request.getParameter("accion"));
        variables.put("id", request.getParameter("id"));
    } else {
        // Ruta externa para almacenar imágenes
        String rutaBase = "C:\\Users\\DELL\\Desktop\\Apache Software Foundation\\Tomcat 9.0\\webapps\\descargas"; // Cambiar según el sistema operativo
        File destino = new File(rutaBase);
        if (!destino.exists()) {
            destino.mkdirs(); // Crear la carpeta si no existe
        }

        DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, destino);
        ServletFileUpload upload = new ServletFileUpload(factory);
        ServletRequestContext origen = new ServletRequestContext(request);

        try {
            List<FileItem> elementosFormulario = upload.parseRequest(origen);
            Iterator<FileItem> iterador = elementosFormulario.iterator();
            while (iterador.hasNext()) {
                FileItem elemento = iterador.next();
                if (elemento.isFormField()) {
                    variables.put(elemento.getFieldName(), elemento.getString());
                } else {
                    if (!elemento.getName().isEmpty()) {
                        subioArchivo = true;
                        
                        // Generar nombre único para evitar sobrescritura
                        String nombreUnico = System.currentTimeMillis() + "_" + elemento.getName();
                        File archivo = new File(destino, nombreUnico);
                        elemento.write(archivo); 
                        
                        fotosSubidas.add(nombreUnico); 
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error al procesar el archivo: " + e.getMessage());
        }
    }

    // Crear objeto Planilla y asignar valores
    Planilla planilla = new Planilla();
    planilla.setId(variables.get("id"));
    planilla.setNumeroPlanilla(variables.get("numeroPlanilla"));
    planilla.setCodigoVendedor(variables.get("codigoVendedor"));
    planilla.setNombreVendedor(variables.get("nombreVendedor"));
    planilla.setFecha(variables.get("fecha"));
    planilla.setNumeroSemana(variables.get("numeroSemana"));
    planilla.setPoblacion(variables.get("poblacion"));
    planilla.setNota(variables.get("nota"));
    //planilla.setEstado(Integer.parseInt(variables.get("estado")));


    String accion = variables.get("accion");

    if ("Eliminar".equals(accion)) {
    Persona usuario = (Persona) session.getAttribute("usuariot");
    HistorialDao.registrar(
        usuario.getIdentificacion(),
        "Se elimino una planilla",
        Integer.parseInt(planilla.getId())); // Aún existe

    boolean eliminado = planilla.eliminar();

    if (eliminado) {
        response.sendRedirect("principal.jsp?CONTENIDO=generarPlanillaFormulario.jsp&accion=Adicionar");
    } else {
        out.println("Error al eliminar la planilla.");
    }    
         
    } else if ("Adicionar".equals(accion)) {
        planilla.grabar(); 
        
        Persona usuario = (Persona) session.getAttribute("usuariot");
             HistorialDao.registrar(
             usuario.getIdentificacion(),
             "Se agrego planilla" ,
            Integer.parseInt(planilla.getId())
            );

        for (String foto : fotosSubidas) {
            FotosPlanilla fotosPlanilla = new FotosPlanilla();
            fotosPlanilla.setIdPlanilla(planilla.getId()); 
            fotosPlanilla.setRutaFoto("C:\\\\Users\\\\DELL\\\\Desktop\\\\Apache Software Foundation\\\\Tomcat 9.0\\\\webapps\\\\descargas\\\\" + foto);// Guardar ruta completa
            fotosPlanilla.grabar();

        }      
} else if ("cambiarEstado".equals(accion)) { 
    
    try {    
        String idParam = request.getParameter("id");
        String estadoParam = request.getParameter("estado");

        System.out.println(" ID recibido: " + idParam);
        System.out.println(" Estado recibido: " + estadoParam);

       
        if (idParam == null || estadoParam == null || idParam.isEmpty() || estadoParam.isEmpty()) {
            out.print("ERROR_PARAMETROS");
            return;
        }

        int id = Integer.parseInt(idParam);
        int estado = Integer.parseInt(estadoParam);  
      
        planilla.setId(String.valueOf(id));

        boolean actualizado = planilla.cambiarEstado(estado);  

        if (actualizado) {
            // Enviar solo "OK" sin espacios extra
         Persona usuario = (Persona) session.getAttribute("usuariot");
         HistorialDao.registrar(
         usuario.getIdentificacion(),
         "Se realizo cambios en la planilla",
         Integer.parseInt(planilla.getId()));

            out.print("OK");
            out.flush(); // Asegurar que se envíe inmediatamente
            return;
        } else {
            out.print("ERROR: No se actualizó ninguna fila");
            return;
        }

    } catch (NumberFormatException e) {
        out.print("ERROR_CONVERSION: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.print("ERROR_GENERAL: " + e.getMessage());
        e.printStackTrace();
    }
}

%>

<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=generarPlanillaFormulario.jsp&accion=Adicionar";
</script>
