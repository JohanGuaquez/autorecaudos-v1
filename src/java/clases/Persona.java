package clases;

import clasesGenericas.ConectorBD;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Persona {
    private String identificacion;
    private String nombres;
    private String direccion;
    private String telefono;
    private String email;
    private String rol;
    private String clave;
    private String rutaExcel;

    public Persona() {
    }

    public Persona(String identificacion) {
        String cadenaSQL = "SELECT nombres, direccion, telefono, email, rol, clave, rutaExcel FROM Persona "
                + "WHERE identificacion ='" + identificacion + "'";
        ResultSet resultado = ConectorBD.consultar(cadenaSQL);

        try {
            if (resultado.next()) {
                this.identificacion = identificacion;
                nombres = resultado.getString("nombres");
                direccion = resultado.getString("direccion");
                telefono = resultado.getString("telefono");
                email = resultado.getString("email");
                rol = resultado.getString("rol");
                clave = resultado.getString("clave");
                rutaExcel = resultado.getString("rutaExcel");
            }
        } catch (SQLException ex) {
            Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Getters y setters actualizados
    public String getIdentificacion() {
        return identificacion != null ? identificacion : "";
    }

    public void setIdentificacion(String identificacion) {
        this.identificacion = identificacion != null ? identificacion.trim() : "";
    }

    public String getNombres() {
        return nombres != null ? nombres : "";
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    

    public String getDireccion() {
        return direccion != null ? direccion : "";
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono != null ? telefono : "";
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email != null ? email : "";
    }

    public void setEmail(String email) {
        this.email = email;
    }

   
    public String getRol() {
        return rol != null ? rol : "";
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getClave() {
        return clave != null ? clave : "";
    }

    // Método setClave corregido
    public void setClave(String clave) {
        this.clave = clave != null && !clave.trim().isEmpty() ? clave : identificacion;
    }
    
    public String getRutaExcel() {
        return rutaExcel != null ? rutaExcel : "";
    }

    public void setRutaExcel(String rutaExcel) {
        this.rutaExcel = rutaExcel;
    }
    // Método para retornar el tipo de persona según el rol
    public TipoPersona getTipoEnObjeto() {
        return new TipoPersona(rol);
    }

    // Método grabar corregido con MD5 en la consulta SQL
    public boolean grabar() {
        String cadenaSQL = "INSERT INTO Persona (identificacion, nombres, direccion, telefono, email, rol, rutaExcel, clave) "
                + "VALUES ('"
                + identificacion + "','" + nombres + "','" + direccion + "','" + telefono + "','" + email + "','" + rol + "','" + rutaExcel + "', MD5('" + clave + "'))"; // Aplicamos MD5 correctamente

        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para modificar una persona
    public boolean modificar(String identificacionAnterior) {
        String cadenaSQL = "UPDATE Persona SET identificacion='" + identificacion + "', nombres='" + nombres + 
                 "', direccion='" + direccion + "', telefono='" + telefono + "', email='" + email + "', rol='" + rol + "', rutaExcel='" + rutaExcel + "', clave=MD5('" + clave + "') WHERE identificacion='" + identificacionAnterior + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Método para eliminar una persona
    public boolean eliminar() {
        String cadenaSQL = "DELETE FROM Persona WHERE identificacion='" + identificacion + "'";
        return ConectorBD.ejecutarQuery(cadenaSQL);
    }

    // Métodos para obtener listas de personas
    public static ResultSet getLista(String filtro, String orden) {
        if (filtro != null && !filtro.isEmpty()) {
            filtro = " WHERE " + filtro;
        } else {
            filtro = "";
        }
        if (orden != null && !orden.isEmpty()) {
            orden = " ORDER BY " + orden;
        } else {
            orden = "";
        }
        String cadenaSQL = "SELECT identificacion, nombres, direccion, telefono, email, rol, rutaExcel, clave FROM persona" + filtro + orden;
        return ConectorBD.consultar(cadenaSQL);
    }

    public static List<Persona> getListaEnObjetos(String filtro, String orden) {
        List<Persona> lista = new ArrayList<>();
        ResultSet datos = Persona.getLista(filtro, orden);
        if (datos != null) {
            try {
                while (datos.next()) {
                    Persona persona = new Persona();
                    persona.setIdentificacion(datos.getString("identificacion"));
                    persona.setNombres(datos.getString("nombres"));                    
                    persona.setDireccion(datos.getString("direccion"));
                    persona.setTelefono(datos.getString("telefono"));
                    persona.setEmail(datos.getString("email"));
                    persona.setRol(datos.getString("rol"));
                    persona.setRutaExcel(datos.getString("rutaExcel"));
                    persona.setClave(datos.getString("clave"));
                    lista.add(persona);
                }
            } catch (SQLException ex) {
                Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return lista;
    }

    public static Persona validar(String identificacion, String clave) {
        Persona persona = null;
        List<Persona> lista = Persona.getListaEnObjetos("identificacion='" + identificacion + "' and clave = MD5('" + clave + "')", null);
        if (lista.size() > 0) {
            persona = lista.get(0);
        }
        return persona;
    }
    
    public static String getListaEnOptions(String idSeleccionado) {
    StringBuilder listaOptions = new StringBuilder();
    ResultSet datos = Persona.getLista(null, "nombres"); // Ordenar por nombres

    try {
        while (datos.next()) {
            String identificacion = datos.getString("identificacion");
            String nombres = datos.getString("nombres");

            // Agregar el atributo 'selected' si es la opción seleccionada
            String selected = identificacion.equals(idSeleccionado) ? "selected" : "";
            listaOptions.append("<option value='").append(identificacion).append("' ")
                        .append(selected).append(">")
                        .append(nombres).append("</option>");
        }
    } catch (SQLException ex) {
        Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
    }

    return listaOptions.toString();
}
    
    public static List<Persona> cargarIdentificacionYNombres() {
    List<Persona> lista = new ArrayList<>();
    String cadenaSQL = "SELECT identificacion, nombres FROM Persona ORDER BY nombres";
    ResultSet datos = ConectorBD.consultar(cadenaSQL);

    try {
        while (datos.next()) {
            Persona persona = new Persona();
            persona.setIdentificacion(datos.getString("identificacion"));
            persona.setNombres(datos.getString("nombres"));
            lista.add(persona);
        }
    } catch (SQLException ex) {
        Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, null, ex);
    }

    return lista;
}

public static String obtenerRutaExcelPorIdPlanilla(String id) {
    String rutaExcel = null;

    if (id == null || !id.matches("\\d+")) {
        System.out.println("ID inválido: " + id);
        return null;
    }

    String cadenaSQL = "SELECT p.rutaExcel FROM Persona p " +
                       "JOIN Planilla pl ON p.identificacion = pl.codigoVendedor " +
                       "WHERE pl.id = " + id;

    System.out.println("Ejecutando SQL: " + cadenaSQL); // ✅ Ver la consulta en consola

    ResultSet resultado = ConectorBD.consultar(cadenaSQL);

    try {
        if (resultado != null && resultado.next()) {
            rutaExcel = resultado.getString("rutaExcel");
            System.out.println("Ruta obtenida: " + rutaExcel); // ✅ Ver ruta obtenida
        } else {
            System.out.println("No se encontró ruta para el ID: " + id);
        }
    } catch (SQLException ex) {
        Logger.getLogger(Persona.class.getName()).log(Level.SEVERE, "Error al obtener rutaExcel", ex);
    }
    
    return rutaExcel;
}  
public static String obtenerDireccionPorIdPlanilla(String idPlanilla) {
    String direccion = null;
    String sql = "SELECT p.direccion FROM Persona p " +
                 "JOIN Planilla pl ON p.identificacion = pl.codigoVendedor " +
                 "WHERE pl.id = ?";

    ConectorBD conector = new ConectorBD();
    try {
        conector.conectar();
        ResultSet rs = conector.ejecutarConsultaConParametros(sql, idPlanilla);
        if (rs.next()) {
            direccion = rs.getString("direccion");
        }
        conector.desconectar();
    } catch (Exception e) {
        System.err.println("Error obteniendo dirección: " + e.getMessage());
    }
    return direccion;
}


}
