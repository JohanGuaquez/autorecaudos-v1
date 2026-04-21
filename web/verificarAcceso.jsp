<%-- 
    Document   : verificarAcceso
    Created on : 6/03/2025, 08:32:48 AM
    Author     : DELL
--%>
<%@page import="java.io.File"%>
<%
File carpeta = new File("Z:\\RECAUDOS PIMOVIL\\RECAUDO ENE HASTA DIC 2025\\EDUARDO OCANA 0001");
if (!carpeta.exists() || !carpeta.isDirectory()) {
    response.sendError(HttpServletResponse.SC_NOT_FOUND, "La carpeta del vendedor no existe.");
    return;
}
%>