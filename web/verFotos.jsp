<%@page import="clases.Planilla"%>
<%@page import="java.util.List"%>
<%@page import="clases.FotosPlanilla"%>
<link rel="stylesheet" type="text/css" href="presentacion/fotos.css">
<%
    String idPlanilla = request.getParameter("id"); 
    
    // Obtener la información de la planilla
    Planilla planilla = new Planilla();
planilla.cargarPorId(idPlanilla);

    
    // Lista de imágenes asociadas a la planilla
    List<FotosPlanilla> fotos = FotosPlanilla.obtenerFotosPorPlanilla(idPlanilla);
%>
<!-- Encabezado de la Planilla -->
<h2>Información de la Planilla</h2>
<table border="1">
    <tr>
        <th>Número de Planilla</th>
        <th>Código Vendedor</th>
        <th>Nombre Vendedor</th>
        <th>Fecha</th>
        <th>Número Semana</th>
        <th>Población</th>
    </tr>
    <tr>
        <td><%= planilla.getNumeroPlanilla() %></td>
        <td><%= planilla.getCodigoVendedor() %></td>
        <td><%= planilla.getNombreV() %></td>
        <td><%= planilla.getFecha() %></td>
        <td><%= planilla.getNumeroSemana() %></td>
        <td><%= planilla.getPoblacion() %></td>
    </tr>
</table>

<h3>Comprobante y recibo</h3>
<% for (FotosPlanilla foto : fotos) { %>
    <img src="/descargas/<%= foto.getRutaFoto().substring(foto.getRutaFoto().lastIndexOf("\\") + 1) %>" width="200">
   
<% } %>
