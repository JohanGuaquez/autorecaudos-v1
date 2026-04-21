<%@page import="clases.Persona"%>
<%@page import="clases.Planilla"%>

<%
    String accion = request.getParameter("accion");
    String numeroPlanilla = request.getParameter("numeroPlanilla");
    Planilla planilla;
    if ("Modificar".equals(accion)){
         planilla = new Planilla(numeroPlanilla);
    } else {
        planilla = new Planilla(); 
    }   
HttpSession sesion = request.getSession();
Persona USUARIO = (Persona) sesion.getAttribute("usuariot");
%>

<center><h1><%=accion.toUpperCase()%> PLANILLA</h1></center>

<form name="formulario" method="post" action="generarPlanillaActualizar.jsp" enctype="multipart/form-data">
     <img src="presentacion/dyd.png" alt="Logo del club" class="logo-derecha">
    <link rel="stylesheet" type="text/css" href="presentacion/formulario.css">
    <table border="0">
        <tr>
            <td class="label-columna">ZONA</td>
            <td><input type="text" name="codigoVendedor" value="<%= (USUARIO != null) ? USUARIO.getIdentificacion() : "" %>" readonly></td>
        </tr>
        <tr>
            <td class="label-columna">VENDEDOR</td>
            <td>
                <input type="text" value="<%= (USUARIO != null) ? USUARIO.getNombres() : "" %>" readonly>
                <input type="hidden" name="nombreVendedor" value="<%= (USUARIO != null) ? USUARIO.getIdentificacion() : "" %>">
            </td>
        </tr>
        <tr>
            <td class="label-columna">NUMERO PLANILLA</td>
            <td><input type="number" name="numeroPlanilla" value="<%= planilla.getNumeroPlanilla()!= null ? planilla.getNumeroPlanilla(): "0" %>" min="0" required></td>
        </tr>
        <tr>
            <td class="label-columna">FECHA</td>
            <td><input type="date" name="fecha" value="<%= planilla.getFecha()!= null ? planilla.getFecha(): "" %>" required></td>
        </tr>
        <tr>
            <td class="label-columna">NUMERO SEMANA</td>
            <td><input type="number" name="numeroSemana" value="<%= planilla.getNumeroSemana()!= null ? planilla.getNumeroSemana(): "0" %>" min="0" required></td>
        </tr>
        <tr>
            <td class="label-columna">POBLACION</td>
            <td><input type="text" name="poblacion" value="<%= planilla.getPoblacion() != null ? planilla.getPoblacion() : "" %>" required></td>
        </tr>
        <tr>
            <td class="label-columna">NOTA</td>
            <td>
                <textarea name="nota" rows="5" cols="60" required><%=planilla.getNota() != null ? planilla.getNota() : "" %></textarea>
            </td>
        </tr>
        <tr>
            <td class="label-columna">FOTOS</td>
            <td>
                <input type="file" name="fotos[]" id="imagenes" accept="image/*" multiple onchange="mostrarFotos()">
                <br>
                <div id="preview"></div>
            </td>
        </tr>
    </table>
        
  <div class="botones-container">
  <input class="btn btn-enviar" type="submit" name="accion" value="<%=accion%>" onclick="return confirmarPlanilla()">
  <button class="btn btn-salir" type="button" onclick="window.location.href='principal.jsp?CONTENIDO=inicio.jsp';">Salir</button>
</div>

    
</form>
    

<script type="text/javascript">
function mostrarFotos() {
    var fileInput = document.getElementById("imagenes");
    var previewContainer = document.getElementById("preview");

    for (let file of fileInput.files) {
        if (!file.type.startsWith("image/")) {
            console.error("Uno de los archivos seleccionados no es una imagen.");
            continue;
        }

        let reader = new FileReader();
        reader.onload = function (e) {
            let img = document.createElement("img");
            img.src = e.target.result;
            img.width = 150;
            img.height = 150;
            img.style.margin = "5px";
            previewContainer.appendChild(img);
        };
        reader.readAsDataURL(file);
    }
}
function confirmarPlanilla(){
    return confirm('¿realmente desea enviar esta planilla?');
    }
</script>











