package clases;

public class TipoPersona {
    
     private String codigo;

    public TipoPersona(String codigo) {
        this.codigo = codigo;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }
   
    public String getNombre(){
        String nombre= null;
        switch (codigo){
            case "A" : nombre ="Administrador"; break;
            case "V" : nombre ="Vendedor"; break;
            default : nombre ="Desconocido"; break;
        }
        return nombre;
    }

    @Override
    public String toString() {
        return getNombre();
    }
    public String getMenu() {
    StringBuilder menu = new StringBuilder("<ul class='menu'>");

    menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=inicio.jsp'>")
        .append("<i class='fas fa-home'></i> Inicio</a></li>");

    switch(this.codigo) {
        case "A":
            menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=usuarios.jsp'>")
                .append("<i class='fas fa-users-cog'></i> Usuarios del sistema</a></li>");
            
            menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=generarPlanilla.jsp'>")
                .append("<i class='fas fa-file-invoice-dollar'></i> Planillas recaudos</a></li>");
            
            menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=historial.jsp'>")
                .append("<i class='fas fa-history'></i> Historiales</a></li>");
            break;

        case "V":
            menu.append("<li><a href='principal.jsp?CONTENIDO=generarPlanillaFormulario.jsp&accion=Adicionar' title='Adicionar'>")
                .append("<i class='fas fa-plus-circle'></i> Generar Planilla</a></li>");
            
            menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=generarPlanilla.jsp'>")
                .append("<i class='fas fa-folder-open'></i> Mis Planillas</a></li>");
            break;

        default:
            menu.append("<li><a href='/AutoRecaudos_dyd/principal.jsp?CONTENIDO=inicio.jsp'>")
                .append("<i class='fas fa-home'></i> Inicio</a></li>");
            break;
    }

    menu.append("<li><a href='/AutoRecaudos_dyd/index.jsp'>")
        .append("<i class='fas fa-sign-out-alt'></i> Salir</a></li>");

    menu.append("</ul>");
    return menu.toString();
}


   
    public String getListaEnOptions() {
    String lista = "";
    if (codigo == null) codigo = "";
    
    lista += "<option value='A'" + (codigo.equals("A") ? " selected" : "") + ">Administrador</option>";
    lista += "<option value='V'" + (codigo.equals("V") ? " selected" : "") + ">Vendedor</option>";
    
    return lista;
}
}