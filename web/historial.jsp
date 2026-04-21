<%@page import="dao.HistorialDao"%>
<%@page import="clasesGenericas.ConectorBD"%>
<%@page import="java.sql.*"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="clases.Persona"%>
<link rel="stylesheet" type="text/css" href="presentacion/planilla.css">

<%
    HttpSession sesion = request.getSession();
    Persona usuario = (Persona) sesion.getAttribute("usuariot");
    
    
    if (usuario == null || !"A".equals(usuario.getRol())) {
        out.println("<h3>No tienes permisos para ver esta página.</h3>");
        return;
    }

    ConectorBD conector = new ConectorBD();
    conector.conectar();

    String sql = "SELECT h.*, p.nombres, pl.numeroPlanilla " +
                 "FROM HistorialAcciones h " +
                 "JOIN Persona p ON h.idUsuario = p.identificacion " +
                 "LEFT JOIN Planilla pl ON h.idPlanilla = pl.id " +
                 "ORDER BY h.fechaHora DESC";

    ResultSet rs = conector.consultar(sql);
%>
<img src="presentacion/dyd.png" alt="Logo del club" class="logos-derecha">
<center><h2>HISTORIAL</h2></center>
<form method="post" action="historialActualizar.jsp" onsubmit="return confirm('¿Estás seguro que deseas eliminar TODO el historial?');">
    <input type="hidden" name="accion" value="eliminarTodo">
    <button type="submit">Borrar historial</button>
</form>

<table border="1" cellpadding="5">
    <tr>
        <th>Usuario</th>
        <th>Nombre</th>
        <th>Acción</th>
        <th>Número de Planilla</th>
        <th>Fecha y Hora</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("idUsuario") %></td>
        <td><%= rs.getString("nombres") %></td>
        <td><%= rs.getString("accion") %></td>
        <td><%= rs.getString("numeroPlanilla") != null ? rs.getString("numeroPlanilla") : "N/A" %></td>
        <td><%= rs.getString("fechaHora") %></td>
    </tr>
<%
    }
    conector.desconectar();
%>
</table>
