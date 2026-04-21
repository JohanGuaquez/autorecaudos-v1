<%@page import="dao.HistorialDao"%>
<%@page import="clases.Persona"%>
<%
    String accion = request.getParameter("accion");

    if ("eliminarTodo".equals(accion)) {
        try {
            HistorialDao.eliminarTodo();
            //out.print("<script>alert('Historial eliminado exitosamente.'); location.href='historial.jsp';</script>");
        } catch (Exception e) {
            out.print("<script>alert('Error al eliminar el historial: " + e.getMessage() + "'); location.href='historial.jsp';</script>");
        }
    } else {
        String idPlanillaStr = request.getParameter("idPlanilla");

        if (idPlanillaStr != null && !idPlanillaStr.isEmpty()) {
            int idPlanilla = Integer.parseInt(idPlanillaStr);
            HttpSession sesion = request.getSession();
            Persona usuario = (Persona) sesion.getAttribute("usuariot");

            if (usuario != null && !"V".equals(usuario.getRol())) {
                HistorialDao.registrar(usuario.getIdentificacion(), accion, idPlanilla);
            }
        } else {
            //out.print("<script>alert('ID de planilla no válido.'); location.href='historial.jsp';</script>");
        }
    }
%>
<script type="text/javascript">
    document.location = "principal.jsp?CONTENIDO=historial.jsp";
</script>

