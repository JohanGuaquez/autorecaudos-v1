<%@ page import="clases.Persona" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
    Persona persona = (Persona) session.getAttribute("usuariot");
    String nombre = (persona != null) ? persona.getNombres() : "Invitado";
%>

<html>
<head>
    <title>Página Principal</title>
    <link rel="stylesheet" type="text/css" href="presentacion/global.css">
</head>
<body>
    <div id="banner">
        <div style="text-align: center;">
            <img src="presentacion/dyd.png" alt="Logo de la Escuela" width="100">
        </div>
        <h1 style="text-align: center; font-family: Arial, sans-serif; margin-bottom: 10px;">¡HOLA!</h1>
        <h1 style="text-align: center; font-family: Arial;"><%= nombre %></h1>

        <div class="cards-container">
            <!-- Aquí puedes insertar tus accesos directos -->
        </div>
    </div>
</body>
</html>
