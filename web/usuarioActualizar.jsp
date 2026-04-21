
<%@page import="clases.Persona"%>
<%
String accion = request.getParameter("accion");
String identificacionAnterior = request.getParameter("identificacionAnterior");

Persona usuario = new Persona();
usuario.setIdentificacion(request.getParameter("identificacion"));
usuario.setNombres(request.getParameter("nombres"));
usuario.setDireccion(request.getParameter("direccion")); // Asegúrate de capturar la dirección si es necesaria
usuario.setTelefono(request.getParameter("telefono"));
usuario.setEmail(request.getParameter("email")); // Captura la fecha de retiro si es necesaria
usuario.setRol(request.getParameter("tipo"));
usuario.setRutaExcel(request.getParameter("rutaExcel"));
usuario.setClave(request.getParameter("clave"));// Asumiendo que 'tipo' se refiere al rol

switch (accion) {
    case "Adicionar":
        usuario.grabar();
        break;
    case "Modificar":
        usuario.modificar(identificacionAnterior);
        break;
    case "Eliminar":
        usuario.eliminar();
        break;
}
%>
<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=usuarios.jsp";
</script>
