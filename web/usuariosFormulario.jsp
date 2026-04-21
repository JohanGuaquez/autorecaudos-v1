<%@page import="clases.Encriptador"%>
<%@page import="clases.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="presentacion/planilla.css">
<%
    String accion = request.getParameter("accion");
    String identificacion = request.getParameter("identificacion");
    String nuevaClave = request.getParameter("clave");
    String claveActual = request.getParameter("claveActual");
    Persona usuario;

    if ("Modificar".equals(accion)) {
        usuario = new Persona(identificacion);
    } else {
        usuario = new Persona(); // Adicionar o cualquier otra acción
    }

    if (nuevaClave != null && !nuevaClave.trim().isEmpty()) {
        usuario.setClave(Encriptador.encriptar(nuevaClave));
    } else {
        usuario.setClave(claveActual);
    }
%>

<center><h1><%=accion.toUpperCase()%> USUARIO</h1></center>
<form name="formulario" method="post" action="usuarioActualizar.jsp">
<img src="presentacion/dyd.png" alt="Logo del club" class="logos-derecha">
    
    <table border="0">
        <tr>
            <th>Identificación</th>
            <td><input type="text" name="identificacion" maxlength="12" value="<%=usuario.getIdentificacion().trim()%>" required></td>
        </tr>
        <tr>
            <th>Nombres</th>
            <td><input type="text" name="nombres" value="<%=usuario.getNombres()%>" size="50" maxlength="50" required></td>            
        </tr>
        <tr>
            <th>Dirección del servidor</th>
            <td>
                <input type="text" name="direccion" 
                       value="<%= (usuario.getDireccion() != null ? usuario.getDireccion().replace("\\", "\\\\") : "") %>"

                       size="50" maxlength="200">
            </td>
        </tr>
        <tr>
            <th>Teléfono</th>
            <td><input type="tel" name="telefono" value="<%=usuario.getTelefono()%>" maxlength="12"></td>
        </tr>
        <tr>
            <th>Correo electrónico</th>
            <td><input type="email" name="email" value="<%=usuario.getEmail()%>" maxlength="80" required></td>
        </tr>
        <tr>
            <th>Rol</th>
            <td>
                <select name="tipo">
                    <%=usuario.getTipoEnObjeto().getListaEnOptions()%>
                </select>
            </td>
        </tr>
        <tr>
            <th>Ruta libro Excel</th>
            <td>
                <input type="text" name="rutaExcel" 
                       value="<%=usuario.getRutaExcel().replace("\\", "\\\\")%>" 
                       size="50" maxlength="200">
            </td>
        </tr>
        <tr>
            <th>Contraseña</th>
            <td>
                <input type="password" name="clave" placeholder="Dejar en blanco para mantener la actual">
                <input type="hidden" name="claveActual" value="<%=usuario.getClave()%>">
            </td>
        </tr>
    </table>

    <p>
    <input type="hidden" name="identificacionAnterior" value="<%=usuario.getIdentificacion()%>">
    <input class="btn-guardar" type="submit" name="accion" value="<%=accion%>">
    <button class="btn-salir" type="button" onclick="window.location.href='principal.jsp?CONTENIDO=usuarios.jsp';">Salir</button>
    </p>

</form>
<style>
.btn-guardar, .btn-salir {
    padding: 10px 20px;
    font-size: 16px;
    font-family: Arial, sans-serif;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
    margin: 5px;
}

.btn-guardar {
    background-color: #28a745;
    color: white;
}

.btn-guardar:hover {
    background-color: #218838;
    transform: scale(1.05);
}

.btn-salir {
    background-color: #dc3545;
    color: white;
}

.btn-salir:hover {
    background-color: #c82333;
    transform: scale(1.05);
}
</style>