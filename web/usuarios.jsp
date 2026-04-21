<%@page import="java.util.List"%>
<%@page import="clases.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="presentacion/planilla.css">
<%
    String lista = "";
    List<Persona> datos = Persona.getListaEnObjetos("rol<>'C'", null);
    for (int i = 0; i < datos.size(); i++) {
        Persona usuario = datos.get(i);
        lista += "<tr>";
        lista += "<td>" + usuario.getIdentificacion() + "</td>";
        lista += "<td>" + usuario.getNombres() + "</td>";
        lista += "<td>" + usuario.getDireccion() + "</td>";
        lista += "<td>" + usuario.getTelefono() + "</td>";
        lista += "<td>" + usuario.getEmail() + "</td>";
        lista += "<td>" + usuario.getTipoEnObjeto() + "</td>";
        lista += "<td>" + usuario.getRutaExcel()+ "</td>";
        
        
        /*if (usuario.getRol().equals("E")) {
            lista += "<td>";
            lista += "<a href='fichaTecnicaEntrenador.jsp?identificacion=" + usuario.getIdentificacion() + "' title='Ficha Técnica'>";
            lista += "<img src='presentacion/imagenes/fichaE.png'></a>"; 
            lista += "</td>";
        } else {
            lista += "<td></td>"; 
        }*/

        lista += "<td>";
        lista += "<a href='principal.jsp?CONTENIDO=usuariosFormulario.jsp&accion=Modificar&identificacion=" + usuario.getIdentificacion() + "' title='Modificar'><img src='presentacion/imagenes/modificar.png'></a>";
        lista += "<img src='presentacion/imagenes/eliminar.png' style=' title='Eliminar' onClick='eliminar(" + usuario.getIdentificacion() + ")'>";
        lista += "</td>";
        lista += "</tr>";
    }
%>
<img src="presentacion/dyd.png" alt="Logo del club" class="logos-derecha">
<p>
<table border="1">
    <tr>
        <th>Zona Vendedor</th>
        <th>Nombres</th>
        <th>Direccion servidor</th>
        <th>Telefono</th>
        <th>Email</th>
        <th>Tipo</th>   
        <th>Ruta carpeta</th>   
        <th>
            <a href="principal.jsp?CONTENIDO=usuariosFormulario.jsp&accion=Adicionar" title="Adicionar">
                <img src="presentacion/imagenes/agregarC.png">
            </a>
        </th>  
    </tr>
    <%= lista %>
</table>

<script type="text/javascript">
    function eliminar(identificacion) {
        resultado = confirm("¿Realmente desea eliminar el usuario con identificación " + identificacion + "?");
        if (resultado) {
            document.location = "principal.jsp?CONTENIDO=usuarioActualizar.jsp&accion=Eliminar&identificacion=" + identificacion;
        }
    }
</script>
