<%-- 
    Document   : generarPlanilla
    Created on : 21/02/2025, 11:37:19 AM
    Author     : DELL
--%>
<%@page import="clases.Persona"%>
<%@page import="clases.Planilla"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="presentacion/planilla.css">
<!DOCTYPE html>

    
    <%
        // BUSCADOR POR FECHA
    String filtro = "";
    String chkFecha = request.getParameter("chkFecha");
    String fechaInicio = "";
    String fechaFin = "";
    if (chkFecha != null) {
        chkFecha = "checked";
        fechaInicio = request.getParameter("fechaInicio");
        fechaFin = request.getParameter("fechaFin");
        filtro = "fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "'";
    } else {
        chkFecha = "";
    }
       // BUACDOR POR CODIGO DE VENDEDOR
    String chkCodigoVendedor = request.getParameter("chkCodigoVendedor");
    String codigoVendedor = "";
    if (chkCodigoVendedor != null) {

        chkCodigoVendedor = "checked";
        codigoVendedor = request.getParameter("codigoVendedor");
        if (!filtro.isEmpty()) filtro += " AND ";
        filtro += "codigoVendedor = " + codigoVendedor;
    } else {
        chkCodigoVendedor = "";
    }

    String lista = "";
    HttpSession sesion = request.getSession();
    Persona USUARIO = (Persona) sesion.getAttribute("usuariot");

    String rolUsuario = (USUARIO != null) ? USUARIO.getRol() : ""; // Asegúrate de tener un método getRol()
    String codigoUsuario = (USUARIO != null) ? USUARIO.getIdentificacion() : "";

   List<Planilla> datos = Planilla.getListaEnObjetos(filtro, null);
for (int i = 0; i < datos.size(); i++) {
    Planilla planilla = datos.get(i);

    // Si el usuario es vendedor (V), solo puede ver sus propios registros
    if ("V".equals(rolUsuario) && !planilla.getCodigoVendedor().equals(codigoUsuario)) {
        continue; // Saltar registros que no sean del usuario vendedor
    }

    // Determinar la clase CSS según el estado de la planilla
    String claseFila = planilla.getEstado() == 1 ? "pintada" : "no-pintada";

    lista += "<tr id='fila-" + planilla.getId() + "' class='" + claseFila + "'>";
    lista += "<td>" + planilla.getNumeroPlanilla() + "</td>";
    lista += "<td>" + planilla.getCodigoVendedor() + "</td>";
    lista += "<td>" + planilla.getNombreV() + "</td>";
    lista += "<td>" + planilla.getFecha() + "</td>";
    lista += "<td>" + planilla.getNumeroSemana() + "</td>";
    lista += "<td>" + planilla.getPoblacion() + "</td>";
    lista += "<td>" + planilla.getNota() + "</td>";
    lista += "<td><img src='presentacion/imagenes/ver.png' alt='ver' title='Ver fotos' onClick='ver(\"" + planilla.getId() + "\")'></td>";

    if (!"V".equals(rolUsuario)) {
        lista += "<td>";
        lista += "<div class='tabla-menu'>";
        lista += "<span class='menu-icon' onclick='toggleMenu(" + planilla.getId() + ")'>☰</span>";
        lista += "<div class='menu-content' id='menu-" + planilla.getId() + "'>";
        lista += "<img src='presentacion/imagenes/eliminar.png' alt='Eliminar' title='Eliminar' onClick='eliminar(\"" + planilla.getId() + "\")'>";
        lista += "<img src='presentacion/imagenes/pegar.png' alt='Pegar fotos' title='Pegar fotos al recaudo' onClick='exportarExcel(\"" + planilla.getId() + "\")'>";
        lista += "<img src='presentacion/imagenes/excel.png' alt='Exportar a Excel' title='Generar recaudo' onClick='MacroExecute(\"" + planilla.getId() + "\")'>";
        lista += "</div>";
        lista += "</div>"; // Cierra .menu-container
        if (planilla.getId() != null) {
            lista += "        <button onclick='cambiarEstado(" + planilla.getId() + ", " + (planilla.getEstado() == 1 ? 0 : 1) + ")'>";
            lista += (planilla.getEstado() == 1 ? "Realizado" : "Pendiente") + "</button>";
        } else {
            lista += "        <button disabled>Estado desconocido</button>";
            System.err.println("⚠️ Advertencia: planilla.getId() es NULL en la iteración " + i);
        }

        lista += "</td>";
    
    }

    lista += "</tr>";
}

%>
<style>
  .menu-opcion {
    display: flex; /* Mantiene icono y texto en línea */
    align-items: center; /* Alineación vertical */
    padding: 8px 15px; /* Espaciado interno */
    gap: 12px; /* Espacio entre el icono y el texto */
}

.menu-opcion img {
    width: 300px; /* Ajusta el tamaño del icono */
    height: auto;
}

.texto-opcion {
    font-weight: bold;
    font-size: 16px;
    color: black;
    white-space: nowrap; /* Evita saltos de línea */
    text-align: left;
    flex-grow: 1; /* Hace que el texto ocupe el espacio disponible */
}


</style>
<div id="overlay"></div>

   <img src="presentacion/dyd.png" alt="Logo del club" class="logos-derecha">

    <%--<center><h1>Listado planillas</h1></center>--%>
    <p>
       
            
            
               

    <form method="get" action="principal.jsp">
  <input type="hidden" name="CONTENIDO" value="generarPlanilla.jsp">

  <div class="row align-items-center">
    <!-- FILTRO POR FECHA -->
    <div class="col-md-5">
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name="chkFecha" <%= chkFecha %>>
        <label class="form-check-label"> Filtrar por Fecha </label>
      </div>
      <div class="input-group">
        <span class="input-group-text">Desde</span>
        <input type="date" name="fechaInicio" value="<%= fechaInicio %>" class="form-control">
        <span class="input-group-text">Hasta</span>
        <input type="date" name="fechaFin" value="<%= fechaFin %>" class="form-control">
      </div>
    </div>

    <!-- FILTRO POR VENDEDOR -->
    <% if (!"V".equals(rolUsuario)) { %>
    <div class="col-md-4">
      <div class="form-check">
        <input class="form-check-input" type="checkbox" name="chkCodigoVendedor" <%= chkCodigoVendedor %>>
        <label class="form-check-label"> Filtrar por ID Vendedor </label>
      </div>
      <input type="text" name="codigoVendedor" value="<%= codigoVendedor %>" class="form-control" placeholder="Código Vendedor">
    </div>
    <% } %>

    <!-- BOTONES -->
    <div class="col-md-3 text-center">
      

      <% if (!"V".equals(rolUsuario)) { %>
      <a onclick="window.location.href='https://dyd.pimovil.co/mobilesale/';">
        <img src="presentacion/imagenes/pimovil.png" alt="PiMovil">
      </a>
      <% } %>

    </div>  
  </div>
      <button type="submit" class="btn btn-primary w-100">Buscar</button>
      <button onclick="window.location.href='principal.jsp?CONTENIDO=inicio.jsp';" type="button">
        Salir
      </button>
</form>


        

        <table border="1">
            <tr>
                <th>Numero Planilla</th>
                <th>Zona vendedor</th>
                <th>Razon social</th>
                <th>Fecha</th>
                <th>Numero semana</th>
                <th>Poblacion</th>
                <th>Nota</th>
                <th>Vista</th>
                <th>
                    <a href="principal.jsp?CONTENIDO=generarPlanillaFormulario.jsp&accion=Adicionar" title="Adicionar">
                        <img src="presentacion/imagenes/agrega.png">
                    </a>
                </th>
            </tr>
            <%= lista %>
        </table>
      

        


</html>
<script type="text/javascript">
    function eliminar(id) {
    if (confirm("¿realmente deseas eliminar esta planilla?")) {
        fetch("registrarAccion.jsp", {
            method: "POST",
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: "accion=Eliminar&idPlanilla=" + id
        }).then(() => {
            document.location = "principal.jsp?CONTENIDO=generarPlanillaActualizar.jsp&accion=Eliminar&id=" + id;
        });
    }
}

    function exportar(id) {
        window.open("exportarExcel.jsp?id="+id);
    }
    function ver(id) {
    window.open("verFotos.jsp?id=" + id, "VerFotos", "width=600,height=400");
}

    function exportarExcel(id) {
        window.location.href = "expPlanilla?id=" + id;
    }
    function MacroExecute(id) {
        window.location.href = "MacroExecute?id=" + id;
    }
    
  
    function cambiarEstado(id, nuevoEstado) {
    console.log("📌 ID recibido:", id);
    console.log("📌 Estado recibido:", nuevoEstado);

    // Validación para evitar valores nulos o indefinidos
    if (id == null || nuevoEstado == null || id === "" || nuevoEstado === "") {
        console.error("❌ Error: ID o Estado son inválidos.");
        return;
    }

    // Convertir a número para evitar errores en el backend
    nuevoEstado = parseInt(nuevoEstado, 10);
    console.log("📌 Estado después de parseInt:", nuevoEstado);

    // Verificar si nuevoEstado sigue siendo un número válido
    if (isNaN(nuevoEstado)) {
        console.error("❌ Error: Estado convertido es NaN.");
        return;
    }

    let params = new URLSearchParams();
    params.append("accion", "cambiarEstado");
    params.append("id", id);
    params.append("estado", String(nuevoEstado));

    console.log("📤 Enviando a fetch():", params.toString());

    fetch('generarPlanillaActualizar.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: params.toString()
    })
    .then(response => response.text())
    .then(data => {
        console.log("📥 Respuesta del servidor:", data);

        if (data.trim() === "OK") {
            let fila = document.getElementById("fila-" + id);
            if (fila) {
                // Actualizar clases CSS de la fila
                if (nuevoEstado === 1) {
                    fila.classList.add("pintada");
                    fila.classList.remove("no-pintada");
                } else {
                    fila.classList.remove("pintada");
                    fila.classList.add("no-pintada");
                }

                // Forzar reflujo para asegurar que el navegador actualice el estilo
                void fila.offsetWidth;

                // Actualizar el botón dentro de la fila
                let boton = fila.querySelector("button");
                if (boton) {
                    let nuevoValor = nuevoEstado === 1 ? 0 : 1;
                    boton.innerText = nuevoEstado === 1 ? "Realizado" : "Pendiente";
                    boton.setAttribute("onclick", `cambiarEstado(${id}, ${nuevoValor})`);
                } else {
                    console.warn("⚠️ Botón no encontrado en la fila.");
                }
            } else {
                console.warn("⚠️ Fila no encontrada para ID:", id);
            }
        } else {
            alert("❌ Error al actualizar el estado. Servidor respondió: " + data);
        }
    })
    .catch(error => console.error("❌ Error en la petición:", error));
}



function toggleMenu(id) {
    var menu = document.getElementById('menu-' + id);
    var overlay = document.getElementById('overlay');

    if (menu.style.display === 'block') {
        menu.style.display = 'none';
        overlay.style.display = 'none'; // Desbloquea la tabla
    } else {
        // Cierra otros menús antes de abrir uno nuevo
        document.querySelectorAll('.tabla-menu .menu-content').forEach(m => m.style.display = 'none');
        menu.style.display = 'block';
        overlay.style.display = 'block'; // Bloquea la tabla
    }
}

// Cierra el menú y desbloquea la tabla al hacer clic fuera
document.getElementById('overlay').addEventListener('click', function() {
    document.querySelectorAll('.tabla-menu .menu-content').forEach(menu => menu.style.display = 'none');
    this.style.display = 'none'; // Desbloquea la tabla
});


   

</script>