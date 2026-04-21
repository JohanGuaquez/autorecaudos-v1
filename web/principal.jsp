<%@page import="clases.Persona"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="presentacion/menu.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
HttpSession sesion = request.getSession();
Persona USUARIO = null;
if (sesion.getAttribute("usuariot") == null) {
    response.sendRedirect("index.jsp?error=2");
} else {
    USUARIO = (Persona) sesion.getAttribute("usuariot");
}
%>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dulces y dulces</title>
<body>
    <!-- Menú lateral -->
    <div class="sidebar" id="menu">
        <span class="menu-icon">☰</span>
        <div class="menu-content">
            <%
                if (USUARIO != null && USUARIO.getTipoEnObjeto() != null) {
                    out.print(USUARIO.getTipoEnObjeto().getMenu());
                } else {
                    out.print("<a href='#'>Menú no disponible</a>");
                }
            %>
        </div>
    </div>

    <!-- Contenido principal -->
    <div class="content">
        <jsp:include page='<%= request.getParameter("CONTENIDO") %>' flush="true" />
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const menu = document.getElementById("menu");
            const menuContent = document.querySelector(".menu-content");

            // Alternar menú al hacer clic en el icono
            menu.addEventListener("click", function () {
                menu.classList.toggle("expanded");
            });

            // Cerrar menú cuando se seleccione una opción
            const menuLinks = document.querySelectorAll(".menu-content a");
            menuLinks.forEach(link => {
                link.addEventListener("click", function () {
                    menu.classList.remove("expanded");
                });
            });
        });
    </script>
</body>
